data int;
    input ID$ GROUP$ BMI_base BMI_3mos BMI_9mos;
    cards;
    101 int 34.5 33.8 31.1
    102 int 30.7 29.6 27.3
    103 int 32.0 30.7 27.5
    105 int 34.6 33.5 33.3
    106 int 37.6 34.9 30.1
    107 int 30.2 29.2 28.7
    108 int 37.2 36.0 35.1
    109 int 35.2 33.3 33.7
    111 int 32.3 31.4 29.4
    ;

data cnt;
    input ID$ GROUP$ BMI_base BMI_3mos BMI_9mos;
    cards;
    401 cnt 33.7 33.4 33.2
    402 cnt 31.2 30.1 29.8
    404 cnt 30.8 31.1 31.8
    406 cnt 29.2 29.0 28.9
    408 cnt 27.7 27.3 27.9
    409 cnt 33.8 32.9 31.4
    ;

data combined1;
    set int cnt;
    BMI_change = BMI_9mos - BMI_base;
run;

proc print;
run;

data combined1 (drop = BMI_change);
    set int cnt;
    BMI_change = BMI_9mos - BMI_base;
    if BMI_change < -3 AND GROUP = "int" 
    OR BMI_change < 0 AND GROUP = "cnt";
run;

proc print;
run;
