Libname HW5 '/folders/myfolders/HW5/';

data HW5.dat; set HW5.hw5p1_data; logGSI=log2(GSI + 1/53); run; 

/* 1. Intercept only model*/
PROC MIXED DATA = HW5.dat NOCLPRINT METHOD=ML COVTEST NOITPRINT;
CLASS ID Parent_ID;
MODEL logGSI = / solution ddfm=betwithin;
random intercept / subject=Parent_ID type=UN;
random intercept / subject=ID(Parent_ID) type=UN;
RUN;

/*Step 2: Adding Time-dependent Variable*/
proc mixed data=HW5.dat noclprint method=ml covtest noitprint;
  class ID Parent_ID season Parent_died Parent_drug_status;
  model logGSI = True_month Season Parent_died 
  Parent_drug_status Parent_alcohol Parent_marijuana/ solution  ddfm=bw ;
  random intercept / subject=Parent_ID type=un; 
  random intercept / subject=ID(Parent_ID) type=un; 
run;

data pvalue;
  df =6; chisq = 7277.6- 7251.5;
  pvalue = 1 - probchi(chisq, df); run;
proc print data = pvalue noobs;run;


/*Step 3: Testing Random Slope for Signifciant Variables in Step 2 */
proc mixed data=HW5.dat noclprint method=ml covtest noitprint;
  class ID Parent_ID season Parent_died Parent_drug_status;
  model logGSI = Season Parent_died Parent_drug_status / solution  ddfm=bw ;
  random intercept / subject=Parent_ID type=un; 
  random intercept Parent_died Parent_drug_status / subject=ID(Parent_ID); 
run;

data pvalue;
  df =6; chisq = 7251.5- 7252.4;
  pvalue = 1 - probchi(chisq, df); run;
proc print data = pvalue noobs;run;

/*Step 4: Adding Level-2 Variables*/
proc mixed data=HW5.dat noclprint method=ml covtest noitprint;
  class ID Parent_ID season Parent_died Parent_drug_status Gender Hispanic;
  model logGSI = Season Parent_died Parent_drug_status Gender Hispanic/ solution  ddfm=bw ;
  random intercept / subject=Parent_ID type=un; 
  random intercept / subject=ID(Parent_ID) type=un; 
run;
data pvalue;
  df =2; chisq = 7251.5- 7241.8;
  pvalue = 1 - probchi(chisq, df); run;
proc print data = pvalue noobs;run;

/*Step 5: Adding Level-3 Variables*/
proc mixed data=HW5.dat noclprint method=ml covtest noitprint;
  class ID Parent_ID season Parent_died Parent_drug_status Gender
  Parent_gender Parent_diagnosis;
  model logGSI = Season Parent_died Parent_drug_status Gender 
  Parent_base_age Parent_gender Parent_diagnosis Treatment/ solution  ddfm=bw ;
  random intercept / subject=Parent_ID type=un; 
  random intercept / subject=ID(Parent_ID) type=un; 
run;
data pvalue;
  df =4; chisq = 7241.8 - 7232.5;
  pvalue = 1 - probchi(chisq, df); run;
proc print data = pvalue noobs;run;

/*Step 6: Testing the Interaction Between Season and Gender*/
proc mixed data=HW5.dat noclprint method=ml covtest noitprint;
  class ID Parent_ID season Parent_died Parent_drug_status Gender
  Parent_gender Parent_diagnosis;
  model logGSI = Season|Gender Parent_died Parent_drug_status Parent_diagnosis/ solution  ddfm=bw;
  random intercept / subject=Parent_ID type=un; 
  random intercept / subject=ID(Parent_ID) type=un; 
run;
data pvalue;
  df =6; chisq = 7241.8 - 7235.5;
  pvalue = 1 - probchi(chisq, df); run;
proc print data = pvalue noobs;run;

/*Step 6: Testing the Interaction Between Parent_died and Gender*/
proc mixed data=HW5.dat noclprint method=ml covtest noitprint;
  class ID Parent_ID season Parent_died Parent_drug_status Gender
  Parent_gender Parent_diagnosis;
  model logGSI = Season Parent_died|Gender Parent_drug_status Parent_diagnosis/ solution  ddfm=bw;
  random intercept / subject=Parent_ID type=un; 
  random intercept / subject=ID(Parent_ID) type=un; 
run;
data pvalue;
  df =4; chisq = 7241.8 - 7233.8;
  pvalue = 1 - probchi(chisq, df); run;
proc print data = pvalue noobs;run;

/*Step 6: Testing the Interaction Between Parent_drug_status and Gender*/
proc mixed data=HW5.dat noclprint method=ml covtest noitprint;
  class ID Parent_ID season Parent_died Parent_drug_status Gender
  Parent_gender Parent_diagnosis;
  model logGSI = Season Parent_died Parent_drug_status|Gender Parent_diagnosis/ solution  ddfm=bw;
  random intercept / subject=Parent_ID type=un; 
  random intercept / subject=ID(Parent_ID) type=un; 
run;
data pvalue;
  df =6; chisq = 7241.8 - 7236.1;
  pvalue = 1 - probchi(chisq, df); run;
proc print data = pvalue noobs;run;








