/* Call data. */
data merged;
 infile './data/sas_map.csv' dlm=',' missover firstobs=2;
 length IDNAME $ 35;
 input IDNAME$ ID year quarter pop_dens literacy in_migration pop urban_rural_ratio cases incidence diff;
run;

/* Macro for a quarter. */
%macro mapper1(quarter);
/* Acquire quarter number for title and file name.*/
data _null_;
 quarter_num = compress("&quarter", '', 'A');
 call symputx('quarter_num',quarter_num);
run;

title "Raw incidences rates, Year &year Quarter &quarter_num";
proc gmap data = &quarter map = maps.Vietnam all gout = work.gseg;
 id ID;
 choro incidence / name = "Q&quarter_num";
run;
quit;
%mend;

%macro mapper(year);
/* Create quarterly data from given year. */
data q1 q2 q3 q4;
 set merged;
 if (year = &year);
 if (quarter = 1) then output q1;
 if (quarter = 2) then output q2;
 if (quarter = 3) then output q3;
 if (quarter = 4) then output q4;
run;

/* Create maps per quarter. */
ods html gpath = ".\outputs\sas_temp\" device = svg;
%mapper1(q1);
%mapper1(q2);
%mapper1(q3);
%mapper1(q4);

/* Merge maps. */
ods graphics on;
ods html gpath = ".\outputs\sas_final" device = svg;
title "Raw incidences rates, Year &year";
proc greplay igout=work.gseg tc=sashelp.templt template=l2r2 nofs;
 treplay 1:Q1 2:Q2 3:Q3 4:Q4 name = "SAS &year raw";
run;
quit;

/* Clean work.gseg. */
proc greplay igout = work.gseg nofs;
 delete _all_;
 run;
quit;
%mend;

/* Create maps. */
%mapper(2011);
%mapper(2012);
%mapper(2013);
%mapper(2014);
%mapper(2015);

/* Differences */

/* Macro for a quarter. */
%macro mapper1(quarter);
/* Acquire quarter number for title and file name.*/
data _null_;
 quarter_num = compress("&quarter", '', 'A');
 call symputx('quarter_num',quarter_num);
run;

title "Incidences rate changes, Year &year Quarter &quarter_num";
proc gmap data = &quarter map = maps.Vietnam all gout = work.gseg;
 id ID;
 choro diff / name = "Q&quarter_num";
run;
quit;
%mend;

%macro mapper(year);
/* Create quarterly data from given year. */
data q1 q2 q3 q4;
 set merged;
 if (year = &year);
 if (quarter = 1) then output q1;
 if (quarter = 2) then output q2;
 if (quarter = 3) then output q3;
 if (quarter = 4) then output q4;
run;

/* Create maps per quarter. */
ods html gpath = ".\outputs\sas_temp\" device = svg;
%mapper1(q1);
%mapper1(q2);
%mapper1(q3);
%mapper1(q4);

/* Merge maps. */
ods graphics on;
ods html gpath = ".\outputs\sas_final" device = svg;
title "Incidences rate changes, Year &year";
proc greplay igout=work.gseg tc=sashelp.templt template=l2r2 nofs;
 treplay 1:Q1 2:Q2 3:Q3 4:Q4 name = "SAS &year diff";
run;
quit;

/* Clean work.gseg. */
proc greplay igout = work.gseg nofs;
 delete _all_;
 run;
quit;
%mend;

/* Create maps. */
%mapper(2011);
%mapper(2012);
%mapper(2013);
%mapper(2014);
%mapper(2015);
