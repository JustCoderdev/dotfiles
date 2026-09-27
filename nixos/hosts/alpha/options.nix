{ ... }:

{
	jcbin.update-system.enable = true;

	modules.services =
	{
		nixbuilder.server =
		{
			enable = true;
			maxJobs = 8;
		};
	};
}
