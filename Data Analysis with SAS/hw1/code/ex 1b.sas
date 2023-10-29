data DataFile;
infile '../data/car_prices.txt';
input make$ ncylinders$ horsepower citympg highwaympg price; 
run;

proc print data=DataFile;
run;
