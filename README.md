# deploytermux
This is a Termux deployment script, designed to quickly get it up and running with all the stuff I need.

## List of included stuff
- Dropbear – for remote shell
- Neovim – for editing code
- ZSH with Powerlevel10k theme (see rice/dots for .p10k.zsh and .zshrc)
- Nerdfont MesloLGS
- "Neon" colorscheme
- Some simple MOTD message (edit rice/dots/.zprofile to change it to your liking)


## Installation
1. Install [Termux](https://f-droid.org/en/packages/com.termux/)
2. Install [Termux:API](https://f-droid.org/en/packages/com.termux.api/)
3. `pkg install git`
4. `git clone https://github.com/d4nse/deploytermux`
5. `cd deploytermux`
6. `bash deploy.sh`

## Post Installation
To get SSH working without passwords follow these:
1. Set `passwd` on Termux
2. On PC run `ssh-keygen -t rsa -b 4096` (No need for that if you already have keys generated)
3. And this `ssh your_phone_local_ip mkdir -p ~/.ssh && cat > ~/.ssh/authorized_keys <$HOME/.ssh/id_rsa.pub`.\ 
This basically estsablishes ssh connection with your phone, creates ".ssh" directory in your termux home and cats your public ssh key from PC to Termux.


## TODO
- [x] Code termux config and deployment
- [x] Code dropbear deployment (mostly manual)
- [x] Code basic neovim config and deployment
- [x] Code dependency installation
- [ ] Maybe code some would-be-handy scripts
- [ ] Come up with something more than that
