# It's all thanks to this guide if I managed to
# make it work! thank you so much!
# <https://nathan.gs/2023/12/28/home-assistant-add-a-custom-component-in-nixos-revisited/>

{ lib, buildHomeAssistantComponent, fetchFromGitHub, OWNd-pkg }:

buildHomeAssistantComponent
rec {
	owner = "anotherjulien";
	domain = "myhome";
	version = "0.9.3";
	
	src = fetchFromGitHub {
		inherit owner;
		repo = "MyHOME";
		rev = version;
		hash = "sha256-+zv3L034Uoyfbzdtijhlmjh7ms1OpM3sPRzAVtwipQc=";
	};
	
	propagatedBuildInputs = [ OWNd-pkg ];
	
	meta = with lib; {
		changelog = "https://github.com/anotherjulien/MyHOME/releases/tag/0.9.3";
		description = "MyHOME integration for Home-Assistant";
		homepage = "https://github.com/anotherjulien/MyHOME";
		license = licenses.agpl3Only;
	};
}

