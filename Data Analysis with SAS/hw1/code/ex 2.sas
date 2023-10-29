data Exercise2;
	do counter = 1 to 31;
		group = 'nonsurgical';
		response = 'yes';
		output;
	end;
	do counter = 1 to 769;
		group = 'nonsurgical';
		response = 'no';
		output;
	end;
	do counter = 1 to 54;
		group = 'surgical';
		response = 'yes';
		output;
	end;
	do counter = 1 to 1092;
		group = 'surgical';
		response = 'no';
		output;
	end;

run;

proc print data=Exercise2;
run;
