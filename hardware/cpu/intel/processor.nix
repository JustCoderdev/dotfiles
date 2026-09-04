manufacturer: architecture:

let
	add-proc = (name: cores: year: has-igpu: arch: { inherit manufacturer name cores year has-igpu arch; } );
in

[
	#              name        cores year has-igpu arch
	(add-proc "atom_x5-Z8350"    4   2016  false   architecture.atom.cherry-trail) # <https://www.intel.com/content/www/us/en/products/sku/93361/intel-atom-x5z8350-processor-2m-cache-up-to-1-92-ghz/specifications.html>
	(add-proc "core_i5-8400"     6   2017  false   architecture.core.coffee-lake)  # <https://www.intel.com/content/www/us/en/products/sku/126687/intel-core-i58400-processor-9m-cache-up-to-4-00-ghz/specifications.html>
	(add-proc "core_i5-1035G1"   4   2019  true    architecture.core.ice-lake)

	# [x] wise   : atom_x5-Z8350
	# [x] msi    : core_i5-8400
	# [x] asus   : core_i5-1035G1
	# [ ] acer
	# [ ] alpha
	# [ ] beta
	# [ ] jarvis
	# [ ] quiss
]

