#!/usr/bin/env bash

#Package instaklls, put packages in packages-extra.txt
set -euo pipefail

PKG_FILE="${1:-packages.txt}"     # allow passing a custom file
GIT_TARGET_DIR="${GIT_TARGET_DIR:-$HOME/Code}"  # can be overridden: GIT_TARGET_DIR=/opt ./install-from-list.sh

# ---------- helpers ----------
err()  { printf "\e[31m[ERR]\e[0m %s\n" "$*" >&2; }
ok()   { printf "\e[32m[OK]\e[0m %s\n" "$*"; }
info() { printf "\e[33m[INFO]\e[0m %s\n" "$*"; }

if [[ ! -f "$PKG_FILE" ]]; then
  err "Package file '$PKG_FILE' not found."
  exit 1
fi

# detect yay
have_yay=0
if command -v yay >/dev/null 2>&1; then
  have_yay=1
else
  info "yay not found — AUR packages will be skipped unless you install yay first."
fi

# detect flatpak
have_flatpak=0
if command -v flatpak >/dev/null 2>&1; then
  have_flatpak=1
fi

# make git target dir
mkdir -p "$GIT_TARGET_DIR"

# ---------- read sections ----------
current_section=""
mapfile -t lines < <(sed 's/\r$//' "$PKG_FILE")

pacman_pkgs=()
aur_pkgs=()
flatpak_pkgs=()
git_repos=()

for line in "${lines[@]}"; do
  # trim
  line="${line#"${line%%[![:space:]]*}"}"
  line="${line%"${line##*[![:space:]]}"}"

  [[ -z "$line" ]] && continue
  [[ "$line" =~ ^# ]] && continue

  if [[ "$line" =~ ^\[[a-zA-Z0-9_-]+\]$ ]]; then
    current_section="${line#[}"
    current_section="${current_section%]}"
    continue
  fi

  case "$current_section" in
    pacman)
      pacman_pkgs+=("$line")
      ;;
    aur)
      aur_pkgs+=("$line")
      ;;
    flatpak)
      flatpak_pkgs+=("$line")
      ;;
    git)
      git_repos+=("$line")
      ;;
    *)
      info "Found line outside a known section, ignoring: $line"
      ;;
  esac
done

# ---------- PACMAN ----------
if ((${#pacman_pkgs[@]})); then
  info "Installing PACMAN packages: ${pacman_pkgs[*]}"
  sudo pacman -Syu --needed --noconfirm "${pacman_pkgs[@]}"
  ok "Pacman packages installed."
else
  info "No pacman packages listed."
fi

# ---------- AUR (yay) ----------
if ((${#aur_pkgs[@]})); then
  if ((have_yay)); then
    info "Installing AUR packages with yay: ${aur_pkgs[*]}"
    yay -S --needed --noconfirm "${aur_pkgs[@]}"
    ok "AUR packages installed."
  else
    err "AUR packages were listed but 'yay' is not installed. Skipping AUR section."
    err "Install yay first, then re-run this script."
  fi
else
  info "No AUR packages listed."
fi

# ---------- FLATPAK ----------
if ((${#flatpak_pkgs[@]})); then
  if ((have_flatpak)); then
    info "Installing Flatpaks: ${flatpak_pkgs[*]}"
    for fp in "${flatpak_pkgs[@]}"; do
      flatpak install -y "$fp"
    done
    ok "Flatpak packages installed."
  else
    err "Flatpak packages were listed but 'flatpak' command not found. Skipping Flatpak section."
  fi
else
  info "No Flatpak packages listed."
fi

# ---------- GIT CLONES ----------
if ((${#git_repos[@]})); then
  info "Cloning git repos into $GIT_TARGET_DIR"
  for entry in "${git_repos[@]}"; do
    # split into URL and optional target directory
    repo_url="$(awk '{print $1}' <<<"$entry")"
    repo_dir="$(awk '{print $2}' <<<"$entry")"

    if [[ -z "$repo_dir" ]]; then
      # derive from repo name if no custom dir given
      repo_dir="$(basename "$repo_url" .git)"
    fi

    target="$GIT_TARGET_DIR/$repo_dir"
    if [[ -d "$target/.git" ]]; then
      info "Repo already exists, pulling latest changes: $target"
      git -C "$target" pull --ff-only || true
    else
      info "Shallow cloning $repo_url -> $target"
      git clone --depth 1 "$repo_url" "$target"
    fi
  done
  ok "Git repositories processed."
else
  info "No git repositories listed."
fi

ok "All done ✅"
