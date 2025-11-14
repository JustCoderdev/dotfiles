let
	add-arch = (year: { inherit year; });
in
{

	tera-scale1 = (add-arch 2008);
	tera-scale2 = (add-arch 2009);
	tera-scale3 = (add-arch 2010);
		  gcn-1 = (add-arch 2012);
		  gcn-2 = (add-arch 2013);
		  gcn-3 = (add-arch 2015);
		  gcn-4 = (add-arch 2016);
		  gcn-5 = (add-arch 2017);
		 rdna-1 = (add-arch 2019);
		 rdna-2 = (add-arch 2020);
		 rdna-3 = (add-arch 2022);
		 rdna-4 = (add-arch 2025);
}
