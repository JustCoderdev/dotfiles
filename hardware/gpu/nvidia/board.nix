manufacturer: architecture:

let
	add-board = (name: year: arch: driver-name: { inherit manufacturer name year arch driver-name; } );
	inherit (architecture) pascal maxwell;
in

# Sources:
#  - <https://www.nvidia.com/en-us/drivers/unix/legacy-gpu/>
#  - <https://www.nvidia.com/en-us/drivers/>
[
	#              name        year arch    driver-name
	(add-board "gtx-1050-ti"   2016 pascal  "legacy_580")
	(add-board "geforce-mx130" 2017 maxwell "legacy_580")
]
