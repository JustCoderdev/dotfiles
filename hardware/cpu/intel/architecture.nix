let
	add-arch = (name: year: { inherit name year; });
in
{
	atom =
	[
		(add-arch "cherry-trail" 2015)
	];

	core =
	[
		(add-arch "coffee-lake" 2017)
		(add-arch    "ice-lake" 2019)
	];
}

