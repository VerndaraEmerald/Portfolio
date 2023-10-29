data exercise3;
input Name$ 1-18 Age 19-21 Nationality$ 22-31 Club$ 32-51 jerseynumber 52-54 Height$ 55-59 Weight$;
label jerseynumber='Jersey Number';
cards;
L. Messi          31 Argentina FC Barcelona        10 5'7  159lbs
Cristiano Ronaldo 33 Portugal  Juventus            7  6'2  183lbs
Neymar Jr         26 Brazil    Paris Saint-Germain 10 5'9  150lbs
De Gea            27 Spain     Manchester United   1  6'4  168lbs
K. De Bruyne      27 Belgium   Manchester City     7  5'11 154lbs
E. Hazard         27 Belgium   Chelsea             10 5'8  163lbs
L. Modric         32 Croatia   Real Madrid         10 5'8  146lbs
L. Suárez         31 Uruguay   FC Barcelona        9  6'0  190lbs
Sergio Ramos      32 Spain     Real Madrid         15 6'0  181lbs
J. Oblak          25 Slovenia  Atlético Madrid     1  6'2  192lbs
R. Lewandowski    29 Poland    FC Bayern München   9  6'0  176lbs
T. Kroos          28 Germany   Real Madrid         8  6'0  168lbs
;
run;

proc print data=exercise3 label;
format;
run;
