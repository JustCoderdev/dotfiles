manufacturer: architecture:

let
	add-board = (name: year: arch: { inherit manufacturer name year arch; } );
	inherit (architecture) tera_scale-2;
in

[
	#            name    year     arch
	(add-board "hd-6750" 2011 tera_scale-2)  # <https://www.amd.com/en/support/downloads/drivers.html/graphics/radeon-hd/radeon-hd-6000-series/amd-radeon-hd-6750.html#amd_support_product_spec>
]

