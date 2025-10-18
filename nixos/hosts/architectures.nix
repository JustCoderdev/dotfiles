{
	cpu = 
	{
		# amd = [ "" "" ];

		intel =
		let
			add-arch = (year: { inherit year; });
		in
		{
					nehalen = (add-arch 2008);
				   westmere = (add-arch 2010);
			   sandy-bridge = (add-arch 2011);
				 ivy-bridge = (add-arch 2012);
					haswell = (add-arch 2013);
					 canyon = (add-arch 2014);
				  broadwell = (add-arch 2014);
				   sky-lake = (add-arch 2015);
				  kaby-lake = (add-arch 2016);
				coffee-lake = (add-arch 2017);
			   whiskey-lake = (add-arch 2018);
				 amber-lake = (add-arch 2018);
				cannon-lake = (add-arch 2018);
				   ice-lake = (add-arch 2019);
			   cascade-lake = (add-arch 2019);
				 comet-lake = (add-arch 2019);
				cooper-lake = (add-arch 2020);
				 tiger-lake = (add-arch 2020);
				rocket-lake = (add-arch 2021);
				 alder-lake = (add-arch 2021);
				raptor-lake = (add-arch 2022);
				meteor-lake = (add-arch 2023);
			sapphire-rapids = (add-arch 2023);
			 emerald-rapids = (add-arch 2023);
			 granite-rapids = (add-arch 2024);
				 lunar-lake = (add-arch 2024);
				 arrow-lake = (add-arch 2025);
		};
	};

	gpu = 
	{
		amd =
		let
			add-arch = (year: { inherit year; });
		in
		{

			tera-scale1 = (add-arch 2008);
			tera-scale2 = (add-arch 2009);
			tera-scale3 = (add-arch 2010);
				  gcn-1 = (add-arch 2012);
				  gcn-2 = (add-arch 2013);
				  gcn-3 = (add-arch 2015);
				  gcn-4 = (add-arch 2016);
				  gcn-5 = (add-arch 2017);
				 rdna-1 = (add-arch 2019);
				 rdna-2 = (add-arch 2020);
				 rdna-3 = (add-arch 2022);
				 rdna-4 = (add-arch 2025);
		};

		# -------------------- #

		nvidia =
		let
			add-arch = (
				year: driver-name:
				{ inherit year driver-name; }
			);
		in
		{
			# <https://en.wikipedia.org/wiki/List_of_eponyms_of_Nvidia_GPU_microarchitectures>
			  fahrenheit = (add-arch 1998 null);
				 celsius = (add-arch 1999 null);
				  kelvin = (add-arch 2001 null);
				 rankine = (add-arch 2003 null);
				   curie = (add-arch 2004 null);
				   tesla = (add-arch 2006 "legacy_340");
				   fermi = (add-arch 2010 "legacy_470");
				  kepler = (add-arch 2012 "legacy_470");
				 maxwell = (add-arch 2014 "stable");
				  pascal = (add-arch 2016 "stable");
				   volta = (add-arch 2017 "stable");
				  turing = (add-arch 2018 "stable");
				  ampere = (add-arch 2020 "stable");
				  hopper = (add-arch 2022 "stable");
			ada-lovelace = (add-arch 2022 "stable");
			   blackwell = (add-arch 2024 "stable");
				   rubin = (add-arch 2026 "stable");
				 feynman = (add-arch 2028 "stable");
		};
	};
}
