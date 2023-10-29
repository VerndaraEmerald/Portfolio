data knees;
    input ID$ knee ScorePre Score1D Score1W Score1M;
    cards;
    01 1 0 5  7  10
    02 1 0 10 15 15
    02 2 3 5  8  10
    03 1 0 3  3  3
    03 2 0 6  9  9
    04 1 0 4  10 10
    ;

title knee1;
data knee1;
    set knees;
     if knee = 1;
     array x[4] ScorePre Score1D Score1W Score1M;
     do visit = 1 to 4;
         score = x[visit];
         output;
      end;
  keep id visit score;
  run;

proc print noobs;
run;

title knee2;
data knee2;
    set knees;
     if knee = 2;
     array x[4] ScorePre Score1D Score1W Score1M;
     do visit = 1 to 4;
         score = x[visit];
         output;
      end;
  keep id visit score;
  run;
  
  proc print noobs;
  run;

  proc format;
    value visit_f
        1 = "pre_op"
        2 = "day 1"
        3 = "week 1"
        4 = "month 1";

title combined;
data combine;
    merge 
        knee1(rename=score=score_knee1) 
        knee2(rename=score=score_knee2);
    by ID;
    format visit visit_f.;
run;
    
proc print noobs;
run;
