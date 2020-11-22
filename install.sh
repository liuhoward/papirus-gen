#!/bin/bash

ROOT_UID=0
DEST_DIR=

# Destination directory
if [ "$UID" -eq "$ROOT_UID" ]; then
  DEST_DIR="/usr/share/icons"
else
  DEST_DIR="$HOME/.icons"
fi

SRC_DIR=$(cd $(dirname $0) && pwd)

THEME_NAME=Papirus

usage() {
  printf "%s\n" "Usage: $0 [OPTIONS...]"
  printf "\n%s\n" "OPTIONS:"
  printf "  %-25s%s\n" "-d, --dest DIR" "Specify theme destination directory (Default: ${DEST_DIR})"
  printf "  %-25s%s\n" "-n, --name NAME" "Specify theme name (Default: ${THEME_NAME})"
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
    -n|--name)
      name="${2}"
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
name=${name:-${THEME_NAME}}

THEME_DIR=${dest}/${name}

echo "Installing '${THEME_DIR}'..."
rm -rf ${THEME_DIR}
mkdir -p ${THEME_DIR}


papirus_version=$(wget --no-check-certificate -qO- https://api.github.com/repos/PapirusDevelopmentTeam/papirus-icon-theme/releases/latest | grep 'tag_name' | cut -d\" -f4)

wget -O papirus.tar.gz "https://github.com/PapirusDevelopmentTeam/papirus-icon-theme/archive/${papirus_version}.tar.gz" &&
tar -zxf papirus.tar.gz -C /tmp/ &&
rm -f papirus.tar.gz &&

cp -r /tmp/papirus-icon-theme-${papirus_version}/Papirus/* ${THEME_DIR}


cp -r --remove-destination 16x16/* ${THEME_DIR}/16x16/

#bash ../svgscale.sh $size &&    # output is vague

sizes=(22 24 32 48 64)
for size in ${sizes[@]}
do
  cp -r --remove-destination places/* ${THEME_DIR}/${size}x${size}/places/
done


sizes=(16 22 24 32 48 64)
for size in ${sizes[@]}
do
  cp -r --remove-destination apps/* ${THEME_DIR}/${size}x${size}/apps/
done


sizes=(16 22 24 32 48 64)
for size in ${sizes[@]}
do
  cp -r --remove-destination mimetypes/* ${THEME_DIR}/${size}x${size}/mimetypes/
done


cd ${SRC_DIR}


cd ${dest}
gtk-update-icon-cache ${name}${theme}






