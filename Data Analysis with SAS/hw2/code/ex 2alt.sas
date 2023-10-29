proc import out = Asthma
 datafile = '../data/asthma_Ex2.csv'
 dbms = csv replace;
 getnames = yes;
run;

title1 'Asthma Patients';
title2 'Basic Data Set';
footnote1 'Data from Medical Records';

proc sort data = asthma out = asthma;
format BMI comma10.1;
by smoking patient;
run;

proc print data = asthma;
ID patient;
var asthma age bmi;
by smoking;
run;
