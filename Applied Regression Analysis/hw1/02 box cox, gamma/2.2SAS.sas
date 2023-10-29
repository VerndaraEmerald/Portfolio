/* Call data. */
data QIScores;
 infile '../../data/Exercise2.2Data.csv' dlm=',' firstobs = 2;
 input desgn$ wrkyrs priorqi$ score;
 nurse=(desgn="nurse");
 doctor=(desgn="doctor");
 priorqiyes=(priorqi="yes");
scoreper = score/100;
run; 

/* Test normality. */
ods listing gpath='../../temp outputs';
ods graphics / imagename = "histogram" imagefmt = png;
proc univariate;
 var scoreper;
 histogram/normal;
 ODS select Histogram;
 ODS select GoodnessOfFit;
run;   

proc transreg;
model boxcox (scoreper) = identity(nurse doctor wrkyrs priorqiyes);
run;

/* Transform */
data QIScores;
set QIScores;
scoreper_tr = 1-1/scoreper;
run;

proc univariate;
 var scoreper_tr;
 histogram/normal;
 ODS select Histogram;
 ODS select GoodnessOfFit;
run;   

/* Fitted model. Uses ods output to enable copying. */
ods output ModelFit=ModelFit;
ods output ParameterEstimates=ParameterEstimates;
proc genmod data=QIScores;
 model scoreper_tr= nurse doctor wrkyrs priorqiyes/dist=normal link=identity;
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
proc genmod data=QIScores;
 model scoreper_tr=/dist=normal link=identity;
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
input desgn$ wrkyrs priorqi$; cards;
nurse 7 yes
run;

/* Plop into dataset. */
data QIScores;
set QIScores predict;
run;

/* Predicted model. */
proc genmod;
 class desgn priorqi;
 model scoreper_tr = desgn wrkyrs priorqi/dist=normal link=identity;
 output out=outdata p=pscoreper_tr;
 ODS select ModelFit;
 ODS select ParameterEstimates;
run;

/* Acquire the final row. */
proc sql noprint;
select (count(*)) into :Rows from outdata;
quit;
run;
%put Rows = &Rows;

/* Untrasform. */
data outdata;
set outdata;
pscoreraw=100/(1-pscoreper_tr);
run;

/* Output prediction. */
proc print data=outdata (firstobs=&Rows) noobs;
var pscoreraw;
run; 
