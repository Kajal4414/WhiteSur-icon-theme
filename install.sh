#!/usr/bin/env bash

set -eo pipefail

ROOT_UID=0
DEST_DIR=

# Destination directory
if [ "$UID" -eq "$ROOT_UID" ]; then
  DEST_DIR="/usr/share/icons"
else
  DEST_DIR="$HOME/.local/share/icons"
fi

SRC_DIR="$(cd "$(dirname "$0")" && pwd)"

THEME_NAME=WhiteSur
COLOR_VARIANTS=('' '-light' '-dark')
THEME_VARIANTS=('' '-purple' '-pink' '-red' '-orange' '-yellow' '-green' '-grey' '-nord')

themes=()
colors=()

find_icon_target() {
  local theme_dir=${1}
  local icon_name=${2}
  local context
  local candidate

  for context in actions apps categories devices emblems mimes places status; do
    candidate="${theme_dir}/${context}/symbolic/${icon_name}"

    if [[ -e "${candidate}" || -L "${candidate}" ]]; then
      printf '%s\n' "${candidate}"
      return 0
    fi
  done

  return 1
}

xsi_fallback_icon() {
  case "${1}" in
    accessibility-symbolic.svg) printf '%s\n' "preferences-desktop-accessibility-symbolic.svg" ;;
    addon-symbolic.svg) printf '%s\n' "application-x-addon-symbolic.svg" ;;
    airplane-symbolic.svg) printf '%s\n' "airplane-mode-symbolic.svg" ;;
    appliance-symbolic.svg) printf '%s\n' "application-x-appliance-symbolic.svg" ;;
    applications-administration-symbolic.svg) printf '%s\n' "preferences-system-symbolic.svg" ;;
    applications-preferences-symbolic.svg) printf '%s\n' "preferences-system-symbolic.svg" ;;
    applications-webapps-symbolic.svg) printf '%s\n' "web-browser-symbolic.svg" ;;
    applications-wine-symbolic.svg) printf '%s\n' "folder-wine-symbolic.svg" ;;
    apps-symbolic.svg) printf '%s\n' "preferences-desktop-apps-symbolic.svg" ;;
    audio-volume-control-symbolic.svg) printf '%s\n' "multimedia-volume-control-symbolic.svg" ;;
    battery-ac-symbolic.svg) printf '%s\n' "ac-adapter-symbolic.svg" ;;
    battery-level-100-charging-symbolic.svg) printf '%s\n' "battery-full-charging-symbolic.svg" ;;
    boot-menu-symbolic.svg) printf '%s\n' "open-menu-symbolic.svg" ;;
    check-spelling-symbolic.svg) printf '%s\n' "tools-check-spelling-symbolic.svg" ;;
    cog-symbolic.svg) printf '%s\n' "cog-wheel-symbolic.svg" ;;
    cog2-symbolic.svg) printf '%s\n' "cog-wheel-symbolic.svg" ;;
    color-symbolic.svg) printf '%s\n' "preferences-color-symbolic.svg" ;;
    cpu-symbolic.svg) printf '%s\n' "am-cpu-symbolic.svg" ;;
    calculator-symbolic.svg) printf '%s\n' "accessories-calculator-symbolic.svg" ;;
    certificate-symbolic.svg) printf '%s\n' "application-certificate-symbolic.svg" ;;
    devices-symbolic.svg) printf '%s\n' "preferences-system-devices-symbolic.svg" ;;
    diaporama-symbolic.svg) printf '%s\n' "xapp-diaporama-symbolic.svg" ;;
    dictionary-symbolic.svg) printf '%s\n' "accessories-dictionary-symbolic.svg" ;;
    edit-page-symbolic.svg) printf '%s\n' "document-edit-symbolic.svg" ;;
    emote-love-symbolic.svg) printf '%s\n' "emblem-favorite-symbolic.svg" ;;
    engineering-symbolic.svg) printf '%s\n' "applications-engineering-symbolic.svg" ;;
    executable-symbolic.svg) printf '%s\n' "application-x-executable-symbolic.svg" ;;
    eye-symbolic.svg) printf '%s\n' "object-visible-symbolic.svg" ;;
    face-plain-symbolic.svg) printf '%s\n' "user-info-symbolic.svg" ;;
    face-sad-symbolic.svg) printf '%s\n' "user-info-symbolic.svg" ;;
    face-smile-big-symbolic.svg) printf '%s\n' "user-info-symbolic.svg" ;;
    face-smile-symbolic.svg) printf '%s\n' "user-info-symbolic.svg" ;;
    face-smirk-symbolic.svg) printf '%s\n' "user-info-symbolic.svg" ;;
    face-surprise-symbolic.svg) printf '%s\n' "user-info-symbolic.svg" ;;
    face-uncertain-symbolic.svg) printf '%s\n' "user-info-symbolic.svg" ;;
    face-wink-symbolic.svg) printf '%s\n' "user-info-symbolic.svg" ;;
    favorite-symbolic.svg) printf '%s\n' "xapp-favorite-symbolic.svg" ;;
    file-manager-symbolic.svg) printf '%s\n' "system-file-manager-symbolic.svg" ;;
    firmware-symbolic.svg) printf '%s\n' "application-x-firmware-symbolic.svg" ;;
    folder-warning-symbolic.svg) printf '%s\n' "dialog-warning-symbolic.svg" ;;
    font-symbolic.svg) printf '%s\n' "applications-fonts-symbolic.svg" ;;
    format-text-direction-left-symbolic.svg) printf '%s\n' "format-text-direction-ltr-symbolic.svg" ;;
    format-text-direction-right-symbolic.svg) printf '%s\n' "format-text-direction-rtl-symbolic.svg" ;;
    format-text-highlight-symbolic.svg) printf '%s\n' "xapp-format-text-highlight-symbolic.svg" ;;
    games-symbolic.svg) printf '%s\n' "applications-games-symbolic.svg" ;;
    geolocation-disabled-symbolic.svg) printf '%s\n' "location-disabled-symbolic.svg" ;;
    geolocation-symbolic.svg) printf '%s\n' "location-symbolic.svg" ;;
    git-pr-symbolic.svg) printf '%s\n' "builder-vcs-git-symbolic.svg" ;;
    git-symbolic.svg) printf '%s\n' "folder-git-symbolic.svg" ;;
    github-symbolic.svg) printf '%s\n' "folder-github-symbolic.svg" ;;
    go-history-next-symbolic-rtl.svg) printf '%s\n' "xapp-go-history-next-symbolic.svg" ;;
    go-history-next-symbolic.svg) printf '%s\n' "xapp-go-history-next-symbolic.svg" ;;
    go-history-previous-symbolic-rtl.svg) printf '%s\n' "xapp-go-history-previous-symbolic.svg" ;;
    go-history-previous-symbolic.svg) printf '%s\n' "xapp-go-history-previous-symbolic.svg" ;;
    graphics-symbolic.svg) printf '%s\n' "applications-graphics-symbolic.svg" ;;
    group-symbolic.svg) printf '%s\n' "object-group-symbolic.svg" ;;
    keyboard-character-symbolic.svg) printf '%s\n' "preferences-desktop-keyboard-symbolic.svg" ;;
    keyboard-shortcuts-symbolic.svg) printf '%s\n' "preferences-desktop-keyboard-shortcuts-symbolic.svg" ;;
    keyboard-symbolic.svg) printf '%s\n' "preferences-desktop-keyboard-symbolic.svg" ;;
    lock-screen-symbolic.svg) printf '%s\n' "system-lock-screen-symbolic.svg" ;;
    log-out-symbolic-rtl.svg) printf '%s\n' "system-log-out-rtl-symbolic.svg" ;;
    log-out-symbolic.svg) printf '%s\n' "system-log-out-symbolic.svg" ;;
    multimedia-symbolic.svg) printf '%s\n' "applications-multimedia-symbolic.svg" ;;
    multitasking-symbolic.svg) printf '%s\n' "preferences-desktop-multitasking-symbolic.svg" ;;
    network-proxy-symbolic.svg) printf '%s\n' "preferences-system-network-proxy-symbolic.svg" ;;
    network-symbolic.svg) printf '%s\n' "network-wired-symbolic.svg" ;;
    parental-controls-symbolic.svg) printf '%s\n' "preferences-system-parental-control-symbolic.svg" ;;
    pci-card-symbolic.svg) printf '%s\n' "drive-harddisk-symbolic.svg" ;;
    preview-symbolic.svg) printf '%s\n' "xapp-prefs-preview-symbolic.svg" ;;
    preferences-symbolic.svg) printf '%s\n' "preferences-system-symbolic.svg" ;;
    privacy-symbolic.svg) printf '%s\n' "preferences-system-privacy-symbolic.svg" ;;
    ram-symbolic.svg) printf '%s\n' "am-memory-symbolic.svg" ;;
    reboot-symbolic.svg) printf '%s\n' "system-reboot-symbolic.svg" ;;
    remote-desktop-symbolic.svg) printf '%s\n' "preferences-desktop-remote-desktop-symbolic.svg" ;;
    rss-symbolic.svg) printf '%s\n' "application-rss+xml-symbolic.svg" ;;
    run-symbolic.svg) printf '%s\n' "system-run-symbolic.svg" ;;
    science-symbolic.svg) printf '%s\n' "applications-science-symbolic.svg" ;;
    screensaver-symbolic.svg) printf '%s\n' "preferences-desktop-screensaver-symbolic.svg" ;;
    search-entire-word-symbolic.svg) printf '%s\n' "xapp-search-entire-word-symbolic.svg" ;;
    search-wrap-symbolic.svg) printf '%s\n' "xapp-search-wrap-symbolic.svg" ;;
    sharedlib-symbolic.svg) printf '%s\n' "library-symbolic.svg" ;;
    shutdown-symbolic.svg) printf '%s\n' "system-shutdown-symbolic.svg" ;;
    sign-at-symbolic.svg) printf '%s\n' "mail-message-new-symbolic.svg" ;;
    sign-forbidden-symbolic.svg) printf '%s\n' "dialog-warning-symbolic.svg" ;;
    sign-info-symbolic.svg) printf '%s\n' "dialog-information-symbolic.svg" ;;
    sim-locked-symbolic.svg) printf '%s\n' "auth-sim-locked-symbolic.svg" ;;
    sim-missing-symbolic.svg) printf '%s\n' "auth-sim-missing-symbolic.svg" ;;
    sim-symbolic.svg) printf '%s\n' "sim-card-symbolic.svg" ;;
    smartcard-symbolic.svg) printf '%s\n' "auth-smartcard-symbolic.svg" ;;
    software-install-symbolic.svg) printf '%s\n' "system-software-install-symbolic.svg" ;;
    swiss-knife-symbolic.svg) printf '%s\n' "tools-symbolic.svg" ;;
    switch-user-symbolic-rtl.svg) printf '%s\n' "system-switch-user-rtl-symbolic.svg" ;;
    text-case-symbolic.svg) printf '%s\n' "xapp-text-case-symbolic.svg" ;;
    time-symbolic.svg) printf '%s\n' "preferences-system-time-symbolic.svg" ;;
    toolbar-symbolic.svg) printf '%s\n' "xapp-prefs-toolbar-symbolic.svg" ;;
    toolbox-symbolic.svg) printf '%s\n' "tools-symbolic.svg" ;;
    unfavorite-symbolic.svg) printf '%s\n' "xapp-unfavorite-symbolic.svg" ;;
    usb-stick-symbolic.svg) printf '%s\n' "drive-removable-media-usb-symbolic.svg" ;;
    usb-symbolic.svg) printf '%s\n' "usb-hub-symbolic.svg" ;;
    use-regex-symbolic.svg) printf '%s\n' "xapp-use-regex-symbolic.svg" ;;
    user-favorites-symbolic.svg) printf '%s\n' "user-bookmarks-symbolic.svg" ;;
    users-symbolic.svg) printf '%s\n' "system-users-symbolic.svg" ;;
    view-fit-height-symbolic.svg) printf '%s\n' "xapp-view-fit-height-symbolic.svg" ;;
    view-fit-width-symbolic.svg) printf '%s\n' "xapp-view-fit-width-symbolic.svg" ;;
    wallpaper-symbolic.svg) printf '%s\n' "preferences-desktop-wallpaper-symbolic.svg" ;;
    *) return 1 ;;
  esac
}

install_xsi_icon_links() {
  local theme_dir=${1}
  local hicolor_dir="/usr/share/icons/hicolor/scalable/actions"
  local alias_path
  local icon_path
  local icon_name
  local target_name
  local target_path
  local fallback_name
  local installed=0

  [[ -d "${hicolor_dir}" ]] || return 0
  [[ -d "${theme_dir}/actions/symbolic" ]] || return 0

  while IFS= read -r icon_path; do
    icon_name=${icon_path##*/}
    target_name=${icon_name#xsi-}
    target_path=$(find_icon_target "${theme_dir}" "${target_name}" || true)

    if [[ -z "${target_path}" ]]; then
      fallback_name=$(xsi_fallback_icon "${target_name}" || true)

      if [[ -n "${fallback_name}" ]]; then
        target_path=$(find_icon_target "${theme_dir}" "${fallback_name}" || true)
      fi
    fi

    [[ -n "${target_path}" ]] || continue

    alias_path="${theme_dir}/actions/symbolic/${icon_name}"
    [[ -e "${alias_path}" || -L "${alias_path}" ]] && continue

    ln -sr "${target_path}" "${alias_path}"
    installed=$((installed + 1))
  done < <(find "${hicolor_dir}" -maxdepth 1 -type f -name 'xsi-*-symbolic*.svg' | sort)

  if [[ "${installed}" -gt 0 ]]; then
    echo "Installed ${installed} Linux Mint XSI icon aliases."
  fi
}

usage() {
cat << EOF
  Usage: $0 [OPTION]...

  OPTIONS:
    -d, --dest DIR          Specify destination directory (Default: $DEST_DIR)
    -n, --name NAME         Specify theme name (Default: $THEME_NAME)
    -t, --theme VARIANT     Specify theme color variant(s) [default|purple|pink|red|orange|yellow|green|grey|nord|all] (Default: blue)
    -a, --alternative       Install alternative icons for software center and file-manager
    -b, --bold              Install bolder panel icons version (1.5px size)
    -p, --kde-plasma        Replaces Apple logo with KDE Plasma logo.

    -r, --remove,
    -u, --uninstall         Uninstall (remove) icon themes

    -h, --help              Show help
EOF
}

install() {
  local dest=${1}
  local name=${2}
  local theme=${3}
  local color=${4}

  local THEME_DIR=${dest}/${name}${theme}${color}

  [[ -d "${THEME_DIR}" ]] && rm -rf "${THEME_DIR}"

  echo "Installing '${THEME_DIR}'..."

  mkdir -p                                                                                   "${THEME_DIR}"
#  cp -r "${SRC_DIR}"/{COPYING,AUTHORS}                                                       "${THEME_DIR}"
  cp -r "${SRC_DIR}"/src/index.theme                                                         "${THEME_DIR}"

  #cd "${THEME_DIR}"
  sed -i "s/WhiteSur/${name}${theme}${color}/g" "${THEME_DIR}"/index.theme

  if [[ ${color} == '' ]]; then
    mkdir -p                                                                                 "${THEME_DIR}"/status
    cp -r "${SRC_DIR}"/src/{actions,animations,apps,categories,devices,emotes,emblems,mimes,places,preferences} "${THEME_DIR}"
    cp -r "${SRC_DIR}"/src/status/{16,22,24,32,symbolic}                                     "${THEME_DIR}"/status

    if [[ ${black:-} == 'true' ]]; then
      sed -i "s/#f2f2f2/#363636/g" "${THEME_DIR}"/status/{16,22,24}/*
    fi

    if [[ ${bold:-} == 'true' ]]; then
      cp -r "${SRC_DIR}"/bold/*                                                              "${THEME_DIR}"
    fi

    if [[ $DESKTOP_SESSION == '/usr/share/xsessions/budgie-desktop' ]]; then
      cp -r "${SRC_DIR}"/src/status/symbolic-budgie/*.svg                                    "${THEME_DIR}"/status/symbolic
    fi

    if [[ ${alternative:-} == 'true' ]]; then
      cp -r "${SRC_DIR}"/alternative/*                                                       "${THEME_DIR}"
    fi

    if [[ ${plasma:-} == 'true' ]]; then
      cp -r "${SRC_DIR}"/plasma/*                                                            "${THEME_DIR}"
    fi

    if [[ ${theme} != '' ]]; then
      cp -r "${SRC_DIR}"/colors/color${theme}/*.svg                                          "${THEME_DIR}"/places/scalable
    fi

    rm -rf "${THEME_DIR}"/places/scalable/user-trash{'','-full'}-dark.svg

    cp -r "${SRC_DIR}"/links/{actions,apps,categories,devices,emotes,emblems,mimes,places,status,preferences} "${THEME_DIR}"
  fi

  if [[ ${color} == '-light' ]]; then
    mkdir -p                                                                                 "${THEME_DIR}"/status
    cp -r ${SRC_DIR}/src/status/{16,22,24,32}                                                "${THEME_DIR}"/status

    if [[ ${bold:-} == 'true' ]]; then
      cp -r "${SRC_DIR}"/bold/status/{16,22,24}                                              "${THEME_DIR}"/status
    fi

    # Change icon color for light theme
    sed -i "s/#f2f2f2/#363636/g" "${THEME_DIR}"/status/{16,22,24,32}/*
    cp -r "${SRC_DIR}"/links/status/{16,22,24,32}                                            "${THEME_DIR}"/status

    cd ${dest}
    ln -s ../${name}${theme}/actions ${name}${theme}-light/actions
    ln -s ../${name}${theme}/animations ${name}${theme}-light/animations
    ln -s ../${name}${theme}/apps ${name}${theme}-light/apps
    ln -s ../${name}${theme}/categories ${name}${theme}-light/categories
    ln -s ../${name}${theme}/devices ${name}${theme}-light/devices
    ln -s ../${name}${theme}/emotes ${name}${theme}-light/emotes
    ln -s ../${name}${theme}/emblems ${name}${theme}-light/emblems
    ln -s ../${name}${theme}/mimes ${name}${theme}-light/mimes
    ln -s ../${name}${theme}/places ${name}${theme}-light/places
    ln -s ../${name}${theme}/preferences ${name}${theme}-light/preferences
    ln -s ../../${name}${theme}/status/symbolic ${name}${theme}-light/status/symbolic
  fi

  if [[ ${color} == '-dark' ]]; then
    mkdir -p                                                                                 "${THEME_DIR}"/{apps,categories,emblems,devices,mimes,places,status}

    cp -r "${SRC_DIR}"/src/actions                                                           "${THEME_DIR}"
    cp -r "${SRC_DIR}"/src/apps/{16,22,32,symbolic}                                          "${THEME_DIR}"/apps
    cp -r "${SRC_DIR}"/src/categories/{22,symbolic}                                          "${THEME_DIR}"/categories
    cp -r "${SRC_DIR}"/src/emblems/symbolic                                                  "${THEME_DIR}"/emblems
    cp -r "${SRC_DIR}"/src/mimes/symbolic                                                    "${THEME_DIR}"/mimes
    cp -r "${SRC_DIR}"/src/devices/{16,22,24,32,symbolic}                                    "${THEME_DIR}"/devices
    cp -r "${SRC_DIR}"/src/places/{16,22,24,scalable,symbolic}                               "${THEME_DIR}"/places
    cp -r "${SRC_DIR}"/src/status/symbolic                                                   "${THEME_DIR}"/status

    if [[ ${bold:-} == 'true' ]]; then
      cp -r "${SRC_DIR}"/bold/actions/symbolic/*.svg                                         "${THEME_DIR}"/actions/symbolic
      cp -r "${SRC_DIR}"/bold/apps/symbolic/*.svg                                            "${THEME_DIR}"/apps/symbolic
      cp -r "${SRC_DIR}"/bold/devices/symbolic/*.svg                                         "${THEME_DIR}"/devices/symbolic
      cp -r "${SRC_DIR}"/bold/status/symbolic/*.svg                                          "${THEME_DIR}"/status/symbolic
    fi

    if [[ ${alternative:-} == 'true' ]]; then
      cp -r "${SRC_DIR}"/alternative/apps/symbolic/*.svg                                     "${THEME_DIR}"/apps/symbolic
      cp -r "${SRC_DIR}"/alternative/places/scalable/*.svg                                   "${THEME_DIR}"/places/scalable
    fi

    if [[ ${theme} != '' ]]; then
      cp -r "${SRC_DIR}"/colors/color${theme}/*.svg                                          "${THEME_DIR}"/places/scalable
    fi

    if [[ $DESKTOP_SESSION == '/usr/share/xsessions/budgie-desktop' ]]; then
      cp -r "${SRC_DIR}"/src/status/symbolic-budgie/*.svg                                    "${THEME_DIR}"/status/symbolic
    fi

    mv -f "${THEME_DIR}"/places/scalable/user-trash-dark.svg "${THEME_DIR}"/places/scalable/user-trash.svg
    mv -f "${THEME_DIR}"/places/scalable/user-trash-full-dark.svg "${THEME_DIR}"/places/scalable/user-trash-full.svg

    # Change icon color for dark theme
    sed -i "s/#363636/#dedede/g" "${THEME_DIR}"/{actions,devices,places}/{16,22,24}/*.svg
    sed -i "s/#363636/#dedede/g" "${THEME_DIR}"/apps/{16,22,32}/*.svg
    sed -i "s/#363636/#dedede/g" "${THEME_DIR}"/categories/22/*.svg
    sed -i "s/#363636/#dedede/g" "${THEME_DIR}"/{actions,devices}/32/*.svg
    sed -i "s/#363636/#dedede/g" "${THEME_DIR}"/{actions,apps,categories,emblems,devices,mimes,places,status}/symbolic/*.svg

    cp -r "${SRC_DIR}"/links/actions/{16,22,24,32,symbolic}                                  "${THEME_DIR}"/actions
    cp -r "${SRC_DIR}"/links/devices/{16,22,24,32,symbolic}                                  "${THEME_DIR}"/devices
    cp -r "${SRC_DIR}"/links/places/{16,22,24,scalable,symbolic}                             "${THEME_DIR}"/places
    cp -r "${SRC_DIR}"/links/apps/{16,22,32,symbolic}                                        "${THEME_DIR}"/apps
    cp -r "${SRC_DIR}"/links/categories/{22,symbolic}                                        "${THEME_DIR}"/categories
    cp -r "${SRC_DIR}"/links/mimes/symbolic                                                  "${THEME_DIR}"/mimes
    cp -r "${SRC_DIR}"/links/status/symbolic                                                 "${THEME_DIR}"/status

    cd ${dest}
    ln -s ../${name}${theme}/animations ${name}${theme}-dark/animations
    ln -s ../${name}${theme}/emotes ${name}${theme}-dark/emotes
    ln -s ../${name}${theme}/preferences ${name}${theme}-dark/preferences
    ln -s ../../${name}${theme}/categories/32 ${name}${theme}-dark/categories/32
    ln -s ../../${name}${theme}/emblems/16 ${name}${theme}-dark/emblems/16
    ln -s ../../${name}${theme}/emblems/22 ${name}${theme}-dark/emblems/22
    ln -s ../../${name}${theme}/emblems/24 ${name}${theme}-dark/emblems/24
    ln -s ../../${name}${theme}/mimes/16 ${name}${theme}-dark/mimes/16
    ln -s ../../${name}${theme}/mimes/22 ${name}${theme}-dark/mimes/22
    ln -s ../../${name}${theme}/mimes/scalable ${name}${theme}-dark/mimes/scalable
    ln -s ../../${name}${theme}/apps/scalable ${name}${theme}-dark/apps/scalable
    ln -s ../../${name}${theme}/devices/scalable ${name}${theme}-dark/devices/scalable
    ln -s ../../${name}${theme}/status/16 ${name}${theme}-dark/status/16
    ln -s ../../${name}${theme}/status/22 ${name}${theme}-dark/status/22
    ln -s ../../${name}${theme}/status/24 ${name}${theme}-dark/status/24
    ln -s ../../${name}${theme}/status/32 ${name}${theme}-dark/status/32
  fi

  (
    cd "${THEME_DIR}"
    ln -sf actions actions@2x
    ln -sf animations animations@2x
    ln -sf apps apps@2x
    ln -sf categories categories@2x
    ln -sf devices devices@2x
    ln -sf emotes emotes@2x
    ln -sf emblems emblems@2x
    ln -sf mimes mimes@2x
    ln -sf places places@2x
    ln -sf preferences preferences@2x
    ln -sf status status@2x
  )

  if [[ ${color} != '-light' ]]; then
    install_xsi_icon_links "${THEME_DIR}"
  fi

  gtk-update-icon-cache "${THEME_DIR}"
}

uninstall() {
  local dest=${1}
  local name=${2}
  local theme=${3}
  local color=${4}

  local THEME_DIR=${dest}/${name}${theme}${color}

  [[ -d "${THEME_DIR}" ]] && rm -rf "${THEME_DIR}"

  echo "Uninstalling '"${THEME_DIR}"'..."
}

while [[ "$#" -gt 0 ]]; do
  case "${1:-}" in
    -d|--dest)
      dest="$2"
      mkdir -p "$dest"
      shift 2
      ;;
    -n|--name)
      name="${2}"
      shift 2
      ;;
    -a|--alternative)
      alternative='true'
      echo "Installing 'alternative' version..."
      shift
      ;;
    -b|--bold)
      bold='true'
      echo "Installing 'bold' version..."
      shift
      ;;
    -p|--kde-plasma)
      plasma='true'
      echo "Replacing Apple logo with KDE Plasma logo..."
      shift
      ;;
    -r|--remove|-u|--uninstall)
      remove='true'
      shift
      ;;
    -t|--theme)
      shift
      for theme in "${@}"; do
        case "${theme}" in
          default)
            themes+=("${THEME_VARIANTS[0]}")
            shift
            ;;
          purple)
            themes+=("${THEME_VARIANTS[1]}")
            shift
            ;;
          pink)
            themes+=("${THEME_VARIANTS[2]}")
            shift
            ;;
          red)
            themes+=("${THEME_VARIANTS[3]}")
            shift
            ;;
          orange)
            themes+=("${THEME_VARIANTS[4]}")
            shift
            ;;
          yellow)
            themes+=("${THEME_VARIANTS[5]}")
            shift
            ;;
          green)
            themes+=("${THEME_VARIANTS[6]}")
            shift
            ;;
          grey)
            themes+=("${THEME_VARIANTS[7]}")
            shift
            ;;
          nord)
            themes+=("${THEME_VARIANTS[8]}")
            shift
            ;;
          all)
            themes+=("${THEME_VARIANTS[@]}")
            shift
            ;;
          -*|--*)
            break
            ;;
          *)
            echo "ERROR: Unrecognized theme variant '$1'."
            echo "Try '$0 --help' for more information."
            exit 1
            ;;
        esac
        # echo "Installing '${theme}' folder version..."
      done
      ;;
    -h|--help)
      usage
      exit 0
      ;;
    *)
      echo "ERROR: Unrecognized installation option '$1'."
      echo "Try '$0 --help' for more information."
      exit 1
      ;;
  esac
done

if [[ "${#themes[@]}" -eq 0 ]]; then
  themes=("${THEME_VARIANTS[0]}")
fi

if [[ "${#colors[@]}" -eq 0 ]]; then
  colors=("${COLOR_VARIANTS[@]}")
fi

install_theme() {
  for theme in "${themes[@]}"; do
    for color in "${colors[@]}"; do
      install "${dest:-${DEST_DIR}}" "${name:-${THEME_NAME}}" "${theme}" "${color}"
    done
  done
}

uninstall_theme() {
  for theme in "${THEME_VARIANTS[@]}"; do
    for color in "${COLOR_VARIANTS[@]}"; do
      uninstall "${dest:-${DEST_DIR}}" "${name:-${THEME_NAME}}" "${theme}" "${color}"
    done
  done
}

if [[ "${remove}" == 'true' ]]; then
  uninstall_theme
else
  install_theme
fi

#exit 0
