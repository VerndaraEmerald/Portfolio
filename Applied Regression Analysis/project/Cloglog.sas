data admissions;
 infile '.\data\math dept.csv' dlm=',' firstobs = 2;
 length Major$ 30 HS_GPA 5. Status$ 20 Ethnicity$ 40 Sex$ 10 Local$ 10;
 input Major$ HS_GPA Status$ Ethnicity$ Sex$ Local$;

/* Remove unknown sex, combine ethnicities. */
data admissions;
set admissions;
if Sex = "Unknown" then delete;
if Ethnicity = "Two or More Races" 
	OR Ethnicity = "Unknown" 
	OR Ethnicity = "Visa Non-U.S." 
then Ethnicity = "Other";
run;

/* Establish categories. */
proc format;
value $admissions 
"Applied"="3App" 
"Admitted"="2Adm" 
"Enrolled"="1Enr";
run;

/* Begin computation. */
title 'Fitted model';
ODS output ModelFit=ModelFit;
ODS output ParameterEstimates=ParameterEstimates;
proc genmod;
class Major(ref="Pre-Applied Statistics") Local(ref="Non-Local") Ethnicity Sex;
model Status = Major HS_GPA Ethnicity Sex Local/
dist=multinomial link=cumcll;
format Status $admissions.;
    ODS select ModelFit;
    ODS select ParameterEstimates;    
run;
title;

/* Copy log likelihood from fitted model's ModelFit. */
data _null_;
 set ModelFit;
 if Criterion="Log Likelihood" then call symputx("FittedLogLike", Value);
run;
%put LogLike = &FittedLogLike;

/* Calculates degrees of freedom for deviance testing. Counts rows from ParameterEstimates with DF = 1 and where
the Parameter is not like intercept.*/
proc sql noprint;
SELECT (count(DF)) into :Rows 
FROM ParameterEstimates 
WHERE DF = 1 AND Parameter NOT LIKE 'Intercept_';
quit;
run;
%put Rows = &Rows;

/* Null model. */
title 'Null model';
ods output ModelFit=ModelFit;
proc genmod data = admissions;
model Status = /
dist=multinomial link=cumcll;
 ODS select ModelFit;
 ODS select ParameterEstimates;
run;
title;

/* Copy log likelihood from null model's ModelFit. */
data _null_;
 set ModelFit;
 if Criterion="Log Likelihood" then call symputx("NullLogLike", Value);
run;
%put LogLike = &NullLogLike;

/* Deviance test via macros. */
title 'Deviance test';
data deviance_test;
 deviance=-2*(&NullLogLike-(&FittedLogLike));
 pvalue=1-probchi(deviance,&Rows);
run;

proc print noobs;
run;
title;

/* Prediction. */
data prediction;
length Major $30 HS_GPA 8 Status $10 Ethnicity $30 Sex $10 Local $10;
infile datalines dsd DLM='|';
input Major$ HS_GPA Status$ Ethnicity$ Sex$ Local$;
datalines; 
Pre-Math Education|3.54||White|Female|Non-Local
;

data admissions;
set admissions prediction;
run;

ods select none;
proc genmod;
class Major Ethnicity Sex Local;
model Status = Major HS_GPA Ethnicity Sex Local/
	dist=multinomial link=cumcll;
output out=outdata p=pred_prob;
format Status $admissions.;
run;

/* Prediction with all values.*/
ods select all;
title 'Final probabilities';
data final_probabilities;
    set outdata end=eof;
    if missing(Status);
        between_prob = pred_prob - lag1(pred_prob);
    output;
    if eof=1 then do;
        _LEVEL_ = "3App";
        pred_prob = 1 - pred_prob;
        between_prob = .;
        output;
        end;
    keep _LEVEL_ pred_prob between_prob;
run;

proc print data=final_probabilities;
run;
