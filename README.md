# BlackBoxPayloads

أكيد يا نجم، ده نفس ملف README.md بس بالإنجليزي، احترافي وجاهز للرفع على GitHub:


---

# 🐚 stealthShells

**stealthShells** is a lightweight Bash project that combines multi-platform reverse shell generation with custom payload encryption — no external tools needed. Everything runs natively using just `bash` and `nc`.

## 📁 Project Files

| File              | Description |
|------------------|-------------|
| `silentShell.sh` | Multi-platform reverse shell generator for Linux, Windows, and macOS. Payloads are created interactively and saved to disk. |
| `encryptor.sh`   | Encrypts any command or payload using Base64 + ROT13 + Reverse, producing obfuscated versions that are still functional. |

---

## ⚙️ Features

- ✅ Pure Bash – no dependencies or external tools
- ✅ Supports multiple OS targets (Linux, Windows, macOS)
- ✅ Encrypts payloads for stealth and obfuscation
- ✅ Fully interactive and easy to use
- ✅ Works perfectly with `nc`

---

## 🚀 Usage

### 1. Generate Reverse Shell Payloads

```bash
chmod +x silentShell.sh
./silentShell.sh

Select the target OS (Linux / Windows / macOS)

Choose a payload format (bash, powershell, python, etc.)

Enter your LHOST and LPORT

Payload will be saved to a file like payload_nc.sh or payload_powershell.bat



---

2. Encrypt Custom Payloads or Commands

chmod +x encryptor.sh
./encryptor.sh

Option [1]: Encrypt a single custom command

Option [2]: Encrypt an entire payload from a file


Encrypted output will be shown and/or saved to a new file.


---

🔐 Example of Encrypted Payload Execution

eval "$(echo <encrypted_string> | rev | tr 'A-Za-z' 'N-ZA-Mn-za-m' | base64 -d)"

You can place this anywhere — in a script, cronjob, or exploit.


---

⚠️ Disclaimer

> This project is intended for educational and ethical use only.
Any misuse or unauthorized activity is strictly your own responsibility.
Always obtain proper authorization before running payloads or reverse shells on any system.




---

👨‍💻 Built With ❤️

> Fully written in pure Bash.
Created by ChatGPT + contributions from the cybersecurity community.


---


