{ ... }:

{
	jcbin.update-system.enable = true;

	modules.services =
	{
		samba.enable = true;

		nixbuilder.server =
		{
			enable = true;
			maxJobs = 8;
		};
	};
}
