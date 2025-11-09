{ callPackage }:

let
	nim_1_0 = callPackage ./overlay/nim_1_0.nix { };
in

callPackage ./overlay/boomer.nix { inherit nim_1_0; }
