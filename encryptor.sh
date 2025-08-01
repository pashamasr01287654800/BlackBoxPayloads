#!/bin/bash

# Ctrl+C Exit
trap "echo -e '\n\e[1;31m[!] Exiting...\e[0m'; exit" INT

# Banner
banner() {
  echo -e "\e[1;32m"
  echo "=============================================="
  echo "         Custom Payload Encryptor - Bash      "
  echo "         🔒 Encrypt any command or file        "
  echo "        Encoding: Base64 + ROT13 + Reverse    "
  echo "=============================================="
  echo -e "\e[0m"
}

# Encryption Function
encrypt_string() {
  local input="$1"
  local b64=$(echo "$input" | base64)
  local rot13=$(echo "$b64" | tr 'A-Za-z' 'N-ZA-Mn-za-m')
  local reversed=$(echo "$rot13" | rev)
  echo "eval \"\$(echo $reversed | rev | tr 'A-Za-z' 'N-ZA-Mn-za-m' | base64 -d)\""
}

# Encrypt a Custom Command
encrypt_command() {
  read -p $'\e[1;33mEnter your command to encrypt:\e[0m\n> ' user_cmd

  if [[ -z "$user_cmd" ]]; then
    echo -e "\e[1;31m[!] Empty command! Try again.\e[0m"
    return
  fi

  final=$(encrypt_string "$user_cmd")

  echo -e "\n\e[1;32m[+] Encrypted Command:\e[0m"
  echo -e "\e[1;36m$final\e[0m"
}

# Encrypt a Payload from File
encrypt_file() {
  read -p $'\e[1;33mEnter payload file path:\e[0m ' filepath

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

  echo -e "\n\e[1;32m[+] Encrypted file saved as:\e[0m \e[1;36m$output\e[0m"
}

# Menu
main_menu() {
  while true; do
    echo -e "\n\e[1;34mChoose mode:\e[0m"
    echo -e "\e[1;33m[1]\e[0m Encrypt custom command"
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


