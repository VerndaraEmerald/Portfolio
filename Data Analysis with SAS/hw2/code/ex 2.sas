data asthma;
 infile '../data/asthma_Ex2.csv' dlm=',' firstobs = 2;
 format BMI comma10.1;
 length Smoking $15;
 input Patient Weight Height Age BMI Smoking$ Asthma$;
run;

title1 'Asthma Patients';
title2 'Basic Data Set';
footnote1 'Data from Medical Records';

proc sort data = asthma out = asthma;
by smoking patient;
run;

proc print data = asthma;
ID patient;
var asthma age bmi;
by smoking;
run;
