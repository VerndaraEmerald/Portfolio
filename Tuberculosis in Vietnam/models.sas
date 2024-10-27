/* Call data. */
data merged;
 infile './data/sas_merged.csv' dlm=',' missover firstobs=2;
 length province $ 20;
 input province$ year quarter$ pop_dens literacy in_migration pop urban_rural_ratio cases incidence diff;
run;

/* Arbitrary combination. */
data selected;
 INFILE DATALINES DLM='|';
 length province $ 20;
 input province$ year quarter$ pop_dens literacy in_migration pop urban_rural_ratio cases incidence diff; datalines;
 .|2012|3|500|90|60.5|.|5|.|.|.|.
run;

/* Combine. */
data merged;
 length province $ 20;
 set merged selected;
run;

/* Run gam. */
proc gam data = merged;
 class quarter(ref="1");
 model incidence = param(year quarter) 
 loess(pop_dens) loess(literacy) loess(in_migration) loess(urban_rural_ratio);
 score data = merged out = predicted;
 ods select ParameterEstimates;
 ods select ANODEV;
run;

/* Acquire the final row. */
proc sql noprint;
 select (count(*)) into :Rows from predicted;
 quit;
 run;
%put Rows = &Rows;

/* Output final row. */
proc print data = predicted (firstobs=&Rows) noobs;
 var province year quarter pop_dens literacy in_migration urban_rural_ratio P_incidence P_pop_dens P_literacy P_in_migration P_urban_rural_ratio;
run;

proc glimmix data = merged method=Laplace;
 class quarter(ref="1") province;
 logn = log(duration);
 model cases = quarter pop_dens literacy in_migration urban_rural_ratio / solution dist = poisson link = log offset = logn;
 random intercept year/subject=province type=un;
 covtest/wald;
 output out=outdata pred(ilink)=pred_cases;
run;

data final;
 set outdata;
 pred_inc = 100000 * pred_cases/pop;
run;

proc print;
run;
