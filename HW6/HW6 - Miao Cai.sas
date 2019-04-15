Libname HW6 '/folders/myfolders/HW6/';RUN;

PROC FREQ DATA=HW6.hw6_p2data;
TABLES time;
RUN;

DATA HW6.dat;
  SET HW6.hw6_p2data;
     time = time/5;
RUN;


/* Model 1: intercept-only model*/
proc glimmix data = HW6.dat noclprint METHOD=laplace noclprint noitprint;
  class ID;
  model awake(desc)  = / solution DIST=MULTINOMIAL LINK=CLOGIT;
  random int /subject=ID type=un;
  COVTEST / WALD; 
run;

/* Model 2: adding level 1 variables - time*/
proc glimmix data = HW6.dat noclprint METHOD=laplace noclprint noitprint;
  class ID;
  model awake(desc)  = time/ solution DIST=MULTINOMIAL LINK=CLOGIT oddsratio(LABEL);
  random int /subject=ID type=un;
  COVTEST / WALD; 
run;
data pvalue;
  df =1; chisq = 826.46- 661.74;
  pvalue = 1 - probchi(chisq, df); run;
proc print data = pvalue noobs;run;


/* Model 3: random slope of level 1 variables - time*/
proc glimmix data = HW6.dat noclprint METHOD=laplace noclprint;
  class ID;
  model awake(desc) = time/ solution DIST=MULTINOMIAL LINK=CLOGIT oddsratio(LABEL);
  random int time/subject=ID type=un;
  COVTEST / WALD; 
run;
data pvalue;
  df =1; chisq = 661.74 - 661.94;
  pvalue = 1 - probchi(chisq, df); run;
proc print data = pvalue noobs;run;


/* Model 4: adding level 2 variables*/
proc glimmix data = HW6.dat noclprint METHOD=laplace noclprint noitprint;
  class ID;
  model awake(desc) = time dose age duration/ solution DIST=MULTINOMIAL LINK=CLOGIT oddsratio(LABEL);
  random int/subject=ID type=un;
  COVTEST / WALD; 
run;
data pvalue;
  df =3; chisq = 661.74 - 656.33;
  pvalue = 1 - probchi(chisq, df); run;
proc print data = pvalue noobs;run;










































