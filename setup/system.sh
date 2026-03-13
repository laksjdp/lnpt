# ===============================
# ========== WSL Setup ==========
# ===============================
wsl --install kali-linux --name lnpt
# kali-tweaks
sudo nano ~/.bashrc
source ~/.bashrc
kupgrade

# =======================================
# ========== GPU Compatibility ==========
# =======================================
hashcat -I  # Check here
wget https://developer.download.nvidia.com/compute/cuda/repos/wsl-ubuntu/x86_64/cuda-keyring_1.0-1_all.deb
sudo dpkg -i cuda-keyring_1.0-1_all.deb
sudo apt update
sudo apt-get install -y cuda

# ====================================
# ========== Kali NetHunter ==========
# ====================================
https://github.com/termux/termux-app/releases
https://f-droid.org/packages/com.termux/

pkg update && pkg upgrade -y

termux-setup-storage
pkg install wget

wget -O install-nethunter-termux https://offs.ec/2MceZWr
chmod +x install-nethunter-termux
/install-nethunter-termux

# nethunter/nh          -> Start Kali NetHunter command line interface
# nh <command>          -> Run <command> in Kali NetHunter environment

# nh -r                     -> Start Kali NetHunter cli as root
# nethunter -r <command>    -> Run <command> in Kali NetHunter environment as root

# ===============================
# ========== ~/.Bashrc ==========
# ===============================
# ln -s /mnt/d/work ~/j
# if mountpoint -q /mnt/d/; then cd /mnt/d/work; else cd ~/Desktop; fi
alias kupgrade='sudo apt update && sudo apt upgrade -y && sudo apt autoremove -y'
alias obsh='sudo nano ~/.bashrc'
alias sbsh='source ~/.bashrc'

alias cdwork='cd /mnt/d/work'
alias cdws='cd /mnt/d//work/ws'
alias cdweb3='cd /mnt/d/work/web3'
alias cddownloads='cd /mnt/d/download'
alias cdlnpt='cd /mnt/d/work/lnpt'

alias codelnpt='code /mnt/d/work/lnpt'

alias emptyHistory='sudo echo "" > ~/.bash_history'
alias openHistory='sudo nano ~/.bash_history'

cd /mnt/d/work/ws && clear

echo -e "\n\e[97;44m   LAKS_JDP - Bug Bounty Hunting   \e[0m\n"

export GOPATH="$HOME/go"
export PATH="$PATH:$GOPATH/bin"

# =======================================
# ========== Chrome Extensions ==========
# =======================================
FoxyProxy
Link Gopher

# ==================================================
# ========== Daily Routine for Discipline ==========
# ==================================================
# Daily Routine for Discipline
#  ____From_12:00_AM_______  _________From_06:00_AM________________
# |    			           | |  By: 06:30 AM - Gentle Mobility     |
# |  By: 06:00 AM - Sleep  >>>  By: 08:15 AM - Work	               |
# | 			           | |  By: 08:30 AM - Breakfast           |
# | 			           | | 				                       |
# |____From_08:30_AM_______| |_________From_01:15_PM_______________|
# |  By: 11:15 AM - Work   | |  By: 01:30 PM - Lunch               |
# |  By: 11:30 AM - _Nap   >>>  By: 04:15 PM - Work                |
# |  By: 01:15 PM - Work   | |  By: 04:30 PM - _Nap                |
# | 			           | | 				                       |
# |____From_04:30_PM_______| |_________From_04:30_PM_______________|
# |  By: 08:15 PM - Work   | |  By: 10:30 PM - _Nap     	       |
# |  By: 08:30 PM - Dinner >>>  By: 11:00 PM - Wind-down 	       |
# |  By: 10:15 PM - Work   | |  By: 12:00 AM - Light creative work |
# |________________________| |_____________________________________|
