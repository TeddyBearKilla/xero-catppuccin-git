#!/bin/bash
#set -e
echo "##########################################"
echo "Be Careful this will override your Rice!! "
echo "##########################################"
sleep 2
echo
echo "Backing up current XeroASCII "
echo "#############################"
# Check if XeroAscii.old file exists in /etc/
if [ -f "$HOME/.config/neofetch/XeroAscii.old" ]; then
    echo "Deleting existing XeroAscii.old file..."
    rm $HOME/.config/neofetch/XeroAscii.old
fi
# Rename XeroAscii toXero Ascii.old
if [ -f "$HOME/.config/neofetch/XeroAscii" ]; then
    echo "Renaming XeroAscii to XeroAscii.old..."
    mv $HOME/.config/neofetch/XeroAscii $HOME/XeroAscii.old
fi
echo
sleep 2
echo "Removing No longer needed Packages"
echo "##################################"
sudo pacman -Rns --noconfirm kvantum &>/dev/null; sudo pacman -Rns --noconfirm catppuccin-gtk-theme-mocha &>/dev/null; sudo pacman -Rns --noconfirm catppuccin-cursors-git &>/dev/null; sudo pacman -Rns --noconfirm catppuccin-kde-theme-git &>/dev/null; sudo pacman -Rns --noconfirm catppuccin-gtk-theme-mocha-mauve &>/dev/null; sudo pacman -Rns --noconfirm qt5-virtualkeyboard &>/dev/null; sudo pacman -Rns --noconfirm qt6-virtualkeyboard &>/dev/null
sleep 2
echo
echo "Installing Catppuccin Theme & Packages"
echo "######################################"
# Check if any of the specified packages are installed and install them if not present
packages="lightly-git catppuccin-kde-theme-mauve-git catppuccin-cursors-mocha-mauve xero-catppuccin-sddm asian-fonts lightlyshaders-git xero-catppuccin-wallpapers tela-circle-icon-theme-dracula-git python-pip gnome-themes-extra gtk-engine-murrine gtk-engines xero-fonts-git"
echo
echo "Installing required packages..."
echo "###############################"
for package in $packages; do
    pacman -Qi "$package" > /dev/null 2>&1 || sudo pacman -Syy --noconfirm --needed "$package" > /dev/null 2>&1
done
sleep 2
echo
echo "Applying Our Custom Grub Theme..."
echo "#################################"
chmod +x Grub.sh
sudo ./Grub.sh
sudo sed -i "s/GRUB_GFXMODE=*.*/GRUB_GFXMODE=1920x1080x32/g" /etc/default/grub
sudo grub-mkconfig -o /boot/grub/grub.cfg
sleep 2
echo
# Clone GTK theme repository and install
echo "Installing catppuccin GTK4 theme & Applying LibAdwaita Patch"
echo "############################################################"
git clone --recurse-submodules https://github.com/catppuccin/gtk.git
cd gtk/ && python -m venv . && source bin/activate && pip install --upgrade pip && pip install catppuccin
python install.py mocha -l -a mauve --tweaks float -s compact -d ~/.themes && cd ..
sleep 2
echo
echo "Creating Backup & Applying new Rice, hold on..."
echo "###############################################"
sleep 1.5
cp -r ~/.config ~/.config-backup-$(date +%Y.%m.%d-%H.%M.%S) && cp -Rf Configs/Home/. ~
cp -r ~/.mozilla ~/.mozilla-backup-$(date +%Y.%m.%d-%H.%M.%S) && cp -Rf Configs/Home/. ~
sudo cp -Rf Configs/System/. / && sudo cp -Rf Configs/Home/. /root/
ln -sf "$HOME/.themes/Catppuccin-Mocha-Compact-Mauve-Dark/gtk-4.0/assets" "${HOME}/.config/gtk-4.0/assets"
ln -sf "$HOME/.themes/Catppuccin-Mocha-Compact-Mauve-Dark/gtk-4.0/gtk.css" "${HOME}/.config/gtk-4.0/gtk.css"
ln -sf "$HOME/.themes/Catppuccin-Mocha-Compact-Mauve-Dark/gtk-4.0/gtk-dark.css" "${HOME}/.config/gtk-4.0/gtk-dark.css"
sleep 2
echo
# Update SDDM configuration
echo "Updating SDDM configuration..."
echo "##############################"
sudo sed -i "s/Current=.*/Current=catppuccin/g" /etc/sddm.conf.d/kde_settings.conf 2>/dev/null
sleep 2
echo
echo "Applying Flatpak GTK Overrides"
echo "##############################"
sudo flatpak override --filesystem=$HOME/.themes
sudo flatpak override --filesystem=xdg-config/gtk-3.0:ro
sudo flatpak override --filesystem=xdg-config/gtk-4.0:ro
echo
sleep 2
cd ~ && rm -rf xero-catppuccin-git/
echo
rm -rf ~/.cache/
sleep 3
echo "#############################################"
echo "  All Done! Reboot system To activate rice.  "
echo "#############################################"
