![](desktop.png?raw=true)  

**I am using a default arch ISO that I put onto an USB drive**  
**https://www.archlinux.org/download/**  
**Boot into it and start the installing process**  

**https://wiki.archlinux.org/index.php/Installation_guide**  
**If you are used to a different keyboard layout**  
loadkeys de-latin1  

**Format disks for a clean start**  
**This will open a application to set partitions**  
fdisk /dev/sda  

**Delete all partitions**  
d, enter ... (Repeat, until all partitions are deleted)  
**Create new partitions**  
n (new)  
p (primary)  
**If it asks you to remove some kind of old signature, agree**  
1: boot: Sequence: n, p, enter, + 1GiB (enter)  
2: root: Sequence: n, p, enter, + 20GiB (enter)  
3: swap: Sequence: n, p, enter, + 4GiB (enter)  
3: home: Sequence: n, p, enter, enter (Rest for home)  

**Format all disks**  
mkfs.ext4 /dev/sda1  
mkfs.ext4 /dev/sda2  
mkfs.ext4 /dev/sda4  

**Setup swap**  
mkswap /dev/sda3  
swapon /dev/sda3  

**Mount the file system**  
mount /dev/sda2 /mnt  
mkdir /mnt/boot  
mkdir /mnt/home  
mount /dev/sda1 /mnt/boot  
mount /dev/sda4 /mnt/home  

**Install arch**  
pacstrap /mnt base base-devel  
genfstab -U /mnt >> /mnt/etc/fstab  

**Chroot: We are now in our system, yaaay**  
arch-chroot /mnt  

**Setup your clock**  
**You can just ls this filesystem below to find yours**  
ln -sf /usr/share/zoneinfo/Europe/Berlin /etc/localtime  
hwclock --systohc --utc  

**Setup locale**  
**Uncomment the langauges, that you need**  
nano /etc/locale.gen  
local-gen  
echo LANG=en_US.UTF-8 > /etc/locale.conf  
export LANG=en_US.UTF-8  

**Setup hostname**  
echo robot > /etc/hostname  
echo "127.0.0.1   localhost" >> /etc/hosts  
echo "::1         localhost" >> /etc/hosts  
echo "127.0.1.1   robot.localdomain robot" >> /etc/hosts  

**Install your bootloader of choice, I use grub, cause Im a scrub and dont know better**  
**Damn, what a rime**  
pacman -S grub  
grub-install /dev/sda  
grub-mkconfig -o /boot/grub/grub.cfg  

**Setup root password**  
passwd  

**Check if no updates where pushed during install**  
pacman -Syu  

**Create sudo account**  
pacman -S sudo  
useradd shino  
passwd shino  
mkdir /home/shino  
chown -R shino:root /home/shino  
chmod -R 777 /home/shino  
nano /etc/sudoers  
Add shino  

**Disable root login**  
passwd -l root  

**Find your network device, for me its enp2s0**  
ip link  

**Configure your network**  
echo "[Match]" > /etc/systemd/network/enp2s0.network  
echo "name=de*" >> /etc/systemd/network/enp2s0.network  
echo "[Network]" >> /etc/systemd/network/enp2s0.network  
echo "DHCP=yes" >> /etc/systemd/network/enp2s0.network  

**Enable it**  
systemctl enable systemd-networkd  

**Setup nameserver**  
echo "nameserver 8.8.8.8" >> /etc/resolv.conf  
echo "nameserver 8.8.4.4" >> /etc/resolv.conf  

**From here on, we set up the system**  
su shino  

**Stuff we need for all kinds of things later**  
sudo pacman -S pango kbd wget clang pv cmake git ntfs-3g fuse udisks2 htop ninja python gtk2 gconf libnotify libxss unzip dos2unix bc python2 xbindkeys neofetch  

**Pretty font for our console and polybar**  
sudo pacman -S ttf-font-awesome ttf-inconsolata  

**Display server**  
sudo pacman -S xorg-server i3-wm dmenu i3lock xorg-xinit xorg-xrandr  

**Audio**  
sudo pacman -S alsa-utils pulseaudio pavucontrol  

**Basic applications**  
sudo pacman -S firefox xterm notepadqq  

**For Image capturing I suggest flameshot or ksnip.**  
**I could not get flameshot to work, but ksnip seems fine**  
**https://aur.archlinux.org/ksnip-git.git**  

**Stuff that I needed, maybe you will need it too**  
sudo pacman -S  teamspeak3 telegram-desktop nginx mariadb unixodbc mono  

**Create filesystem for usb slots**  
sudo mkdir /media/  
sudo mdkir /media/usb1  
sudo mdkir /media/usb2  
sudo mdkir /media/usb3  
sudo mdkir /media/usb4  

**Insert a usb with the config files and copy them to the apropriate place**  
**Mounting an USB for dummies (Like me)**  
**Find the usb**  
sudo fdisk -l  
**Mount it, assuming yours is on /dev/sdg1, will likely be somewhere else tho**  
sudo mount /dev/sga1 /mount/usb1  

cp -R /media/usb1/.config ~/  
cp /media/usb1/.bashrc ~/  
cp /media/usb1/.Xdefaults ~/  

**This one is special**  
**I use an usb headset with volume control**  
**By default that does not work, thats a fix for it**  
cp /media/usb1/.xbindkeysrc ~/  

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
cd ../  
rm -Rf polybar  

**Install your favorite code editor**  
**I use VS Code, because atom is meh and I havent found a better one yet**  
**VS Code is also meh, so hit me up with suggestions**  

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
grub-mkconfig -o /boot/grub/grub.cfg  
