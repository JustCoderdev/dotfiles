{ lib, buildHomeAssistantComponent, fetchFromGitHub, }:

buildHomeAssistantComponent
rec {
	owner = "AlexxIT";
	domain = "webrtc";
	version = "3.6.1";
	
	src = fetchFromGitHub {
		inherit owner;
		repo = "WebRTC";
		rev = "v${version}";
		hash = "sha256-/Rw95G7Ro0QvKZ7SNMIA/Q8Kr56QQqxos+t1xksuDJ0=";
	};
	
	meta = with lib; {
		changelog = "https://github.com/AlexxIT/WebRTC/releases/tag/v3.6.1";
		description = "Home Assistant custom component for real-time viewing of almost any camera stream using WebRTC and other technologies";
		homepage = "https://github.com/AlexxIT/WebRTC";
		license = licenses.mit;
	};
}

