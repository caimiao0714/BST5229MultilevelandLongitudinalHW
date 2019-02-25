LIBNAME HW2 '/folders/myfolders/BST5220 Multilevel and Longitudinal Analysis/HW2';
RUN;

/*******************/
/* Recode variable */
PROC FREQ DATA=HW2.DataForHW2; 
TABLES	meducation ChildRace FamilyStructure HouseIncome pHealth  ExerciseFreeTime
		region urban schooltype PctMinority;
RUN;

/* PROC SGPLOT data=HW2.DataForHW2;
   scatter x=ChildBMI y=bmipct;
RUN; */

DATA HW2.DATHW2clean;
KEEP school_ID bmipct 
	meducation ChildRace FamilyStructure HouseIncome pHealth  ExerciseFreeTime TV
	region urban schooltype PctMinority PCTFreeLunch;
SET HW2.DataForHW2;
IF ChildRace='5=white' THEN ChildRace='White';
IF ChildRace='4=black' THEN ChildRace='Black';
IF ChildRace NOT IN ('White','Black') THEN ChildRace='Other';
IF HouseIncome IN ('1<15000', '2:15000-25000') THEN HouseIncome='Low';
IF HouseIncome IN ('3:25000-35000', '4:35000-50000', '5:50000-75000') THEN HouseIncome='Middle';
IF HouseIncome IN ('6:75000-100000', '7:>100000') THEN HouseIncome='High';
IF meducation IN ('3=some college', '4=>=bachelor') THEN meducation='3>=college';
IF PctMinority = 1 THEN PctMinority=1;
IF PctMinority IN (2, 3) THEN PctMinority=2;
IF PctMinority IN (4, 5) THEN PctMinority=3;
IF ExerciseFreeTime IN (1, 2) THEN ExerciseFreeTime=1;
IF ExerciseFreeTime = 3 THEN ExerciseFreeTime=2;
*if nmiss(of _numeric_) > 0 then delete;
RUN;


/* PROC FREQ DATA=HW2.DATHW2clean; 
TABLES meducation ChildRace FamilyStructure HouseIncome pHealth  ExerciseFreeTime TV
		region urban schooltype PctMinority;
RUN; */


* meducation ChildRace FamilyStructure HouseIncome pHealth  ExerciseFreeTime TV
		region urban schooltype PctMinority PCTFreeLunch;





/******************************************/
/***********Statistical Analysis***********/
/******************************************/

/* 00 Random Intercept model*/
PROC MIXED DATA=HW2.DATHW2clean noclprint covtest noitprint method=reml;
CLASS school_ID;
MODEL bmipct = / solution ddfm = bw;
RANDOM intercept / subject=school_ID TYPE=UN;
RUN; *-2loglikelihood: 151837.0;




/******************************************/
/************RANDOM INTERCEPT 01***********/
/******************************************/

/* 01 Random Intercept model with level 1 variables*/
PROC MIXED DATA=HW2.DATHW2clean noclprint covtest noitprint method=reml;
CLASS school_ID meducation ChildRace FamilyStructure HouseIncome pHealth  ExerciseFreeTime;
MODEL bmipct = meducation ChildRace FamilyStructure HouseIncome pHealth  ExerciseFreeTime TV/ solution ddfm = bw;
RANDOM intercept / subject=school_ID TYPE=UN;
RUN; *-2loglikelihood: 125772.8;

DATA pvalue;
	DF = 7; CHISQ = 151837.0 - 125772.8;
	PVALUE = 1 - PROBCHI(CHISQ, DF);
RUN;

/* 02 Random Intercept model with level 1 variables - delete insignificant: FamilyStructure ExerciseFreeTime*/
PROC MIXED DATA=HW2.DATHW2clean noclprint covtest noitprint method=reml;
CLASS school_ID meducation ChildRace HouseIncome pHealth;
MODEL bmipct = meducation ChildRace HouseIncome pHealth TV/ solution ddfm = bw;
RANDOM intercept / subject=school_ID TYPE=UN;
RUN; *-2loglikelihood: 126244.7;

DATA pvalue;
	DF = 2; CHISQ = 126244.7 - 125772.8;
	PVALUE = 1 - PROBCHI(CHISQ, DF);
RUN;





/******************************************/
/************RANDOM INTERCEPT 02***********/
/******************************************/

/* 12 Random Intercept with both level variables*/
PROC MIXED DATA=HW2.DATHW2clean noclprint covtest noitprint method=reml;
CLASS school_ID meducation ChildRace HouseIncome pHealth Region Urban Schooltype;
MODEL bmipct = meducation ChildRace HouseIncome pHealth TV Region Urban Schooltype PctMinority/ solution ddfm = bw;
RANDOM intercept/ subject=school_ID TYPE=UN;
RUN; *-2loglikelihood: 123079.8;

DATA pvalue;
	DF = 4; CHISQ = 126244.7 - 123079.8;
	PVALUE = 1 - PROBCHI(CHISQ, DF);
RUN;

/* 12.5 Random Intercept with both level variables - delete Schooltype*/
PROC MIXED DATA=HW2.DATHW2clean noclprint covtest noitprint method=reml;
CLASS school_ID meducation ChildRace HouseIncome pHealth Region Urban;
MODEL bmipct = meducation ChildRace HouseIncome pHealth TV Region Urban PctMinority/ solution ddfm = bw;
RANDOM intercept/ subject=school_ID TYPE=UN;
RUN; *-2loglikelihood: 	123083.9;

DATA pvalue;
	DF = 1; CHISQ = 126244.7 - 123083.9;
	PVALUE = 1 - PROBCHI(CHISQ, DF);
RUN;





/***********************************/
/************RANDOM SLOPE***********/
/***********************************/

/* convert string to numeric*/
DATA HW2.DATHW2RSLOPE;
SET HW2.DATHW2clean;
IF ChildRace='White' THEN ChildRace=1;
IF ChildRace='Black' THEN ChildRace=2;
IF ChildRace='Other' THEN ChildRace=3;
IF HouseIncome='Low' THEN HouseIncome=1;
IF HouseIncome='Middle' THEN HouseIncome=2;
IF HouseIncome='High' THEN HouseIncome=3;
IF meducation='1=<high school' THEN meducation=1;
IF meducation='2=high school' THEN meducation=2;
IF meducation='3>=college' THEN meducation=3;
IF pHealth='1=poor or fair' THEN pHealth=1;
IF pHealth='2=good' THEN pHealth=2;
IF pHealth='3=Very good/excellen' THEN pHealth=3;
*if nmiss(of _numeric_) > 0 then delete;
RUN;

DATA HW2.DATHW2RSLOPE;
SET HW2.DATHW2RSLOPE;
ChildRace1 = INPUT(ChildRace, 20.);
HouseIncome1 = INPUT(HouseIncome, 20.);
meducation1 = INPUT(meducation, 20.);
pHealth1 = INPUT(pHealth, 20.);
RUN;

/* 21 Random Intercept and random slope model - add meducation*/
PROC MIXED DATA=HW2.DATHW2RSLOPE noclprint covtest noitprint method=reml;
CLASS school_ID ChildRace HouseIncome pHealth Region Urban;
MODEL bmipct = meducation1 ChildRace HouseIncome pHealth TV Region Urban PctMinority/ solution ddfm = bw;
RANDOM intercept meducation1/ subject=school_ID TYPE=UN;
RUN; *UN(2, 2) NOT SIGNIFICANT;


/* 22 Random Intercept and random slope model - add ChildRace*/
PROC MIXED DATA=HW2.DATHW2RSLOPE noclprint covtest noitprint method=reml;
CLASS school_ID meducation HouseIncome pHealth Region Urban;
MODEL bmipct = meducation ChildRace1 HouseIncome pHealth TV Region Urban PctMinority/ solution ddfm = bw;
RANDOM intercept ChildRace1/ subject=school_ID TYPE=UN;
RUN; *Estimated G matrix is not positive definite;


/* 23 Random Intercept and random slope model - add HouseIncome*/
PROC MIXED DATA=HW2.DATHW2RSLOPE noclprint covtest noitprint method=reml;
CLASS school_ID meducation ChildRace pHealth Region Urban;
MODEL bmipct = meducation ChildRace HouseIncome1 pHealth TV Region Urban PctMinority/ solution ddfm = bw;
RANDOM intercept HouseIncome1/ subject=school_ID TYPE=UN;
RUN; *-2loglikelihood: 	123079.6, this one works!; 

DATA pvalue;
	DF = 1; CHISQ = 123083.9 - 123079.6;
	PVALUE = 1 - PROBCHI(CHISQ, DF);
RUN;

/* 24 Random Intercept and random slope model - add pHealth*/
PROC MIXED DATA=HW2.DATHW2RSLOPE noclprint covtest noitprint method=reml;
CLASS school_ID meducation ChildRace HouseIncome Region Urban pHealth;
MODEL bmipct = meducation ChildRace HouseIncome pHealth1 TV Region Urban PctMinority/ solution ddfm = bw;
RANDOM intercept pHealth1/ subject=school_ID TYPE=UN;
RUN; *Estimated G matrix is not positive definite.;

/* 25 Random Intercept and random slope model - add pHealth*/
PROC MIXED DATA=HW2.DATHW2RSLOPE noclprint covtest noitprint method=reml;
CLASS school_ID meducation ChildRace HouseIncome pHealth Region Urban;
MODEL bmipct = meducation ChildRace HouseIncome pHealth TV Region Urban PctMinority/ solution ddfm = bw;
RANDOM intercept TV/ subject=school_ID TYPE=UN;
RUN; *Model NOT Working;






/***********************************************/
/************CROSS-LEVEL INTERACTION ***********/
/***********************************************/

/* 31 cross level interaction - add pHealth*/
PROC MIXED DATA=HW2.DATHW2RSLOPE noclprint covtest noitprint method=reml;
CLASS school_ID meducation ChildRace pHealth Region Urban;
MODEL bmipct = meducation ChildRace pHealth TV HouseIncome1|Region HouseIncome1|Urban HouseIncome1|PctMinority/ solution ddfm = bw;
RANDOM intercept HouseIncome1/ subject=school_ID TYPE=UN;
RUN; *-2loglikelihood: 123080.1;

DATA pvalue;
	DF = 3; CHISQ = 123083.9 - 123080.1;
	PVALUE = 1 - PROBCHI(CHISQ, DF);
RUN;


/* Final model*/
PROC MIXED DATA=HW2.DATHW2RSLOPE noclprint covtest noitprint method=reml;
CLASS school_ID meducation ChildRace pHealth Region Urban;
MODEL bmipct = meducation ChildRace HouseIncome1 pHealth TV Region Urban PctMinority/ solution ddfm = bw;
RANDOM intercept HouseIncome1/ subject=school_ID TYPE=UN G V;
RUN; *-2loglikelihood: 	123079.6, this one works!; 



