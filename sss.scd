(// char "/" is not accepted at the preset name
var f, goku, folder, folderMa;
"abc".postln;
folderMa = PathName.new("/Users/EmanTnuocca/1ST_DEMO");
//folder = PathName.new("/Users/EmanTnuocca/Downloads/ANALOG1/PERCUSS/");
folderMa.entries.do({
	arg path;
	folder = path;
	folder.postln;
/*
	32.do({arg index;
		goku = (folder.files[index]).fullPath;
		//goku.isString.postln;
		f = File("~/Inferno.afx".standardizePath,"a");
		c = FileReader(goku);
		x = c.read;
		145.do({arg item;
			if( ((x[(3 * item) + 8][12]).asInt >9),
				{f.write((x[(3 * item) + 8][12]))},
				{f.write("0" ++ (x[(3 * item) + 8][12]))}
		)});
		f.write("\n");
		f.close;
	});
*/
	});

)