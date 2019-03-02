LIBNAME HW3 '/folders/myfolders/BST5220 Multilevel and Longitudinal Analysis/HW3';
RUN;

/*******************/
/* Recode variable */
DATA HW3.DATHW2clean;
KEEP school_ID bmipct 
	meducation ChildRace FamilyStructure HouseIncome pHealth  ExerciseFreeTime TV
	region urban schooltype PctMinority PCTFreeLunch;
SET HW3.DataForHW2;
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

/**********  Q1  **********/
/* Q1.1 Exchangeable correlation matrix */
proc genmod data = HW3.DATHW2clean; 
  class school_ID meducation ChildRace FamilyStructure HouseIncome pHealth  ExerciseFreeTime  
  Region Urban Schooltype PctMinority;
  model bmipct = meducation ChildRace FamilyStructure HouseIncome pHealth  ExerciseFreeTime TV  
  Region Urban Schooltype PctMinority /type3 dist=normal;
  repeated subject = school_ID/type=exch corrw ;
run; 
/* Q1.2 Exchangeable correlation matrix */
proc genmod data = HW3.DATHW2clean; 
  class school_ID meducation ChildRace FamilyStructure HouseIncome pHealth  ExerciseFreeTime  
  Region Urban Schooltype PctMinority;
  model bmipct = meducation ChildRace FamilyStructure HouseIncome pHealth  ExerciseFreeTime TV  
  Region Urban Schooltype PctMinority /type3 dist=normal;
  repeated subject = school_ID/type=toep corrw ;
run; 



/********** Q2 **********/
/* Q2.1 Exchangeable correlation matrix */
proc genmod data = HW3.DATHW2clean; 
  class school_ID meducation ChildRace FamilyStructure HouseIncome pHealth  ExerciseFreeTime  
  Region Urban Schooltype PctMinority;
  model bmipct = meducation ChildRace FamilyStructure HouseIncome pHealth  ExerciseFreeTime TV  
  Region Urban Schooltype PctMinority /type3 dist=normal;
  repeated subject = school_ID/type=exch corrw;
run; 
/* Q2.2 single-level analysis */
proc glm data=HW3.DATHW2clean;
 class school_ID meducation ChildRace FamilyStructure HouseIncome pHealth  ExerciseFreeTime  
  Region Urban Schooltype PctMinority;
 model bmipct = meducation ChildRace FamilyStructure HouseIncome pHealth  ExerciseFreeTime TV  
  Region Urban Schooltype PctMinority/solution;
run;



/********** Q3 **********/
/* Q3.1 Exchangeable correlation matrix */
proc genmod data = HW3.DATHW2clean; 
  class school_ID meducation ChildRace FamilyStructure HouseIncome pHealth  ExerciseFreeTime  
  Region Urban Schooltype PctMinority;
  model bmipct = meducation ChildRace FamilyStructure HouseIncome pHealth  ExerciseFreeTime TV  
  Region Urban Schooltype PctMinority /type3 dist=normal;
  repeated subject = school_ID/type=exch corrw;
run; 
/* Q3.2 remove FamilyStructure */
proc genmod data = HW3.DATHW2clean; 
  class school_ID meducation ChildRace HouseIncome pHealth  ExerciseFreeTime  
  Region Urban Schooltype PctMinority;
  model bmipct = meducation ChildRace HouseIncome pHealth  ExerciseFreeTime TV  
  Region Urban Schooltype PctMinority /type3 dist=normal;
  repeated subject = school_ID/type=exch corrw;
run; 
/* Q3.3 remove schooltype */
proc genmod data = HW3.DATHW2clean; 
  class school_ID meducation ChildRace HouseIncome pHealth  ExerciseFreeTime  
  Region Urban PctMinority;
  model bmipct = meducation ChildRace HouseIncome pHealth  ExerciseFreeTime TV  
  Region Urban PctMinority /type3 dist=normal;
  repeated subject = school_ID/type=exch corrw;
run; 
/* Q3.4 remove schooltype */
/* BEST FIT MODEL ! */
proc genmod data = HW3.DATHW2clean; 
  class school_ID ChildRace HouseIncome pHealth  ExerciseFreeTime  
  Region Urban PctMinority;
  model bmipct = ChildRace HouseIncome pHealth  ExerciseFreeTime TV  
  Region Urban PctMinority /type3 dist=normal;
  repeated subject = school_ID/type=exch corrw;
run; 
/* Q3.5 remove ExerciseFreeTime */
proc genmod data = HW3.DATHW2clean; 
  class school_ID ChildRace HouseIncome pHealth  
  Region Urban PctMinority;
  model bmipct = ChildRace HouseIncome pHealth  TV  
  Region Urban PctMinority /type3 dist=normal;
  repeated subject = school_ID/type=exch corrw;
run; 


















































































































































































































