proc import out=ViaExcel 
  datafile='../data/car_prices.xlsx'
   dbms=Excel replace; 
run; 

proc print data=ViaExcel;
run;
