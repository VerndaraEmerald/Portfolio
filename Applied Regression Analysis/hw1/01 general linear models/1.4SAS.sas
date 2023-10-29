/* Call data. */
proc import out=sleep
  datafile='../../Data/Exercise1.4Data.csv'
   dbms=csv replace; 
run;

/* Test normality. The two ODS select acquires only currently-used tables.*/
ods listing gpath='../../temp outputs';
ods graphics / imagename = "histogram" imagefmt = png;
proc univariate;
 var Sleephours;
 histogram/normal;
 ODS select Histogram;
 ODS select GoodnessOfFit;
run;

/* Fitted model. Uses ods output to enable copying. The two ODS select acquires only currently-used tables.*/
ODS output ModelFit=ModelFit;
ODS output ParameterEstimates=ParameterEstimates;
proc genmod;
 class gender(ref="F") JobStatus(ref="full");
 model Sleephours=Age Gender QuietTime NChildren StressLevel JobStatus NActivities PastVac/dist=normal link=identity;
 ODS select ModelFit;
 ODS select ParameterEstimates;
run;

/* Copy log likelihood from fitted model's ModelFit. */
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
proc genmod data=sleep;
 model Sleephours=/dist=normal link=identity;
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
input Age Gender$ QuietTime NChildren StressLevel JobStatus$ NActivities PastVac; cards;
30 F 10 3 7 full 7 12
run;

/* Plop into dataset. */
data sleep;
set sleep predict;
run;

/* Run model. */
ods exclude all;
proc genmod;
 class gender(ref="F") JobStatus(ref="full");
 model Sleephours=Age Gender QuietTime NChildren StressLevel JobStatus NActivities PastVac/dist=normal link=identity;
 output out=outdata p=psleephours;
run;
ods exclude none;

/* Acquire the final row. */
proc sql noprint;
 select (count(*)) into :Rows from outdata;
 quit;
run;
%put Rows = &Rows;

/* Output prediction. */
proc print data=outdata (firstobs=&Rows) noobs;
var psleephours;
run; 

/* Reset data. If this isn't present, rerunning this will cause the dataset to keep appending predictions. */
proc delete data=sleep;
run;
