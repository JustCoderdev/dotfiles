> [!warning]
>
> My dotfiles had an incident
>
> This is why all commits before a certain point report the date of the incident, at least 8 commits got lost (as far as I know)

# Dotfiles

These are my dotfiles, feel free to use them and share with me any feedback or trick you may know :p

There are 4 branches:

- `main`: Oldest "stable" version (fully "compatible" with macos)
- `nixos-integration`: (CURRENT) Restructuring of nixos w better flakes
- `nixos-compliant`: [DEPRECATED] Messy stable version of nixos
- `nixos-compliant-unstable`: [DEPRECATED] Switched to unstable to configure hyprland

```plaintext
* 16d55fd main
|\
| * 88e48b9 nixos-compliant (nixpkgs-23.05)
| |\
| | * cfb1ed0 nixos-compliant-unstable (nixpkgs/unstable)
| | |
| |/
| * 2c6a8c9 nixos-compliant (nixpkgs-24.05)
| |
| * 0be0f74 nixos-compliant (nixpkgs-24.11)
' |
  * 91c5ef1 nixos-integration (nixpkgs-24.11)
  v
```

> [!tip]
>
> Nixos and virtual machines
>
> - Nixos doesn't like virtual box's default graphics driver, use `VBoxVGA`
> - Hyrpland may not work in a VM

---

![Xfce desktop](./.screenshots/xfce-i3-desktop.png)
> "Xfce", i3, i3status, nvim and zsh showcase

---

![Hyprland desktop](./.screenshots/hyprland_desktop.png)
> "Hyprland", waybar, wallpaper showcase

---

![Plymouth theme](./.screenshots/plymouth-darnix-theme.png)
> Plymouth darnix theme (custom)

---

## Overview

These are all my dotfiles which are compatible with or
without (or at least that's the goal) nix/NixOS installed

- `Operating System`: NixOS (duh)
- `Terminal`: Alacritty
- `Editor`: Nvim (trying emacs tho...)

|                | XServer  | Wayland  |
| -------------- | -------- | -------- |
| Window manager | i3       | hyprland |
| Status bar     | i3status | waybar   |
| App launcher   | dmenu    | wofi     |

Included configuration files

[standalone] firefox - tmux

- Alacritty \[\>v0.12.2\] ([Github](https://github.com/alacritty))
- Clang \[\>7.0.1-8\] ([Docs](https://clangd.llvm.org/config.html))
- Clang-format \[\>7.0.1-8\] ([Docs](https://releases.llvm.org/7.0.0/tools/clang/docs/ClangFormatStyleOptions.html))
- Emacs (WIP)
- Fusuma (WIP)
- Git
- Hyprland (WIP)
- i3 \[\>4.16.1\] ([Docs](https://i3wm.org/docs/userguide.html), [statDocs](https://i3wm.org/docs/i3status.html))
- Neovim \[\>v0.9.1\] ([Github](https://github.com/neovim))
- NixOS \[\>v23.11\]
- Plymouth \[\>v24.004.60\] ([Gitlab](https://gitlab.freedesktop.org/plymouth/plymouth))
- Waybar \[\>v0.10.3\] ([Github](https://github.com/Alexays/Waybar))
- Zsh \[\>5.7.1\]
- and more...

## Special Requirements

- Font: `Roboto Mono` [Link](https://github.com/googlefonts/RobotoMono.git) (For Alacritty)
- Font: `SF Pro Text` [Link](https://developer.apple.com/fonts) (For Waybar)

## Special Global Variables

- `DOT_NIXOS`: `1` if the system is using the nixos configuration otherwise unset
- `DOT_FILES`: The absolute path to the dotfiles folder (currently hardcoded in zsh.nix)
- `DOT_NIX_SUB_URL`: The url to a nix substituter
- `DOT_NIX_SUB_PORT`: The port of the nix subsituter

## TODO

### Fix

- Fix disko using `/dev/disk/by-id/...` instead one `/dev/...` with `ll`
- Fix keyrings not persisting credentials
- Fix host files manually to use grub
- ~~Fix WakeOnLan module to make it persistent across reboots~~
- Fix move `dotfiles_abs_path` from `confs/settings/USER.nix` to new manifest files
- [msi] Fix nginx catchall path using self signed certificate

### Improve

- Move all manifest related files to manifest folder
- Move all hardware manifest files in `nixos/common/hardware/`
- ~~Improve grub by adding rescue option~~
- Improve neovim by nuking current settings
- Improve alacritty by resetting keybindings
- Improve `refresh-displays` command by adding the toggle to mirror or extend display
- Improve samba "global" directory to list all shares
- [msi] Improve nginx by removing `/<service>` subpath when using subdomain

### Add

- Add authelia module for homeserver auth
- Add guest samba share
- Add dns delegation to master manager
- Add Eve-ng (<https://github.com/SmartFinn/eve-ng-integration/issues/68>)

## Installation guide

1. Clone

```shell
DOT_FILES="${HOME}/.config/dotfiles" # or /.dotfiles
git clone https://github.com/JustCoderdev/dotfiles.git "${DOT_FILES}"
cd "${DOT_FILES}"
```

2. Install

- Without nix [not updated]

```shell
./bin/bash-scripts/mount-configs.sh
```

- With nix stuff

Home manager

```shell
cd confs

# add "--extra-features 'nix-command flakes'" after `nix`
# and before `build` if using a non-flake env
nix build ".#${USER}-activation"

./result/activate
```

Disk partitions

```shell
# add "--extra-features 'nix-command flakes'" after `nix`
# and before `run` if using a non-flake env
sudo nix \
     run github:nix-community/disko/latest -- \
     --mode destroy,format,mount nixos/hosts/${HOST}/disko.nix
```

- With NixOS

> [!important]
>
> You will get "relative path error for ./bin..."
>
> To fix it remove any mention of `jcbin` and `jcconfs` from `flake.lock` and then rebuild

```shell
./install.sh
```

## Dotfiles structure

There are 3 main directories (+1):

- `bin`: various scripts available in a flake
- `confs`: application configuration files (w home-manager support)
- `nixos`: nixos system modules
- `secrets`: local secrets directory

### bin

- `binaries`: packaged programs that "need" nixos to be built
- `scripts`: custom bash scripts that can run even without nixos

### confs

- `.wallpapers`: desktop wallpapers
- `modules`: configurations that haven't been migrated to home-manager yet
- `settings`: user settings (username and insecure/unfree packages list)
- `standalone`: configurations that exist only in home-manager
- `stylix`: stylix theme and modules
- `users`: available users

### nixos

- `common`:
    - `core`: required stuff from all systems (locale, font, etc...)
    - `environments`: user "environments" (gaming, development)
    - `manifest`: [new] settings to create the ecosystem of hosts
    - `users`: system users
- `hosts`:
    - `.example`: example configuration files for installation script
    - `.old`: host configurations files for hosts that haven't yet migrated to manifest sytem
    - `...`: host configuration
        - `boot.nix`: boot related options
        - `configuration.nix`: specific device / services configuration
        - `disko.nix`: disk configuration
        - `hardware-configuration.nix`: nixos generated hw configuration file
        - `manifest.nix`: manifest file
        - `options.nix`: [soon to be deprecated] set values for custom options
- `system`:
    - `desktop`: desktop environment
    - `services`: daemons and what not
- `unofficial`:
    - `pkgs`: custom packaged applications
    - `modules`: custom modularised packages

### secrets

see `nixos/common/core/secrets.nix`

## Inspiration

- Jdah dotfiles ([Github](https://github.com/jdah/dotfiles))
- Librephoenix dotfiles ([Gitlab](https://gitlab.com/librephoenix/nixos-config))
- EmergentMind nixos configuration ([Github](https://github.com/EmergentMind/nix-config))
- erictossel nixos configuration ([Github](https://github.com/erictossell/nixflakes))
- mrkux nixos configuration ([Github](https://github.com/mrkuz/nixos))
- Sane1090x Waybar style ([Github](https://github.com/sane1090x/dotfiles/blob/everforest/.config/waybar/config))
- Ruixi-rebirth waybar idea ([Github](https://github.com/Ruixi-rebirth/flakes/blob/main/home/programs/waybar/hyprland_waybar.nix))
- XeIaso doublas-adams-quotes for making me discover the power of flakes ([Github](https://github.com/Xe/douglas-adams-quotes/blob/main/flake.nix)[XeIasoBlog](https://xeiaso.net/))

## Obtaining Secrets

All secrets are "indexed" in `nixos/common/core/secrets.nix`

### Cloudflared

```shell
cd ${DOT_FILES}/secrets/cloudflare
nix-shell -p cloudflared

cloudflared login
mv /home/${USER}/.cloudflared/cert.pem .

cloudflared tunnel --origincert "$(pwd)/cert.pem" create home
mv *.json tunnel-home.json
```

### WPA Supplicant psk

```shell
cd ${DOT_FILES}/secrets
token=$(wpa_passphrase WindTower-LTE PSK)
echo "windtower_lte_psk=${token}" > wireless.conf
vim wireless.conf
```

### Nix Serve

```shell
cd ${DOT_FILES}/secrets
sudo nix-store --generate-binary-cache-key DOMAIN \
        nixserve/cache-priv-key.pem nixserve/cache-pub-key.pem

# Update nixos/common/core/nix.nix
```

### Self Signed SSL Certificate

Source <https://www.digitalocean.com/community/tutorials/how-to-create-a-self-signed-ssl-certificate-for-nginx-in-ubuntu-20-04-1>

```shell
cd ${DOT_FILES}/secrets/nginx/VHOST
sudo openssl req -x509 -nodes -days 365 -newkey rsa:2048 \
       -keyout VHOST-cert.key -out VHOST-cert.crt
```

## Emergency wiki

### Enable flakes in nix system

```shell
cd ~/.config/nix/nix.conf # or /etc/nix/nix.conf
experimental-features = nix-command flakes
```

### Recover rollback dotfiles

Get backup path

```shell
nix derivation show -r /run/current-system \
        | grep --color -E '"out": "/nix/store/.*dotfiles-backup"'
```

Open backup path (EXPERIMENTAL)

```shell
current-dotfiles
```

### Connect to internet (with wpa_supplicant)

```shell
wpa_passphrase <ESSID> | sudo tee -a /etc/wpa_supplicant/wpa_supplicant.conf
systemctl restart wpa_supplicant
```

### Connect to internet (with nmcli)

```shell
nmcli device wifi rescan
nmcli device wifi list
nmcli device wifi connect <SSID> password <password>
```

### Connect to bluetooth

```shell
bluetootctl scan on
bluetootctl list
bluetootctl connect <ADDRESS>
```

### Enable ssh connection

```shell
sudo apt-get install openssh-server
sudo systemctl enable ssh
sudo systemctl start ssh
sudo systemctl status ssh
```

### Generate and add new ssh keypair

```shell
ssh-keygen -t ed25519 -C "USER@HOST"
id_HOST_USER

eval "$(ssh-agent -s)"
ssh-add ~/.ssh/id_HOST_USER
```

### Check battery level

```shell
cat /sys/class/power_supply/<BAT>/status
cat /sys/class/power_supply/<BAT>/charge_now
cat /sys/class/power_supply/<BAT>/charge_full
```

### Setup mdadm raid

Sources

- <https://www.jeffgeerling.com/blog/2021/htgwa-create-raid-array-linux-mdadm>
- <https://www.youtube.com/watch?v=CJ0ed38N8-s>

```shell
# Create raid
sudo mdadm --create --verbose /dev/md0 --level=1 --raid-devices=2 /dev/sdb1 /dev/sdc1
cat /proc/mdstat  # check creation progress

# Save raid information
sudo mdadm --detail --scan > /etc/mdadm/mdadm.conf  # save configuration

# File System
sudo mkfs.ext4 /dev/md0
blkid # check if md0 shows up

# Mount fs
```

### Mdadm maintenance

Source <https://www.thomas-krenn.com/en/wiki/Mdadm_recovery_and_resync>

```shell
# hot remove
sudo mdadm --manage /dev/md0 -r /dev/sdc1

# add
sudo mdadm --manage /dev/md0 -a /dev/sdc1
```

### Edit Samba credentials

Login with `smb://<ip>/<share>`

```shell
# Create a user
sudo smbpasswd -a <username>

# List users
sudo pdbedit -L
```

### No space left on device `/boot`

Source <https://blog.tiserbox.com/posts/2024-04-15-how-to-fix-boot-volume-running-out-of-disk-space-in-nix-os.html>

```shell
sudo su

# Check occupied space
df -h /boot

# Display all installed profiles
nix profile history \
    --profile /nix/var/nix/profiles/system

# Remove profiles older than 14 days
sudo nix profile wipe-history
    --profile /nix/var/nix/profiles/system \
    --older-than 14d

# Run garbage collection
nix store gc

# (You might need to move kernels out of /boot/kernels)
mkdir -p /home/$USER/Documents/kernels
sudo mv /boot/kernels/* /home/$USER/Documents/kernels

# Rebuild
rebuild-system
```

### GRUB doesn't start because of EFI

Source <https://discourse.nixos.org/t/systemd-boot-keeps-starting-even-if-grub-is-installed/23065/8>

```nix
# grub.nix

boot.loader.efi.canTouchEfiVariables = false;

boot.loader.grub.enable = true;
boot.loader.grub.device = "nodev";
boot.loader.grub.efiSupport = true;
boot.loader.grub.efiInstallAsRemovable = true;
```

Regenerate boot `BOOTX64.EFI`

```shell
sudo su
mkdir -p /home/$USER/Documents/boot
mv /boot/* /home/$USER/Documents/boot
```

### Shrink partition (& fs)

Sources

- Shrink file system <https://access.redhat.com/articles/1196333>
- Resize partition <https://docs.redhat.com/en/documentation/red_hat_enterprise_linux/7/html/storage_administration_guide/s2-disk-storage-parted-resize-part>

```shell
# Check fs integrity
sudo e2fsck -f /dev/sda1

# Resize fs
sudo resize2fs /dev/sda1 31G

# Check size
sudo mount /dev/sda1 /mnt/part
df -h /mnt/part
sudo umount /mnt/part

# Open disk in fdisk
sudo fdisk /dev/sda
p      # Find partition number
d      # Delete partition
    2      # partition number
n      # Create new partition
    p      # primary
    2      # partition number
    CR     # first sector
    +31G   # size / last sector
w      # Save and exit
```

### Moving the nix store

Source <https://wiki.nixos.org/wiki/Storage_optimization#Moving_the_store>

1. Create a new partition and mount it over `/mnt`

```shell
sudo mount -o defaults,noatime /dev/disk/by-label/nix /mnt/nix
```

2. Copy everything from `/nix` to `/mnt` (Trailing slashes are important)

```shell
sudo rsync \
    --archive \
    --hard-links \
    --acls \
    --one-file-system \
    --info=progress2 \
    /nix/{store,var} /mnt/nix
```

3. Mount the new partition as the new `/nix`

```shell
sudo umount /mnt/nix
sudo mount /dev/disk/by-label/nix /nix
```

4. Restart nix-daemon

```shell
sudo systemctl stop nix-daemon.service
sudo systemctl restart nix-daemon.socket
sudo systemctl start nix-daemon.service
```

5. Add the new `/nix` partition to `nixos/hosts/$HOST/boot.nix`

```nix
# -- IMPORTANT -- #
fileSystems."/nix" = {
	device = "/dev/disk/by-label/nix";
	fsType = "ext4";
	neededForBoot = true;
	options = [ "noatime" ];
};
# -- IMPORTANT -- #
```

6. Rebuild

7. Reboot

8. Check that `/nix` is mounted over your partition

```shell
sudo mount | grep "/nix" && echo "Nix store is on a new partition" || echo "Nix is on the old partition"
```

9. Delete the old store

```shell
sudo mkdir /tmp/old_root
sudo mount --bind / /tmp/old_root
sudo rm --recursive /tmp/old_root/nix
sudo umount /tmp/old_root
sudo rmdir /tmp/old_root
```

### Build system for host

Build system locally for remote device `<hostname>` available at `<ip>`

```shell
sudo nixos-rebuild switch \
         --flake .#<hostname> \
         --target-host "<user>@<ip>"
```
