# Enable community server
setup-apkrepos -c

apk update

# Sudo things
apk add sudo
echo '%wheel ALL=(ALL) ALL' >> /etc/sudoers

# Groups for xorg or something
for u in $(ls /home); do for g in disk lp input audio cdrom dialout video netdev games users; do addgroup $u $g; done;done

# Setup xorg
setup-xorg-base

# No idea
setup-devd udev

# Same
apk add dbus dbus-x11
rc-update add dbus

# GPU drivers
apk add mesa-dri-gallium mesa-va-gallium linux-firmware-amdgpu mesa-vulkan-ati

# Setting up Kernel Modesetting(no idea what it is and what it does)
echo radeon >> /etc/modules
echo fbcon >> /etc/modules

apk add mkinitfs
echo "features=\"keymap cryptsetup kms ata base ide scsi usb virtio ext4\"" > /etc/mkinitfs/mkinitfs.conf
mkinitfs

# i3wm and some other related things
apk add i3wm i3status xterm xf86-video-fbdev xf86-video-vesa font-terminus rofi

# Start i3wm when italo logs in
cat <<EOF >> /home/italo/.profile
if [ -z "$DISPLAY" ] && [ "$(tty)" = "/dev/tty1" ]; then
    exec startx /usr/bin/i3
fi
EOF

# Using my i3wm config
mkdir -p ~/.config/i3
cp config ~/.config/i3

# Keyboard layout config
mkdir -p /etc/X11/xorg.conf.d
cat <<EOF >> /etc/X11/xorg.conf.d/00-keyboard.conf
Section "InputClass"
    Identifier "system-keyboard"
    MatchIsKeyboard "on"
    Option "XkbLayout" "br"
    Option "XkbVariant" ""
    Option "XkbModel" "pc105"
EndSection
EOF

# Welcome message
rm /etc/motd
echo Welcome to Alpine! >> /etc/motd

# Programs i think ill probably use
apk add firefox alacritty xz build-base cmake pkgconf git

# Probably not necessary
apk add fontconfig freetype ttf-dejavu
