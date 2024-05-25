echo "Building $1 configuration..."

sed -i "s/\(hostname = \).*/\1\"$1\";/" "./flake.nix"
sudo nixos-rebuild switch --show-trace --flake ".#$1"
