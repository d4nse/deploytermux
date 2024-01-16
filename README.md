
<h1 align="center">Termux Deployment Script</h1>

<div align="center">
<div>
Custom <a href="https://github.com/termux/termux-app">Termux</a> config.
</div>
<p></p>
    <a href="#features">Features</a>
  <span> • </span>
    <a href="#installation">Installation</a>
  <span> • </span>
    <a href="https://wiki.termux.com/wiki/Main_Page">Docs</a>
  <p></p>
</div>


### <a name="#features"></a> Features
* [**Dropbear**](https://github.com/mkj/dropbear): Remote access
* [**Neovim**](https://github.com/neovim/neovim): Editor for quick editing
* [**PowerLevel10K**](https://github.com/romkatv/powerlevel10k): Powerful Zsh theme
* [**MesloLGS**](https://github.com/romkatv/powerlevel10k/blob/master/font.md): Cool font
* **Neon** dark colorscheme
* [**MOTD**](/rice/dots/.zprofile): Simple custom login message


## <a name="#installation"></a> Installation
1. Install [Termux](https://f-droid.org/en/packages/com.termux/)
2. Install [Termux:API](https://f-droid.org/en/packages/com.termux.api/)
3. Install git:
```zsh
pkg install git
```
4. Clone this repo:
```zsh
git clone https://github.com/d4nse/deploytermux
```
5. Cd into repo:
```zsh
cd deploytermux
```
6. Run the script:
```zsh
chmod +x deploy.sh
bash deploy.sh
```

### Post Installation
To get SSH working without passwords follow these:
1. Set `passwd` on Termux
2. On PC run `ssh-keygen -t rsa -b 4096` (No need for that if you already have keys generated)
3. And this `ssh your_phone_local_ip mkdir -p ~/.ssh && cat > ~/.ssh/authorized_keys <$HOME/.ssh/id_rsa.pub`

This basically estsablishes ssh connection with your phone, creates ".ssh" directory in your termux home and cats your public ssh key from PC to Termux.
