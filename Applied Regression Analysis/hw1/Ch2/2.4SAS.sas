/* Call data. */
data claims;
 infile '../../data/Exercise2.4Data.csv' dlm=',' firstobs = 2;
 input npolicies yrswithfirm percopenclaims claimamount;
policiesk = npolicies/1000;
run; 

/* Test normality. */
ods listing gpath='../../temp outputs';
ods graphics / imagename = "histogram" imagefmt = png;
proc univariate;
 var claimamount;
 histogram/normal;
 ODS select Histogram;
 ODS select GoodnessOfFit;
run;

/* Box Cox transformation. */
ods listing gpath='C:/Users/3sekk/Desktop/fall 23 stats/410/hw1/2.4';
ods graphics / imagename = "boxcox" imagefmt = png;
proc transreg;
model boxcox (claimamount) = identity(policiesk yrswithfirm percopenclaims);
run;

/* Transform. */
data claims;
set claims;
claimamount_tr = 2 * (sqrt(claimamount)-1);
run;

/* Test transformed normality. */
ods listing gpath='C:/Users/3sekk/Desktop/fall 23 stats/410/hw1/2.4';
ods graphics / imagename = "histogram" imagefmt = png;
proc univariate;
 var claimamount_tr;
 histogram/normal;
 ODS select Histogram;
 ODS select GoodnessOfFit;
run;

/* Fitted model. Uses ods output to enable copying. */
ods output ModelFit=ModelFit;
ods output ParameterEstimates=ParameterEstimates;
proc genmod data=claims;
 class ;
 model claimamount_tr= policiesk yrswithfirm percopenclaims/dist=normal link=identity;
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
proc genmod data=claims;
 model claimamount_tr=/dist=normal link=identity;
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
input  policiesk yrswithfirm percopenclaims; cards;
15.5 3 15
run;

/* Plop into dataset. */
data claims;
set claims predict;
run;

/* Predicted model. */
proc genmod;
 model claimamount_tr = policiesk yrswithfirm percopenclaims/dist=normal link=identity;
 output out=outdata p=pclaimamount_tr;
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
pclaimamount=((pclaimamount_tr/2)+1)**2;
run;

/* Output prediction. */
proc print data=outdata (firstobs=&Rows) noobs;
var pclaimamount;
run; 

/* Reset data. If this isn't present, rerunning this will cause the dataset to keep appending predictions. */
proc delete data=claims;
run;

