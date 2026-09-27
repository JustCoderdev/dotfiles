{ ... }:

{
	jcbin.update-system.enable = true;

	modules.services =
	{
		avahi.enable = true;

		nixbuilder.server =
		{
			enable = true;
			maxJobs = 8;
		};

		samba.enable = true;
	};
}
