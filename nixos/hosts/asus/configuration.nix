{ pkgs, ... }:

{
	environment.systemPackages = with pkgs; [ dbeaver-bin vscode ];

	services.mysql = {
		enable = true;
		package = pkgs.mariadb;
	};
}
