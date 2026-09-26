manufacturer: architecture:

let
	add-proc = (name: cores: year: has-igpu: arch: { inherit manufacturer name cores year has-igpu arch; } );
	inherit (architecture) sandy-bridge ivy-bridge cherry-trail coffee-lake ice-lake;
in

[
	#              name        cores year has-igpu arch
	(add-proc "celeron_887"      2   2012  true    sandy-bridge)  # <https://www.intel.com/content/www/us/en/products/sku/196603/intel-core-i51035g1-processor-6m-cache-up-to-3-60-ghz/specifications.html>
	(add-proc "core_i5-3470"     4   2012  true    ivy-bridge)    # <https://www.intel.com/content/www/us/en/products/sku/68316/intel-core-i53470-processor-6m-cache-up-to-3-60-ghz/specifications.html>
	(add-proc "atom_x5-Z8350"    4   2016  false   cherry-trail)  # <https://www.intel.com/content/www/us/en/products/sku/93361/intel-atom-x5z8350-processor-2m-cache-up-to-1-92-ghz/specifications.html>
	(add-proc "core_i5-8400"     6   2017  false   coffee-lake)   # <https://www.intel.com/content/www/us/en/products/sku/126687/intel-core-i58400-processor-9m-cache-up-to-4-00-ghz/specifications.html>
	(add-proc "core_i5-1035G1"   4   2019  true    ice-lake)      # <https://www.intel.com/content/www/us/en/products/sku/196603/intel-core-i51035g1-processor-6m-cache-up-to-3-60-ghz/specifications.html>

	# [x] acer
	# [x] quiss
	# [x] wise
	# [x] msi
	# [x] asus
	# [ ] alpha
	# [ ] beta
	# [ ] jarvis
]
