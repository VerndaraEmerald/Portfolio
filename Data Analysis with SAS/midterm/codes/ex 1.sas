proc import out=ExamEx1 
  datafile='../data/ExamEx1.xls'
   dbms=Excel replace; 
run; 

proc means n mean median std min max range maxdec=2 data=ExamEx1;
    class Group;
    var Age Visit_1 Visit_2 Visit_3 Visit_4;
 run;
