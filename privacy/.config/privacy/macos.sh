#!/usr/bin/env bash
# ─── macos.sh  ──────────────────────────────────────────────────────╯

# ┏━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━┓
# ┃ WARNING                                                         ┃
# ┃                                                                 ┃
# ┃ Several commands require `sudo`. You will be prompted if        ┃
# ┃ needed. Some settings only take effect after a restart.         ┃
# ┗━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━┛

# ┏━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━┓
# ┃ INFO                                                            ┃
# ┃                                                                 ┃
# ┃ macOS-only. Safe to re-run.                                     ┃
# ┃ Strict privacy-focused configuration (may reduce usability).    ┃
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

  print_header "macOS privacy hardening"

  # ─── analytics & crash reporting ──────────────────────────────────

  run defaults write com.apple.CrashReporter DialogType none
  run sudo defaults write "/Library/Application Support/CrashReporter/DiagnosticMessagesHistory.plist" AutoSubmit -bool false
  run sudo defaults write /Library/Preferences/com.apple.SubmitDiagInfo.plist AutoSubmit -bool false

  # ─── siri ─────────────────────────────────────────────────────────

  run defaults write com.apple.assistant.support "Siri Data Sharing Opt-In Status" -int 2
  run defaults write com.apple.Siri StatusMenuVisible -bool false
  run defaults write com.apple.Siri UserHasDeclinedEnable -bool true

  # ─── spotlight ──────────────────────────────────────────────────

  run defaults write com.apple.lookup.shared LookupSuggestionsDisabled -bool true

  # ─── screen lock ────────────────────────────────────────────────

  run defaults write com.apple.screensaver askForPassword -int 1
  run defaults write com.apple.screensaver askForPasswordDelay -int 0

  # ─── airdrop ────────────────────────────────────────────────────

  run defaults write com.apple.NetworkBrowser DisableAirDrop -bool true

  # ─── bluetooth ──────────────────────────────────────────────────

  run sudo defaults write /Library/Preferences/com.apple.Bluetooth ControllerPowerState -int 0

  # ─── firewall & stealth mode ────────────────────────────────────

  run sudo /usr/libexec/ApplicationFirewall/socketfilterfw --setglobalstate on
  run sudo /usr/libexec/ApplicationFirewall/socketfilterfw --setstealthmode on
  run sudo /usr/libexec/ApplicationFirewall/socketfilterfw --setloggingmode on

  # ─── remote services ────────────────────────────────────────────

  # run sudo systemsetup -setremotelogin off
  run sudo launchctl disable system/com.apple.remote_management

  # ─── auto time zone ─────────────────────────────────────────────

  run sudo defaults write /Library/Preferences/com.apple.timezone.auto Active -bool false

  # ─── recent items ───────────────────────────────────────────────

  run defaults write com.apple.recentitems MaxApplications -int 0
  run defaults write com.apple.recentitems MaxDocuments -int 0
  run defaults write com.apple.recentitems MaxServers -int 0

  # ─── handoff & continuity ───────────────────────────────────────

  run defaults -currentHost write com.apple.coreduetd ActivityAdvertisingAllowed -bool false
  run defaults -currentHost write com.apple.coreduetd ActivityReceivingAllowed -bool false

  # ─── icloud document sync ───────────────────────────────────────

  run defaults write NSGlobalDomain NSDocumentSaveNewDocumentsToCloud -bool false

  # ─── done ───────────────────────────────────────────────────────

  print_info "Log out or restart for all changes to take effect."
  print_complete "Privacy settings applied."
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
