{ config, ... }:

{
	system.gaming.enable = true;

	user.app-collection = {
		image-editing = true;
		video-editing = true;
		developer = true;
	};

}
