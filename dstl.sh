#!/bin/bash

set -euo pipefail

VENV_PATH="/root/Flask-server"
source "$VENV_PATH/bin/activate"
#PATH 
FILE_PATH="/root/Drone-Data-Server"

usage() {
cat <<EOF
Usage: $(basename "$0") <command> <subcommand> [args...]

Commands
  dstl create license                                      #create license serial 
  dstl help                                                #Show help

EOF
}

choose_model() {
  while true; do
    echo "Choose model:"
    echo "1) modelA"
    echo "2) modelB"
    echo "3) modelC"
    read -rp "Select model [1-3]: " model_choice

    case "$model_choice" in
      1) MODEL="modelA"; break ;;
      2) MODEL="modelB"; break ;;
      3) MODEL="modelC"; break ;;
      *) echo "Invalid choice. Please select 1, 2,3." ;;
    esac
  done
}

input_serial() {
  while true; do
    echo "ex : abc123456789"
    read -rp "Enter serial number: " SERIAL
    [[ -n "$SERIAL" ]] && break
    echo "Serial cannot be empty."
  done
}

choose_version() {
  while true; do
    echo "Select firmware version:"
    echo "1) 1.0.0"
    echo "2) 1.1.1"
    read -rp "Select version [1-2]: " version_choice

    case "$version_choice" in
      1) VERSION="1.0.0"; break ;;
      2) VERSION="1.0.1"; break ;;
      *) echo "❌ Invalid choice. Please select 1 or 2." ;;
    esac
  done
}

main() {
  CMD="$1"
  SUBCMD="${2:-}"

  if [[ $# -lt 2 ]]; then
    usage
    exit 1
  fi

  if [[ "$CMD" == "create" && "$SUBCMD" == "license" ]]; then
    choose_model
    input_serial
    choose_version

    echo "Creating license with:"
    echo "  Model    : $MODEL"
    echo "  Serial   : $SERIAL"
    echo "  Version  : $VERSION"

    python3 "$FILE_PATH/create_license.py" "$MODEL" "$SERIAL" "$VERSION" 
  else
    usage
    exit 1
  fi

  if [[ "$CMD" == "help" ]]; then
    usage
  fi

}

main "$@"
