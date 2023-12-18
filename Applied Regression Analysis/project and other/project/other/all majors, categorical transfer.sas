proc import out=admissions
  datafile='../data/database_alt.csv'
   dbms=csv replace; 
run;

proc format;
value $admissions 
"Applied"="1App" 
"Admitted"="2Adm" 
"Enrolled"="3Enr";
run;

ODS output ModelFit=ModelFit;
ODS output ParameterEstimates=ParameterEstimates;
proc genmod;
class Student_Major Local_Preference(ref="no") Average_Transfer_GPA(ref="no");
model Applicant_Status = Student_Major AVG_HS_GPA Average_Transfer_GPA Local_Preference/
dist=multinomial link=cumlogit;
format Applicant_Status $admissions.;
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
model Applicant_Status = /
dist=multinomial link=cumlogit;
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
input Student_Major$ 1-22 AVG_HS_GPA 24-26 Average_Transfer_GPA$ 28-30 Local_Preference$ 32-40;
cards;
Pre-Applied Statistics 4.0 yes Non-Local
;

proc print data = prediction;
run;

data admissions;
set admissions prediction;
run;

proc genmod;
class Student_Major Local_Preference Average_Transfer_GPA(ref="no");
model Applicant_Status = Student_Major AVG_HS_GPA Average_Transfer_GPA Local_Preference/
dist=multinomial link=cumlogit;
output out=outdata p=pred_prob;
format Applicant_Status $admissions.;
run;

proc print data=outdata (firstobs=147200) noobs;
run;
