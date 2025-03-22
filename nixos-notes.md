# Notes

## Autologin w/o DE

> <https://discourse.nixos.org/t/autologin-w-o-display-manager/16672>

- Startx requires a ~/.xinitrc file see startx(1)

```nix
displaymanager.startx.enable = true;
services.getty.autologinUser = "ryuji";
```

## Smallest NixOS image (issue)

> <https://github.com/NixOS/nixpkgs/issues/21315>

## Build a very lightweight live NixOS image

> <https://www.reddit.com/r/NixOS/comments/1cncbf1/trying_to_build_a_very_lightweight_live_nixos_iso/>
> <https://sidhion.com/blog/posts/nixos_server_issues/>

## How to have a minimal NixOS

> <https://discourse.nixos.org/t/how-to-have-a-minimal-nixos/22652>

```nix
documentation.man.enable = false;
```

- "You can get rid of most fluff with something like this"
> References <https://discourse.nixos.org/t/flake-based-web-kiosk-project/38084/2>

```nix
{
  imports = [
    <nixpkgs/nixos/modules/profiles/headless.nix>
    <nixpkgs/nixos/modules/profiles/minimal.nix>
  ];

  # only add strictly necessary modules
  boot.initrd.includeDefaultModules = false;
  boot.initrd.kernelModules = [ "ext4" ... ];
  disabledModules =
    [ <nixpkgs/nixos/modules/profiles/all-hardware.nix>
      <nixpkgs/nixos/modules/profiles/base.nix>
    ];

  # disable useless software
  environment.defaultPackages = [];
  xdg.icons.enable  = false;
  xdg.mime.enable   = false;
  xdg.sounds.enable = false;
}
```

## How minimal can a NixOS image get?

> <https://discourse.nixos.org/t/how-minimal-can-a-nixos-image-get/45268>

'''
You can likely get down to 200-400MB quite easily.
The minimal ISO is designed to work on as much hardware as possible
so it includes the full linux-firmware package which is ~500MB of
already compressed firmware so the compressed ISO is likely 50% firmware.

You’ll also want to disable docs and man pages.
Trim the default system packages to just those strictly required.

You can use a tool like `nix-tree` to what’s contributing to a Nix
closure size. Use the `nix repl` to view what’s adding packages to
`environment.systemPackages` e.g on a flake check
`nixosConfigurations.myNixosConfig.options.environment.systemPackages.definitionsWithLocations`
'''

## Questions about package management

> <https://discourse.nixos.org/t/questions-about-package-management/39426/7>

```bash
nix why-depends /run/current-system \
        /nix/store/...-bluez-5.70
        --extra-experimental-features nix-command
```

## i3 Themes Inconsistencies 

> <https://wiki.nixos.org/wiki/I3#Lxappearance>

## i3 Configuration

> <https://johnduhamel.io/posts/2019-01-29-nixos-i3-setup.html>

- check if lightdm pulls xfce

```nix
services.xserver.enable = true;
services.xserver.autorun = false;
services.xserver.layout = "us";
services.xserver.desktopManager.default = "none";
services.xserver.desktopManager.xterm.enabe = false;
services.xserver.displayManager.lightdm.enable = true;
services.xserver.windowManager.i3.enable = true;
```
