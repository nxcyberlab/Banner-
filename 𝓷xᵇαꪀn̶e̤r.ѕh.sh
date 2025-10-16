#!/data/data/com.termux/files/usr/bin/bash
# Tool: NX CYBER LAB
# Author: NX AL IMRAN S
# Website: https://www.nxalimrans.bloger.com

# --- Color Codes ---
r='\033[1;91m'
g='\033[1;92m'
y='\033[1;93m'
b='\033[1;94m'
c='\033[1;96m'
n='\033[0m'

# --- Symbols ---
A="[${g}+${n}]"
C="[${c}/${n}]"
E="[${r}x${n}]"
I="[${y}!${n}]"

# --- Main Banner Function ---
main_banner() {
    clear
    echo -e "   ${y}███╗░░██╗██╗░░██╗"
    echo -e "   ${y}████╗░██║╚██╗██╔╝"
    echo -e "   ${y}██╔██╗██║░╚███╔╝░"
    echo -e "   ${y}██║╚████║░██╔██╗░"
    echo -e "   ${y}██║░╚███║██╔╝╚██╗"
    echo -e "   ${c}╚═╝░░╚══╝╚═╝░░╚═╝"
    echo -e "${y}   +-+-+-+-+-+-+-+-+-+-+-+-+-+-+"
    echo -e "${c}   |N|X| |C|Y|B|E|R| |L|A|B|"
    echo -e "${y}   +-+-+-+-+-+-+-+-+-+-+-+-+-+-+${n}"
    echo
#!/bin/bash
bash <(base64 -d <<'B64'
ZWNobyAtZSAiJHtifeKVreKVkOKVkCAke2d944CEICR7eX1OWCBDWUJFUiBMQUIgJHtnfeOAhCIKZWNo
byAtZSAiJHtifeKUg+KdgSAke2d9QXV0aG9yICA6ICR7eX1OWCBBTCBJTVJBTiBTIgplY2hvIC1lICIk
e2J94pSD4p2BICR7Z31Qcm9maWxlICA6ICR7eX1ueGFsaW1yYW5zLmJsb2dlci5jb20iCmVjaG8gLWUg
IiR7Yn3ilIPinYEgJHtnfVdlYnNpdGUgOiAke3l9bnhjeWJlcmxhYi5ibG9nc3BvdC5jb20iCmVjaG8g
LWUgIiR7Yn3ilbDilIjinqQgJHtnfSBXZWxjb21lIHRvIHRoZSBpbnN0YWxsZXIhJHtufSIK
B64
)
}

# --- Spinner for long processes ---
spinner() {
    local pid=$1
    local msg=$2
    local delay=0.1
    local spinstr='|/-\'
    while [ "$(ps a | awk '{print $1}' | grep $pid)" ]; do
        local temp=${spinstr#?}
        printf " \r ${A} ${c}%s... [%s]  " "$msg" "$spinstr"
        spinstr=$temp${spinstr%"$temp"}
        sleep $delay
    done
    printf " \r ${A} ${g}%s... [Done]${n}\n" "$msg"
}

# --- Function to install all dependencies ---
install_dependencies() {
    echo -e "${A} ${y}Updating package lists...${n}"
    pkg update -y > /dev/null 2>&1 &
    spinner $! "Updating"

    echo -e "${A} ${y}Installing required packages. This might take a while...${n}"
    local packages=("git" "zsh" "figlet" "ruby" "ncurses-utils" "lsd" "nano")
    for package in "${packages[@]}"; do
        if ! command -v $package &> /dev/null; then
            pkg install "$package" -y > /dev/null 2>&1 &
            spinner $! "Installing $package"
        fi
    done

    if ! command -v lolcat &> /dev/null; then
        gem install lolcat > /dev/null 2>&1 &
        spinner $! "Installing lolcat"
    fi
    echo -e "${A} ${g}All dependencies are installed successfully!${n}"
    sleep 1
}

# --- Function to automatically install Nerd Font ---
install_nerd_font() {
    echo -e "${A} ${c}Looking for Nerd Font (font.ttf)...${n}"
    # Get the directory where the script is located
    SCRIPT_DIR=$(dirname "$(readlink -f "$0")")
    FONT_SOURCE="$SCRIPT_DIR/font.ttf"
    FONT_DEST="$HOME/.termux/font.ttf"

    if [ -f "$FONT_SOURCE" ]; then
        echo -e "${A} ${g}Nerd Font found! Installing automatically...${n}"
        mkdir -p "$HOME/.termux"
        cp "$FONT_SOURCE" "$FONT_DEST"
        echo -e "${A} ${g}Font installed successfully to ~/.termux/font.ttf${n}"
    else
        echo -e "${I} ${y}Warning: 'font.ttf' not found in the same directory as the script.${n}"
        echo -e "${I} ${y}Skipping automatic font installation. Please install a Nerd Font manually for icon support.${n}"
    fi
}


# --- Main Setup Function ---
setup_environment() {
    main_banner
    echo -e "${I} ${c}This script will configure your Termux shell.${n}"
    echo

    # --- Get User Input ---
    local BANNER_TEXT
    while true; do
        read -p "$(echo -e "${g}[+] Enter your Banner Text (1-8 chars): ${y}")" BANNER_TEXT
        if [[ ${#BANNER_TEXT} -ge 1 && ${#BANNER_TEXT} -le 8 ]]; then
            break
        else
            echo -e " ${E} ${r}Error: Name must be between 1 and 8 characters. Please try again.${n}"
        fi
    done

    local NICKNAME
    read -p "$(echo -e "${g}[+] Enter your Nickname for the prompt: ${y}")" NICKNAME
    echo

    # --- Install Oh My Zsh and plugins ---
    echo -e "${A} ${c}Installing Oh My Zsh and plugins...${n}"
    if [ ! -d "$HOME/.oh-my-zsh" ]; then
        git clone https://github.com/ohmyzsh/ohmyzsh.git "$HOME/.oh-my-zsh" --quiet
    fi
    if [ ! -d "${ZSH_CUSTOM:-$HOME/.oh-my-zsh/custom}/plugins/zsh-autosuggestions" ]; then
        git clone https://github.com/zsh-users/zsh-autosuggestions ${ZSH_CUSTOM:-$HOME/.oh-my-zsh/custom}/plugins/zsh-autosuggestions --quiet
    fi
    if [ ! -d "${ZSH_CUSTOM:-$HOME/.oh-my-zsh/custom}/plugins/zsh-syntax-highlighting" ]; then
        git clone https://github.com/zsh-users/zsh-syntax-highlighting.git ${ZSH_CUSTOM:-$HOME/.oh-my-zsh/custom}/plugins/zsh-syntax-highlighting --quiet
    fi

    # --- Create .zshrc file using HERE Document ---
    echo -e "${A} ${c}Creating '.zshrc' configuration file...${n}"
    cat <<EOF > "$HOME/.zshrc"
# Path to your oh-my-zsh installation.
export ZSH="\$HOME/.oh-my-zsh"

# Set name of the theme to load.
ZSH_THEME="nxcyberlab"

# Export variables for the prompt and banner BEFORE loading Oh My Zsh
export NICKNAME="${NICKNAME}"
export BANNER_TEXT="${BANNER_TEXT}"

# Add wisely, as too many plugins slow down shell startup.
plugins=(git zsh-autosuggestions zsh-syntax-highlighting)

# Load Oh My Zsh
source \$ZSH/oh-my-zsh.sh

# --- Custom aliases ---
alias cls='clear'
alias update='pkg update && pkg upgrade'
alias ls='lsd --icon=auto'
alias la='lsd -a --icon=auto'

# --- Custom Banner Function at startup ---
show_banner() {
    clear
    local width=\$(tput cols)
    echo
    figlet -c -f ASCII-Shadow -w \$width "\${BANNER_TEXT}" | lolcat
    echo
    echo -e " \033[1;92mWelcome to NX CYBER LAB, '\033[1;93m\${BANNER_TEXT}\033[1;92m'!"
}

show_banner
EOF

# --- Create the custom theme file ---
    echo -e "${A} ${c}Creating custom theme 'nxsiverlab'...${n}"
    mkdir -p "$HOME/.oh-my-zsh/custom/themes"
    cat <<EOF > "$HOME/.oh-my-zsh/custom/themes/nxcyberlab.zsh-theme"
# NX CYBER LAB Custom Theme
# Author: NX AL IMRAN S

PROMPT uses \$'...' to correctly interpret newline characters like \n
PROMPT=\$'%F{cyan}╭─%f%F{cyan}[%f%F{magenta}\${NICKNAME}%f%F{yellow}〄%f%F{green}\${BANNER_TEXT}%f%F{cyan}]%f%F{cyan}-[%f%F{green}%~%f%F{cyan}]%f
%F{cyan}╰───%f %F{yellow}❯%f%F{blue}❯%f%F{cyan}❯%f '
EOF

    # --- Install Figlet Font ---
    echo -e "${A} ${c}Installing required font for banner...${n}"
    mkdir -p "$PREFIX/share/figlet"
    cat <<'EOF' > "$PREFIX/share/figlet/ASCII-Shadow.flf"
flf2a$ 7 7 13 0 7 0 64 0
Font Author: ?

More Info:

https://web.archive.org/web/20120819044459/http://www.roysac.com/thedrawfonts-tdf.asp

FIGFont created with: http://patorjk.com/figfont-editor
$  $@
$  $@
$  $@
$  $@
$  $@
$  $@
$  $@@
██╗@
██║@
██║@
╚═╝@
██╗@
╚═╝@
   @@
@
@
@
@
@
@
@@
 ██╗ ██╗ @
████████╗@
╚██╔═██╔╝@
████████╗@
╚██╔═██╔╝@
 ╚═╝ ╚═╝ @
         @@
▄▄███▄▄·@
██╔════╝@
███████╗@
╚════██║@
███████║@
╚═▀▀▀══╝@
        @@
██╗ ██╗@
╚═╝██╔╝@
  ██╔╝ @
 ██╔╝  @
██╔╝██╗@
╚═╝ ╚═╝@
       @@
   ██╗   @
   ██║   @
████████╗@
██╔═██╔═╝@
██████║  @
╚═════╝  @
         @@
@
@
@
@
@
@
@@
 ██╗@
██╔╝@
██║ @
██║ @
╚██╗@
 ╚═╝@
    @@
██╗ @
╚██╗@
 ██║@
 ██║@
██╔╝@
╚═╝ @
    @@
      @
▄ ██╗▄@
 ████╗@
▀╚██╔▀@
  ╚═╝ @
      @
      @@
@
@
@
@
@
@
@@
   @
   @
   @
   @
▄█╗@
╚═╝@
   @@
      @
      @
█████╗@
╚════╝@
      @
      @
      @@
   @
   @
   @
   @
██╗@
╚═╝@
   @@
    ██╗@
   ██╔╝@
  ██╔╝ @
 ██╔╝  @
██╔╝   @
╚═╝    @
       @@
 ██████╗ @
██╔═████╗@
██║██╔██║@
████╔╝██║@
╚██████╔╝@
 ╚═════╝ @
         @@
 ██╗@
███║@
╚██║@
 ██║@
 ██║@
 ╚═╝@
    @@
██████╗ @
╚════██╗@
 █████╔╝@
██╔═══╝ @
███████╗@
╚══════╝@
        @@
██████╗ @
╚════██╗@
 █████╔╝@
 ╚═══██╗@
██████╔╝@
╚═════╝ @
        @@
██╗  ██╗@
██║  ██║@
███████║@
╚════██║@
     ██║@
     ╚═╝@
        @@
███████╗@
██╔════╝@
███████╗@
╚════██║@
███████║@
╚══════╝@
        @@
 ██████╗ @
██╔════╝ @
███████╗ @
██╔═══██╗@
╚██████╔╝@
 ╚═════╝ @
         @@
███████╗@
╚════██║@
    ██╔╝@
   ██╔╝ @
   ██║  @
   ╚═╝  @
        @@
 █████╗ @
██╔══██╗@
╚█████╔╝@
██╔══██╗@
╚█████╔╝@
 ╚════╝ @
        @@
 █████╗ @
██╔══██╗@
╚██████║@
 ╚═══██║@
 █████╔╝@
 ╚════╝ @
        @@
   @
██╗@
╚═╝@
██╗@
╚═╝@
   @
   @@
   @
██╗@
╚═╝@
▄█╗@
▀═╝@
   @
   @@
  ██╗@
 ██╔╝@
██╔╝ @
╚██╗ @
 ╚██╗@
  ╚═╝@
     @@
@
@
@
@
@
@
@@
██╗  @
╚██╗ @
 ╚██╗@
 ██╔╝@
██╔╝ @
╚═╝  @
     @@
██████╗ @
╚════██╗@
  ▄███╔╝@
  ▀▀══╝ @
  ██╗   @
  ╚═╝   @
        @@
 ██████╗ @
██╔═══██╗@
██║██╗██║@
██║██║██║@
╚█║████╔╝@
 ╚╝╚═══╝ @
         @@
 █████╗ @
██╔══██╗@
███████║@
██╔══██║@
██║  ██║@
╚═╝  ╚═╝@
        @@
██████╗ @
██╔══██╗@
██████╔╝@
██╔══██╗@
██████╔╝@
╚═════╝ @
        @@
 ██████╗@
██╔════╝@
██║     @
██║     @
╚██████╗@
 ╚═════╝@
        @@
██████╗ @
██╔══██╗@
██║  ██║@
██║  ██║@
██████╔╝@
╚═════╝ @
        @@
███████╗@
██╔════╝@
█████╗  @
██╔══╝  @
███████╗@
╚══════╝@
        @@
███████╗@
██╔════╝@
█████╗  @
██╔══╝  @
██║     @
╚═╝     @
        @@
 ██████╗ @
██╔════╝ @
██║  ███╗@
██║   ██║@
╚██████╔╝@
 ╚═════╝ @
         @@
██╗  ██╗@
██║  ██║@
███████║@
██╔══██║@
██║  ██║@
╚═╝  ╚═╝@
        @@
██╗@
██║@
██║@
██║@
██║@
╚═╝@
   @@
     ██╗@
     ██║@
     ██║@
██   ██║@
╚█████╔╝@
 ╚════╝ @
        @@
██╗  ██╗@
██║ ██╔╝@
█████╔╝ @
██╔═██╗ @
██║  ██╗@
╚═╝  ╚═╝@
        @@
██╗     @
██║     @
██║     @
██║     @
███████╗@
╚══════╝@
        @@
███╗   ███╗@
████╗ ████║@
██╔████╔██║@
██║╚██╔╝██║@
██║ ╚═╝ ██║@
╚═╝     ╚═╝@
           @@
███╗   ██╗@
████╗  ██║@
██╔██╗ ██║@
██║╚██╗██║@
██║ ╚████║@
╚═╝  ╚═══╝@
          @@
 ██████╗ @
██╔═══██╗@
██║   ██║@
██║   ██║@
╚██████╔╝@
 ╚═════╝ @
         @@
██████╗ @
██╔══██╗@
██████╔╝@
██╔═══╝ @
██║     @
╚═╝     @
        @@
 ██████╗ @
██╔═══██╗@
██║   ██║@
██║▄▄ ██║@
╚██████╔╝@
 ╚══▀▀═╝ @
         @@
██████╗ @
██╔══██╗@
██████╔╝@
██╔══██╗@
██║  ██║@
╚═╝  ╚═╝@
        @@
███████╗@
██╔════╝@
███████╗@
╚════██║@
███████║@
╚══════╝@
        @@
████████╗@
╚══██╔══╝@
   ██║   @
   ██║   @
   ██║   @
   ╚═╝   @
         @@
██╗   ██╗@
██║   ██║@
██║   ██║@
██║   ██║@
╚██████╔╝@
 ╚═════╝ @
         @@
██╗   ██╗@
██║   ██║@
██║   ██║@
╚██╗ ██╔╝@
 ╚████╔╝ @
  ╚═══╝  @
         @@
██╗    ██╗@
██║    ██║@
██║ █╗ ██║@
██║███╗██║@
╚███╔███╔╝@
 ╚══╝╚══╝ @
          @@
██╗  ██╗@
╚██╗██╔╝@
 ╚███╔╝ @
 ██╔██╗ @
██╔╝ ██╗@
╚═╝  ╚═╝@
        @@
██╗   ██╗@
╚██╗ ██╔╝@
 ╚████╔╝ @
  ╚██╔╝  @
   ██║   @
   ╚═╝   @
         @@
███████╗@
╚══███╔╝@
  ███╔╝ @
 ███╔╝  @
███████╗@
╚══════╝@
        @@
███╗@
██╔╝@
██║ @
██║ @
███╗@
╚══╝@
    @@
@
@
@
@
@
@
@@
███╗@
╚██║@
 ██║@
 ██║@
███║@
╚══╝@
    @@
 ███╗ @
██╔██╗@
╚═╝╚═╝@
      @
      @
      @
      @@
        @
        @
        @
        @
███████╗@
╚══════╝@
        @@
@
@
@
@
@
@
@@
 █████╗ @
██╔══██╗@
███████║@
██╔══██║@
██║  ██║@
╚═╝  ╚═╝@
        @@
██████╗ @
██╔══██╗@
██████╔╝@
██╔══██╗@
██████╔╝@
╚═════╝ @
        @@
 ██████╗@
██╔════╝@
██║     @
██║     @
╚██████╗@
 ╚═════╝@
        @@
██████╗ @
██╔══██╗@
██║  ██║@
██║  ██║@
██████╔╝@
╚═════╝ @
        @@
███████╗@
██╔════╝@
█████╗  @
██╔══╝  @
███████╗@
╚══════╝@
        @@
███████╗@
██╔════╝@
█████╗  @
██╔══╝  @
██║     @
╚═╝     @
        @@
 ██████╗ @
██╔════╝ @
██║  ███╗@
██║   ██║@
╚██████╔╝@
 ╚═════╝ @
         @@
██╗  ██╗@
██║  ██║@
███████║@
██╔══██║@
██║  ██║@
╚═╝  ╚═╝@
        @@
██╗@
██║@
██║@
██║@
██║@
╚═╝@
   @@
     ██╗@
     ██║@
     ██║@
██   ██║@
╚█████╔╝@
 ╚════╝ @
        @@
██╗  ██╗@
██║ ██╔╝@
█████╔╝ @
██╔═██╗ @
██║  ██╗@
╚═╝  ╚═╝@
        @@
██╗     @
██║     @
██║     @
██║     @
███████╗@
╚══════╝@
        @@
███╗   ███╗@
████╗ ████║@
██╔████╔██║@
██║╚██╔╝██║@
██║ ╚═╝ ██║@
╚═╝     ╚═╝@
           @@
███╗   ██╗@
████╗  ██║@
██╔██╗ ██║@
██║╚██╗██║@
██║ ╚████║@
╚═╝  ╚═══╝@
          @@
 ██████╗ @
██╔═══██╗@
██║   ██║@
██║   ██║@
╚██████╔╝@
 ╚═════╝ @
         @@
██████╗ @
██╔══██╗@
██████╔╝@
██╔═══╝ @
██║     @
╚═╝     @
        @@
 ██████╗ @
██╔═══██╗@
██║   ██║@
██║▄▄ ██║@
╚██████╔╝@
 ╚══▀▀═╝ @
         @@
██████╗ @
██╔══██╗@
██████╔╝@
██╔══██╗@
██║  ██║@
╚═╝  ╚═╝@
        @@
███████╗@
██╔════╝@
███████╗@
╚════██║@
███████║@
╚══════╝@
        @@
████████╗@
╚══██╔══╝@
   ██║   @
   ██║   @
   ██║   @
   ╚═╝   @
         @@
██╗   ██╗@
██║   ██║@
██║   ██║@
██║   ██║@
╚██████╔╝@
 ╚═════╝ @
         @@
██╗   ██╗@
██║   ██║@
██║   ██║@
╚██╗ ██╔╝@
 ╚████╔╝ @
  ╚═══╝  @
         @@
██╗    ██╗@
██║    ██║@
██║ █╗ ██║@
██║███╗██║@
╚███╔███╔╝@
 ╚══╝╚══╝ @
          @@
██╗  ██╗@
╚██╗██╔╝@
 ╚███╔╝ @
 ██╔██╗ @
██╔╝ ██╗@
╚═╝  ╚═╝@
        @@
██╗   ██╗@
╚██╗ ██╔╝@
 ╚████╔╝ @
  ╚██╔╝  @
   ██║   @
   ╚═╝   @
         @@
███████╗@
╚══███╔╝@
  ███╔╝ @
 ███╔╝  @
███████╗@
╚══════╝@
        @@
@
@
@
@
@
@
@@
@
@
@
@
@
@
@@
@
@
@
@
@
@
@@
@
@
@
@
@
@
@@
@
@
@
@
@
@
@@
@
@
@
@
@
@
@@
@
@
@
@
@
@
@@
@
@
@
@
@
@
@@
@
@
@
@
@
@
@@
@
@
@
@
@
@
@@
@
@
@
@
@
@
@@
EOF

    # --- Auto-install Nerd Font ---
    install_nerd_font

    # --- Final Steps ---
    chsh -s zsh

    # Reload Termux settings to apply the new font
    termux-reload-settings

    main_banner
    echo -e "${A} ${g}SUCCESS! Configuration is complete.${n}"
    echo -e "${I} ${y}Please type '${c}exit${y}' and RESTART the Termux app completely to see all changes.${n}"
    echo
}


# --- SCRIPT STARTS HERE ---

# 1. Check if running in Termux
if [ ! -d "/data/data/com.termux/files/usr/" ]; then
    echo -e "${E} ${r}Error: This script is designed for Termux only.${n}"
    exit 1
fi

# 2. Check for internet connection
main_banner
echo -e "${A} ${c}Checking for internet connection...${n}"
if ! curl -s --head http://www.google.com/ | grep "200 OK" > /dev/null; then
  echo -e "${E} ${r}Error: No internet connection found. Please connect to the internet and try again.${n}"
  exit 1
fi
echo -e "${A} ${g}Internet connection found.${n}"
sleep 1
# 3. Install all dependencies
install_dependencies

# 4. Run the main setup
setup_environment