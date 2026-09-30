{ pkgs, ... }:

{
	environment.systemPackages = with pkgs; [ geteduroam ];
}

