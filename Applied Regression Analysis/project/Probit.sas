proc import out=admissions
  datafile='./data/math dept.csv'
   dbms=csv replace; 
   guessingrows=50;
run;

proc format;
value $admissions 
"Applied"="3App" 
"Admitted"="2Adm" 
"Enrolled"="1Enr";
run;

ODS output ModelFit=ModelFit;
ODS output ParameterEstimates=ParameterEstimates;
proc genmod;
class Major(ref="Pre-Applied Statistics") Local(ref="Non-Local") Ethnicity(ref="Unknown") Sex;
model Status = Major HS_GPA Ethnicity Sex Local/
dist=multinomial link=cumprobit;
format Status $admissions.;
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

ods output ModelFit=ModelFit;
proc genmod data = admissions;
model Status = /
dist=multinomial link=cumprobit;
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

data prediction;
length Major $30 HS_GPA 8 Status $10 Ethnicity $10 Sex $10 Local $10;
infile datalines dsd DLM='|';
input Major$ HS_GPA Status$ Ethnicity$ Sex$ Local$;
datalines; 
Pre-Applied Statistics|4.23||Asian|Male|Non-Local
;

proc print data = prediction;
run;

data admissions;
set admissions prediction;
run;

proc genmod;
class Major Ethnicity Sex Local;
model Status = Major HS_GPA Ethnicity Sex Local/
	dist=multinomial link=cumprobit;
output out=outdata p=pred_prob;
format Status $admissions.;
run;

/* Acquire the final row. */
proc sql noprint;
select (count(*)) - 1 into :Rows from outdata;
quit;
run;
%put Rows = &Rows;

/* Output prediction. */
proc print data=outdata (firstobs=&Rows) noobs;
run; 
