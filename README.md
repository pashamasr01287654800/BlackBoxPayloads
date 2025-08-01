# 🐚 BlackBoxPayloads

**BlackBoxPayloads** is a pure Bash toolkit that provides a full system for generating and encrypting reverse shell payloads — with zero external dependencies. It supports Linux, Windows, and macOS, and works with many common payload formats.

---

## ⚙️ Features

- ✅ Written entirely in Bash – no external tools required  
- ✅ Generate reverse shell payloads for Linux, Windows, macOS  
- ✅ Advanced encryption: Base64 → ROT13 → Reverse  
- ✅ Support for all major payload types (bash, powershell, vbs, js, php, python...)  
- ✅ Fully interactive and easy to use  
- ✅ 100% compatible with `nc` (netcat)

---

## 📁 Project Structure

| File                   | Description |
|------------------------|-------------|
| `silentShell.sh`       | Interactive reverse shell payload generator |
| `encryptor_linux.sh`   | Encrypts Linux payloads using Base64 + ROT13 + Reverse |
| `encryptor_windows.sh` | Encrypts Windows payloads (.ps1, .bat, .vbs, .js, .hta) with proper wrapper logic |

---

## 🚀 Usage

### 1. Generate Reverse Shell Payload

```bash
chmod +x silentShell.sh
./silentShell.sh

Select target OS (Linux / Windows / macOS)

Select payload type (bash, powershell, python, etc.)

Enter LHOST and LPORT

Payload will be saved as: payload_<type>.<ext>



---

2. Encrypt Payload (Linux)

chmod +x encryptor_linux.sh
./encryptor_linux.sh

Options:

[1] Encrypt a custom command (multi-line supported)

[2] Encrypt from an existing payload file


Resulting output is a safe, executable bash command like:

bash -c "$(echo '<payload>' | rev | tr 'A-Za-z' 'N-ZA-Mn-za-m' | base64 -d)"


---

3. Encrypt Payload (Windows)

chmod +x encryptor_windows.sh
./encryptor_windows.sh

Options:

[1] Encrypt a Windows payload (PowerShell, BAT, etc.)

[2] Encrypt from a payload file


Produces fully working Windows payloads with embedded decryption logic.

Example:

powershell -NoP -NonI -W Hidden -Command "$e='<payload>'; <decryption_logic>"


---

💡 Supported Formats

OS	Payloads

Linux	bash, sh, zsh, python2/3, perl, php, ruby, nc, awk, java
Windows	powershell_tcp, powershell_web, vbs, js, hta
macOS	bash, zsh, python3



---

⚠️ Disclaimer

> This project is intended for educational and authorized security testing purposes only.
Misuse of this tool is entirely your own responsibility.




---

👨‍💻 Built With Love

> Fully written in Bash by ChatGPT, with contributions from the cybersecurity community.




---







