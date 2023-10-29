/* Call data. */
data novelsuccess;
 infile '../../Data/Exercise3.3Data.csv' dlm=',' firstobs = 2;
 input success$ cover$ methods$ novels$ years;
run; 

/* Fitted model. Uses ods output to enable copying. */
ods output ModelFit=ModelFit;
ods output ParameterEstimates=ParameterEstimates;
proc genmod data=novelsuccess;
 class cover(ref="no") methods(ref="none") novels(ref="many");
 model success(event="yes")= cover methods novels years/dist=binomial link=cloglog;
 ODS select ModelFit;
 ODS select ParameterEstimates;
run;

/* Copy log likelihood from general model's ModelFit. */
data _null_;
set ModelFit;
if Criterion="Log Likelihood" then call symputx("FittedLogLike", Value);
run;
%put LogLike = &FittedLogLike;

/* Calculates degrees of freedom for deviance testing. Counts rows from ParameterEstimates with DF = 1 then subtracts 2, with 2 representing the number of parameters of the null model.*/
proc sql noprint;
select (count(DF)-1) into :Rows from ParameterEstimates where DF = 1;
quit;
run;
%put Rows = &Rows;

/* Outputs ParameterEstimates to a file for Python to write out a regression analysis. */
proc export data=ParameterEstimates
outfile = "../../temp outputs/text.csv"
dbms = csv replace;
delimeter = ',';
run;

/* Null model. Uses ods output to enable copying.*/
ods output ModelFit=ModelFit;
proc genmod data=novelsuccess;
 model success(event="yes")=/dist=binomial link=cloglog;
 ODS select ModelFit;
 ODS select ParameterEstimates;
run;

/* Copy log likelihood from null model's ModelFit. */
data _null_;
set ModelFit;
if Criterion="Log Likelihood" then call symputx("NullLogLike", Value);
run;
%put LogLike = &NullLogLike;

/* Deviance test via macros. */
data deviance_test;
deviance=-2*(&NullLogLike-(&FittedLogLike));
pvalue=1-probchi(deviance,&Rows);
run;
proc print noobs;
run;

/* Set prediction values. */
data predict;
input cover$ methods$ novels$ years; cards;
yes none first 0
run;

/* Plop into dataset. */
data novelsuccess;
set novelsuccess predict;
run;

/* Predicted model. */
proc genmod;
 class  cover methods novels;
 model success(event="yes") = cover methods novels years/dist=binomial link=cloglog;
 output out=outdata p=psuccess;
 ODS select ModelFit;
 ODS select ParameterEstimates;
run;

/* Acquire the final row. */
proc sql noprint;
select (count(*)) into :Rows from outdata;
quit;
run;
%put Rows = &Rows;
/* Output prediction. */
proc print data=outdata (firstobs=&Rows) noobs;
var psuccess;
run; 

/* Reset data. If this isn't present, rerunning this will cause the dataset to keep appending predictions. */
proc delete data=novelsuccess;
run;
