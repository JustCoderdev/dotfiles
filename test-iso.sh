nix-shell -p qemu --command 'qemu-system-x86_64 -enable-kvm -m 256 -cdrom result/iso/nixos-*.iso'
