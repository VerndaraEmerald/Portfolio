data DataFile;
    infile '../data/ExamEx2.dat' dlm='09'x firstobs = 2;
input ID A$ B$;
    run;

proc freq;
    tables A*B / nopercent norow nocol;
run;
