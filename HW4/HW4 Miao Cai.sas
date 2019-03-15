Libname HW4 '/folders/myfolders/HW4/';

proc import datafile = '/folders/myfolders/HW4/hw4long.csv' replace
 out = HW4.hw4
 dbms = CSV;
run;

/*               Problem 3                  */
* model 1 random intercept model;
proc mixed data=HW4.hw4 noclprint covtest noitprint method=ml; 
  class id;
  model seizure = /solution ddfm=bw  ;
  random intercept /sub=id type=UN g v vcorr;
  repeated / subject = id r;
run;

* model 2 add level 1 variable;
proc mixed data=HW4.hw4 noclprint covtest noitprint method=ml; 
  class id;
  model seizure = week/solution ddfm=bw  ;
  random intercept /sub=id type=UN g v vcorr;
  repeated / subject = id r;
run;

DATA pvalue;
	DF = 1; CHISQ = 2489.0 - 2406.3;
	PVALUE = 1 - PROBCHI(CHISQ, DF);
RUN;

* model 3 adding random coefficients of the time variable;
proc mixed data=HW4.hw4 noclprint covtest noitprint method=ml; 
  class id;
  model seizure = week/solution ddfm=bw  ;
  random intercept week/sub=id type=UN g v vcorr;
  repeated / subject = id r;
run;

DATA pvalue;
	DF = 1; CHISQ = 2406.3 - 2347.7;
	PVALUE = 1 - PROBCHI(CHISQ, DF);
RUN;

/* center week and rerun the model*/
proc sql; 
create table HW4.weekC as
select *, week - mean(week) as week_c from HW4.hw4;
quit;

proc mixed data=HW4.weekC noclprint covtest noitprint method=ml; 
  class id;
  model seizure = week_c/solution ddfm=bw  ;
  random intercept week_c/sub=id type=UN g v vcorr;
  repeated / subject = id r;
run;


* model 4: adding level 2 variables;
proc mixed data=HW4.hw4 noclprint covtest noitprint method=ml; 
  class id;
  model seizure = Treatment Age week/solution ddfm=bw  ;
  random intercept /sub=id type=UN g v vcorr;
  repeated / subject = id r;
run;

DATA pvalue;
	DF = 2; CHISQ = 2406.3 - 2405.4;
	PVALUE = 1 - PROBCHI(CHISQ, DF);
RUN;



/*               Problem 4                  */
* Model 1 Exchangeable correlation matrix ;
proc genmod data = HW4.hw4;  
  class id; 
  model seizure = Treatment Age week /type3 dist=normal; 
  repeated subject = id/type=exch corrw ; 
run;  

* Model 2: Using the ar(1) correlation structure;
proc genmod data = HW4.hw4;  
  class id; 
  model seizure = Treatment Age week /type3 dist=normal; 
  repeated subject = id/type=ar(1) corrw ; 
run;  

* Model 3: Using the toep correlation structure;
proc genmod data = HW4.hw4;  
  class id; 
  model seizure = Treatment Age week /type3 dist=normal; 
  repeated subject = id/type=toep corrw ; 
run;  

* Model 4: Using the unstructured correlation structure;
proc genmod data = HW4.hw4;  
  class id; 
  model seizure = Treatment Age week /type3 dist=normal; 
  repeated subject = id/type=un corrw ; 
run; 
































