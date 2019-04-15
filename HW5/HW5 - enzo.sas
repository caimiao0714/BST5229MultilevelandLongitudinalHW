/*Step 1: The Intercept-Only Model*/
proc mixed data = MLA.HW5 noclprint method=ml covtest noitprint;
  class ID Parent_ID;
  model logGSI = / solution ddfm=bw ;
  random intercept / subject=Parent_ID type=un; 
  random intercept / subject=ID(Parent_ID) type=un; 
run;

/*Step 2: Adding Time-dependent Variable*/
proc mixed data=MLA.HW5 noclprint method=ml covtest noitprint;
  class ID Parent_ID season Parent_died Parent_drug_status;
  model logGSI = True_month Season Parent_died 
  Parent_drug_status Parent_alcohol Parent_marijuana/ solution  ddfm=bw ;
  random intercept / subject=Parent_ID type=un; 
  random intercept / subject=ID(Parent_ID) type=un; 
run;

/*Step 3: Testing Random Slope for Signifciant Variables in Step 2 */
proc mixed data=MLA.HW5 noclprint method=ml covtest noitprint;
  class ID Parent_ID season Parent_died Parent_drug_status;
  model logGSI = Season Parent_died Parent_drug_status / solution  ddfm=bw ;
  random intercept / subject=Parent_ID type=un; 
  random intercept Season Parent_died Parent_drug_status / subject=ID(Parent_ID); 
run;

/*Step 4: Adding Level-2 Variables*/
proc mixed data=MLA.HW5 noclprint method=ml covtest noitprint;
  class ID Parent_ID season Parent_died Parent_drug_status Gender Hispanic;
  model logGSI = Season Parent_died Parent_drug_status Gender Hispanic/ solution  ddfm=bw ;
  random intercept / subject=Parent_ID type=un; 
  random intercept / subject=ID(Parent_ID) type=un; 
run;

/*Step 5: Adding Level-3 Variables*/
proc mixed data=MLA.HW5 noclprint method=ml covtest noitprint;
  class ID Parent_ID season Parent_died Parent_drug_status Gender
  Parent_gender Parent_diagnosis;
  model logGSI = Season Parent_died Parent_drug_status Gender 
  Parent_base_age Parent_gender Parent_diagnosis Treatment/ solution  ddfm=bw ;
  random intercept / subject=Parent_ID type=un; 
  random intercept / subject=ID(Parent_ID) type=un; 
run;

/*Step 6: Testing the Interaction Between Season and Gender*/
proc mixed data=MLA.HW5 noclprint method=ml covtest noitprint;
  class ID Parent_ID season Parent_died Parent_drug_status Gender
  Parent_gender Parent_diagnosis;
  model logGSI = Season|Gender Parent_died Parent_drug_status Parent_diagnosis/ solution  ddfm=bw;
  random intercept / subject=Parent_ID type=un; 
  random intercept / subject=ID(Parent_ID) type=un; 
run;

/*Step 6: Testing the Interaction Between Parent_died and Gender*/
proc mixed data=MLA.HW5 noclprint method=ml covtest noitprint;
  class ID Parent_ID season Parent_died Parent_drug_status Gender
  Parent_gender Parent_diagnosis;
  model logGSI = Season Parent_died|Gender Parent_drug_status Parent_diagnosis/ solution  ddfm=bw;
  random intercept / subject=Parent_ID type=un; 
  random intercept / subject=ID(Parent_ID) type=un; 
run;

/*Step 6: Testing the Interaction Between Parent_drug_status and Gender*/
proc mixed data=MLA.HW5 noclprint method=ml covtest noitprint;
  class ID Parent_ID season Parent_died Parent_drug_status Gender
  Parent_gender Parent_diagnosis;
  model logGSI = Season Parent_died Parent_drug_status|Gender Parent_diagnosis/ solution  ddfm=bw;
  random intercept / subject=Parent_ID type=un; 
  random intercept / subject=ID(Parent_ID) type=un; 
run;
