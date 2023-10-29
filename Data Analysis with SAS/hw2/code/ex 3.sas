data states;
 infile '../data/states_Ex3.csv' dlm=',' firstobs = 2;
 length StateName $20;
 input StateName$ StateAbbrev$ PostalAbbrev$ Area Population;
run;

ods HTML PATH = 'C:/Users/3sekk/Desktop/fall 23 stats/475/homework2' 
    File ='states1.html';
options nonumber nodate;
title;
proc report nowd headline headskip;
 column StateName StateAbbrev PostalAbbrev Area Population;
 define StateName/'State Name';
 define StateAbbrev/'State Abbrev.' width = 10 spacing = 10;
 define PostalAbbrev/'Postal Abbrev.' width = 10 spacing = 5;
 define Area/'Area (Sq Mi)' format = comma7. width = 8;
 define Population/'Population' format = comma10. width = 12 spacing = 5;
run; 
ods HTML close;
