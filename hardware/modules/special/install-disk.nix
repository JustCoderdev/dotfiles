
  ###############################
  #      !!! IMPORTANT !!!      #
  # IMPORT ONLY ON INSTALL DISK #
  ###############################

{ modulesPath, ... }:

{
	imports = [ "${modulesPath}/installer/cd-dvd/installation-cd-minimal.nix" ];
}

