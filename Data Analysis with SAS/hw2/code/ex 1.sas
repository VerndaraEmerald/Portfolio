data DataFile;
infile '../data/earthquakes_Ex1.txt';
input date yymmdd10. time time11. magnitude latitute longitude;
run;

proc print data=DataFile;
format date date7. time time5.;
run;

proc print data=DataFile;
format date mmddyy10. time time11.;
run;

proc print data=DataFile;
format date weekdate. time time11.;
run;
