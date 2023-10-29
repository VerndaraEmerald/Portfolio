/* Call data. */
data cardiac;
 infile '../../data/Exercise3.5Data.csv' dlm=',' firstobs = 2;
 input group a w;
run; 

/* Fitted model. Uses ods output to enable copying. */
ods output ModelFit=ModelFit;
ods output ParameterEstimates=ParameterEstimates;
proc genmod data=cardiac;
 class ;
 model group(event="1")= a w/dist=binomial link=logit;
 ODS select ModelFit;
 ODS select ParameterEstimates;
run;

/* Copy log likelihood from general model's ModelFit. */
data _null_;
set ModelFit;
if Criterion="Log Likelihood" then call symputx("FittedLogLike", Value);
run;
%put LogLike = &FittedLogLike;

/* Calculates degrees of freedom for deviance testing. Counts rows from ParameterEstimates with DF = 1 then subtracts 1, with 1 representing the number of parameters of the null model.*/
proc sql noprint;
select (count(DF)-1) into :Rows from ParameterEstimates where DF = 1;
quit;
run;
%put Rows = &Rows;

/* Outputs ParameterEstimates to a file for Python to write out a regression analysis. */
proc export data=ParameterEstimates
outfile = "C:/Users/3sekk/Desktop/fall 23 stats/410/text.csv"
dbms = csv replace;
delimeter = ',';
run;

/* Null model. Uses ods output to enable copying.*/
ods output ModelFit=ModelFit;
proc genmod data=cardiac;
 model group(event="1")=/dist=binomial link=logit;
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
input a w; cards;
2 4
run;

/* Plop into dataset. */
data cardiac;
set cardiac predict;
run;

/* Predicted model. */
proc genmod;
 class ;
 model group(event="1") = a w/dist=binomial link=logit;
 output out=outdata p=pgroup;
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
var pgroup;
run; 

/* Reset data. If this isn't present, rerunning this will cause the dataset to keep appending predictions. */
proc delete data=cardiac;
run;
