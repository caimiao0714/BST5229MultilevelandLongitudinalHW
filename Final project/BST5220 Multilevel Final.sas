LIBNAME F '/folders/myfolders/'; RUN;

* 1. intercept only model;
proc glimmix data=F.finalprojectdata_bst522 noitprint noclprint;
  class family_ID ID;
  model visit = / solution dist = poisson link = log;
  random int / subject=family_ID type=un;
  random int / subject=ID(family_ID) type=un;
  COVTEST / WALD;
run;

* 2. exclude insignificant random intercept at family_ID level;
proc glimmix data=F.finalprojectdata_bst522 noitprint noclprint;
  class  ID family_ID;
  model visit = / solution dist = poisson link = log;
  random int / subject=ID(family_ID) type=un;
  COVTEST / WALD;
run;

* 2.1 add overdispersion parameter;
proc glimmix data=F.finalprojectdata_bst522 noitprint noclprint;
  class  ID family_ID;
  model visit = / solution dist = poisson link = log;
  random int / subject=ID(family_ID) type=un;
  random _residual_ /subject=ID(family_ID);
  COVTEST / WALD;
run;
* 3101.21; 

* 3. adding time variable;
proc glimmix data=F.finalprojectdata_bst522 noitprint noclprint;
  class  ID family_ID;
  model visit = year/ solution dist = poisson link = log;
  random int / subject=ID(family_ID) type=un;
  random _residual_ /subject=ID(family_ID);
  COVTEST / WALD;
run;

data pvalue;
  df =1; chisq = 3101.21- 3094.06;
  pvalue = 1 - probchi(chisq, df); run;
proc print data = pvalue noobs;run;

* 4. test random slope of time;
proc glimmix data=F.finalprojectdata_bst522 noitprint noclprint;
  class  ID family_ID;
  model visit = year/ solution dist = poisson link = log;
  random int year/ subject=ID(family_ID) type=un;
  random _residual_ /subject=ID(family_ID);
  COVTEST / WALD;
run; * not converge;

* 5. Add level 2 variables;
proc glimmix data=F.finalprojectdata_bst522 noitprint noclprint;
  class  ID family_ID gender education(ref='1');
  model visit = year gender chronic education age_base/ solution dist = poisson link = log;
  random int / subject=ID(family_ID) type=un;
  random _residual_ /subject=ID(family_ID);
  COVTEST / WALD;
run;

data pvalue;
  df =6; chisq = 3094.06- 3058.51;
  pvalue = 1 - probchi(chisq, df); 
proc print data = pvalue noobs;run;


* 6. Test the interaction between level 1 and level 2;
* 6.1 year and gender;
proc glimmix data=F.finalprojectdata_bst522 noitprint noclprint;
  class  ID family_ID gender education(ref='1');
  model visit = year|gender chronic education age_base/ solution dist = poisson link = log;
  random int / subject=ID(family_ID) type=un;
  random _residual_ /subject=ID(family_ID);
  COVTEST / WALD;
run;

* 6.1 year and gender;
proc glimmix data=F.finalprojectdata_bst522 noitprint noclprint;
  class  ID family_ID gender education(ref='1');
  model visit = year gender chronic education age_base/ solution dist = poisson link = log;
  random int / subject=ID(family_ID) type=un;
  random _residual_ /subject=ID(family_ID);
  COVTEST / WALD;
run;

* 6.2 year and chronic;
proc glimmix data=F.finalprojectdata_bst522 noitprint noclprint;
  class  ID family_ID gender education(ref='1');
  model visit = year|chronic gender education age_base/ solution dist = poisson link = log;
  random int / subject=ID(family_ID) type=un;
  random _residual_ /subject=ID(family_ID);
  COVTEST / WALD;
run;

* 6.3 year and education;
proc glimmix data=F.finalprojectdata_bst522 noitprint noclprint;
  class  ID family_ID gender education(ref='1');
  model visit = year|education chronic gender  age_base/ solution dist = poisson link = log;
  random int / subject=ID(family_ID) type=un;
  random _residual_ /subject=ID(family_ID);
  COVTEST / WALD;
run;

* 6.4 year and age_base;
proc glimmix data=F.finalprojectdata_bst522 noitprint noclprint;
  class  ID family_ID gender education(ref='1');
  model visit = year|age_base chronic gender education / solution dist = poisson link = log;
  random int / subject=ID(family_ID) type=un;
  random _residual_ /subject=ID(family_ID);
  COVTEST / WALD;
run;
















