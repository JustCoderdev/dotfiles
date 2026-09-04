let
	add-arch = (name: year: { inherit name year; });
in
[
	# <https://en.wikipedia.org/wiki/List_of_eponyms_of_Nvidia_GPU_microarchitectures>
	(add-arch   "fahrenheit" 1998)
	(add-arch      "celsius" 1999)
	(add-arch       "kelvin" 2001)
	(add-arch      "rankine" 2003)
	(add-arch        "curie" 2004)
	(add-arch        "tesla" 2006)
	(add-arch        "fermi" 2010)
	(add-arch       "kepler" 2012)
	(add-arch      "maxwell" 2014)
	(add-arch       "pascal" 2016)
	(add-arch        "volta" 2017)
	(add-arch       "turing" 2018)
	(add-arch       "ampere" 2020)
	(add-arch       "hopper" 2022)
	(add-arch "ada-lovelace" 2022)
	(add-arch    "blackwell" 2024)
	(add-arch        "rubin" 2026)
	(add-arch      "feynman" 2028)
]
