# !/usr/bin/env bash
# install.sh — dotfiles installer (GNU Stow)

set -euo pipefail

# ─── config ────────────────────────────────────────────────────────────

DOTFILES_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

DRY_RUN=false
SKIP_DEPS=false
RESTOW=false

PACKAGES=(
	"bat"
	"cursor"
	"git"
	"ghostty"
	"ohmyposh"
	"vscode"
	"zsh"
	"nvim"
)

DEPS=(
	"bat"
	"fzf"
	"zoxide" 
	"neovim"
	"git"
	"jandedobbeleer/oh-my-posh/oh-my-posh"
)

CASKS=(
	"font-jetbrains-mono-nerd-font"
	"ghostty"
)

STOW_IGNORE_PATTERNS=(
	'\.DS_Store$'
	'\.git$'
	'\.gitignore$'
	'\.swp$'
	'\.swo$'
	'~$'
)

# ─── help ──────────────────────────────────────────────────────────────

readonly HELP_TEXT=("
Dotfiles Installation Script (using GNU Stow)

Usage:
./install.sh [options]

Options:
--skip-deps     Skip dependency installation
--restow        Restow all packages (re-creates symlinks, useful for updates)
--dry-run       Show what would be done without making changes
-h, --help      Show this help message

This script will:
1. Check system compatibility (macOS)
2. Install GNU Stow if needed
3. Use Stow to create symlinks for all dotfiles
4. Optionally install dependencies (Homebrew packages)

What is GNU Stow?
Stow is a symlink farm manager that creates symlinks from one directory
tree to another. It's perfect for managing dotfiles since it handles
all the symlinking automatically while maintaining a clean repo structure.
")

show_help() {
	printf "%s\n" "$HELP_TEXT"
}

# ─── output helpers ────────────────────────────────────────────────────

readonly NO_COLOR='\033[0m'
readonly GREEN='\033[0;32m'
readonly RED='\033[0;31m'
readonly BLUE='\033[0;34m'
readonly YELLOW='\033[1;33m'

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
	echo "${BLUE}  $*${NO_COLOR}"
	echo "${BLUE}━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${NO_COLOR}"
	echo
}

print_complete() {
	echo ""
	echo "${GREEN}━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${NO_COLOR}"
	echo "${GREEN}  ✓ $1${NO_COLOR}"
	echo "${GREEN}━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${NO_COLOR}"
	echo ""
}

# ─── core logic ────────────────────────────────────────────────────────

check_system() {
	print_header "System Check"

	if [[ "$OSTYPE" != "darwin"* ]]; then
		print_error "This script is designed for macOS only"
		exit 1
	fi
	
	print_success "Running on macOS"

	if [[ "$DRY_RUN" == true ]]; then 
		print_warning "Running in DRY RUN mode - no changes will be made" 
	fi
}

install_stow() {
	if command -v stow >/dev/null 2>&1; then
		print_success "GNU Stow is already installed"
		return 0
	fi

	print_header "Installing GNU Stow"

	if ! command -v brew >/dev/null 2>&1; then
		print_error "Homebrew not found. Please install Homebrew first:"
		print_info "https://brew.sh"
		exit 1
	fi

	if $DRY_RUN; then
		print_info "Would install GNU Stow via Homebrew"
	else
		print_info "Installing GNU Stow via Homebrew..."
		brew install stow
		print_success "GNU Stow installed"
	fi
}

stow_dotfiles() {
	print_header "Stowing Dotfiles"

	cd "$DOTFILES_DIR"

	local stow_cmd="stow"
	local stow_args=(--verbose "--target=$HOME")

	$DRY_RUN && stow_args+=(--simulate)
	$RESTOW && stow_args+=(--restow)

	for pattern in "${STOW_IGNORE_PATTERNS[@]}"; do
		stow_args+=(--ignore="$pattern")
	done

	for package in "${PACKAGES[@]}"; do
		if [[ ! -d "$package" ]]; then
			print_warning "Package directory not found: $package (skipping)"
			continue
		fi

		print_info "Stowing $package..."

		if [[ "$DRY_RUN" == true ]]; then
			print_info "Would run: $stow_cmd ${stow_args[*]} $package"
		fi

		local IFS=$'\n\t'

		if $stow_cmd "${stow_args[@]}" "$package" 2>&1 | while IFS= read -r line; do
			if [[ "$line" == WARNING!* ]]; then
				in_warning=true
				print_warning "$line"
				continue
			fi

			if [[ "${in_warning:-false}" == true ]]; then
				if [[ "$line" =~ ^[[:space:]]+\* ]]; then
					print_warning "  ↳ ${line#* }"
					continue
				else
					in_warning=false
				fi
			fi

			if [[ "$line" == "LINK:"* ]]; then
				print_success "Linked: $(awk '{$1=""; print substr($0,2)}' <<< "$line")"
				continue
			fi
		done; then
			if [[ "$DRY_RUN" == false ]]; then
				print_success "Stowed $package"
			fi
		else
			print_error "Failed to stow $package"
			print_info "You may have existing files. Try backing them up manually or use --restow"
		fi
	done

	print_success "Dotfiles stowing complete"
}

install_dependencies() {
	if [[ "$SKIP_DEPS" == true ]]; then
		print_warning "Skipping dependency installation (--skip-deps)"
		return
	fi

	print_header "Installing Dependencies"

	if ! command -v brew >/dev/null 2>&1; then
		print_error "Homebrew not found. Please install Homebrew first:"
		print_info "https://brew.sh"
		return 1
	fi

	print_success "Homebrew found"
	print_info "Installing Homebrew packages..."

	for dep in "${DEPS[@]}"; do
		if [[ "$DRY_RUN" == true ]]; then
			print_info "Would install: $dep"
		else
			if brew list "$dep" &>/dev/null; then
				print_success "$dep already installed"
			else
				print_info "Installing $dep..."
				brew install "$dep"
			fi
		fi
	done

	print_info "Installing Homebrew casks..."

	for cask in "${CASKS[@]}"; do
		if [[ "$DRY_RUN" == true ]]; then
			print_info "Would install: $cask"
		else
			if brew list --cask "$cask" &>/dev/null; then
				print_success "$cask already instakelled"
			else
				print_info "Installing $cask..."
				brew install --cask "$cask"
			fi
		fi
	done

	print_success "Dependencies installation complete"
}

post_install() {
	print_header "Post-Installation"
	print_info "Zinit will auto-install on first Zsh launch"

	if [[ ! -f "$HOME/.zshrc.local" ]]; then
		print_info "Creating .zshrc.local for local customizations"

		if [[ "$DRY_RUN" == false ]]; then
			printf "%s\n" "${ZSHRC_LOCAL_CONTENT[@]}" > "$HOME/.zshrc.local"
			print_success "Created .zshrc.local"
		else
			print_info "Would create .zshrc.local"
		fi
	fi

	print_complete "DONE!"
	echo ""

	print_info "Next steps:"
	printf "%s\n" "${POST_INSTALL_NEXT_STEPS[@]}"
	echo ""
	
	print_info "Useful commands:"
	printf "%s\n" "${POST_INSTALL_USEFUL_COMMANDS[@]}"
	echo ""
}

readonly ZSHRC_LOCAL_CONTENT=(
	"# ─── .zshrc.local  ────────────────────────────────────────────────────╯"
	"#"
	"# This file is for machine-specific configuration that should not be"
	"# tracked in git (API keys, work-specific aliases, etc.)"
	"#"
	"# This file is sourced last in .zshrc, so you can override anything."
	""
)

readonly POST_INSTALL_NEXT_STEPS=(
	"Next steps:"
	"  1. Restart your terminal or run: source ~/.zshrc"
	"  2. Customize ~/.config/zsh/.zshrc.local for machine-specific settings"
)

readonly POST_INSTALL_USEFUL_COMMANDS=(
	"Useful commands:"
	"  ./install.sh --restow        # Update symlinks after pulling changes"
	"  stow --target=\$HOME -D zsh   # Unstow (remove symlinks for) a package"
)

# ─── main ──────────────────────────────────────────────────────────────

while [[ $# -gt 0 ]]; do
	case $1 in
		--skip-deps)
			SKIP_DEPS=true
			shift
			;;
		--restow)
			RESTOW=true
			shift
			;;
		--dry-run)
			DRY_RUN=true
			shift
			;;
		-h|--help)
			show_help
			exit 0
			;;
		*)
			print_error "Unknown option: $1"
			show_help
			exit 1
			;;
	esac
done

main() {
	check_system
	install_stow
	stow_dotfiles
	install_dependencies
	post_install
}

main
