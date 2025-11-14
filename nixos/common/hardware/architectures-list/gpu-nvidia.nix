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
}
