# Thanks to allmark migration commit to making me discover
# how to properly package legacy go modules
# Source <https://github.com/NixOS/nixpkgs/pull/318220/commits/f27bd6fd0a2bbf27fae725d0c00fc5a05fbdc433>

{ buildGoModule, fetchFromGitHub }:

buildGoModule
rec {
	pname = "schemer2";
	version = "89a66cbf40440e82921719c6919f11bb563d7cfa";

	postPatch = ''
go mod init github.com/thefryscorer/schemer2
'';

	src = fetchFromGitHub
	{
		owner = "thefryscorer";
		repo = "schemer2";
		rev = version;
		sha256 = "sha256-EKjVz4NkxtxqGissFwlzUahFut9UAxS8icxx3V7aNnw=";
	};

	vendorHash = null;
}
