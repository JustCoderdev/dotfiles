{ lib, ... }:

{
	imports = [
		./ryuji.nix
		./school.nix
	];

	options = {
		common.users = {
			ryuji = {
				enable = lib.mkOption {
					type = lib.types.bool;
					description = "Enable personal user";
					default = true;
				};

				image-editing = lib.mkOption  {
					type = lib.types.bool;
					description = "Add image editing sofware to environment packages";
					default = false;
				};
				video-editing = lib.mkOption {
					type = lib.types.bool;
					description = "Add video editing sofware to environment packages";
					default = false;
				};
				game-developing = lib.mkOption {
					type = lib.types.bool;
					description = "Add game developing sofware to environment packages";
					default = false;
				};

#				developer = lib.mkOption {
#					type = lib.types.bool;
#					description = "Add developer sofware to environment packages";
#					default = false;
#				};
			};

			school.enable = lib.mkOption {
				type = lib.types.bool;
				description = "Enable school user";
				default = false;
			};
		};
	};
}
