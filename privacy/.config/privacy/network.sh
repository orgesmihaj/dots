#!/usr/bin/env bash
# ─── network.sh  ────────────────────────────────────────────────────╯

# ┏━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━┓
# ┃ WARNING                                                         ┃
# ┃                                                                 ┃
# ┃ Several commands require `sudo`. You will be prompted if        ┃
# ┃ needed. Some settings only take effect after a restart or       ┃
# ┃ reconnecting to the network.                                    ┃
# ┗━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━┛

# ┏━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━┓
# ┃ INFO                                                            ┃
# ┃                                                                 ┃
# ┃ macOS-only. Safe to re-run.                                     ┃
# ┃ Network-level privacy hardening: DNS, Bonjour, captive          ┃
# ┃ portal, and IPv6 privacy extensions.                            ┃
# ┗━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━┛

set -u

[[ "$(uname)" != "Darwin" ]] && {
  print_error "macOS only. Exiting."
  exit 0
}

trap 'echo ""; print_warning "Interrupted."; exit 130' INT

DEBUG="${DEBUG:-0}"

# ─── main ───────────────────────────────────────────────────────────

main() {
  require_sudo

  print_header "Network privacy hardening"

  # ─── dns ────────────────────────────────────────────────────────

  # Quad9: non-profit, no logging, blocks malicious domains.
  # Sets DNS on Wi-Fi (en0) and Ethernet (en1); adjust interface
  # names with `networksetup -listallnetworkservices` if needed.
  run sudo networksetup -setdnsservers Wi-Fi 9.9.9.9 149.112.112.112
  run sudo networksetup -setdnsservers Ethernet 9.9.9.9 149.112.112.112

  # Flush the DNS cache so the new servers take effect immediately.
  run sudo dscacheutil -flushcache
  run sudo killall -HUP mDNSResponder

  # ─── bonjour advertising ────────────────────────────────────────

  # Stop advertising hostname and services on the local network via
  # mDNS multicast. Other devices can still discover the Mac when
  # explicitly probed, but passive advertisements are suppressed.
  run sudo defaults write /Library/Preferences/com.apple.mDNSResponder.plist \
    NoMulticastAdvertisements -bool true

  # ─── captive portal detection ───────────────────────────────────

  # Disable the automatic captive portal check that macOS sends to
  # Apple (captive.apple.com) on every Wi-Fi association. Disable
  # this if you do not rely on hotel/airport portal auto-detection.
  run sudo defaults write /Library/Preferences/SystemConfiguration/com.apple.captive.control \
    Active -bool false

  # ─── ipv6 privacy extensions ────────────────────────────────────

  # Ensure IPv6 privacy extensions (RFC 4941) are enabled on Wi-Fi
  # and Ethernet. macOS enables this by default, but make it
  # explicit so re-runs are idempotent.
  run sudo networksetup -setv6automatic Wi-Fi
  run sudo networksetup -setv6automatic Ethernet

  # ─── done ───────────────────────────────────────────────────────

  print_info "Reconnect to Wi-Fi or restart for all DNS changes to take effect."
  print_complete "Network privacy settings applied."
}

# ─── helpers ───────────────────────────────────────────────────────

run() {
  if [[ "$DEBUG" -eq 1 ]]; then
    print_info "$*"
  fi

  "$@" < /dev/null > /dev/null
  local exit_code=$?

  if [[ $exit_code -ne 0 ]]; then
    print_error "skip  $*  (exit ${exit_code})"
  else
    print_success "$*"
  fi
}

require_sudo() {
  sudo -v || {
    print_error "sudo required. Exiting."
    exit 1
  }
}

# ─── output helpers ─────────────────────────────────────────────────

readonly NO_COLOR=$'\033[0m'
readonly GREEN=$'\033[0;32m'
readonly RED=$'\033[0;31m'
readonly BLUE=$'\033[0;34m'
readonly YELLOW=$'\033[1;33m'

print_success() {
  echo "${GREEN}✓${NO_COLOR} $1"
}

print_error() {
  echo "${RED}✗${NO_COLOR} $1"
}

print_info() {
  echo "${BLUE}→${NO_COLOR} $1"
}

print_warning() {
  echo "${YELLOW}!${NO_COLOR} $1"
}

print_header() {
  echo
  echo "${BLUE}━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${NO_COLOR}"
  echo "${BLUE}$*${NO_COLOR}"
  echo "${BLUE}━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${NO_COLOR}"
  echo
}

print_complete() {
  echo ""
  echo "${GREEN}━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${NO_COLOR}"
  echo "${GREEN}✓ $1${NO_COLOR}"
  echo "${GREEN}━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${NO_COLOR}"
  echo ""
}

main
