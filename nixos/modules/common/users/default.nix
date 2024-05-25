{ lib, ... }:

with lib;

{
	imports = [
		./ryuji.nix
		./school.nix
	];

	options = {
		common.users = {
			ryuji = {
				enable = mkOption {
					type = types.bool;
					description = "Enable personal user";
					default = true;
				};

				image-editing = mkOption  {
					type = types.bool;
					description = "Add image editing sofware to environment packages";
					default = false;
				};
				video-editing = mkOption {
					type = types.bool;
					description = "Add video editing sofware to environment packages";
					default = false;
				};
				developer = mkOption {
					type = types.bool;
					description = "Add developer sofware to environment packages";
					default = false;
				};
			};
			school.enable = mkOption {
				type = types.bool;
				description = "Enable school user";
				default = false;
			};
		};
	};
}
