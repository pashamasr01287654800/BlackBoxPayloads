# 🐚 BlackBoxPayloads

**BlackBoxPayloads** is a pure Bash toolkit that provides a full system for generating and encrypting reverse shell payloads — with zero external dependencies. It supports Linux, and macOS, and works with many common payload formats.

---

## ⚙️ Features

- ✅ Written entirely in Bash – no external tools required  
- ✅ Generate reverse shell payloads for Linux, macOS  
- ✅ Advanced encryption: Base64 → ROT13 → Reverse  
- ✅ Support for all major payload types (bash, js, php, python...)  
- ✅ Fully interactive and easy to use  
- ✅ 100% compatible with `nc` (netcat)

---

## 📁 Project Structure

| File                   | Description |
|------------------------|-------------|
| `silentShell.sh`       | Interactive reverse shell payload generator |
| `encryptor_linux.sh`   | Encrypts Linux payloads using Base64 + ROT13 + Reverse |

---

## 🚀 Usage

### 1. Generate Reverse Shell Payload

```bash
chmod +x silentShell.sh
./silentShell.sh

Select target OS (Linux / macOS)

Select payload type (bash, python, etc.)

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

💡 Supported Formats

OS	Payloads

Linux	bash, sh, zsh, python2/3, perl, php, ruby, nc, awk, java
macOS	bash, zsh, python3



---

⚠️ Disclaimer

> This project is intended for educational and authorized security testing purposes only.
Misuse of this tool is entirely your own responsibility.




---

👨‍💻 Built With Love

> Fully written in Bash by ChatGPT, with contributions from the cybersecurity community.




---





