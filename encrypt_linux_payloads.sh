#!/bin/bash

# Ctrl+C Exit
trap "echo -e '\n\e[1;31m[!] Exiting...\e[0m'; exit" INT

# Banner
banner() {
  echo -e "\e[1;32m"
  echo "=============================================="
  echo "       🐚 linux Payload Encryptor - Bash      "
  echo "      ⚙️ Encoding: Base64 + ROT13 + Reverse    "
  echo "          🔒 Accepts any payload format         "
  echo "=============================================="
  echo -e "\e[0m"
}

# Encryption Function (safe for any code)
encrypt_string() {
  local input="$1"

  # Encode safely
  local b64=$(printf '%s' "$input" | base64 -w 0)
  local rot13=$(echo "$b64" | tr 'A-Za-z' 'N-ZA-Mn-za-m')
  local reversed=$(echo "$rot13" | rev)

  # Output final payload (safe eval using bash)
  echo "bash -c \"\$(echo '$reversed' | rev | tr 'A-Za-z' 'N-ZA-Mn-za-m' | base64 -d)\""
}

# Encrypt a Custom Payload
encrypt_command() {
  echo -e "\e[1;33mEnter your full payload (any language, multi-line supported). Press Ctrl+D to finish:\e[0m"
  user_cmd=$(</dev/stdin)

  if [[ -z "$user_cmd" ]]; then
    echo -e "\e[1;31m[!] Empty payload! Try again.\e[0m"
    return
  fi

  final=$(encrypt_string "$user_cmd")

  echo -e "\n\e[1;32m[+] Encrypted Payload:\e[0m"
  echo -e "\e[1;36m$final\e[0m"
}

# Encrypt Payload from File
encrypt_file() {
  read -p $'\e[1;33mEnter full path of your payload file:\e[0m ' filepath

  if [[ ! -f "$filepath" ]]; then
    echo -e "\e[1;31m[!] File not found!\e[0m"
    return
  fi

  content=$(<"$filepath")
  final=$(encrypt_string "$content")

  filename=$(basename -- "$filepath")
  extension="${filename##*.}"
  name="${filename%.*}"
  output="${name}-encrypted.${extension}"

  echo "$final" > "$output"
  chmod +x "$output"
  echo -e "\n\e[1;32m[+] Encrypted payload saved as:\e[0m \e[1;36m$output\e[0m"
}

# Main Menu
main_menu() {
  while true; do
    echo -e "\n\e[1;34mChoose an option:\e[0m"
    echo -e "\e[1;33m[1]\e[0m Encrypt custom payload"
    echo -e "\e[1;33m[2]\e[0m Encrypt payload from file"
    read -p $'\e[1;33mSelect option [1-2]: \e[0m' option

    case "$option" in
      1) encrypt_command; break ;;
      2) encrypt_file; break ;;
      *) echo -e "\e[1;31m[!] Invalid option. Try again.\e[0m" ;;
    esac
  done
}

# Run
clear
banner
main_menu


