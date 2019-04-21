![](desktop.png?raw=true)  

**I am using a default arch ISO that I put onto an USB drive**  
**https://www.archlinux.org/download/**  
**Boot into it and start the installing process**  

**https://wiki.archlinux.org/index.php/Installation_guide**  
**If you are used to a different keyboard layout**  
loadkeys de-latin1  

**Format disks for a clean start**  
**This will open a application to set partitions**  
fdisk /dev/nvme0n1  

**Delete all partitions**  
d, enter ... (Repeat, until all partitions are deleted)  
**Create new partitions**  
n (new)  
p (primary)  
**If it asks you to remove some kind of old signature, agree**  
1: boot: Sequence: n, p, enter, + 1GiB (enter)  
2: root: Sequence: n, p, enter, + 100GiB (enter)  
3: swap: Sequence: n, p, enter, + 16GiB (enter)  
3: home: Sequence: n, p, enter, enter (Rest for home)  

**Format all disks**  
mkfs.ext4 /dev/nvme0n1p1  
mkfs.ext4 /dev/nvme0n1p2  
mkfs.ext4 /dev/nvme0n1p4  

**Setup swap**  
mkswap /dev/nvme0n1p3  
swapon /dev/nvme0n1p3  

**Mount the file system**  
mount /dev/nvme0n1p2 /mnt  
mkdir /mnt/boot  
mkdir /mnt/home  
mount /dev/nvme0n1p1 /mnt/boot  
mount /dev/nvme0n1p4 /mnt/home  

**Install arch**  
pacstrap /mnt base base-devel  
genfstab -U /mnt >> /mnt/etc/fstab  

arch-chroot /mnt

nano /etc/locale.gen  
locale-gen  
echo LANG=en_US.UTF-8 > /etc/locale.conf  
export LANG=en_US.UTF-8  
export KEYMAP=de-latin1  
echo "KEYMAP=de-latin1" > /etc/vconsole.conf  

**Setup hostname**  
echo robot > /etc/hostname  
echo "127.0.0.1   localhost" >> /etc/hosts  
echo "::1         localhost" >> /etc/hosts  
echo "127.0.1.1   robot.localdomain robot" >> /etc/hosts  

**Install your bootloader of choice, I use grub, cause Im a scrub and dont know better**  
**Damn, what a rime**  
pacman -S grub efibootmgr  
grub-install --target=i386-pc /dev/nvme0n1  
grub-mkconfig -o /boot/grub/grub.cfg  

**Setup root password**  
passwd  

**Check if no updates where pushed during install**  
pacman -Syu  

**Create sudo account**  
pacman -S sudo  
useradd -m -g wheel shino  
passwd shino  
mkdir /home/shino  
chown -R shino:root /home/shino  
chmod -R 777 /home/shino  
nano /etc/sudoers  
Add shino  

**Disable root login**  
passwd -l root  

**Find your network device, for me its enp4s0**  
ip link  

**Configure your network**  
echo "[Match]" > /etc/systemd/network/enp4s0.network  
echo "name=de*" >> /etc/systemd/network/enp4s0.network  
echo "[Network]" >> /etc/systemd/network/enp4s0.network  
echo "DHCP=yes" >> /etc/systemd/network/enp4s0.network  

**Enable it**  
systemctl enable systemd-networkd  

**Setup nameserver**  
echo "nameserver 8.8.8.8" >> /etc/resolv.conf  
echo "nameserver 8.8.4.4" >> /etc/resolv.conf  

**From here on, we set up the system**  
su shino  

**Stuff we need for all kinds of things later**  
sudo pacman -S pango kbd wget clang pv cmake git ntfs-3g fuse udisks2 htop ninja python gtk2 gconf libnotify libxss unzip dos2unix bc python2 openssh rustup linux-headers openssl-1.0 npm yarn nodejs-lts-dubnium    

**Pretty font for our console and polybar**  
sudo pacman -S ttf-font-awesome ttf-inconsolata ttf-dejavu noto-fonts noto-fonts-cjk noto-fonts-emoji noto-fonts-extra  

**Display server**  
sudo pacman -S xorg-server i3-wm i3lock xorg-xinit xorg-xrandr thunar perl-anyevent  

**Audio**  
sudo pacman -S alsa-utils pulseaudio pavucontrol  

**Graphics**   
sudo pacman -S nvidia-dkms cuda cudnn

**Basic applications**  
sudo pacman -S firefox alacritty notepadqq code thunderbird vagrant virtualbox  

**Stuff that I needed, maybe you will need it too**  
sudo pacman -S  teamspeak3 telegram-desktop nginx mariadb unixodbc mono  

sudo mysql_install_db --user=mysql --basedir=/usr --datadir=/var/lib/mysql  
sudo systemctl enable mysqld  
sudo systemctl enable nginx  

**Create filesystem for usb slots**  
sudo mkdir /media/  
sudo mdkir /media/usb1  
sudo mdkir /media/usb2   

**Insert a usb with the config files and copy them to the apropriate place**  
**Mounting an USB for dummies (Like me)**  
**Find the usb**  
sudo fdisk -l  
**Mount it, assuming yours is on /dev/sdg1, will likely be somewhere else tho**  
sudo mount /dev/sga1 /mount/usb1  

cp -R /media/usb1/.config ~/  
cp /media/usb1/.bashrc ~/  

echo "exec i3" >> ~/.xinitrc  

**Set up your git config**  
git config --global user.email "MAIL"  
git config --global user.name "NAME"  

**Discord is by default enabled in the i3/config as startup**  
**If you dont install it, remove the line then**  
**Setting up Discord**  
cd ~/  
git clone "https://aur.archlinux.org/libc++.git"  
cd libc++  
makepkg  

**It will complain that a key isnt trusted, thats how you resolved this issue**  
gpg --recv-keys <KEY>  
gpg --edit-key <KEY>  

**A application opens: Type follwing Sequence (with enter in between)**  
**trust, 4, quit**  
makepkg  
sudo pacman -U <PATH/TO/ABI/PKG>  
sudo pacman -U <PATH/TO/NON-ABI/PKG>  
cd ../  
rm -Rf libc++  

git clone "https://aur.archlinux.org/discord.git"  
cd discord  
makepkg  
sudo pacman -U <PATH/TOPKG>  
cd ../  
rm -Rf discord  
**Discord setup end**  

**Setting up directories we need**  
cd ~/  
mkdir Games  
**Copy over your games: pv "path1" > ~/Games**  
mkdir Repos  
**Clone your directories**  
mkdir Screenshots  

**Setup wine, if u want to use windows applications**  
**Uncomment MultiLib and the line below it**  
sudo nano /etc/pacman.conf  
sudo pacman -Syu  

sudo pacman -S wine wine-mono lib32-libpulse  

**Installing polybar**  
cd ~/  
git clone "https://aur.archlinux.org/polybar.git"  
cd polybar  
makepkg  
sudo pacman -U <PATH/TO/PKG>  
cd ../  dmenu
rm -Rf polybar  

**We are done!**  
**Type repeatedly exit until you are at the start again and then reboot**  
systemctl reboot  

**Once your system booted again, login and start the displayserver with i3**  
startx  

**Enable your internet**  
sudo dhcpcd  

**Lets squeeze out the very last % performance and bloat out of our hardware**  
**We build a customized kernel for our system**  
**Using this guide: https://wiki.archlinux.org/index.php/Kernel/Traditional_compilation**  
cd ~/  

**Create a build directory**  
mkdir kernelbuild  
cd kernelbuild  

**Replace numbers with the current version**  
wget https://www.kernel.org/pub/linux/kernel/v4.x/linux-4.18.7.tar.xz  
unxz linux-4.18.7.tar.xz  
tar -xf linux-4.18.7.tar  
rm -f linux-4.18.7.tar  

**Clean up first**  
make clean && make mrproper  

**You have two options here:**  
**This will give you the bloated default arch linux config for general purpose**  
zcat /proc/config.gz > .config  
**This will tailor it to the current installed drivers and CONNECTED hardware**  
make localmodconfig  

**You can do it in the command line, but I prefer a GUI here, also tells you some fun facts for each setting**  
**Configure it to your needs, be careful not to mess something up here**  
**Chances are high that your kernel wont even boot if you remove something important**  
make xconfig  

**With **-jk where k is the number of virtual cores +1**  
**Optional: cc=clang, This might fail though with errors**  
**My Setup has hyperthreaded 8 cores**  
make -j17  

**From here on you need root privileges**  
**Add modules**  
sudo make modules_install  

**Copy your kernel into your boot directory**  
sudo cp arch/x86_64/boot/bzImage /boot/vmlinuz-custom  

**Create a preset for your kernel**  
**Open the copied file and rename the endings, i.e. linux => linux-custom**  
sudo cp /etc/mkinitcpio.d/linux.preset /etc/mkinitcpio.d/linux-custom.preset  

**Generate img files**  
sudo mkinitcpio -p linux-custom  

**Copy the map over to boot**  
sudo cp System.map /boot/System.map-custom  
sudo ln -sf /boot/System.map-custom /boot/System.map  

**Now, if you have choosen a different bootloader up there, you might take a look at the arch wiki**  
**https://wiki.archlinux.org/index.php/Kernel/Traditional_compilation#Bootloader_configuration**  
**Thats how you do it with grub**  
**This will print your disk UIDS**  
**Take the one for /mnt/boot (/dev/sda1)**  
sudo blkid  

**Replace the UUID from above here**  
menuentry "Arch Custom" {  
    set root=UUID=XXXX-YYYY  
    linux /vmlinuz-custom root=UUID=XXXX-YYYY ro quiet splash  
    initrd /initrd-custom.img  
}  
**Edit grub.cfg at the custom part (Says 40-custom or so)**  
sudo nano /boot/grub/grub.cfg  

**When the entry is added, we just generate a new one**  
**Dont worry if your kernel doesnt boot, you can go back to the default one as fallback**  
**Given you have not overwritten it xD**  
sudo grub-mkconfig -o /boot/grub/grub.cfg  
