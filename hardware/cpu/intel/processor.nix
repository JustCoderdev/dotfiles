manufacturer: architecture:

let
	add-proc = (name: cores: year: has-igpu: arch: { inherit manufacturer name cores year has-igpu arch; } );
in

[
	#              name          cores year has-igpu arch
	(add-proc "celeron_887"        2   2012  true    architecture.sandy-bridge)  # <https://www.intel.com/content/www/us/en/products/sku/196603/intel-core-i51035g1-processor-6m-cache-up-to-3-60-ghz/specifications.html>
	(add-proc "atom_x5-Z8350"      4   2016  false   architecture.cherry-trail)  # <https://www.intel.com/content/www/us/en/products/sku/93361/intel-atom-x5z8350-processor-2m-cache-up-to-1-92-ghz/specifications.html>
	(add-proc "core_i5-8400"       6   2017  false   architecture.coffee-lake)   # <https://www.intel.com/content/www/us/en/products/sku/126687/intel-core-i58400-processor-9m-cache-up-to-4-00-ghz/specifications.html>
	(add-proc "core_i5-1035G1"     4   2019  true    architecture.ice-lake)      # <https://www.intel.com/content/www/us/en/products/sku/196603/intel-core-i51035g1-processor-6m-cache-up-to-3-60-ghz/specifications.html>

	# [x] acer
	# [x] wise
	# [x] msi
	# [x] asus
	# [ ] alpha
	# [ ] beta
	# [ ] jarvis
	# [ ] quiss
]
