ZSH_THEME="powerlevel9k/powerlevel9k"

if [ `tty` = "/dev/tty2" ]; then
  securefs m ~/Drive/sync/sfs ~/Drive/mount/sfs --pass 
fi
if [ `tty` = "/dev/tty3" ]; then
  openvpn client.ovpn
fi

alias ai="sudo apt-get install"
alias aup="sudo apt-get update"
alias aug="sudo apt-get dist-upgrade"
alias au="aup && aug"
alias c=clear
