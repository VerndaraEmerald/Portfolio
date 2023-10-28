/* Call data. */
data qiscore;
 infile '../../data/Exercise2.2Data.csv' dlm=',' firstobs = 2;
 input desgn$ wrkyrs priorqi$ score;
 perscore=score/100;
run; 

/* Fitted model. Uses ods output to enable copying. */
ods output ModelFit=ModelFit;
ods output ParameterEstimates=ParameterEstimates;
proc genmod data=qiscore;
 class desgn(ref="staff") priorqi(ref="no");
 model perscore= desgn wrkyrs priorqi/dist=gamma link=log;
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
select (count(DF)-2) into :Rows from ParameterEstimates where DF = 1;
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
proc genmod data=qiscore;
 model perscore=/dist=gamma link=log;
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
input  desgn$ wrkyrs priorqi$; cards;
nurse 7 yes
run;

/* Plop into dataset. */
data qiscore;
set qiscore predict;
run;

/* Fitted model. Uses ods output to enable copying. */
proc genmod;
 class desgn(ref="staff") priorqi(ref="no");
 model perscore= desgn wrkyrs priorqi/dist=gamma link=log;
 output out=outdata p=pperscore;
 ODS select ModelFit;
 ODS select ParameterEstimates;
run;

/* Acquire the final row. */
proc sql noprint;
select (count(*)) into :Rows from outdata;
quit;
run;
%put Rows = &Rows;

data outdata;
set outdata;
pperscore = pperscore * 100;
run;

/* Output prediction. */
proc print data=outdata (firstobs=&Rows) noobs;
var pperscore;
run; 

/* Reset data. If this isn't present, rerunning this will cause the dataset to keep appending predictions. */
proc delete data=qiscore;
run;

