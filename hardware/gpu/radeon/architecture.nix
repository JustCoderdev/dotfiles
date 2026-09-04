let
	add-arch = (name: year: { inherit name year; });
in
[
	(add-arch "tera-scale1" 2008)
	(add-arch "tera-scale2" 2009)
	(add-arch "tera-scale3" 2010)
	(add-arch       "gcn-1" 2012)
	(add-arch       "gcn-2" 2013)
	(add-arch       "gcn-3" 2015)
	(add-arch       "gcn-4" 2016)
	(add-arch       "gcn-5" 2017)
	(add-arch      "rdna-1" 2019)
	(add-arch      "rdna-2" 2020)
	(add-arch      "rdna-3" 2022)
	(add-arch      "rdna-4" 2025)
]
