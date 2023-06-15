#######################################
# postinstall_debian_afterinternet.sh #
#######################################

echo "# Configure UFW"
cp  ~me/mystuff/myconfigs/before.rules /etc/ufw/before.rules
cp  ~me/mystuff/myconfigs/before6.rules /etc/ufw/before6.rules
mv /etc/ufw/applications.d/* /root
systemctl enable ufw
ufw enable
ufw reload

echo "# Purge crap installs"
apt purge -y firefox cups cups-browsed samba nfs-kernel-server spice-vdagent virtualbox-guest-utils-modified-init virtualbox-guest-utils nfs-common-modified-init* open-vm-tools

echo "# Add hashicorp apt repo"
wget -O- https://apt.releases.hashicorp.com/gpg | gpg --dearmor | sudo tee /usr/share/keyrings/hashicorp-archive-keyring.gpg
gpg --no-default-keyring --keyring /usr/share/keyrings/hashicorp-archive-keyring.gpg --fingerprint
echo "deb [signed-by=/usr/share/keyrings/hashicorp-archive-keyring.gpg] https://apt.releases.hashicorp.com $(lsb_release -cs) main" | sudo tee /etc/apt/sources.list.d/hashicorp.list

echo "# Add github-cli repo"
curl -fsSL https://cli.github.com/packages/githubcli-archive-keyring.gpg | sudo dd of=/usr/share/keyrings/githubcli-archive-keyring.gpg \
&& sudo chmod go+r /usr/share/keyrings/githubcli-archive-keyring.gpg \
&& echo "deb [arch=$(dpkg --print-architecture) signed-by=/usr/share/keyrings/githubcli-archive-keyring.gpg] https://cli.github.com/packages stable main" | sudo tee /etc/apt/sources.list.d/github-cli.list > /dev/null

echo "# Install required packages"
sudo apt update -y && sudo apt install -y apparmor apparmor-notify apparmor-profiles apparmor-profiles-extra apparmor-utils apt-transport-https aria2 curl docker.io fzf gh git httperf httping jq mtr nmap postgresql-client powertop  python3-pip python3-pynvim python3-venv ripgrep silversearcher-ag software-properties-common tcpdump terraform tlp tlp-rdw tmux tor zsh zsh-syntax-highlighting flatpak

echo "# Install kvm"
sudo apt install -y --no-install-recommends qemu-system libvirt-clients libvirt-daemon-system

echo "# Start docker libvirt tor & tlp on boot"
systemctl enable docker libvirtd tor tlp

echo "# Usermod for zsh, docker, libvirt and journalctl"
usermod -s /usr/bin/zsh me
usermod -aG docker me
usermod -aG libvirt me
usermod -aG systemd-journal me

echo "# Install golang"
tar -C /usr/local -zxvf /home/me/mystuff/go1.20.4.linux-amd64.tar.gz

echo "# Install helm"
~me/bin/get_helm.sh

echo "Install Firefox, Brave, Thunderbird, Zoom etc"
echo "Add Flathub"
flatpak remote-add --if-not-exists flathub https://flathub.org/repo/flathub.flatpakrepo
flatpak install -y flathub us.zoom.Zoom flathub org.jitsi.jitsi-meet com.tutanota.Tutanota org.mozilla.firefox org.mozilla.Thunderbird

#########################################################
echo "Now take care of stuff to be done as me (not root)
#########################################################
sudo su - me

echo "# Configure nvim for go"
mkdir go
ln -s $HOME/mystuff/myconfigs/nvim $HOME/.config/nvim

echo "# Symlink to zshrc and other stuff"
ln -s $HOME/mystuff/myconfigs/.completions
ln -s $HOME/mystuff/myconfigs/.ssh
ln -s $HOME/mystuff/myconfigs/.tmux.conf
ln -s $HOME/mystuff/myconfigs/.zshrc
ln -s $HOME/mystuff/mybin/tux bin

echo "# Get daily-use executables"
cd ~me/bin
./get_kind.sh
./get_kubectl.sh
./get_minikube.sh
./get_linkerd.sh
./get_argocd.sh
cd ~me


echo "# Installing gcloud & aws cli"
tar -xzvf mystuff/google-cloud-cli-397.0.0-linux-x86_64.tar.gz
unzip mystuff/awscliv2.zip
cd ~/aws/
./install -i ~/.local/aws-cli -b ~/.local/bin

## Set KVM env for user
#virsh  list --all

echo "# Setting firefox as default.browser"
xdg-mime default org.mozilla.firefox.desktop x-scheme-handler/https x-scheme-handler/http
xdg-settings set default-web-browser org.mozilla.firefox.desktop

## Installing Lynis

# sudo apt-key adv --keyserver keyserver.ubuntu.com --recv-keys 013baa07180c50a7101097ef9de922f1c2fde6c4

# echo 'Acquire::Languages "none";' | sudo tee /etc/apt/apt.conf.d/99disable-translations

# echo "deb https://packages.cisofy.com/community/lynis/deb/ stable main" | sudo tee /etc/apt/sources.list.d/cisofy-lynis.list

# apt update
# apt install lynis