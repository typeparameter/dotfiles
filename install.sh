#!/usr/bin/env bash

set -euo pipefail

readonly DOTFILES_REPOSITORY='typeparameter/dotfiles'
readonly NIXPKGS_CHANNEL_URL='https://nixos.org/channels/nixpkgs-unstable'
readonly HOME_MANAGER_CHANNEL_URL='https://github.com/nix-community/home-manager/archive/master.tar.gz'

readonly COLOR_RED=$'\033[31m'
readonly COLOR_GREEN=$'\033[32m'
readonly COLOR_YELLOW=$'\033[33m'
readonly COLOR_CYAN=$'\033[36m'
readonly COLOR_RESET=$'\033[0m'

use_stdout_color='false'
use_stderr_color='false'
if [[ -z "${NO_COLOR+x}" && "${TERM:-}" != 'dumb' ]]; then
  if [[ -t 1 ]]; then
    use_stdout_color='true'
  fi
  if [[ -t 2 ]]; then
    use_stderr_color='true'
  fi
fi
readonly use_stdout_color
readonly use_stderr_color

info() {
  if [[ "$use_stdout_color" == 'true' ]]; then
    printf '%s%s%s\n' "$COLOR_CYAN" "$*" "$COLOR_RESET"
  else
    printf '%s\n' "$*"
  fi
}

success() {
  if [[ "$use_stdout_color" == 'true' ]]; then
    printf '%s%s%s\n' "$COLOR_GREEN" "$*" "$COLOR_RESET"
  else
    printf '%s\n' "$*"
  fi
}

warn() {
  if [[ "$use_stderr_color" == 'true' ]]; then
    printf '%swarning: %s%s\n' "$COLOR_YELLOW" "$*" "$COLOR_RESET" >&2
  else
    printf 'warning: %s\n' "$*" >&2
  fi
}

die() {
  if [[ "$use_stderr_color" == 'true' ]]; then
    printf '%serror: %s%s\n' "$COLOR_RED" "$*" "$COLOR_RESET" >&2
  else
    printf 'error: %s\n' "$*" >&2
  fi
  exit 1
}

prompt_with_default() {
  local label="$1"
  local default_value="$2"
  local value

  printf '%s [%s]: ' "$label" "$default_value" >&3
  IFS= read -r value <&3 || die 'Could not read from the terminal.'

  if [[ -z "$value" ]]; then
    value="$default_value"
  fi

  printf '%s' "$value"
}

prompt_required() {
  local label="$1"
  local value

  while true; do
    printf '%s: ' "$label" >&3
    IFS= read -r value <&3 || die 'Could not read from the terminal.'

    if [[ -n "$value" ]]; then
      printf '%s' "$value"
      return
    fi

    printf 'A value is required.\n' >&3
  done
}

prompt_yes_no() {
  local label="$1"
  local value

  while true; do
    printf '%s [y/N]: ' "$label" >&3
    IFS= read -r value <&3 || die 'Could not read from the terminal.'

    case "$value" in
      y|Y|yes|Yes|YES)
        return 0
        ;;
      ''|n|N|no|No|NO)
        return 1
        ;;
      *)
        printf 'Please answer yes or no.\n' >&3
        ;;
    esac
  done
}

run_nix_shell() {
  if [[ "$interactive" == 'true' ]]; then
    nix-shell "$@" <&3
  else
    nix-shell "$@" </dev/null
  fi
}

warn_if_channel_differs() {
  local channel_name="$1"
  local configured_url="$2"
  local expected_url="$3"

  if [[ "${configured_url%/}" != "${expected_url%/}" ]]; then
    warn "The '${channel_name}' channel does not match the expected branch."
    printf '  configured: %s\n' "$configured_url" >&2
    printf '  expected:   %s\n' "$expected_url" >&2
    printf '  Continuing with the configured channel.\n' >&2
  fi
}

nix_escape() {
  local value="$1"

  value="${value//\\/\\\\}"
  value="${value//\"/\\\"}"
  value="${value//\$/\\\$}"

  printf '%s' "$value"
}

interactive='false'
if [[ -z "${NONINTERACTIVE:-}" ]] && : <>/dev/tty 2>/dev/null; then
  interactive='true'
  exec 3<>/dev/tty
fi
readonly interactive

for command_name in nix nix-channel nix-shell; do
  if ! command -v "$command_name" >/dev/null 2>&1; then
    die 'Nix must be installed and available before running this installer.'
  fi
done

if ! nix --version </dev/null >/dev/null 2>&1; then
  die 'Nix is installed but is not working for the current user.'
fi

if ! username="$(id -un 2>/dev/null)" || [[ -z "$username" ]]; then
  die 'Could not determine the current username.'
fi

home_directory="${HOME:-}"
if [[ -z "$home_directory" || "$home_directory" != /* ]]; then
  die 'HOME must be set to an absolute path before running this installer.'
fi

printf '\n'
info 'This installer will:'
printf '%s\n' \
  '  - Add any missing nixpkgs and Home Manager channels' \
  '  - Update the nixpkgs and Home Manager channels' \
  "  - Clone ${DOTFILES_REPOSITORY} into ~/.config/home-manager" \
  '  - Generate the local Home Manager configuration' \
  '  - Install and activate Home Manager'
printf '\n'

if [[ "$interactive" == 'true' ]]; then
  username="$(prompt_with_default 'Username' "$username")"

  while true; do
    requested_home_directory="$(prompt_with_default 'Home directory' "$home_directory")"
    if [[ "$requested_home_directory" == /* ]]; then
      home_directory="$requested_home_directory"
      break
    fi
    printf 'The home directory must be an absolute path.\n' >&3
  done

  git_user_name="$(prompt_required 'Git user name')"
  git_user_email="$(prompt_required 'Git user email')"
else
  info 'Running non-interactively with:'
  printf '  Username: %s\n' "$username"
  printf '  Home directory: %s\n' "$home_directory"
  printf '\n'
fi

if [[ ! -d "$home_directory" ]]; then
  die "The home directory '${home_directory}' does not exist."
fi

config_directory="${home_directory}/.config/home-manager"
if [[ -e "$config_directory" || -L "$config_directory" ]]; then
  die "An existing Home Manager configuration was found at '${config_directory}'. It will not be overwritten."
fi

if ! channel_list="$(nix-channel --list </dev/null)"; then
  die 'Could not list the current Nix channels.'
fi

while read -r channel_name channel_url; do
  case "$channel_name" in
    nixpkgs)
      nixpkgs_channel_url="$channel_url"
      ;;
    home-manager)
      home_manager_channel_url="$channel_url"
      ;;
  esac
done <<< "$channel_list"

if [[ -z "${nixpkgs_channel_url:-}" ]]; then
  info 'Adding the nixpkgs unstable channel...'
  nix-channel --add "$NIXPKGS_CHANNEL_URL" nixpkgs </dev/null
else
  warn_if_channel_differs 'nixpkgs' "$nixpkgs_channel_url" "$NIXPKGS_CHANNEL_URL"
fi

if [[ -z "${home_manager_channel_url:-}" ]]; then
  info 'Adding the Home Manager master channel...'
  nix-channel --add "$HOME_MANAGER_CHANNEL_URL" home-manager </dev/null
else
  warn_if_channel_differs 'home-manager' "$home_manager_channel_url" "$HOME_MANAGER_CHANNEL_URL"
fi

info 'Updating the nixpkgs and Home Manager channels...'
nix-channel --update nixpkgs home-manager </dev/null

mkdir -p "${home_directory}/.config"

info 'Cloning the dotfiles repository...'
dotfiles_https_repository="https://github.com/${DOTFILES_REPOSITORY}.git"
if ! run_nix_shell -p git --run \
  "git clone '${dotfiles_https_repository}' '${config_directory}'"
then
  die "Could not clone '${dotfiles_https_repository}'. Check the repository URL and network connection."
fi

if [[ "$interactive" == 'true' ]] && prompt_yes_no 'Use SSH for future Git operations?'; then
  dotfiles_ssh_repository="git@github.com:${DOTFILES_REPOSITORY}.git"
  if ! run_nix_shell -p git --run \
    "git -C '${config_directory}' remote set-url origin '${dotfiles_ssh_repository}'"
  then
    die "Could not change the Git origin to '${dotfiles_ssh_repository}'."
  fi
fi

{
  cat <<EOF
{
  home.username = "$(nix_escape "$username")";
  home.homeDirectory = "$(nix_escape "$home_directory")";
EOF

  if [[ "$interactive" == 'true' ]]; then
    cat <<EOF

  programs.git.settings.user = {
    name = "$(nix_escape "$git_user_name")";
    email = "$(nix_escape "$git_user_email")";
  };
EOF
  fi

  printf '%s\n' '}'
} > "${config_directory}/local.nix"

info 'Installing and activating Home Manager...'
if ! (
  export HOME="$home_directory"
  export USER="$username"
  unset XDG_CONFIG_HOME
  cd "$config_directory"
  run_nix_shell '<home-manager>' -A install
); then
  die "Home Manager installation failed. The dotfiles checkout remains at '${config_directory}'."
fi

success 'Home Manager is installed and the dotfiles are active.'
