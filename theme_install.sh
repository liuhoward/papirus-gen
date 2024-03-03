#!/bin/bash

headline() {
	printf "%b => %b%s\n" "\e[1;32m" "\e[0m" "$*"
}

msg() {
	printf "%b [+] %b%s\n" "\e[1;33m" "\e[0m" "$*"
}

ROOT_UID=0
DEST_DIR=

# Destination directory
if [ "$UID" -eq "$ROOT_UID" ]; then
  DEST_DIR="/usr/share/themes"
else
  DEST_DIR="$HOME/.themes"
fi

SRC_DIR=$(cd $(dirname $0) && pwd)


usage() {
  printf "%s\n" "Usage: $0 [OPTIONS...]"
  printf "\n%s\n" "OPTIONS:"
  printf "  %-25s%s\n" "-d, --dest DIR" "Specify theme destination directory (Default: ${DEST_DIR})"
  printf "  %-25s%s\n" "-h, --help" "Show this help"
}

while [[ $# -gt 0 ]]; do
  case "${1}" in
    -d|--dest)
      dest="${2}"
      if [[ ! -d "${dest}" ]]; then
        echo "ERROR: Destination directory does not exist."
        exit 1
      fi
      shift 2
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
  shift
done


dest=${dest:-${DEST_DIR}}

THEME_DIR=${dest}

echo "Installing '${THEME_DIR}'..."
rm -rf ${THEME_DIR}/WhiteSur*


theme_version=$(wget --no-check-certificate -qO- https://api.github.com/repos/vinceliuice/WhiteSur-gtk-theme/releases/latest | grep 'tag_name' | cut -d\" -f4)

wget -O whitesur.tar.gz "https://github.com/vinceliuice/WhiteSur-gtk-theme/archive/${theme_version}.tar.gz" &&
tar -zxf whitesur.tar.gz -C /tmp/ &&
rm -f whitesur.tar.gz &&

find /tmp/WhiteSur-gtk-theme-${theme_version}/src/sass/ -name "_colors-palette.scss" -type f -exec sed -i 's/#0860F2/#94BBEF/g' {} \;

bash /tmp/WhiteSur-gtk-theme-${theme_version}/install.sh -d ${THEME_DIR}



