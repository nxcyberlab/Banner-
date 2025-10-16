#!/bin/bash
# ==========================================
#        ⚡ NX CYBER LAB MENU SYSTEM ⚡
# ==========================================

# --- Color Codes ---
r='\033[1;91m'
g='\033[1;92m'
y='\033[1;93m'
b='\033[1;94m'
c='\033[1;96m'
w='\033[1;97m'
n='\033[0m'

# --- Animated Banner ---
banner() {
    clear
    for i in {1..3}; do
        echo -e "${b}╔══════════════════════════════════════════╗${n}"
        echo -e "${c}         ⚡ NX CYBER LAB TOOLS ⚡${n}"
        echo -e "${b}╚══════════════════════════════════════════╝${n}"
        sleep 0.15
        clear
        echo -e "${c}╔══════════════════════════════════════════╗${n}"
        echo -e "${b}         ⚡ NX CYBER LAB TOOLS ⚡${n}"
        echo -e "${c}╚══════════════════════════════════════════╝${n}"
        sleep 0.15
        clear
    done
    echo -e "${b}╔══════════════════════════════════════════╗${n}"
    echo -e "${g}         🔥 NX CYBER LAB TOOLS 🔥${n}"
    echo -e "${b}╚══════════════════════════════════════════╝${n}"
    echo -e "${y}           Created by NX AL IMRAN${n}"
    echo
}

# --- Loading Animation ---
loading() {
    echo -ne "${c}Connecting"
    for i in {1..5}; do
        echo -ne "."
        sleep 0.3
    done
    echo -e " ${g}OK${n}"
    sleep 0.5
}

# --- Menu ---
menu() {
    banner
    echo -e "${c}[1]${w} Free Version"
    echo -e "${c}[2]${w} Premium Version"
    echo -e "${c}[0]${w} Exit"
    echo
    echo -en "${y}Select Option [1-2]: ${n}"
}

# --- Main Logic ---
menu
read -n 1 choice
echo

case $choice in
    1)
        loading
        echo -e "${b}[>] Opening YouTube Channel...${n}"
        termux-open-url "https://youtube.com/@nxcyberlab"
        sleep 2
        if [ -f "𝓷xᵇαꪀn̶e̤r.ѕh.sh" ]; then
            echo -e "${g}[+] Starting Free Version...${n}"
            sleep 1
            bash 𝓷xᵇαꪀn̶e̤r.ѕh.sh
        else
            echo -e "${r}[x] Free script not found!${n}"
        fi
        ;;
    2)
        loading
        echo -e "${g}[+] Redirecting to Telegram Premium...${n}"
        sleep 1
        termux-open-url "https://t.me/NX_AL_IMRAN_S"
        ;;
    0)
        echo -e "${y}Exiting...${n}"
        exit 0
        ;;
    *)
        echo -e "${r}[x] Invalid option!${n}"
        ;;
esac