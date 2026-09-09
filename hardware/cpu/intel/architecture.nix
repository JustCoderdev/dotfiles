let
	add-arch = (name: year: { inherit name year; });
in
[
	(add-arch "sandy-bridge" 2011)
	(add-arch "cherry-trail" 2015)
	(add-arch  "coffee-lake" 2017)
	(add-arch     "ice-lake" 2019)
]

