/* Call data. */
data times;
 infile '../../data/Exercise1.5Data.csv' dlm=',' firstobs = 2;
 input age gender$ run t1 bike t2 swim;
 combined=t1+t2;
run; 

/* Test normality. */
ods listing gpath='../../temp outputs';
ods graphics / imagename = "histogram" imagefmt = png;
proc univariate;
 var combined;
 histogram/normal;
 ODS select Histogram;
 ODS select GoodnessOfFit;
run;

/* Fitted model. Uses ods output to enable copying. */
ods output ModelFit=ModelFit;
ods output ParameterEstimates=ParameterEstimates;
proc genmod data=times;
 class gender;
 model combined=age gender run bike swim/dist=normal link=identity;
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
proc genmod data=times;
 model combined=/dist=normal link=identity;
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
input age gender$ run  bike  swim; cards;
25 M 27.53 56.28 8.77
run;

/* Plop into dataset. */
data times;
set times predict;
run;

/* Fitted model. Uses ods output to enable copying. */
ods output ModelFit=ModelFit;
ods output ParameterEstimates=ParameterEstimates;
proc genmod;
 class gender;
 model combined=age gender run  bike  swim/dist=normal link=identity;
 output out=outdata p=pcombined;
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
var pcombined;
run; 

/* Reset data. If this isn't present, rerunning this will cause the dataset to keep appending predictions. */
proc delete data=times;
run;
