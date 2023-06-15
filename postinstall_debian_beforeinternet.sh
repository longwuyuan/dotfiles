echo "# Disable ipv6 in Kernel"
sed -i 's/quiet/ipv6.disable=1 amd_pstate=passive/g' /etc/default/grub
update-grub2

echo "# Disable & stopping crap services"
set -x
systemctl disable avahi-daemon.service cups cups-browsed.service nss-lookup.target nss-user-lookup.target openvpn.service packagekit.service remote-fs.target unattended-upgrades.service ModemManager.service
systemctl stop avahi-daemon.service cups cups-browsed.service nss-lookup.target nss-user-lookup.target openvpn.service packagekit.service remote-fs.target unattended-upgrades.service ModemManager.service

echo "# Remove execute bin on crap executables"
chmod -x /usr/libexec/gvfsd-{dav,dnssd,ftp,google,http,nfs,network,sftp,smb,smb-browse} /usr/libexec/packagekit*

echo "# Disable ipv6 in sysctl"
sysctl -a 2>/dev/null | grep ipv6 | grep disable | sudo sed -e 's/= 0/= 1/g' >> /etc/sysctl.conf
sysctl -p

echo "# Hardcode nameserver"
echo "nameserver 1.1.1.1" > /etc/resolv.conf
chattr +i /etc/resolv.conf

echo "# Blacklist some crap modules"
echo "blacklist bluetooth" >> /etc/modprobe.d/blacklist.conf
echo "blacklist btusb" >> /etc/modprobe.d/blacklist.conf
echo "blacklist bnep" >> /etc/modprobe.d/blacklist.conf
echo "blacklist rfcomm" >> /etc/modprobe.d/blacklist.conf
echo "blacklist iscsi" >> /etc/modprobe.d/blacklist.conf
echo "blacklist nfs" >> /etc/modprobe.d/blacklist.conf

echo "# Done with pre-internet postinstall. Now connect to internet and run the script postinstall_debian_afterinternet.sh"