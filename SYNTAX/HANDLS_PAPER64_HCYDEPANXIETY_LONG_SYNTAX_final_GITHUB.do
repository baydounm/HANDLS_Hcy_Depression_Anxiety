capture log using "E:\HANDLS_PAPER64_HCYDEPANXIETY_LONG\OUTPUT\DATA_MANAGEMENT1.smcl", replace

cd "E:\HANDLS_PAPER64_HCYDEPANXIETY_LONG\DATA"



//STEP 0: CREATE ANXIETY SCORE LONGITUDINAL AND CHECK ALL VARIABLES IN THE WAVES 1, 3 AND 4 DATASETS//

use 2023-09-28_anx,clear
capture rename HNDID HNDID
capture rename HNDWAVE HNDwave
save, replace


capture drop ga0* ga10* anxd*
decode PDSQga01, generate(ga01)
decode PDSQga02, generate(ga02)
decode PDSQga03, generate(ga03)
decode PDSQga04, generate(ga04)
decode PDSQga05, generate(ga05)
decode PDSQga06, generate(ga06)
decode PDSQga07, generate(ga07)
decode PDSQga08, generate(ga08)
decode PDSQga09, generate(ga09)
decode PDSQga10, generate(ga10)
decode AnxietyDisorder, generate(anxd)


replace ga01 = "0" if ga01 == "No"
replace ga01 = "1" if ga01 == "Yes" 

replace ga02 = "0" if ga02 == "No"
replace ga02 = "1" if ga02 == "Yes" 

replace ga03 = "0" if ga03 == "No"
replace ga03 = "1" if ga03 == "Yes" 

replace ga04 = "0" if ga04 == "No"
replace ga04 = "1" if ga04 == "Yes" 

replace ga05 = "0" if ga05 == "No"
replace ga05 = "1" if ga05 == "Yes" 

replace ga06 = "0" if ga06 == "No"
replace ga06 = "1" if ga06 == "Yes"

replace ga07 = "0" if ga07 == "No"
replace ga07 = "1" if ga07 == "Yes" 

replace ga08 = "0" if ga08 == "No"
replace ga08 = "1" if ga08 == "Yes" 

replace ga09 = "0" if ga09 == "No"
replace ga09 = "1" if ga09 == "Yes" 

replace ga10 = "0" if ga10 == "No"
replace ga10 = "1" if ga10 == "Yes" 

replace anxd = "0" if anxd == "No"
replace anxd = "1" if anxd == "Yes" 


encode ga01, generate(ga01_n)
encode ga02, generate(ga02_n)
encode ga03, generate(ga03_n)
encode ga04, generate(ga04_n)
encode ga05, generate(ga05_n)
encode ga06, generate(ga06_n)
encode ga07, generate(ga07_n)
encode ga08, generate(ga08_n)
encode ga09, generate(ga09_n)
encode ga10, generate(ga10_n)
encode anxd, generate(anxd_n)

capture drop ANXIETY
gen ANXIETY=ga01_n+ga02_n+ga03_n+ga04_n+ga05_n+ga06_n+ga07_n+ga08_n+ga09_n+ga10_n
replace ANXIETY=ANXIETY


save, replace

**********
use 2023-09-28_anx,clear
keep if HNDwave==1
save 2023-09-28_anx_wave1, replace
capture rename HNDID HNDID
save, replace


use 2023-09-28_anx,clear
keep if HNDwave==3
capture rename HNDID HNDID
save 2023-09-28_anx_wave3, replace


use 2023-09-28_anx,clear
keep if HNDwave==4
capture rename HNDID HNDID
save 2023-09-28_anx_wave4, replace

use 2023-09-28_anx_wave1,clear


describe
su



use 2023-09-28_anx_wave3,clear

describe
su


use 2023-09-28_anx_wave4,clear

describe
su




//STEP 1: CREATE WAVE 1 DEMOGRAPHIC VARIABLES//

use 2023-09-28_anx_wave1,clear

keep HNDID HNDwave Race PovStat Sex Age 
capture rename HNDID HNDID
sort HNDID

save DEMOw1, replace

addstub Race PovStat Sex Age, stub(w1)

save, replace


//STEP 2: CREATE DEPRESSIVE SYMPTOMS DATA AT WAVES 1, 3 AND 4, LONG//

*****DEPRESSIVE SYMPTOMS AND ANXIETY DATA AT WAVE 1**

use 2023-09-28_anx_wave1,clear
capture rename HNDID HNDID

keep HNDID HNDwave CES* PDSQ* ANXIETY AnxietyDisorder HCys
sort HNDID

save DEPRESSIVE_SYMPTOMS_wave1long, replace


*****DEPRESSIVE SYMPTOMS AND ANXIETY DATA AT WAVE 3**


use 2023-09-28_anx_wave3,clear
capture rename HNDID HNDID


keep HNDID HNDwave CES* PDSQ* ANXIETY AnxietyDisorder HCys
sort HNDID

save DEPRESSIVE_SYMPTOMS_wave3long, replace


*****DEPRESSIVE SYMPTOMS AND ANXIETY DATA AT WAVE 4**


use 2023-09-28_anx_wave4,clear
capture rename HNDID HNDID


keep HNDID HNDwave CES* PDSQ* ANXIETY AnxietyDisorder HCys
sort HNDID

save DEPRESSIVE_SYMPTOMS_wave4long, replace




//STEP 3: CREATE WAVE 1, 3 and 4 DEPRESSIVE SYMPTOMS DATA, WIDE//


*****DEPRESSIVE SYMPTOMS AND ANXIETY DATA AT WAVE 1**

use DEPRESSIVE_SYMPTOMS_wave1long, clear

keep HNDID CES* PDSQ* ANXIETY AnxietyDisorder

addstub CES* PDSQ* ANXIETY AnxietyDisorder, stub(w1)

save DEPRESSIVE_SYMPTOMSwave1wide, replace



*****DEPRESSIVE SYMPTOMS AND ANXIETY DATA AT WAVE 3**

use DEPRESSIVE_SYMPTOMS_wave3long, clear

keep HNDID CES* PDSQ* ANXIETY AnxietyDisorder

addstub CES* PDSQ* ANXIETY AnxietyDisorder, stub(w3)

save DEPRESSIVE_SYMPTOMSwave3wide, replace


*****DEPRESSIVE SYMPTOMS AND ANXIETY DATA AT WAVE 4**

use DEPRESSIVE_SYMPTOMS_wave4long, clear

keep HNDID CES* PDSQ* ANXIETY AnxietyDisorder

addstub CES* PDSQ* ANXIETY AnxietyDisorder, stub(w4)

save DEPRESSIVE_SYMPTOMSwave4wide, replace



//STEP 4: MERGE AGEw1 with DEP AND ANXIETY DATA AT WAVE 1//

use 2023-09-28_anx_wave1,clear
capture rename HNDID HNDID

keep HNDID Age
sort HNDID

save Agew1, replace
capture rename Age w1Age
save, replace

use DEPRESSIVE_SYMPTOMS_wave1long,clear
merge HNDID using Agew1

save DEPRESSIVE_SYMPTOMS_wave1longAgew1, replace



//STEP 5: MERGE AGEw3 with DEP AND ANXIETY DATA AT WAVE 3//


use 2023-09-28_anx_wave3,clear
capture rename HNDID HNDID

keep HNDID Age
sort HNDID

save Agew3, replace
capture rename Age w3Age
save, replace

use DEPRESSIVE_SYMPTOMS_wave3long,clear
merge HNDID using Agew3

save DEPRESSIVE_SYMPTOMS_wave3longAgew3, replace



//STEP 6: MERGE AGEw4 with DEP AND ANXIETY DATA AT WAVE 4//


use 2023-09-28_anx_wave4,clear
capture rename HNDID HNDID

keep HNDID Age
sort HNDID

save Agew4, replace
capture rename Age w4Age
save, replace

use DEPRESSIVE_SYMPTOMS_wave4long,clear
merge HNDID using Agew4

save DEPRESSIVE_SYMPTOMS_wave4longAgew4, replace



//STEP 7: APPEND LONG DEPRESSIVE SYMPTOMS DATA MERGED WITH AGE VARIABLES//

use DEPRESSIVE_SYMPTOMS_wave1longAgew1, clear

capture drop _merge

save, replace


use DEPRESSIVE_SYMPTOMS_wave3longAgew3, clear

capture drop _merge

save, replace



use DEPRESSIVE_SYMPTOMS_wave4longAgew4, clear

capture drop _merge

save, replace


use DEPRESSIVE_SYMPTOMS_wave1longAgew1, clear
append using DEPRESSIVE_SYMPTOMS_wave3longAgew3
append using DEPRESSIVE_SYMPTOMS_wave4longAgew4


save DEPRESSIVE_SYMPTOMS_waves134_append, replace




keep HNDID HNDwave CES* PDSQ* HCys

save DEPRESSIVE_SYMPTOMS_waves134_appendsmall, replace


//STEP 8: APPEND THE DEPRESSIVE SYMPTOMS (LONG) WITH DEMO AT WAVE 1: CALL THIS LAYER HNDWAVE==0//

use DEMOw1, clear
recode HNDwave 1=0

save, replace

append using DEPRESSIVE_SYMPTOMS_waves134_appendsmall

save DEPRESSIVE_SYMPTOMS_waves134_appendsmallDEMOw1long, replace

sort HNDID

save, replace

use DEMOw1, clear
sort HNDID
capture drop HNDwave
save DEMOw1wide, replace

use DEPRESSIVE_SYMPTOMS_waves134_appendsmallDEMOw1long,clear
capture drop w1Sex w1Race w1PovStat w1Age 

merge HNDID using DEMOw1wide
save, replace

//STEP 9: MERGE WAVE 1 DEP, WIDE WITH THE APPENDED DATA//
use  DEPRESSIVE_SYMPTOMS_waves134_appendsmallDEMOw1long,clear
capture drop _merge
sort HNDID
save, replace

use DEPRESSIVE_SYMPTOMSwave1wide,clear
sort HNDID
save, replace

use  DEPRESSIVE_SYMPTOMS_waves134_appendsmallDEMOw1long,clear
merge HNDID using DEPRESSIVE_SYMPTOMSwave1wide

tab _merge
capture drop _merge

save DEPRESSIVE_SYMPTOMS_DEMO_WIDEW1_APPENDED, replace



//STEP 9: MERGE WAVE 3 DEP, WIDE WITH THE APPENDED DATA//
use  DEPRESSIVE_SYMPTOMS_DEMO_WIDEW1_APPENDED,clear
capture drop _merge
sort HNDID
save, replace

use DEPRESSIVE_SYMPTOMSwave3wide,clear
sort HNDID
save, replace

use  DEPRESSIVE_SYMPTOMS_DEMO_WIDEW1_APPENDED,clear
merge HNDID using DEPRESSIVE_SYMPTOMSwave3wide

tab _merge
capture drop _merge

save DEPRESSIVE_SYMPTOMS_DEMO_WIDEW1W3_APPENDED, replace


//STEP 10: MERGE WAVE 4 DEP, WIDE WITH THE APPENDED DATA//
use  DEPRESSIVE_SYMPTOMS_DEMO_WIDEW1W3_APPENDED,clear
capture drop _merge
sort HNDID
save, replace

use DEPRESSIVE_SYMPTOMSwave4wide,clear
sort HNDID
save, replace

use  DEPRESSIVE_SYMPTOMS_DEMO_WIDEW1W3_APPENDED,clear
merge HNDID using DEPRESSIVE_SYMPTOMSwave4wide

tab _merge
capture drop _merge

save DEPRESSIVE_SYMPTOMS_DEMO_WIDEW1W3W4_APPENDED, replace


//STEP 11: MERGE THIS FILE WITH WAVE 3 AGE//
use 2023-09-28_anx_wave3,clear

describe
su


keep HNDID Age
save Agew3, replace
capture rename Age w3Age
capture rename HNDID HNDID
sort HNDID
save, replace

use DEPRESSIVE_SYMPTOMS_DEMO_WIDEW1W3W4_APPENDED,clear
sort HNDID
capture drop _merge
save, replace

merge HNDID using Agew3
save, replace

//STEP 12: MERGE THIS FILE WITH WAVE 4 AGE//
use 2023-09-28_anx_wave3,clear

describe
su


keep HNDID Age
save Agew3, replace
capture rename Age w4Age
capture rename HNDID HNDID
sort HNDID
save, replace

use DEPRESSIVE_SYMPTOMS_DEMO_WIDEW1W3W4_APPENDED,clear
sort HNDID
capture drop _merge
save, replace

merge HNDID using Agew4
save, replace




//STEP 12: CREATE THE TIME VARIABLE BETWEEN WAVES 1, 3 and 4//

use DEPRESSIVE_SYMPTOMS_DEMO_WIDEW1W3W4_APPENDED,clear

capture drop timew1w3w4
gen timew1w3w4=.
replace timew1w3w4=0 if HNDwave==1
replace timew1w3w4=w3Age-w1Age if HNDwave==3
replace timew1w3w4=w4Age-w1Age if HNDwave==4

su timew1w3w4 if HNDwave==4

save, replace

****************************************************************************************
//STEP 13A: CREATE THE EXPOSURE VARIABLES AT WAVE 1//
use 2023-09-28_anx_wave1,clear

describe
su


keep HNDID HCys


addstub HCys, stub(w1)

save HOMOCYSTEINE_EXPOSURES_W1,replace

            
//STEP 13B: CREATE THE EXPOSURE VARIABLES AT WAVE 3//

use 2023-09-28_anx_wave3,clear

describe
su


keep HNDID HCys


addstub HCys, stub(w3)

save HOMOCYSTEINE_EXPOSURES_W3,replace

            
//STEP 13C: CREATE THE EXPOSURE VARIABLES AT WAVE 4//

use 2023-09-28_anx_wave4,clear

describe
su


keep HNDID HCys


addstub HCys, stub(w4)

save HOMOCYSTEINE_EXPOSURES_W4,replace


//STEP 13D: MERGE WAVES, 1, 3 AND 4 EXPOSURES WITH FINAL FILE///

use DEPRESSIVE_SYMPTOMS_DEMO_WIDEW1W3W4_APPENDED,clear
capture drop _merge
sort HNDID

save HANDLS_PAPER64_HCYDEPANXIETY_LONG, replace


use HOMOCYSTEINE_EXPOSURES_W1,clear
sort HNDID
capture drop _merge
save HOMOCYSTEINE_EXPOSURES_W1, replace


use HOMOCYSTEINE_EXPOSURES_W3,clear
sort HNDID
capture drop _merge
save HOMOCYSTEINE_EXPOSURES_W3, replace


use HOMOCYSTEINE_EXPOSURES_W4,clear
sort HNDID
capture drop _merge
save HOMOCYSTEINE_EXPOSURES_W4, replace

use HANDLS_PAPER64_HCYDEPANXIETY_LONG
merge HNDID using HOMOCYSTEINE_EXPOSURES_W1
tab _merge
capture drop _merge
sort HNDID
merge HNDID using HOMOCYSTEINE_EXPOSURES_W3
tab _merge
capture drop _merge
sort HNDID
merge HNDID using HOMOCYSTEINE_EXPOSURES_W4
tab _merge
capture drop _merge
sort HNDID

save HANDLS_PAPER64_HCYDEPANXIETY_LONG, replace


*********************************************************************************************************


//STEP 13: CREATE ALL OTHER COVARIATE VARIABLES AT WAVES 1 //

*************************WAVE 1 VARIABLES************************

use 2023-09-28_anx_wave1,clear
capture rename HNDID HNDID
save, replace


///DEMOGRAPHICS//

keep HNDID Race PovStat Sex 
save DEMOGRAPHICS_wave1, replace
sort HNDID
save, replace

use HANDLS_PAPER64_HCYDEPANXIETY_LONG, clear
sort HNDID
capture drop _merge
save, replace


merge HNDID using DEMOGRAPHICS_wave1

save, replace


// EDUCATION//
use 2023-09-28_anx_wave1,clear
capture rename HNDID HNDID
save, replace


keep HNDID Education
capture rename Education w1Education
save Educationw1, replace
sort HNDID
save,replace

use HANDLS_PAPER64_HCYDEPANXIETY_LONG,clear
sort HNDID
capture drop _merge
save, replace

merge HNDID using Educationw1
save, replace

tab w1Education if HNDwave==1

capture drop w1edubr
gen w1edubr=.
replace w1edubr=1 if w1Education>=1 & w1Education<=8
replace w1edubr=2 if w1Education>=9 & w1Education<=12
replace w1edubr=3 if w1Education>=13 & w1Education~=.

tab w1edubr if HNDwave==1
tab w1edubr w1Education

save, replace


//LIFESTYLE FACTORS: SMOKING AND DRUG USE: CigaretteStatus //

use 2023-09-28_anx_wave1,clear
capture rename HNDID HNDID
save, replace


keep HNDID CigaretteStatus MarijCurr CokeCurr OpiateCurr
addstub CigaretteStatus MarijCurr CokeCurr OpiateCurr,stub(w1)
sort HNDID
save Smoke_drugsw1,replace


**Current smoking status**

tab  w1CigaretteStatus
su w1CigaretteStatus

capture drop w1smoke
gen w1smoke=.
replace w1smoke=1 if w1CigaretteStatus==4 
replace w1smoke=0 if w1CigaretteStatus~=4 & w1CigaretteStatus~=.
replace w1smoke=9 if w1smoke==.

tab1 w1smoke w1CigaretteStatus w1MarijCurr w1CokeCurr w1OpiateCurr

capture drop w1smoke1 w1smoke9
gen w1smoke1=1 if w1smoke==1
replace w1smoke1=0 if w1smoke~=1

gen w1smoke9=1 if w1smoke==9
replace w1smoke9=0 if w1smoke~=9

sort HNDID

save, replace


**Current drug use**

tab1 w1MarijCurr w1CokeCurr w1OpiateCurr

capture drop w1currdrugs
gen w1currdrugs=.
replace w1currdrugs=1 if w1MarijCurr==1 | w1CokeCurr==1 | w1OpiateCurr==1
replace w1currdrugs=0 if w1currdrugs~=1 & w1MarijCurr~=. & w1CokeCurr~=. & w1OpiateCurr~=.
replace w1currdrugs=9 if w1currdrugs==.

tab w1currdrugs

tab w1currdrugs w1MarijCurr
tab w1currdrugs w1CokeCurr
tab w1currdrugs w1OpiateCurr

save, replace


use HANDLS_PAPER64_HCYDEPANXIETY_LONG,clear
sort HNDID
capture drop _merge
save, replace

merge HNDID using Smoke_drugsw1
save, replace




//CES-D, BMI, SELF-RATED HEALTH AND CO-MORBIND CONDITIONS//

use 2023-09-28_anx_wave1,clear
capture rename HNDID HNDID
save, replace


keep HNDID BMI SF01 dxHTN dxDiabetes CVhighChol CVaFib CVangina CVcad CVchf CVmi 

addstub SF01-dxDiabetes,stub(w1)

save HEALTH_w1, replace

tab w1SF01


capture drop w1SRH
gen w1SRH=.
replace w1SRH=1 if w1SF01==1 | w1SF01==2
replace w1SRH=2 if w1SF01==3
replace w1SRH=3 if w1SF01==4 | w1SF01==5


tab w1SRH

save, replace

su w1dxHTN w1dxDiabetes

tab1 w1dxHTN w1dxDiabetes


tab1 w1CVhighChol 

save, replace

tab1  w1CVaFib w1CVangina w1CVcad w1CVchf w1CVmi

capture drop w1cvdbr
gen w1cvdbr=.
replace w1cvdbr=1 if w1CVaFib==2 | w1CVangina==2 | w1CVcad==2 | w1CVchf==2 | w1CVmi==2
replace w1cvdbr=0 if w1cvdbr~=1 & w1CVaFib~=. & w1CVangina~=. & w1CVcad~=. & w1CVchf~=. & w1CVmi~=.


tab w1cvdbr


sort HNDID
save, replace



use HANDLS_PAPER64_HCYDEPANXIETY_LONG,clear
sort HNDID
capture drop _merge
save, replace



merge HNDID using HEALTH_w1
save, replace


//HEI, Wave 1://


use 2023-09-28_anx_wave1,clear
capture rename HNDID HNDID
save, replace


keep HNDID hei2010_total_score
addstub hei2010_total_score,stub(w1)
sort HNDID
save Otherdietarysw1,replace


su w1hei2010_total_score
histogram w1hei2010_total_score


use HANDLS_PAPER64_HCYDEPANXIETY_LONG,clear
sort HNDID
capture drop _merge
save, replace


merge HNDID using Otherdietarysw1
save, replace


//ANXIETY VARIABLES, WAVE 1//


use 2023-09-28_anx_wave1,clear
capture rename HNDID HNDID
save, replace

capture drop ANXIETY_ORD
gen ANXIETY_ORD=ANXIETY-10

save, replace



keep HNDID ANXIETY* AnxietyDisorder ga* anxd
addstub ANXIETY* AnxietyDisorder ga* anxd,stub(w1)
sort HNDID
save ANXIETYw1,replace

use HANDLS_PAPER64_HCYDEPANXIETY_LONG,clear
sort HNDID
capture drop _merge
save, replace


merge HNDID using ANXIETYw1
save, replace


//STEP 14: CREATE DEPRESSIVE SYMPTOMS SELECTION VARIABLES//


use HANDLS_PAPER64_HCYDEPANXIETY_LONG,clear
sort HNDID
capture drop _merge
save, replace

capture drop sample_CES=.
gen sample_CES=1 if w1CES~=. | w3CES~=. | w4CES~=.
replace sample_CES=0 if sample_CES~=1

tab sample_CES if HNDwave==1

save, replace




//STEP 15A: RENAME FIXED COVARIATES///


use HANDLS_PAPER64_HCYDEPANXIETY_LONG,clear
sort HNDID
capture drop _merge
save, replace

capture rename w1Sex Sex
capture rename w1Race Race
capture rename w1PovStat PovStat

save, replace



//STEP 15B: CREATE EMPIRICAL BAYES ESTIMATORS FOR CES-D TOTAL SCORE AND DOMAINS ANNUALIZED RATE OF CHANGE: //

use HANDLS_PAPER64_HCYDEPANXIETY_LONG,clear


**CES**

xtmixed CES timew1w3w4 ||HNDID: timew1w3w4, cov(un)


capture drop e_consCES e_TIMECES
predict  e_TIMECES e_consCES, reffects level(HNDID)

estat ic

capture drop bayes1CES
gen bayes1CES= -.1279407  +e_TIMECES


su bayes1CES  


su bayes1CES if HNDwave==1,det
su bayes1CES if HNDwave==3,det


histogram bayes1CES if HNDwave==1



**CES_DA**

xtmixed CES_DA timew1w3w4 ||HNDID: timew1w3w4, cov(un)


capture drop e_consCES_DA e_TIMECES_DA
predict  e_TIMECES_DA e_consCES_DA, reffects level(HNDID)

estat ic

capture drop bayes1CES_DA
gen bayes1CES_DA= -.075786  +e_TIMECES_DA


su bayes1CES_DA  


su bayes1CES_DA if HNDwave==1,det
su bayes1CES_DA if HNDwave==3,det


histogram bayes1CES_DA if HNDwave==1



**CES_SC**

xtmixed CES_SC timew1w3w4 ||HNDID: timew1w3w4, cov(un)


capture drop e_consCES_SC e_TIMECES_SC
predict  e_TIMECES_SC e_consCES_SC, reffects level(HNDID)

estat ic

capture drop bayes1CES_SC
gen bayes1CES_SC= -.0806016 +e_TIMECES_SC


su bayes1CES_SC  


su bayes1CES_SC if HNDwave==1,det
su bayes1CES_SC if HNDwave==3,det


histogram bayes1CES_SC if HNDwave==1

**CES_IP**

xtmixed CES_IP timew1w3w4 ||HNDID: timew1w3w4, cov(un)


capture drop e_cons_CES_IP e_TIMECES_IP
predict  e_TIME_CES_IP e_cons_CES_IP, reffects level(HNDID)

estat ic

capture drop bayes1CES_IP
gen bayes1CES_IP= -.0144396 +e_TIME_CES_IP


su bayes1CES_IP  


su bayes1CES_IP if HNDwave==1,det
su bayes1CES_IP if HNDwave==3,det


histogram bayes1CES_IP if HNDwave==1

**CES_WB**

xtmixed CES_WB timew1w3w4 ||HNDID: timew1w3w4, cov(un)


capture drop e_cons_CES_WB e_TIMECES_WB
predict  e_TIMECES_WB e_cons_CES_WB, reffects level(HNDID)

estat ic

capture drop bayes1CES_WB
gen bayes1CES_WB=   -.0491547 +e_TIMECES_WB


su bayes1CES_WB  


su bayes1CES_WB if HNDwave==1,det
su bayes1CES_WB if HNDwave==3,det


histogram bayes1CES_WB if HNDwave==1


**HCY***
capture drop LnHCys
gen LnHCys=ln(HCys)

xtmixed LnHCys timew1w3w4 ||HNDID: timew1w3w4, cov(un)


capture drop e_cons_LnHcys e_TIME_LnHcys
predict  e_TIME_LnHcys e_cons_LnHcys, reffects level(HNDID)

estat ic

capture drop bayes1HCys
gen bayes1HCys=   .0185574  + e_TIME_LnHcys


su bayes1HCys  


su bayes1HCys if HNDwave==1,det
su bayes1HCys if HNDwave==3,det


histogram bayes1HCys if HNDwave==1



save, replace

//STEP 16: COLLAPSE THE EMPIRICAL BAYES ESTIMATORS AND RE-MERGE WITH DATA//

use  HANDLS_PAPER64_HCYDEPANXIETY_LONG,clear

keep HNDID bayes1*

save bayes1_depchange, replace

collapse (mean) bayes1*, by(HNDID)

save bayes1_depchange_collapse, replace

addstub bayes1*, stub(w1w3w4)

sort HNDID
save, replace

use HANDLS_PAPER64_HCYDEPANXIETY_LONG,clear
capture drop _merge
sort HNDID
save, replace

merge HNDID using bayes1_depchange_collapse
tab _merge
capture drop _merge
sort HNDID
save, replace


//STEP 17: CREATE STEPWISE SELECTION PROCESS FOR FLOWCHART//

**Initial wave 1 sample: SAMPLE1**

capture drop sample1
gen sample1=1 if w1Age~=.
replace sample1=0 if sample1~=1

tab sample1
tab sample1 if HNDwave==1

**Sample with complete w1 HCys load  exposure data: SAMPLE2**

capture drop sample2
gen sample2=1 if w1HCys~=.
replace sample2=0 if sample2~=1

tab sample2
tab sample2 if HNDwave==1


save, replace 

**Samples with complete CES-D data at waves 1 and/or 3 and/or 4: SAMPLE3**

use HANDLS_PAPER64_HCYDEPANXIETY_LONG,clear

keep HNDID sample_CES

save selectCES, replace
collapse (mean) sample_CES, by(HNDID)

save sampleCES_collapse, replace
sort HNDID
addstub sample_CES, stub(w1w3w4)
save, replace

use HANDLS_PAPER64_HCYDEPANXIETY_LONG,clear
capture drop _merge
sort HNDID

merge HNDID using sampleCES_collapse
tab _merge
capture drop _merge
sort HNDID

save, replace


capture drop sample3obs
gen sample3obs=.
replace sample3obs=1 if w1w3w4sample_CES>0 & w1w3w4sample_CES~=. & sample_CES==1 & HNDwave==1 | w1w3w4sample_CES>0 & w1w3w4sample_CES~=. & sample_CES==1 & HNDwave==3 | w1w3w4sample_CES>0 & w1w3w4sample_CES~=. & sample_CES==1 & HNDwave==4 
replace sample3obs=0 if sample3obs~=1 

capture drop sample3part
gen sample3part=.
replace sample3part=1 if w1w3w4sample_CES>0 & w1w3w4sample_CES~=. & HNDwave==1 | w1w3w4sample_CES>0 & w1w3w4sample_CES~=.  & HNDwave==3 | w1w3w4sample_CES>0 & w1w3w4sample_CES~=.  & HNDwave==4 
replace sample3part=0 if sample3part~=1 

tab sample3obs if HNDwave==1  | HNDwave==3  | HNDwave==4
tab sample3part if HNDwave==1


xtmixed CES timew1w3w4 || HNDID: timew1w3w4

save, replace


**Samples with complete depressive symptoms data at waves 1 and/or 3 and HCys data at wave 1: SAMPLE4 SERIES**

use HANDLS_PAPER64_HCYDEPANXIETY_LONG,clear


**sample4: N=2,298; N'=5,548, k=2.4**


capture drop sample4obs
gen sample4obs=.
replace sample4obs=1 if sample3obs==1 & w1HCys~=.
replace sample4obs=0 if sample4obs~=1 

capture drop sample4part
gen sample4part=1 if sample3part==1 &  w1HCys~=.
replace sample4part=0 if sample4part~=1 

tab sample4obs if HNDwave==1  | HNDwave==3  
tab sample4part if HNDwave==1



xtmixed CES c.timew1w3##c.w1HCys || HNDID: timew1w3w4
xtmixed CES_DA c.timew1w3##c.w1HCys || HNDID: timew1w3w4
xtmixed CES_IP c.timew1w3##c.w1HCys || HNDID: timew1w3w4
xtmixed CES_SC c.timew1w3##c.w1HCys || HNDID: timew1w3w4
xtmixed CES_WB c.timew1w3##c.w1HCys || HNDID: timew1w3w4


save HANDLS_PAPER64_HCYDEPANXIETY_LONG, replace


//STEP 18: CREATE INVERSE MILLS RATIOS FOR FINAL SELECTED SAMPLES FOR MIXED-EFFECTS REGRESSION MODELS//

use HANDLS_PAPER64_HCYDEPANXIETY_LONG, clear


xi:probit sample4obs w1Age Race PovStat Sex

capture drop p1CES
predict p1CES, xb

capture drop phiCES
capture drop caphiCES
capture drop invmillsCES

gen phiCES=(1/sqrt(2*_pi))*exp(-(p1CES^2/2))

egen caphiCES=std(p1CES)

capture drop invmillsCES
gen invmillsCES=phiCES/caphiCES


su invmillsCES

save , replace


capture log close

log using "E:\HANDLS_PAPER64_HCYDEPANXIETY_LONG\OUTPUT\TRAJ.smcl",replace


//////STEP 19A: TRAJECTORY OF HCY BETWEEN WAVES 1 AND 3///////////////////

use HANDLS_PAPER64_HCYDEPANXIETY_LONG,clear

keep if HNDwave==1
save HANDLS_PAPER64_HCYDEPANXIETY_LONG_wide, replace

capture drop sampleHCY
gen sampleHCY=.
replace sampleHCY=1 if (w1HCys~=. & w1Age~=. & w3Age~=. | w3HCys~=. & w1Age~=. & w3Age~=. |w4HCys~=. & w1Age~=. & w4Age~=. )
replace sampleHCY=0 if sampleHCY~=1

tab sampleHCY
tab sampleHCY if HNDwave==1
tab sampleHCY if HNDwave==3
tab sampleHCY if HNDwave==4


su w1Age if sampleHCY==1 & HNDwave==1
su w3Age if sampleHCY==1 & HNDwave==1
su w4Age if sampleHCY==1 & HNDwave==1


su w1HCys if sampleHCY==1 & HNDwave==1
su w3HCys if sampleHCY==1 & HNDwave==1
su w4HCys if sampleHCY==1 & HNDwave==1


**Log transformation of HCY***

capture drop Lnw1HCys Lnw3HCys  Lnw4HCys
foreach x of varlist w1HCys w3HCys  w4HCys {
gen Ln`x'=ln(`x')	
}
 
save HANDLS_PAPER64_HCYDEPANXIETY_LONG_wide, replace

**w1w3HCysTRAJ**
capture drop _traj* 

**One group**
traj if sampleHCY==1, var(Lnw1HCys Lnw3HCys  Lnw4HCys) indep(w1Age w3Age w4Age) model(cnorm) max1(400) order(3) sigmabygroup detail
trajplot, xtitle(Age (years)) ytitle(HCY) ci
graph save "FIGURES2_1A.gph",replace


traj if sampleHCY==1, var(Lnw1HCys Lnw3HCys  Lnw4HCys) indep(w1Age w3Age w4Age) model(cnorm) max1(400) order(2) sigmabygroup detail
trajplot, xtitle(Age (years)) ytitle(HCY) ci
graph save "FIGURES2_1B.gph",replace


traj if sampleHCY==1, var(Lnw1HCys Lnw3HCys  Lnw4HCys) indep(w1Age w3Age w4Age) model(cnorm) max1(400) order(1) sigmabygroup detail
trajplot, xtitle(Age (years)) ytitle(HCY) ci
graph save "FIGURES2_1C.gph",replace


**Two groups**
traj if sampleHCY==1, var(Lnw1HCys Lnw3HCys  Lnw4HCys) indep(w1Age w3Age w4Age) model(cnorm) max1(400) order(3 3) sigmabygroup detail
trajplot, xtitle(Age (years)) ytitle(HCY) ci
graph save "FIGURES2_2A.gph",replace


traj if sampleHCY==1, var(Lnw1HCys Lnw3HCys  Lnw4HCys) indep(w1Age w3Age w4Age) model(cnorm) max1(400) order(2 2) sigmabygroup detail
trajplot, xtitle(Age (years)) ytitle(HCY) ci
graph save "FIGURES2_2B.gph",replace


traj if sampleHCY==1, var(Lnw1HCys Lnw3HCys  Lnw4HCys) indep(w1Age w3Age w4Age) model(cnorm) max1(400) order(1 1) sigmabygroup detail
trajplot, xtitle(Age (years)) ytitle(HCY) ci
graph save "FIGURES2_2C.gph",replace


**Three groups**
traj if sampleHCY==1, var(Lnw1HCys Lnw3HCys  Lnw4HCys) indep(w1Age w3Age w4Age) model(cnorm) max1(400) order(3 3 3) sigmabygroup detail
trajplot, xtitle(Age (years)) ytitle(HCY) ci
graph save "FIGURES2_3A.gph",replace


traj if sampleHCY==1, var(Lnw1HCys Lnw3HCys  Lnw4HCys) indep(w1Age w3Age w4Age) model(cnorm) max1(400) order(2 2 2) sigmabygroup detail
trajplot, xtitle(Age (years)) ytitle(HCY) ci
graph save "FIGURES2_3B.gph",replace



traj if sampleHCY==1, var(Lnw1HCys Lnw3HCys  Lnw4HCys) indep(w1Age w3Age w4Age) model(cnorm) max1(400) order(1 1 1) sigmabygroup detail
trajplot, xtitle(Age (years)) ytitle(HCY) ci
graph save "FIGURE2.gph",replace

capture rename _traj_Group R_traj_GroupHCY 
capture rename _traj_ProbG1 R_traj_ProbG1HCY 
capture rename _traj_ProbG2  R_traj_ProbG2HCY
capture rename _traj_ProbG3  R_traj_ProbG3HCY

save, replace

corr R_traj_ProbG1HCY Lnw1HCys Lnw3HCys Lnw4HCys
corr R_traj_ProbG2HCY Lnw1HCys Lnw3HCys Lnw4HCys
corr R_traj_ProbG3HCY Lnw1HCys Lnw3HCys Lnw4HCys

bysort R_traj_GroupHCY: su Lnw1HCys Lnw3HCys Lnw4HCys if (sampleHCY==1 & HNDwave==1)


capture drop w1w3w4HCysTRAJ
gen w1w3w4HCysTRAJ=R_traj_ProbG3HCY

save, replace

keep HNDID R_traj* w1w3w4HCysTRAJ

save HCY_TRAJ_DATA, replace
sort HNDID
save, replace

use HANDLS_PAPER64_HCYDEPANXIETY_LONG,clear
capture drop _merge
sort HNDID
save, replace

merge HNDID using HCY_TRAJ_DATA
save HANDLS_PAPER64_HCYDEPANXIETY_LONG, replace


*******GBTM FOR ANXIETY******

capture drop w1ANXIETY_ORD
gen w1ANXIETY_ORD=w1ANXIETY-10

capture drop w4ANXIETY_ORD
gen w4ANXIETY_ORD=w4ANXIETY-10

capture drop sampleANXIETY
gen sampleANXIETY=1 if w1ANXIETY~=. | w4ANXIETY~=. 
replace sampleANXIETY=0 if sampleANXIETY~=1

tab sampleANXIETY

**One group**

traj if sampleANXIETY==1, var(w1ANXIETY_ORD   w4ANXIETY_ORD) indep(w1Age  w4Age) model(zip) max1(10) order(3) sigmabygroup detail
trajplot, xtitle(Age (years)) ytitle(ANXIETY) ci
graph save "ANXIETY_FINAL_cubic_one.gph",replace



traj if sampleANXIETY==1, var(w1ANXIETY_ORD   w4ANXIETY_ORD) indep(w1Age  w4Age) model(zip) max1(10) order(2) sigmabygroup detail
trajplot, xtitle(Age (years)) ytitle(ANXIETY) ci
graph save "ANXIETY_FINAL_quadratic_one.gph",replace


traj if sampleANXIETY==1, var(w1ANXIETY_ORD   w4ANXIETY_ORD) indep(w1Age  w4Age) model(zip) max1(10) order(1) sigmabygroup detail
trajplot, xtitle(Age (years)) ytitle(ANXIETY) ci
graph save "ANXIETY_linear_one.gph",replace


**Two group**

traj if sampleANXIETY==1, var(w1ANXIETY_ORD   w4ANXIETY_ORD) indep(w1Age  w4Age) model(zip) max1(10) order(3 3) sigmabygroup detail
trajplot, xtitle(Age (years)) ytitle(ANXIETY) ci
graph save "ANXIETY_FINAL_cubic.gph",replace



traj if sampleANXIETY==1, var(w1ANXIETY_ORD   w4ANXIETY_ORD) indep(w1Age  w4Age) model(zip) max1(10) order(2 2) sigmabygroup detail
trajplot, xtitle(Age (years)) ytitle(ANXIETY) ci
graph save "ANXIETY_FINAL_quadratic.gph",replace


traj if sampleANXIETY==1, var(w1ANXIETY_ORD   w4ANXIETY_ORD) indep(w1Age  w4Age) model(zip) max1(10) order(1 1) sigmabygroup detail
trajplot, xtitle(Age (years)) ytitle(ANXIETY) ci
graph save "ANXIETY_FINAL.gph",replace

capture rename _traj_Group R_traj_GroupANXIETY 
capture rename _traj_ProbG1 R_traj_ProbG1ANXIETY 
capture rename _traj_ProbG2  R_traj_ProbG2ANXIETY


save, replace

corr R_traj_ProbG1ANXIETY w1ANXIETY_ORD  w4ANXIETY_ORD
corr R_traj_ProbG2ANXIETY w1ANXIETY_ORD  w4ANXIETY_ORD

bysort R_traj_GroupANXIETY: su w1ANXIETY_ORD w4ANXIETY_ORD if (sampleANXIETY==1 & HNDwave==1)
twoway (contour R_traj_ProbG1ANXIETY w1ANXIETY_ORD  w4ANXIETY_ORD) if (sampleANXIETY==1 & HNDwave==1)
graph save "ANXIETY_PROBG1_COMPA.gph",replace
twoway (contour R_traj_ProbG2ANXIETY w1ANXIETY_ORD  w4ANXIETY_ORD) if (sampleANXIETY==1 & HNDwave==1)
graph save "ANXIETY_PROBG2_COMPA.gph",replace

graph combine "ANXIETY_FINAL.gph" "ANXIETY_PROBG1_COMPA.gph" "ANXIETY_PROBG2_COMPA.gph" 
graph save "FIGURE3.gph",replace

capture drop w1w4ANXIETYTRAJ
gen w1w4ANXIETYTRAJ=R_traj_ProbG2ANXIETY

save, replace

keep HNDID R_traj* w1w4ANXIETYTRAJ

save ANXIETY_TRAJ_DATA, replace
sort HNDID
save, replace

use HANDLS_PAPER64_HCYDEPANXIETY_LONG,clear
capture drop _merge
sort HNDID
save, replace

merge HNDID using ANXIETY_TRAJ_DATA
save HANDLS_PAPER64_ANXIETYDEPANXIETY_LONG, replace


capture log close


log using "E:\HANDLS_PAPER64_HCYDEPANXIETY_LONG\OUTPUT\IMPUTATIONS.smcl",replace


//STEP 19B: MULTIPLE IMPUTATIONS FOR COVARIATES////////

use HANDLS_PAPER64_HCYDEPANXIETY_LONG,clear

sort HNDwave HNDID


save finaldata_imputed,replace


capture set matsize 11000

capture mi set flong

capture mi xtset, clear

capture mi stset, clear

save, replace

su HNDwave w1w3w4bayes*  w1Age Sex Race PovStat w1edubr  w1currdrugs w1smoke  w1BMI w1SRH w1hei2010_total_score   w1dxHTN w1dxDiabetes w1CVhighChol w1cvdbr if HNDwave==1


replace w1smoke=. if w1smoke==9
save, replace

replace w1currdrugs=. if w1currdrugs==9
save, replace

replace w1SRH=. if w1SRH==9
save, replace

mi unregister HNDID HNDwave w1w3w4bayes*  w1Age Sex Race PovStat w1edubr  w1currdrugs w1smoke  w1BMI w1SRH w1hei2010_total_score   w1dxHTN w1dxDiabetes w1CVhighChol w1cvdbr 

mi register imputed  w1edubr  w1currdrugs w1smoke  w1BMI w1SRH w1hei2010_total_score   w1dxHTN w1dxDiabetes w1CVhighChol w1cvdbr  


mi register passive bayes1*  


mi impute chained (ologit) w1edubr w1smoke w1currdrugs  w1dxHTN w1dxDiabetes w1CVhighChol w1cvdbr w1SRH (regress)  w1BMI w1hei2010_total_score=w1Age Sex Race PovStat if w1Age~=., force augment noisily  add(5) rseed(1234) savetrace(tracefile, replace) 


save finaldata_imputed, replace

capture drop w1comorbid
mi passive: gen w1comorbid=w1dxHTN+w1dxDiabetes+w1CVhighChol+w1cvdbr

save finaldata_imputed_FINAL, replace

capture log close
log using "E:\HANDLS_PAPER64_HCYDEPANXIETY_LONG\OUTPUT\DATA_MANAGEMENT2.smcl",replace


//STEP 20: CENTER CONTINUOUS VARIABLES AND LOG TRANSFORM TRAILS//

use finaldata_imputed_FINAL,clear


**Continuous exposures and covariates**

capture drop Lnw1HCys Lnw3HCys  Lnw4HCys
foreach x of varlist w1HCys w3HCys  w4HCys {
gen Ln`x'=ln(`x')	
}

su Lnw1HCys if HNDwave==1 & _mi_m==0
su w1hei2010_total_score if HNDwave==1 & _mi_m==0
su w1BMI if HNDwave==1 & _mi_m==0
su invmills* if HNDwave==1 & _mi_m==0
su w1Age if HNDwave==1 & _mi_m==0

******HCys******

capture drop Lnw1HCyscenter2p15
mi passive: gen Lnw1HCyscenter2p15=Lnw1HCys-2.15

capture drop zw1w3w4HCysTRAJ
egen zw1w3w4HCysTRAJ=std(w1w3w4HCysTRAJ)  


******Dietary exposures and covariates******

capture drop w1hei2010_total_scorecent43
gen w1hei2010_total_scorecent43=w1hei2010_total_score-43


******Other covariates*******

capture drop w1BMIcent30
gen w1BMIcent30=w1BMI-30

su w1BMIcent30 if HNDwave==1

capture drop w1Agecent48
gen w1Agecent48=w1Age-48

su w1Agecent48 if HNDwave==1


**Categorical covariates:
tab1 w1edubr  w1currdrugs w1smoke  w1SRH w1dxHTN w1dxDiabetes w1CVhighChol w1cvdbr 


**Time varialbes: timew1w3w4

**Outcome variables**
su CES*

save finaldata_imputed_FINAL, replace




**Final sample selectivity**
capture drop sample_final_part
gen sample_final_part=sample4part


mi estimate: logistic sample_final_part w1Age Sex PovStat Race if HNDwave==1 

mi estimate: logistic sample_final_part w1Age  if HNDwave==1
mi estimate: logistic sample_final_part Sex  if HNDwave==1
mi estimate: logistic sample_final_part PovStat  if HNDwave==1
mi estimate: logistic sample_final_part Race  if HNDwave==1

save finaldata_imputed_FINAL, replace

//STEP 21: CREATE HCys LOAD TERTILE//

use finaldata_imputed_FINAL,clear

capture drop w1HCystert
xtile w1HCystert=w1HCys if HNDwave==1 | HNDwave==3,nq(3)


tab w1HCystert

bysort w1HCystert: su  w1HCys if HNDwave==1

save finaldata_imputed_FINAL, replace


capture log close
log using "E:\HANDLS_PAPER64_HCYDEPANXIETY_LONG\OUTPUT\FIGURE1.smcl", replace


*************************MAIN ANALYSIS******************

////////FIGURE 1: PARTICIPANT FLOWCHART, TEXT OF METHODS////


use finaldata_imputed_FINAL,clear


su timew1w3w4 if HNDwave==3


**Initial sample: N=3,720**

mi estimate: mean w1Age if HNDwave==1
mi estimate: prop Sex if HNDwave==1
mi estimate: prop Race if HNDwave==1
mi estimate: prop PovStat if HNDwave==1

save, replace

tab sample1 if HNDwave==1 & _mi_m==0

**Sample with complete HCys load data: N=2,321**

tab sample2 if HNDwave==1 & _mi_m==0

**Samples with complete CED-D scores at waves 1, 3 or 4: N=3,028 participants, N=7,592 observations; Report maximum sample sizes for participants and observations in text ***

tab1 sample3part if HNDwave==1  & _mi_m==0
tab1 sample3part if HNDwave==3  & _mi_m==0
tab1 sample3part if HNDwave==4  & _mi_m==0


tab1 sample3obs if HNDwave==1  & _mi_m==0 | HNDwave==3  & _mi_m==0 | HNDwave==4 & _mi_m==0


**Samples with complete CES-D scores at waves 1, 3 or 4 and complete Hcy exposures: N=1,460; N'=4,124;***

tab1 sample4part if HNDwave==1  & _mi_m==0
tab1 sample4part if HNDwave==3  & _mi_m==0
tab1 sample4part if HNDwave==4  & _mi_m==0


tab1 sample4obs if HNDwave==1  & _mi_m==0 | HNDwave==3  & _mi_m==0 | HNDwave==4  & _mi_m==0

save finaldata_imputed_FINAL,replace



capture log close

log using "E:\HANDLS_PAPER64_HCYDEPANXIETY_LONG\OUTPUT\TABLE1.smcl", replace


//////////////////////////TABLE 1: STUDY CHARACTERISTICS OVERALL AND BY W1 HCys LOAD TERTILE/////////////////////////////////////


use finaldata_imputed_FINAL,clear


capture drop CESDcut16
mi passive: gen CESDcut16=.
mi passive: replace CESDcut16=1 if CES>=16 & CES~=.
mi passive: replace CESDcut16=0 if CESDcut16~=1 & CES~=.

mi estimate: prop CESDcut16 if sample4part==1


save, replace

*******PRELIMINARY ANALYSIS******************

tab w1ANXIETY_ORD if sample4part==1 & _mi_m==0

capture drop w1ANXIETYbr
xtile w1ANXIETYbr=w1ANXIETY_ORD if sample4part==1,nq(2)

tab w1ANXIETYbr
tab w1ANXIETYbr if HNDwave==1 & sample4part==1 & _mi_m==0

tab w1AnxietyDisorder if HNDwave==1 & sample4part==1 & _mi_m==0

tab w1AnxietyDisorder w1ANXIETYbr if HNDwave==1 & sample4part==1 & _mi_m==0, row col chi

capture drop zR_traj_ProbG2ANXIETY
egen zR_traj_ProbG2ANXIETY=std(R_traj_ProbG2ANXIETY)
su R_traj_ProbG2ANXIETY



capture drop w1w3HCys_change
gen w1w3HCys_change=(w3HCys-w1HCys)/(w3Age-w1Age)

capture drop zw1w3HCys_change
mi passive: egen zw1w3HCys_change=std(w1w3HCys_change) if sample4obs==1


capture drop Lnodds_highANXIETY
gen Lnodds_highANXIETY=ln(R_traj_ProbG2ANXIETY/(1-R_traj_ProbG2ANXIETY))


su w1w3HCys_change if sample4obs==1 & HNDwave==1 & _mi_m==0, det
su w1w3w4HCysTRAJ if sample4obs==1 & HNDwave==1 & _mi_m==0, det
bysort w1HCystert: su w1HCys if sample4obs==1 & HNDwave==1 & _mi_m==0, det
bysort w1HCystert: su Lnw1HCys if sample4obs==1 & HNDwave==1 & _mi_m==0, det
bysort w1ANXIETYbr: su w1ANXIETY_ORD if sample4obs==1 & HNDwave==1 & _mi_m==0, det
bysort w1ANXIETYbr: su w1w4ANXIETYTRAJ if sample4obs==1 & HNDwave==1 & _mi_m==0, det
bysort w1AnxietyDisorder: su w1ANXIETY_ORD if sample4obs==1 & HNDwave==1 & _mi_m==0, det
bysort w1AnxietyDisorder: su w1w4ANXIETYTRAJ if sample4obs==1 & HNDwave==1 & _mi_m==0, det
bysort w1AnxietyDisorder: su Lnodds_highANXIETY if sample4obs==1 & HNDwave==1 & _mi_m==0, det

su w1ANXIETY_ORD if sample4obs==1 & HNDwave==1 & _mi_m==0, det
su w1w4ANXIETYTRAJ if sample4obs==1 & HNDwave==1 & _mi_m==0, det
tab w1AnxietyDisorder if sample4obs==1 & HNDwave==1 & _mi_m==0
tab w1ANXIETYbr if sample4obs==1 & HNDwave==1 & _mi_m==0
su Lnodds_highANXIETY if sample4obs==1 & HNDwave==1 & _mi_m==0



save "finaldata_imputed_FINAL.dta", replace





*****MAIN  TABLE ****
mi estimate: mean w1HCys if sample4part==1 & HNDwave==1
mi estimate: mean Lnw1HCys if sample4part==1 & HNDwave==1
mi estimate: mean w1w3w4HCysTRAJ if sample4part==1 & HNDwave==1
mi estimate: mean w1w3HCys_change if sample4part==1 & HNDwave==1

mi estimate: prop Sex  if sample4part==1 & HNDwave==1
mi estimate: mean w1Age  if sample4part==1 & HNDwave==1
mi estimate: prop Race  if sample4part==1 & HNDwave==1
mi estimate: prop PovStat  if sample4part==1 & HNDwave==1
mi estimate: prop w1edubr  if sample4part==1 & HNDwave==1
mi estimate: prop w1currdrugs if sample4part==1 & HNDwave==1 
mi estimate: prop w1smoke if sample4part==1 & HNDwave==1
mi estimate: mean w1BMI if sample4part==1 & HNDwave==1
mi estimate: prop w1SRH if sample4part==1 & HNDwave==1
mi estimate: mean w1hei2010_total_score if sample4part==1 & HNDwave==1
mi estimate: prop w1dxHTN if sample4part==1 & HNDwave==1
mi estimate: prop w1dxDiabetes if sample4part==1 & HNDwave==1
mi estimate: prop w1CVhighChol  if sample4part==1 & HNDwave==1
mi estimate: prop w1cvdbr  if sample4part==1 & HNDwave==1


mi estimate: mean CES if sample4part==1 & HNDwave==1
mi estimate: mean CES_DA if sample4part==1 & HNDwave==1
mi estimate: mean CES_IP if sample4part==1 & HNDwave==1
mi estimate: mean CES_SC if sample4part==1 & HNDwave==1
mi estimate: mean CES_WB if sample4part==1 & HNDwave==1
mi estimate: prop CESDcut16 if sample4part==1 & HNDwave==1

mi estimate: mean w1ANXIETY_ORD if sample4part==1 & HNDwave==1
mi estimate: mean zR_traj_ProbG2ANXIETY if sample4part==1 & HNDwave==1
mi estimate: mean R_traj_ProbG2ANXIETY if sample4part==1 & HNDwave==1
mi estimate: mean Lnodds_highANXIETY if sample4part==1 & HNDwave==1
mi estimate: prop w1ANXIETYbr if sample4part==1 & HNDwave==1
mi estimate: prop w1AnxietyDisorder if sample4part==1 & HNDwave==1



mi estimate: mean w1w3w4bayes1CES if sample4part==1 & HNDwave==1
mi estimate: mean w1w3w4bayes1CES_DA if sample4part==1 & HNDwave==1
mi estimate: mean w1w3w4bayes1CES_IP if sample4part==1 & HNDwave==1
mi estimate: mean w1w3w4bayes1CES_SC if sample4part==1 & HNDwave==1
mi estimate: mean w1w3w4bayes1CES_WB if sample4part==1 & HNDwave==1


save, replace


****************First HCys load tertile*********************

mi estimate: mean w1HCys if sample4part==1 & HNDwave==1 & w1HCystert==1
mi estimate: mean Lnw1HCys if sample4part==1 & HNDwave==1 & w1HCystert==1
mi estimate: mean w1w3w4HCysTRAJ if sample4part==1 & HNDwave==1 & w1HCystert==1
mi estimate: mean w1w3HCys_change if sample4part==1 & HNDwave==1 & w1HCystert==1



mi estimate: prop Sex  if sample4part==1 & HNDwave==1 & w1HCystert==1
mi estimate: mean w1Age  if sample4part==1 & HNDwave==1 & w1HCystert==1
mi estimate: prop Race  if sample4part==1 & HNDwave==1 & w1HCystert==1
mi estimate: prop PovStat  if sample4part==1 & HNDwave==1 & w1HCystert==1
mi estimate: prop w1edubr  if sample4part==1 & HNDwave==1 & w1HCystert==1
mi estimate: prop w1currdrugs if sample4part==1 & HNDwave==1 & w1HCystert==1 
mi estimate: prop w1smoke if sample4part==1 & HNDwave==1 & w1HCystert==1
mi estimate: mean w1BMI if sample4part==1 & HNDwave==1 & w1HCystert==1
mi estimate: prop w1SRH if sample4part==1 & HNDwave==1 & w1HCystert==1
mi estimate: mean w1hei2010_total_score if sample4part==1 & HNDwave==1 & w1HCystert==1
mi estimate: prop w1dxHTN if sample4part==1 & HNDwave==1 & w1HCystert==1
mi estimate: prop w1dxDiabetes if sample4part==1 & HNDwave==1 & w1HCystert==1
mi estimate: prop w1CVhighChol  if sample4part==1 & HNDwave==1 & w1HCystert==1
mi estimate: prop w1cvdbr  if sample4part==1 & HNDwave==1 & w1HCystert==1


mi estimate: mean CES if sample4part==1 & HNDwave==1 & w1HCystert==1
mi estimate: mean CES_DA if sample4part==1 & HNDwave==1 & w1HCystert==1
mi estimate: mean CES_IP if sample4part==1 & HNDwave==1 & w1HCystert==1
mi estimate: mean CES_SC if sample4part==1 & HNDwave==1 & w1HCystert==1
mi estimate: mean CES_WB if sample4part==1 & HNDwave==1 & w1HCystert==1
mi estimate: prop CESDcut16 if sample4part==1 & HNDwave==1 & w1HCystert==1


mi estimate: mean w1ANXIETY_ORD if sample4part==1 & HNDwave==1 & w1HCystert==1
mi estimate: mean zR_traj_ProbG2ANXIETY if sample4part==1 & HNDwave==1 & w1HCystert==1
mi estimate: mean R_traj_ProbG2ANXIETY if sample4part==1 & HNDwave==1 & w1HCystert==1
mi estimate: mean Lnodds_highANXIETY if sample4part==1 & HNDwave==1 & w1HCystert==1
mi estimate: prop w1ANXIETYbr if sample4part==1 & HNDwave==1 & w1HCystert==1
mi estimate: prop w1AnxietyDisorder if sample4part==1 & HNDwave==1 & w1HCystert==1



mi estimate: mean w1w3w4bayes1CES if sample4part==1 & HNDwave==1 & w1HCystert==1
mi estimate: mean w1w3w4bayes1CES_DA if sample4part==1 & HNDwave==1 & w1HCystert==1
mi estimate: mean w1w3w4bayes1CES_IP if sample4part==1 & HNDwave==1 & w1HCystert==1
mi estimate: mean w1w3w4bayes1CES_SC if sample4part==1 & HNDwave==1 & w1HCystert==1
mi estimate: mean w1w3w4bayes1CES_WB if sample4part==1 & HNDwave==1 & w1HCystert==1


save, replace


****************Second HCys load tertile: HCys load=2*********************
mi estimate: mean w1HCys if sample4part==1 & HNDwave==1 & w1HCystert==2
mi estimate: mean Lnw1HCys if sample4part==1 & HNDwave==1 & w1HCystert==2
mi estimate: mean w1w3w4HCysTRAJ if sample4part==1 & HNDwave==1 & w1HCystert==2
mi estimate: mean w1w3HCys_change if sample4part==1 & HNDwave==1 & w1HCystert==2



mi estimate: prop Sex  if sample4part==1 & HNDwave==1 & w1HCystert==2
mi estimate: mean w1Age  if sample4part==1 & HNDwave==1 & w1HCystert==2
mi estimate: prop Race  if sample4part==1 & HNDwave==1 & w1HCystert==2
mi estimate: prop PovStat  if sample4part==1 & HNDwave==1 & w1HCystert==2
mi estimate: prop w1edubr  if sample4part==1 & HNDwave==1 & w1HCystert==2
mi estimate: prop w1currdrugs if sample4part==1 & HNDwave==1 & w1HCystert==2 
mi estimate: prop w1smoke if sample4part==1 & HNDwave==1 & w1HCystert==2
mi estimate: mean w1BMI if sample4part==1 & HNDwave==1 & w1HCystert==2
mi estimate: prop w1SRH if sample4part==1 & HNDwave==1 & w1HCystert==2
mi estimate: mean w1hei2010_total_score if sample4part==1 & HNDwave==1 & w1HCystert==2
mi estimate: prop w1dxHTN if sample4part==1 & HNDwave==1 & w1HCystert==2
mi estimate: prop w1dxDiabetes if sample4part==1 & HNDwave==1 & w1HCystert==2
mi estimate: prop w1CVhighChol  if sample4part==1 & HNDwave==1 & w1HCystert==2
mi estimate: prop w1cvdbr  if sample4part==1 & HNDwave==1 & w1HCystert==2


mi estimate: mean CES if sample4part==1 & HNDwave==1 & w1HCystert==2
mi estimate: mean CES_DA if sample4part==1 & HNDwave==1 & w1HCystert==2
mi estimate: mean CES_IP if sample4part==1 & HNDwave==1 & w1HCystert==2
mi estimate: mean CES_SC if sample4part==1 & HNDwave==1 & w1HCystert==2
mi estimate: mean CES_WB if sample4part==1 & HNDwave==1 & w1HCystert==2
mi estimate: prop CESDcut16 if sample4part==1 & HNDwave==1 & w1HCystert==2


mi estimate: mean w1ANXIETY_ORD if sample4part==1 & HNDwave==1 & w1HCystert==2
mi estimate: mean zR_traj_ProbG2ANXIETY if sample4part==1 & HNDwave==1 & w1HCystert==2
mi estimate: mean R_traj_ProbG2ANXIETY if sample4part==1 & HNDwave==1 & w1HCystert==2
mi estimate: mean Lnodds_highANXIETY if sample4part==1 & HNDwave==1 & w1HCystert==2
mi estimate: prop w1ANXIETYbr if sample4part==1 & HNDwave==1 & w1HCystert==2
mi estimate: prop w1AnxietyDisorder if sample4part==1 & HNDwave==1 & w1HCystert==2


mi estimate: mean w1w3w4bayes1CES if sample4part==1 & HNDwave==1 & w1HCystert==2
mi estimate: mean w1w3w4bayes1CES_DA if sample4part==1 & HNDwave==1 & w1HCystert==2
mi estimate: mean w1w3w4bayes1CES_IP if sample4part==1 & HNDwave==1 & w1HCystert==2
mi estimate: mean w1w3w4bayes1CES_SC if sample4part==1 & HNDwave==1 & w1HCystert==2
mi estimate: mean w1w3w4bayes1CES_WB if sample4part==1 & HNDwave==1 & w1HCystert==2


save, replace

*************Third HCys load tertile********************************************
mi estimate: mean w1HCys if sample4part==1 & HNDwave==1 & w1HCystert==3
mi estimate: mean Lnw1HCys if sample4part==1 & HNDwave==1 & w1HCystert==3
mi estimate: mean w1w3w4HCysTRAJ if sample4part==1 & HNDwave==1 & w1HCystert==3
mi estimate: mean w1w3HCys_change if sample4part==1 & HNDwave==1 & w1HCystert==3



mi estimate: prop Sex  if sample4part==1 & HNDwave==1 & w1HCystert==3
mi estimate: mean w1Age  if sample4part==1 & HNDwave==1 & w1HCystert==3
mi estimate: prop Race  if sample4part==1 & HNDwave==1 & w1HCystert==3
mi estimate: prop PovStat  if sample4part==1 & HNDwave==1 & w1HCystert==3
mi estimate: prop w1edubr  if sample4part==1 & HNDwave==1 & w1HCystert==3
mi estimate: prop w1currdrugs if sample4part==1 & HNDwave==1 & w1HCystert==3 
mi estimate: prop w1smoke if sample4part==1 & HNDwave==1 & w1HCystert==3
mi estimate: mean w1BMI if sample4part==1 & HNDwave==1 & w1HCystert==3
mi estimate: prop w1SRH if sample4part==1 & HNDwave==1 & w1HCystert==3
mi estimate: mean w1hei2010_total_score if sample4part==1 & HNDwave==1 & w1HCystert==3
mi estimate: prop w1dxHTN if sample4part==1 & HNDwave==1 & w1HCystert==3
mi estimate: prop w1dxDiabetes if sample4part==1 & HNDwave==1 & w1HCystert==3
mi estimate: prop w1CVhighChol  if sample4part==1 & HNDwave==1 & w1HCystert==3
mi estimate: prop w1cvdbr  if sample4part==1 & HNDwave==1 & w1HCystert==3


mi estimate: mean CES if sample4part==1 & HNDwave==1 & w1HCystert==3
mi estimate: mean CES_DA if sample4part==1 & HNDwave==1 & w1HCystert==3
mi estimate: mean CES_IP if sample4part==1 & HNDwave==1 & w1HCystert==3
mi estimate: mean CES_SC if sample4part==1 & HNDwave==1 & w1HCystert==3
mi estimate: mean CES_WB if sample4part==1 & HNDwave==1 & w1HCystert==3
mi estimate: prop CESDcut16 if sample4part==1 & HNDwave==1 & w1HCystert==3


mi estimate: mean w1ANXIETY_ORD if sample4part==1 & HNDwave==1 & w1HCystert==3
mi estimate: mean zR_traj_ProbG2ANXIETY if sample4part==1 & HNDwave==1 & w1HCystert==3
mi estimate: mean R_traj_ProbG2ANXIETY if sample4part==1 & HNDwave==1 & w1HCystert==3
mi estimate: mean Lnodds_highANXIETY if sample4part==1 & HNDwave==1 & w1HCystert==3
mi estimate: prop w1ANXIETYbr if sample4part==1 & HNDwave==1 & w1HCystert==3
mi estimate: prop w1AnxietyDisorder if sample4part==1 & HNDwave==1 & w1HCystert==3



mi estimate: mean w1w3w4bayes1CES if sample4part==1 & HNDwave==1 & w1HCystert==3
mi estimate: mean w1w3w4bayes1CES_DA if sample4part==1 & HNDwave==1 & w1HCystert==3
mi estimate: mean w1w3w4bayes1CES_IP if sample4part==1 & HNDwave==1 & w1HCystert==3
mi estimate: mean w1w3w4bayes1CES_SC if sample4part==1 & HNDwave==1 & w1HCystert==3
mi estimate: mean w1w3w4bayes1CES_WB if sample4part==1 & HNDwave==1 & w1HCystert==3


save, replace

*********************DIFFERENCE BY HCys load tertiles**************************

mi estimate: reg w1HCys i.w1HCystert if sample4part==1 & HNDwave==1
mi estimate: reg Lnw1HCys i.w1HCystert if sample4part==1 & HNDwave==1
mi estimate: reg w1w3w4HCysTRAJ i.w1HCystert if sample4part==1 & HNDwave==1
mi estimate: reg w1w3HCys_change i.w1HCystert if sample4part==1 & HNDwave==1


mi estimate: mlogit Sex  i.w1HCystert if sample4part==1 & HNDwave==1
mi estimate: reg w1Age  i.w1HCystert if sample4part==1 & HNDwave==1
mi estimate: mlogit Race  i.w1HCystert if sample4part==1 & HNDwave==1
mi estimate: mlogit PovStat  i.w1HCystert if sample4part==1 & HNDwave==1
mi estimate: mlogit w1edubr  i.w1HCystert if sample4part==1 & HNDwave==1
mi estimate: mlogit w1currdrugs i.w1HCystert if sample4part==1 & HNDwave==1 
mi estimate: mlogit w1smoke i.w1HCystert if sample4part==1 & HNDwave==1
mi estimate: reg w1BMI i.w1HCystert if sample4part==1 & HNDwave==1
mi estimate: mlogit w1SRH i.w1HCystert if sample4part==1 & HNDwave==1
mi estimate: reg w1hei2010_total_score i.w1HCystert if sample4part==1 & HNDwave==1
mi estimate: mlogit w1dxHTN i.w1HCystert if sample4part==1 & HNDwave==1
mi estimate: mlogit w1dxDiabetes i.w1HCystert if sample4part==1 & HNDwave==1
mi estimate: mlogit w1CVhighChol  i.w1HCystert if sample4part==1 & HNDwave==1
mi estimate: mlogit w1cvdbr  i.w1HCystert if sample4part==1 & HNDwave==1


mi estimate: reg CES i.w1HCystert if sample4part==1 & HNDwave==1
mi estimate: reg CES_DA i.w1HCystert if sample4part==1 & HNDwave==1
mi estimate: reg CES_IP i.w1HCystert if sample4part==1 & HNDwave==1
mi estimate: reg CES_SC i.w1HCystert if sample4part==1 & HNDwave==1
mi estimate: reg CES_WB i.w1HCystert if sample4part==1 & HNDwave==1
mi estimate: mlogit CESDcut16 i.w1HCystert if sample4part==1 & HNDwave==1

mi estimate: reg w1ANXIETY_ORD i.w1HCystert if sample4part==1 & HNDwave==1
mi estimate: reg zR_traj_ProbG2ANXIETY i.w1HCystert if sample4part==1 & HNDwave==1
mi estimate: reg R_traj_ProbG2ANXIETY i.w1HCystert if sample4part==1 & HNDwave==1
mi estimate: reg Lnodds_highANXIETY i.w1HCystert if sample4part==1 & HNDwave==1
mi estimate: mlogit w1ANXIETYbr i.w1HCystert if sample4part==1 & HNDwave==1
mi estimate: mlogit w1AnxietyDisorder i.w1HCystert if sample4part==1 & HNDwave==1


mi estimate: reg w1w3w4bayes1CES i.w1HCystert if sample4part==1 & HNDwave==1
mi estimate: reg w1w3w4bayes1CES_DA i.w1HCystert if sample4part==1 & HNDwave==1
mi estimate: reg w1w3w4bayes1CES_IP i.w1HCystert if sample4part==1 & HNDwave==1
mi estimate: reg w1w3w4bayes1CES_SC i.w1HCystert if sample4part==1 & HNDwave==1
mi estimate: reg w1w3w4bayes1CES_WB i.w1HCystert if sample4part==1 & HNDwave==1


save, replace


***********************Difference by HCys load tertile, age, sex, race and poverty status-adjusted*******************
mi estimate: reg w1HCys i.w1HCystert w1Age Race Sex PovStat if sample4part==1 & HNDwave==1
mi estimate: reg Lnw1HCys i.w1HCystert w1Age Race Sex PovStat if sample4part==1 & HNDwave==1
mi estimate: reg w1w3w4HCysTRAJ i.w1HCystert w1Age Race Sex PovStat if sample4part==1 & HNDwave==1
mi estimate: reg w1w3HCys_change i.w1HCystert w1Age Race Sex PovStat if sample4part==1 & HNDwave==1


mi estimate: mlogit Sex  i.w1HCystert w1Age Race  PovStat if sample4part==1 & HNDwave==1
mi estimate: reg w1Age  i.w1HCystert  Race Sex PovStat if sample4part==1 & HNDwave==1
mi estimate: mlogit Race  i.w1HCystert w1Age  Sex PovStat if sample4part==1 & HNDwave==1
mi estimate: mlogit PovStat  i.w1HCystert w1Age Race Sex  if sample4part==1 & HNDwave==1
mi estimate: mlogit w1edubr  i.w1HCystert w1Age Race Sex PovStat if sample4part==1 & HNDwave==1
mi estimate: mlogit w1currdrugs i.w1HCystert w1Age Race Sex PovStat if sample4part==1 & HNDwave==1 
mi estimate: mlogit w1smoke i.w1HCystert w1Age Race Sex PovStat if sample4part==1 & HNDwave==1
mi estimate: reg w1BMI i.w1HCystert w1Age Race Sex PovStat if sample4part==1 & HNDwave==1
mi estimate: mlogit w1SRH i.w1HCystert w1Age Race Sex PovStat if sample4part==1 & HNDwave==1
mi estimate: reg w1hei2010_total_score i.w1HCystert w1Age Race Sex PovStat if sample4part==1 & HNDwave==1
mi estimate: mlogit w1dxHTN i.w1HCystert w1Age Race Sex PovStat if sample4part==1 & HNDwave==1
mi estimate: mlogit w1dxDiabetes i.w1HCystert w1Age Race Sex PovStat if sample4part==1 & HNDwave==1
mi estimate: mlogit w1CVhighChol  i.w1HCystert w1Age Race Sex PovStat if sample4part==1 & HNDwave==1
mi estimate: mlogit w1cvdbr  i.w1HCystert w1Age Race Sex PovStat if sample4part==1 & HNDwave==1


mi estimate: reg CES i.w1HCystert w1Age Race Sex PovStat if sample4part==1 & HNDwave==1
mi estimate: reg CES_DA i.w1HCystert w1Age Race Sex PovStat if sample4part==1 & HNDwave==1
mi estimate: reg CES_IP i.w1HCystert w1Age Race Sex PovStat if sample4part==1 & HNDwave==1
mi estimate: reg CES_SC i.w1HCystert w1Age Race Sex PovStat if sample4part==1 & HNDwave==1
mi estimate: reg CES_WB i.w1HCystert w1Age Race Sex PovStat if sample4part==1 & HNDwave==1
mi estimate: mlogit CESDcut16 i.w1HCystert w1Age Race Sex PovStat if sample4part==1 & HNDwave==1



mi estimate: reg w1ANXIETY_ORD i.w1HCystert w1Age Race Sex PovStat if sample4part==1 & HNDwave==1
mi estimate: reg zR_traj_ProbG2ANXIETY i.w1HCystert w1Age Race Sex PovStat if sample4part==1 & HNDwave==1
mi estimate: reg R_traj_ProbG2ANXIETY i.w1HCystert w1Age Race Sex PovStat if sample4part==1 & HNDwave==1
mi estimate: reg Lnodds_highANXIETY i.w1HCystert w1Age Race Sex PovStat if sample4part==1 & HNDwave==1
mi estimate: mlogit w1ANXIETYbr i.w1HCystert w1Age Race Sex PovStat if sample4part==1 & HNDwave==1
mi estimate: mlogit w1AnxietyDisorder i.w1HCystert w1Age Race Sex PovStat if sample4part==1 & HNDwave==1



mi estimate: reg w1w3w4bayes1CES i.w1HCystert w1Age Race Sex PovStat if sample4part==1 & HNDwave==1
mi estimate: reg w1w3w4bayes1CES_DA i.w1HCystert w1Age Race Sex PovStat if sample4part==1 & HNDwave==1
mi estimate: reg w1w3w4bayes1CES_IP i.w1HCystert w1Age Race Sex PovStat if sample4part==1 & HNDwave==1
mi estimate: reg w1w3w4bayes1CES_SC i.w1HCystert w1Age Race Sex PovStat if sample4part==1 & HNDwave==1
mi estimate: reg w1w3w4bayes1CES_WB i.w1HCystert w1Age Race Sex PovStat if sample4part==1 & HNDwave==1


save, replace

capture log close
log using "E:\HANDLS_PAPER64_HCYDEPANXIETY_LONG\OUTPUT\TABLE2.smcl", replace


capture drop timew1w4
gen timew1w4=0 if HNDwave==1
replace timew1w4=w4Age-w1Age if HNDwave==4

*******************************TABLE 2: HCys LOAD AT WAVE 1 VS. DEPRESSIVE SYMPTOMS CHANGE OVER TIME: OVERALL**************************************

//MODEL 1: INCLUDE ONLY AGE, SEX, RACE AND POVERTY STATUS///
mi estimate: mixed CES  c.timew1w3w4##c.w1Agecent48 c.timew1w3w4##Sex c.timew1w3w4##Race  c.timew1w3w4##PovStat  c.timew1w3w4##c.invmillsCES ///
c.timew1w3w4##c.Lnw1HCyscenter2p15   ///
if sample4obs==1 || HNDID: timew1w3w4, cov(un)


mi estimate: mixed CES_DA c.timew1w3w4##c.w1Agecent48 c.timew1w3w4##Sex c.timew1w3w4##Race  c.timew1w3w4##PovStat  c.timew1w3w4##c.invmillsCES ///
c.timew1w3w4##c.Lnw1HCyscenter2p15   ///
if sample4obs==1 || HNDID: timew1w3w4, cov(un)



mi estimate: mixed CES_IP c.timew1w3w4##c.w1Agecent48 c.timew1w3w4##Sex c.timew1w3w4##Race  c.timew1w3w4##PovStat  c.timew1w3w4##c.invmillsCES ///
c.timew1w3w4##c.Lnw1HCyscenter2p15   ///
if sample4obs==1 || HNDID: timew1w3w4, cov(un)



mi estimate: mixed CES_SC c.timew1w3w4##c.w1Agecent48 c.timew1w3w4##Sex c.timew1w3w4##Race  c.timew1w3w4##PovStat  c.timew1w3w4##c.invmillsCES ///
c.timew1w3w4##c.Lnw1HCyscenter2p15   ///
if sample4obs==1 || HNDID: timew1w3w4, cov(un)



mi estimate: mixed CES_WB c.timew1w3w4##c.w1Agecent48 c.timew1w3w4##Sex c.timew1w3w4##Race  c.timew1w3w4##PovStat  c.timew1w3w4##c.invmillsCES ///
c.timew1w3w4##c.Lnw1HCyscenter2p15   ///
if sample4obs==1 || HNDID: timew1w3w4, cov(un)




save "finaldata_imputed_FINAL.dta", replace


//MODEL 2: FULL MODEL///

mi estimate: mixed CES  c.timew1w3w4##c.w1Agecent48 c.timew1w3w4##Sex c.timew1w3w4##Race  c.timew1w3w4##PovStat  c.timew1w3w4##w1edubr c.timew1w3w4##c.invmillsCES ///
c.timew1w3w4##w1smoke  c.timew1w3w4##w1currdrugs c.timew1w3w4##c.w1hei2010_total_scorecent43 ///
c.timew1w3w4##c.w1BMIcent30 ///
c.timew1w3w4##c.Lnw1HCyscenter2p15   ///
if sample4obs==1 || HNDID: timew1w3w4, cov(un)


mi estimate: mixed CES_DA c.timew1w3w4##c.w1Agecent48 c.timew1w3w4##Sex c.timew1w3w4##Race  c.timew1w3w4##PovStat  c.timew1w3w4##w1edubr c.timew1w3w4##c.invmillsCES ///
c.timew1w3w4##w1smoke  c.timew1w3w4##w1currdrugs c.timew1w3w4##c.w1hei2010_total_scorecent43 ///
c.timew1w3w4##c.w1BMIcent30 ///
c.timew1w3w4##c.Lnw1HCyscenter2p15   ///
if sample4obs==1 || HNDID: timew1w3w4, cov(un)



mi estimate: mixed CES_IP c.timew1w3w4##c.w1Agecent48 c.timew1w3w4##Sex c.timew1w3w4##Race  c.timew1w3w4##PovStat  c.timew1w3w4##w1edubr c.timew1w3w4##c.invmillsCES ///
c.timew1w3w4##w1smoke  c.timew1w3w4##w1currdrugs c.timew1w3w4##c.w1hei2010_total_scorecent43 ///
c.timew1w3w4##c.w1BMIcent30 ///
c.timew1w3w4##c.Lnw1HCyscenter2p15   ///
if sample4obs==1 || HNDID: timew1w3w4, cov(un)



mi estimate: mixed CES_SC c.timew1w3w4##c.w1Agecent48 c.timew1w3w4##Sex c.timew1w3w4##Race  c.timew1w3w4##PovStat  c.timew1w3w4##w1edubr c.timew1w3w4##c.invmillsCES ///
c.timew1w3w4##w1smoke  c.timew1w3w4##w1currdrugs c.timew1w3w4##c.w1hei2010_total_scorecent43 ///
c.timew1w3w4##c.w1BMIcent30 ///
c.timew1w3w4##c.Lnw1HCyscenter2p15   ///
if sample4obs==1 || HNDID: timew1w3w4, cov(un)



mi estimate: mixed CES_WB c.timew1w3w4##c.w1Agecent48 c.timew1w3w4##Sex c.timew1w3w4##Race  c.timew1w3w4##PovStat  c.timew1w3w4##w1edubr c.timew1w3w4##c.invmillsCES ///
c.timew1w3w4##w1smoke  c.timew1w3w4##w1currdrugs c.timew1w3w4##c.w1hei2010_total_scorecent43 ///
c.timew1w3w4##c.w1BMIcent30 ///
c.timew1w3w4##c.Lnw1HCyscenter2p15   ///
if sample4obs==1 || HNDID: timew1w3w4, cov(un)



capture log close
log using "E:\HANDLS_PAPER64_HCYDEPANXIETY_LONG\OUTPUT\TABLE2_BYSEXANDRACE.smcl", replace

*****************************************************************BY SEX***********************************************************************


*******WOMEN******************


//MODEL 1: INCLUDE ONLY AGE, SEX, RACE AND POVERTY STATUS///
mi estimate: mixed CES  c.timew1w3w4##c.w1Agecent48 c.timew1w3w4##Sex c.timew1w3w4##Race  c.timew1w3w4##PovStat  c.timew1w3w4##c.invmillsCES ///
c.timew1w3w4##c.Lnw1HCyscenter2p15   ///
if sample4obs==1 & Sex==1 || HNDID: timew1w3w4, cov(un)


mi estimate: mixed CES_DA c.timew1w3w4##c.w1Agecent48 c.timew1w3w4##Sex c.timew1w3w4##Race  c.timew1w3w4##PovStat  c.timew1w3w4##c.invmillsCES ///
c.timew1w3w4##c.Lnw1HCyscenter2p15   ///
if sample4obs==1 & Sex==1 || HNDID: timew1w3w4, cov(un)



mi estimate: mixed CES_IP c.timew1w3w4##c.w1Agecent48 c.timew1w3w4##Sex c.timew1w3w4##Race  c.timew1w3w4##PovStat  c.timew1w3w4##c.invmillsCES ///
c.timew1w3w4##c.Lnw1HCyscenter2p15   ///
if sample4obs==1 & Sex==1 || HNDID: timew1w3w4, cov(un)



mi estimate: mixed CES_SC c.timew1w3w4##c.w1Agecent48 c.timew1w3w4##Sex c.timew1w3w4##Race  c.timew1w3w4##PovStat  c.timew1w3w4##c.invmillsCES ///
c.timew1w3w4##c.Lnw1HCyscenter2p15   ///
if sample4obs==1 & Sex==1 || HNDID: timew1w3w4, cov(un)



mi estimate: mixed CES_WB c.timew1w3w4##c.w1Agecent48 c.timew1w3w4##Sex c.timew1w3w4##Race  c.timew1w3w4##PovStat  c.timew1w3w4##c.invmillsCES ///
c.timew1w3w4##c.Lnw1HCyscenter2p15   ///
if sample4obs==1 & Sex==1 || HNDID: timew1w3w4, cov(un)



save "finaldata_imputed_FINAL.dta", replace

//MODEL 2: FULL MODEL///

mi estimate: mixed CES  c.timew1w3w4##c.w1Agecent48 c.timew1w3w4##Sex c.timew1w3w4##Race  c.timew1w3w4##PovStat  c.timew1w3w4##w1edubr c.timew1w3w4##c.invmillsCES ///
c.timew1w3w4##w1smoke  c.timew1w3w4##w1currdrugs c.timew1w3w4##c.w1hei2010_total_scorecent43 ///
c.timew1w3w4##c.w1BMIcent30 ///
c.timew1w3w4##c.Lnw1HCyscenter2p15   ///
if sample4obs==1 & Sex==1 || HNDID: timew1w3w4, cov(un)


mi estimate: mixed CES_DA c.timew1w3w4##c.w1Agecent48 c.timew1w3w4##Sex c.timew1w3w4##Race  c.timew1w3w4##PovStat  c.timew1w3w4##w1edubr c.timew1w3w4##c.invmillsCES ///
c.timew1w3w4##w1smoke  c.timew1w3w4##w1currdrugs c.timew1w3w4##c.w1hei2010_total_scorecent43 ///
c.timew1w3w4##c.w1BMIcent30 ///
c.timew1w3w4##c.Lnw1HCyscenter2p15   ///
if sample4obs==1 & Sex==1 || HNDID: timew1w3w4



mi estimate: mixed CES_IP c.timew1w3w4##c.w1Agecent48 c.timew1w3w4##Sex c.timew1w3w4##Race  c.timew1w3w4##PovStat  c.timew1w3w4##w1edubr c.timew1w3w4##c.invmillsCES ///
c.timew1w3w4##w1smoke  c.timew1w3w4##w1currdrugs c.timew1w3w4##c.w1hei2010_total_scorecent43 ///
c.timew1w3w4##c.w1BMIcent30 ///
c.timew1w3w4##c.Lnw1HCyscenter2p15   ///
if sample4obs==1 & Sex==1 || HNDID: timew1w3w4, cov(un)



mi estimate: mixed CES_SC c.timew1w3w4##c.w1Agecent48 c.timew1w3w4##Sex c.timew1w3w4##Race  c.timew1w3w4##PovStat  c.timew1w3w4##w1edubr c.timew1w3w4##c.invmillsCES ///
c.timew1w3w4##w1smoke  c.timew1w3w4##w1currdrugs c.timew1w3w4##c.w1hei2010_total_scorecent43 ///
c.timew1w3w4##c.w1BMIcent30 ///
c.timew1w3w4##c.Lnw1HCyscenter2p15   ///
if sample4obs==1 & Sex==1 || HNDID: timew1w3w4, cov(un)



mi estimate: mixed CES_WB c.timew1w3w4##c.w1Agecent48 c.timew1w3w4##Sex c.timew1w3w4##Race  c.timew1w3w4##PovStat  c.timew1w3w4##w1edubr c.timew1w3w4##c.invmillsCES ///
c.timew1w3w4##w1smoke  c.timew1w3w4##w1currdrugs c.timew1w3w4##c.w1hei2010_total_scorecent43 ///
c.timew1w3w4##c.w1BMIcent30 ///
c.timew1w3w4##c.Lnw1HCyscenter2p15   ///
if sample4obs==1 & Sex==1 || HNDID: timew1w3w4, cov(un)




********MEN******************

//MODEL 1: INCLUDE ONLY AGE, SEX, RACE AND POVERTY STATUS///
mi estimate: mixed CES  c.timew1w3w4##c.w1Agecent48 c.timew1w3w4##Sex c.timew1w3w4##Race  c.timew1w3w4##PovStat  c.timew1w3w4##c.invmillsCES ///
c.timew1w3w4##c.Lnw1HCyscenter2p15   ///
if sample4obs==1 & Sex==2 || HNDID: timew1w3w4, cov(un)


mi estimate: mixed CES_DA c.timew1w3w4##c.w1Agecent48 c.timew1w3w4##Sex c.timew1w3w4##Race  c.timew1w3w4##PovStat  c.timew1w3w4##c.invmillsCES ///
c.timew1w3w4##c.Lnw1HCyscenter2p15   ///
if sample4obs==1 & Sex==2 || HNDID: timew1w3w4, cov(un)



mi estimate: mixed CES_IP c.timew1w3w4##c.w1Agecent48 c.timew1w3w4##Sex c.timew1w3w4##Race  c.timew1w3w4##PovStat  c.timew1w3w4##c.invmillsCES ///
c.timew1w3w4##c.Lnw1HCyscenter2p15   ///
if sample4obs==1 & Sex==2 || HNDID: timew1w3w4, cov(un)



mi estimate: mixed CES_SC c.timew1w3w4##c.w1Agecent48 c.timew1w3w4##Sex c.timew1w3w4##Race  c.timew1w3w4##PovStat  c.timew1w3w4##c.invmillsCES ///
c.timew1w3w4##c.Lnw1HCyscenter2p15   ///
if sample4obs==1 & Sex==2 || HNDID: timew1w3w4, cov(un)



mi estimate: mixed CES_WB c.timew1w3w4##c.w1Agecent48 c.timew1w3w4##Sex c.timew1w3w4##Race  c.timew1w3w4##PovStat  c.timew1w3w4##c.invmillsCES ///
c.timew1w3w4##c.Lnw1HCyscenter2p15   ///
if sample4obs==1 & Sex==2 || HNDID: timew1w3w4, cov(un)


save "finaldata_imputed_FINAL.dta", replace

//MODEL 2: FULL MODEL///

mi estimate: mixed CES  c.timew1w3w4##c.w1Agecent48 c.timew1w3w4##Sex c.timew1w3w4##Race  c.timew1w3w4##PovStat  c.timew1w3w4##w1edubr c.timew1w3w4##c.invmillsCES ///
c.timew1w3w4##w1smoke  c.timew1w3w4##w1currdrugs c.timew1w3w4##c.w1hei2010_total_scorecent43 ///
c.timew1w3w4##c.w1BMIcent30 ///
c.timew1w3w4##c.Lnw1HCyscenter2p15   ///
if sample4obs==1 & Sex==2 || HNDID: timew1w3w4, cov(un)


mi estimate: mixed CES_DA c.timew1w3w4##c.w1Agecent48 c.timew1w3w4##Sex c.timew1w3w4##Race  c.timew1w3w4##PovStat  c.timew1w3w4##w1edubr c.timew1w3w4##c.invmillsCES ///
c.timew1w3w4##w1smoke  c.timew1w3w4##w1currdrugs c.timew1w3w4##c.w1hei2010_total_scorecent43 ///
c.timew1w3w4##c.w1BMIcent30 ///
c.timew1w3w4##c.Lnw1HCyscenter2p15   ///
if sample4obs==1 & Sex==2 || HNDID: timew1w3w4



mi estimate: mixed CES_IP c.timew1w3w4##c.w1Agecent48 c.timew1w3w4##Sex c.timew1w3w4##Race  c.timew1w3w4##PovStat  c.timew1w3w4##w1edubr c.timew1w3w4##c.invmillsCES ///
c.timew1w3w4##w1smoke  c.timew1w3w4##w1currdrugs c.timew1w3w4##c.w1hei2010_total_scorecent43 ///
c.timew1w3w4##c.w1BMIcent30 ///
c.timew1w3w4##c.Lnw1HCyscenter2p15   ///
if sample4obs==1 & Sex==2 || HNDID: timew1w3w4, cov(un)



mi estimate: mixed CES_SC c.timew1w3w4##c.w1Agecent48 c.timew1w3w4##Sex c.timew1w3w4##Race  c.timew1w3w4##PovStat  c.timew1w3w4##w1edubr c.timew1w3w4##c.invmillsCES ///
c.timew1w3w4##w1smoke  c.timew1w3w4##w1currdrugs c.timew1w3w4##c.w1hei2010_total_scorecent43 ///
c.timew1w3w4##c.w1BMIcent30 ///
c.timew1w3w4##c.Lnw1HCyscenter2p15   ///
if sample4obs==1 & Sex==2 || HNDID: timew1w3w4, cov(un)



mi estimate: mixed CES_WB c.timew1w3w4##c.w1Agecent48 c.timew1w3w4##Sex c.timew1w3w4##Race  c.timew1w3w4##PovStat  c.timew1w3w4##w1edubr c.timew1w3w4##c.invmillsCES ///
c.timew1w3w4##w1smoke  c.timew1w3w4##w1currdrugs c.timew1w3w4##c.w1hei2010_total_scorecent43 ///
c.timew1w3w4##c.w1BMIcent30 ///
c.timew1w3w4##c.Lnw1HCyscenter2p15   ///
if sample4obs==1 & Sex==2 || HNDID: timew1w3w4, cov(un)




******INTERACTION BY SEX***********************************************************************

//MODEL 1: INCLUDE ONLY AGE, SEX, RACE AND POVERTY STATUS///
mi estimate: mixed CES  c.timew1w3w4##c.w1Agecent48 c.timew1w3w4##Sex c.timew1w3w4##Race  c.timew1w3w4##PovStat  c.timew1w3w4##c.invmillsCES ///
c.timew1w3w4##c.Lnw1HCyscenter2p15##Sex   ///
if sample4obs==1  || HNDID: timew1w3w4, cov(un)


mi estimate: mixed CES_DA c.timew1w3w4##c.w1Agecent48 c.timew1w3w4##Sex c.timew1w3w4##Race  c.timew1w3w4##PovStat  c.timew1w3w4##c.invmillsCES ///
c.timew1w3w4##c.Lnw1HCyscenter2p15##Sex   ///
if sample4obs==1  || HNDID: timew1w3w4, cov(un)



mi estimate: mixed CES_IP c.timew1w3w4##c.w1Agecent48 c.timew1w3w4##Sex c.timew1w3w4##Race  c.timew1w3w4##PovStat  c.timew1w3w4##c.invmillsCES ///
c.timew1w3w4##c.Lnw1HCyscenter2p15##Sex   ///
if sample4obs==1  || HNDID: timew1w3w4, cov(un)



mi estimate: mixed CES_SC c.timew1w3w4##c.w1Agecent48 c.timew1w3w4##Sex c.timew1w3w4##Race  c.timew1w3w4##PovStat  c.timew1w3w4##c.invmillsCES ///
c.timew1w3w4##c.Lnw1HCyscenter2p15##Sex   ///
if sample4obs==1  || HNDID: timew1w3w4, cov(un)



mi estimate: mixed CES_WB c.timew1w3w4##c.w1Agecent48 c.timew1w3w4##Sex c.timew1w3w4##Race  c.timew1w3w4##PovStat  c.timew1w3w4##c.invmillsCES ///
c.timew1w3w4##c.Lnw1HCyscenter2p15##Sex   ///
if sample4obs==1  || HNDID: timew1w3w4, cov(un)


save "finaldata_imputed_FINAL.dta", replace


//MODLE 2: FULL MODEL///

mi estimate: mixed CES  c.timew1w3w4##c.w1Agecent48 c.timew1w3w4##Sex c.timew1w3w4##Race  c.timew1w3w4##PovStat  c.timew1w3w4##w1edubr c.timew1w3w4##c.invmillsCES ///
c.timew1w3w4##w1smoke  c.timew1w3w4##w1currdrugs c.timew1w3w4##c.w1hei2010_total_scorecent43 ///
c.timew1w3w4##c.w1BMIcent30 ///
c.timew1w3w4##c.Lnw1HCyscenter2p15##Sex   ///
if sample4obs==1  || HNDID: timew1w3w4, cov(un)


mi estimate: mixed CES_DA c.timew1w3w4##c.w1Agecent48 c.timew1w3w4##Sex c.timew1w3w4##Race  c.timew1w3w4##PovStat  c.timew1w3w4##w1edubr c.timew1w3w4##c.invmillsCES ///
c.timew1w3w4##w1smoke  c.timew1w3w4##w1currdrugs c.timew1w3w4##c.w1hei2010_total_scorecent43 ///
c.timew1w3w4##c.w1BMIcent30 ///
c.timew1w3w4##c.Lnw1HCyscenter2p15##Sex   ///
if sample4obs==1  || HNDID: timew1w3w4, cov(un)



mi estimate: mixed CES_IP c.timew1w3w4##c.w1Agecent48 c.timew1w3w4##Sex c.timew1w3w4##Race  c.timew1w3w4##PovStat  c.timew1w3w4##w1edubr c.timew1w3w4##c.invmillsCES ///
c.timew1w3w4##w1smoke  c.timew1w3w4##w1currdrugs c.timew1w3w4##c.w1hei2010_total_scorecent43 ///
c.timew1w3w4##c.w1BMIcent30 ///
c.timew1w3w4##c.Lnw1HCyscenter2p15##Sex   ///
if sample4obs==1  || HNDID: timew1w3w4, cov(un)



mi estimate: mixed CES_SC c.timew1w3w4##c.w1Agecent48 c.timew1w3w4##Sex c.timew1w3w4##Race  c.timew1w3w4##PovStat  c.timew1w3w4##w1edubr c.timew1w3w4##c.invmillsCES ///
c.timew1w3w4##w1smoke  c.timew1w3w4##w1currdrugs c.timew1w3w4##c.w1hei2010_total_scorecent43 ///
c.timew1w3w4##c.w1BMIcent30 ///
c.timew1w3w4##c.Lnw1HCyscenter2p15##Sex   ///
if sample4obs==1  || HNDID: timew1w3w4, cov(un)



mi estimate: mixed CES_WB c.timew1w3w4##c.w1Agecent48 c.timew1w3w4##Sex c.timew1w3w4##Race  c.timew1w3w4##PovStat  c.timew1w3w4##w1edubr c.timew1w3w4##c.invmillsCES ///
c.timew1w3w4##w1smoke  c.timew1w3w4##w1currdrugs c.timew1w3w4##c.w1hei2010_total_scorecent43 ///
c.timew1w3w4##c.w1BMIcent30 ///
c.timew1w3w4##c.Lnw1HCyscenter2p15##Sex   ///
if sample4obs==1  || HNDID: timew1w3w4, cov(un)



****************************************************************BY RACE********************************************************




****************WHITE*******************

//MODEL 1: INCLUDE ONLY AGE, SEX, RACE AND POVERTY STATUS///

mi estimate: mixed CES  c.timew1w3w4##c.w1Agecent48 c.timew1w3w4##Sex c.timew1w3w4##Race  c.timew1w3w4##PovStat  c.timew1w3w4##c.invmillsCES ///
c.timew1w3w4##c.Lnw1HCyscenter2p15   ///
if sample4obs==1 & Race==1  || HNDID: timew1w3w4


mi estimate: mixed CES_DA c.timew1w3w4##c.w1Agecent48 c.timew1w3w4##Sex c.timew1w3w4##Race  c.timew1w3w4##PovStat  c.timew1w3w4##c.invmillsCES ///
c.timew1w3w4##c.Lnw1HCyscenter2p15   ///
if sample4obs==1 & Race==1  || HNDID: timew1w3w4



mi estimate: mixed CES_IP c.timew1w3w4##c.w1Agecent48 c.timew1w3w4##Sex c.timew1w3w4##Race  c.timew1w3w4##PovStat  c.timew1w3w4##c.invmillsCES ///
c.timew1w3w4##c.Lnw1HCyscenter2p15   ///
if sample4obs==1 & Race==1  || HNDID: timew1w3w4, cov(un)



mi estimate: mixed CES_SC c.timew1w3w4##c.w1Agecent48 c.timew1w3w4##Sex c.timew1w3w4##Race  c.timew1w3w4##PovStat  c.timew1w3w4##c.invmillsCES ///
c.timew1w3w4##c.Lnw1HCyscenter2p15   ///
if sample4obs==1 & Race==1  || HNDID: timew1w3w4, cov(un)



mi estimate: mixed CES_WB c.timew1w3w4##c.w1Agecent48 c.timew1w3w4##Sex c.timew1w3w4##Race  c.timew1w3w4##PovStat  c.timew1w3w4##c.invmillsCES ///
c.timew1w3w4##c.Lnw1HCyscenter2p15   ///
if sample4obs==1 & Race==1  || HNDID: timew1w3w4, cov(un)


save "finaldata_imputed_FINAL.dta", replace


//MODEL 2: FULL MODEL///

mi estimate: mixed CES  c.timew1w3w4##c.w1Agecent48 c.timew1w3w4##Sex c.timew1w3w4##Race  c.timew1w3w4##PovStat  c.timew1w3w4##w1edubr c.timew1w3w4##c.invmillsCES ///
c.timew1w3w4##w1smoke  c.timew1w3w4##w1currdrugs c.timew1w3w4##c.w1hei2010_total_scorecent43 ///
c.timew1w3w4##c.w1BMIcent30 ///
c.timew1w3w4##c.Lnw1HCyscenter2p15   ///
if sample4obs==1 & Race==1  || HNDID: timew1w3w4


mi estimate: mixed CES_DA c.timew1w3w4##c.w1Agecent48 c.timew1w3w4##Sex c.timew1w3w4##Race  c.timew1w3w4##PovStat  c.timew1w3w4##w1edubr c.timew1w3w4##c.invmillsCES ///
c.timew1w3w4##w1smoke  c.timew1w3w4##w1currdrugs c.timew1w3w4##c.w1hei2010_total_scorecent43 ///
c.timew1w3w4##c.w1BMIcent30 ///
c.timew1w3w4##c.Lnw1HCyscenter2p15   ///
if sample4obs==1 & Race==1  || HNDID: timew1w3w4



mi estimate: mixed CES_IP c.timew1w3w4##c.w1Agecent48 c.timew1w3w4##Sex c.timew1w3w4##Race  c.timew1w3w4##PovStat  c.timew1w3w4##w1edubr c.timew1w3w4##c.invmillsCES ///
c.timew1w3w4##w1smoke  c.timew1w3w4##w1currdrugs c.timew1w3w4##c.w1hei2010_total_scorecent43 ///
c.timew1w3w4##c.w1BMIcent30 ///
c.timew1w3w4##c.Lnw1HCyscenter2p15   ///
if sample4obs==1 & Race==1  || HNDID: timew1w3w4, cov(un)



mi estimate: mixed CES_SC c.timew1w3w4##c.w1Agecent48 c.timew1w3w4##Sex c.timew1w3w4##Race  c.timew1w3w4##PovStat  c.timew1w3w4##w1edubr c.timew1w3w4##c.invmillsCES ///
c.timew1w3w4##w1smoke  c.timew1w3w4##w1currdrugs c.timew1w3w4##c.w1hei2010_total_scorecent43 ///
c.timew1w3w4##c.w1BMIcent30 ///
c.timew1w3w4##c.Lnw1HCyscenter2p15   ///
if sample4obs==1 & Race==1  || HNDID: timew1w3w4



mi estimate: mixed CES_WB c.timew1w3w4##c.w1Agecent48 c.timew1w3w4##Sex c.timew1w3w4##Race  c.timew1w3w4##PovStat  c.timew1w3w4##w1edubr c.timew1w3w4##c.invmillsCES ///
c.timew1w3w4##w1smoke  c.timew1w3w4##w1currdrugs c.timew1w3w4##c.w1hei2010_total_scorecent43 ///
c.timew1w3w4##c.w1BMIcent30 ///
c.timew1w3w4##c.Lnw1HCyscenter2p15   ///
if sample4obs==1 & Race==1  || HNDID: timew1w3w4, cov(un)


***************AFRICAN-AMERICAN************


//MODEL 1: INCLUDE ONLY AGE, SEX, RACE AND POVERTY STATUS///
mi estimate: mixed CES  c.timew1w3w4##c.w1Agecent48 c.timew1w3w4##Sex c.timew1w3w4##Race  c.timew1w3w4##PovStat  c.timew1w3w4##c.invmillsCES ///
c.timew1w3w4##c.Lnw1HCyscenter2p15   ///
if sample4obs==1 & Race==2  || HNDID: timew1w3w4, cov(un)


mi estimate: mixed CES_DA c.timew1w3w4##c.w1Agecent48 c.timew1w3w4##Sex c.timew1w3w4##Race  c.timew1w3w4##PovStat  c.timew1w3w4##c.invmillsCES ///
c.timew1w3w4##c.Lnw1HCyscenter2p15   ///
if sample4obs==1 & Race==2  || HNDID: timew1w3w4, cov(un)



mi estimate: mixed CES_IP c.timew1w3w4##c.w1Agecent48 c.timew1w3w4##Sex c.timew1w3w4##Race  c.timew1w3w4##PovStat  c.timew1w3w4##c.invmillsCES ///
c.timew1w3w4##c.Lnw1HCyscenter2p15   ///
if sample4obs==1 & Race==2  || HNDID: timew1w3w4, cov(un)



mi estimate: mixed CES_SC c.timew1w3w4##c.w1Agecent48 c.timew1w3w4##Sex c.timew1w3w4##Race  c.timew1w3w4##PovStat  c.timew1w3w4##c.invmillsCES ///
c.timew1w3w4##c.Lnw1HCyscenter2p15   ///
if sample4obs==1 & Race==2  || HNDID: timew1w3w4, cov(un)



mi estimate: mixed CES_WB c.timew1w3w4##c.w1Agecent48 c.timew1w3w4##Sex c.timew1w3w4##Race  c.timew1w3w4##PovStat  c.timew1w3w4##c.invmillsCES ///
c.timew1w3w4##c.Lnw1HCyscenter2p15   ///
if sample4obs==1 & Race==2  || HNDID: timew1w3w4, cov(un)


save "finaldata_imputed_FINAL.dta", replace




//MODEL 2: FULL MODEL///

mi estimate: mixed CES  c.timew1w3w4##c.w1Agecent48 c.timew1w3w4##Sex c.timew1w3w4##Race  c.timew1w3w4##PovStat  c.timew1w3w4##w1edubr c.timew1w3w4##c.invmillsCES ///
c.timew1w3w4##w1smoke  c.timew1w3w4##w1currdrugs c.timew1w3w4##c.w1hei2010_total_scorecent43 ///
c.timew1w3w4##c.w1BMIcent30 ///
c.timew1w3w4##c.Lnw1HCyscenter2p15   ///
if sample4obs==1 & Race==2  || HNDID: timew1w3w4, cov(un)


mi estimate: mixed CES_DA c.timew1w3w4##c.w1Agecent48 c.timew1w3w4##Sex c.timew1w3w4##Race  c.timew1w3w4##PovStat  c.timew1w3w4##w1edubr c.timew1w3w4##c.invmillsCES ///
c.timew1w3w4##w1smoke  c.timew1w3w4##w1currdrugs c.timew1w3w4##c.w1hei2010_total_scorecent43 ///
c.timew1w3w4##c.w1BMIcent30 ///
c.timew1w3w4##c.Lnw1HCyscenter2p15   ///
if sample4obs==1 & Race==2  || HNDID: timew1w3w4



mi estimate: mixed CES_IP c.timew1w3w4##c.w1Agecent48 c.timew1w3w4##Sex c.timew1w3w4##Race  c.timew1w3w4##PovStat  c.timew1w3w4##w1edubr c.timew1w3w4##c.invmillsCES ///
c.timew1w3w4##w1smoke  c.timew1w3w4##w1currdrugs c.timew1w3w4##c.w1hei2010_total_scorecent43 ///
c.timew1w3w4##c.w1BMIcent30 ///
c.timew1w3w4##c.Lnw1HCyscenter2p15   ///
if sample4obs==1 & Race==2  || HNDID: timew1w3w4, cov(un)



mi estimate: mixed CES_SC c.timew1w3w4##c.w1Agecent48 c.timew1w3w4##Sex c.timew1w3w4##Race  c.timew1w3w4##PovStat  c.timew1w3w4##w1edubr c.timew1w3w4##c.invmillsCES ///
c.timew1w3w4##w1smoke  c.timew1w3w4##w1currdrugs c.timew1w3w4##c.w1hei2010_total_scorecent43 ///
c.timew1w3w4##c.w1BMIcent30 ///
c.timew1w3w4##c.Lnw1HCyscenter2p15   ///
if sample4obs==1 & Race==2  || HNDID: timew1w3w4, cov(un)



mi estimate: mixed CES_WB c.timew1w3w4##c.w1Agecent48 c.timew1w3w4##Sex c.timew1w3w4##Race  c.timew1w3w4##PovStat  c.timew1w3w4##w1edubr c.timew1w3w4##c.invmillsCES ///
c.timew1w3w4##w1smoke  c.timew1w3w4##w1currdrugs c.timew1w3w4##c.w1hei2010_total_scorecent43 ///
c.timew1w3w4##c.w1BMIcent30 ///
c.timew1w3w4##c.Lnw1HCyscenter2p15   ///
if sample4obs==1 & Race==2  || HNDID: timew1w3w4, cov(un)


***************INTERACTION BY RACE***************


//MODEL 1: INCLUDE ONLY AGE, SEX, RACE AND POVERTY STATUS///
mi estimate: mixed CES  c.timew1w3w4##c.w1Agecent48 c.timew1w3w4##Sex c.timew1w3w4##Race  c.timew1w3w4##PovStat  c.timew1w3w4##c.invmillsCES ///
c.timew1w3w4##c.Lnw1HCyscenter2p15##Race   ///
if sample4obs==1  || HNDID: timew1w3w4, cov(un)


mi estimate: mixed CES_DA c.timew1w3w4##c.w1Agecent48 c.timew1w3w4##Sex c.timew1w3w4##Race  c.timew1w3w4##PovStat  c.timew1w3w4##c.invmillsCES ///
c.timew1w3w4##c.Lnw1HCyscenter2p15##Race   ///
if sample4obs==1  || HNDID: timew1w3w4, cov(un)



mi estimate: mixed CES_IP c.timew1w3w4##c.w1Agecent48 c.timew1w3w4##Sex c.timew1w3w4##Race  c.timew1w3w4##PovStat  c.timew1w3w4##c.invmillsCES ///
c.timew1w3w4##c.Lnw1HCyscenter2p15##Race   ///
if sample4obs==1  || HNDID: timew1w3w4, cov(un)



mi estimate: mixed CES_SC c.timew1w3w4##c.w1Agecent48 c.timew1w3w4##Sex c.timew1w3w4##Race  c.timew1w3w4##PovStat  c.timew1w3w4##c.invmillsCES ///
c.timew1w3w4##c.Lnw1HCyscenter2p15##Race   ///
if sample4obs==1  || HNDID: timew1w3w4, cov(un)



mi estimate: mixed CES_WB c.timew1w3w4##c.w1Agecent48 c.timew1w3w4##Sex c.timew1w3w4##Race  c.timew1w3w4##PovStat  c.timew1w3w4##c.invmillsCES ///
c.timew1w3w4##c.Lnw1HCyscenter2p15##Race   ///
if sample4obs==1  || HNDID: timew1w3w4, cov(un)


save "finaldata_imputed_FINAL.dta", replace



//MODEL 2: FULL MODEL///

mi estimate: mixed CES  c.timew1w3w4##c.w1Agecent48 c.timew1w3w4##Sex c.timew1w3w4##Race  c.timew1w3w4##PovStat  c.timew1w3w4##w1edubr c.timew1w3w4##c.invmillsCES ///
c.timew1w3w4##w1smoke  c.timew1w3w4##w1currdrugs c.timew1w3w4##c.w1hei2010_total_scorecent43 ///
c.timew1w3w4##c.w1BMIcent30 ///
c.timew1w3w4##c.Lnw1HCyscenter2p15##Race   ///
if sample4obs==1  || HNDID: timew1w3w4, cov(un)


mi estimate: mixed CES_DA c.timew1w3w4##c.w1Agecent48 c.timew1w3w4##Sex c.timew1w3w4##Race  c.timew1w3w4##PovStat  c.timew1w3w4##w1edubr c.timew1w3w4##c.invmillsCES ///
c.*timew1w3w4##w1smoke  c.timew1w3w4##w1currdrugs c.timew1w3w4##c.w1hei2010_total_scorecent43 ///
c.timew1w3w4##c.w1BMIcent30 ///
c.timew1w3w4##c.Lnw1HCyscenter2p15##Race   ///
if sample4obs==1  || HNDID: timew1w3w4



mi estimate: mixed CES_IP c.timew1w3w4##c.w1Agecent48 c.timew1w3w4##Sex c.timew1w3w4##Race  c.timew1w3w4##PovStat  c.timew1w3w4##w1edubr c.timew1w3w4##c.invmillsCES ///
c.timew1w3w4##w1smoke  c.timew1w3w4##w1currdrugs c.timew1w3w4##c.w1hei2010_total_scorecent43 ///
c.timew1w3w4##c.w1BMIcent30 ///
c.timew1w3w4##c.Lnw1HCyscenter2p15##Race   ///
if sample4obs==1  || HNDID: timew1w3w4, cov(un)



mi estimate: mixed CES_SC c.timew1w3w4##c.w1Agecent48 c.timew1w3w4##Sex c.timew1w3w4##Race  c.timew1w3w4##PovStat  c.timew1w3w4##w1edubr c.timew1w3w4##c.invmillsCES ///
c.timew1w3w4##w1smoke  c.timew1w3w4##w1currdrugs c.timew1w3w4##c.w1hei2010_total_scorecent43 ///
c.timew1w3w4##c.w1BMIcent30 ///
c.timew1w3w4##c.Lnw1HCyscenter2p15##Race   ///
if sample4obs==1  || HNDID: timew1w3w4, cov(un)



mi estimate: mixed CES_WB c.timew1w3w4##c.w1Agecent48 c.timew1w3w4##Sex c.timew1w3w4##Race  c.timew1w3w4##PovStat  c.timew1w3w4##w1edubr c.timew1w3w4##c.invmillsCES ///
c.timew1w3w4##w1smoke  c.timew1w3w4##w1currdrugs c.timew1w3w4##c.w1hei2010_total_scorecent43 ///
c.timew1w3w4##c.w1BMIcent30 ///
c.timew1w3w4##c.Lnw1HCyscenter2p15##Race   ///
if sample4obs==1  || HNDID: timew1w3w4, cov(un)



****************************************************************BY ANXIETY STATUS********************************************************




****************NON-ANXIOUS*******************

//MODEL 1: INCLUDE ONLY AGE, SEX, RACE AND POVERTY STATUS///

mi estimate: mixed CES  c.timew1w3w4##c.w1Agecent48 c.timew1w3w4##Sex c.timew1w3w4##Race  c.timew1w3w4##PovStat  c.timew1w3w4##c.invmillsCES ///
c.timew1w3w4##c.Lnw1HCyscenter2p15   ///
if sample4obs==1 & w1ANXIETYbr==1  || HNDID: timew1w3w4


mi estimate: mixed CES_DA c.timew1w3w4##c.w1Agecent48 c.timew1w3w4##Sex c.timew1w3w4##Race  c.timew1w3w4##PovStat  c.timew1w3w4##c.invmillsCES ///
c.timew1w3w4##c.Lnw1HCyscenter2p15   ///
if sample4obs==1 & w1ANXIETYbr==1  || HNDID: timew1w3w4, cov(un)



mi estimate: mixed CES_IP c.timew1w3w4##c.w1Agecent48 c.timew1w3w4##Sex c.timew1w3w4##Race  c.timew1w3w4##PovStat  c.timew1w3w4##c.invmillsCES ///
c.timew1w3w4##c.Lnw1HCyscenter2p15   ///
if sample4obs==1 & w1ANXIETYbr==1  || HNDID: timew1w3w4, cov(un)



mi estimate: mixed CES_SC c.timew1w3w4##c.w1Agecent48 c.timew1w3w4##Sex c.timew1w3w4##Race  c.timew1w3w4##PovStat  c.timew1w3w4##c.invmillsCES ///
c.timew1w3w4##c.Lnw1HCyscenter2p15   ///
if sample4obs==1 & w1ANXIETYbr==1  || HNDID: timew1w3w4, cov(un)



mi estimate: mixed CES_WB c.timew1w3w4##c.w1Agecent48 c.timew1w3w4##Sex c.timew1w3w4##Race  c.timew1w3w4##PovStat  c.timew1w3w4##c.invmillsCES ///
c.timew1w3w4##c.Lnw1HCyscenter2p15   ///
if sample4obs==1 & w1ANXIETYbr==1  || HNDID: timew1w3w4, cov(un)


save "finaldata_imputed_FINAL.dta", replace



//MODEL 2: FULL MODEL///

mi estimate: mixed CES  c.timew1w3w4##c.w1Agecent48 c.timew1w3w4##Sex c.timew1w3w4##Race  c.timew1w3w4##PovStat  c.timew1w3w4##w1edubr c.timew1w3w4##c.invmillsCES ///
c.timew1w3w4##w1smoke  c.timew1w3w4##w1currdrugs c.timew1w3w4##c.w1hei2010_total_scorecent43 ///
c.timew1w3w4##c.w1BMIcent30 ///
c.timew1w3w4##c.Lnw1HCyscenter2p15   ///
if sample4obs==1 & w1ANXIETYbr==1  || HNDID: timew1w3w4


mi estimate: mixed CES_DA c.timew1w3w4##c.w1Agecent48 c.timew1w3w4##Sex c.timew1w3w4##Race  c.timew1w3w4##PovStat  c.timew1w3w4##w1edubr c.timew1w3w4##c.invmillsCES ///
c.timew1w3w4##w1smoke  c.timew1w3w4##w1currdrugs c.timew1w3w4##c.w1hei2010_total_scorecent43 ///
c.timew1w3w4##c.w1BMIcent30 ///
c.timew1w3w4##c.Lnw1HCyscenter2p15   ///
if sample4obs==1 & w1ANXIETYbr==1  || HNDID: timew1w3w4



mi estimate: mixed CES_IP c.timew1w3w4##c.w1Agecent48 c.timew1w3w4##Sex c.timew1w3w4##Race  c.timew1w3w4##PovStat  c.timew1w3w4##w1edubr c.timew1w3w4##c.invmillsCES ///
c.timew1w3w4##w1smoke  c.timew1w3w4##w1currdrugs c.timew1w3w4##c.w1hei2010_total_scorecent43 ///
c.timew1w3w4##c.w1BMIcent30 ///
c.timew1w3w4##c.Lnw1HCyscenter2p15   ///
if sample4obs==1 & w1ANXIETYbr==1  || HNDID: timew1w3w4



mi estimate: mixed CES_SC c.timew1w3w4##c.w1Agecent48 c.timew1w3w4##Sex c.timew1w3w4##Race  c.timew1w3w4##PovStat  c.timew1w3w4##w1edubr c.timew1w3w4##c.invmillsCES ///
c.timew1w3w4##w1smoke  c.timew1w3w4##w1currdrugs c.timew1w3w4##c.w1hei2010_total_scorecent43 ///
c.timew1w3w4##c.w1BMIcent30 ///
c.timew1w3w4##c.Lnw1HCyscenter2p15   ///
if sample4obs==1 & w1ANXIETYbr==1  || HNDID: timew1w3w4



mi estimate: mixed CES_WB c.timew1w3w4##c.w1Agecent48 c.timew1w3w4##Sex c.timew1w3w4##Race  c.timew1w3w4##PovStat  c.timew1w3w4##w1edubr c.timew1w3w4##c.invmillsCES ///
c.timew1w3w4##w1smoke  c.timew1w3w4##w1currdrugs c.timew1w3w4##c.w1hei2010_total_scorecent43 ///
c.timew1w3w4##c.w1BMIcent30 ///
c.timew1w3w4##c.Lnw1HCyscenter2p15   ///
if sample4obs==1 & w1ANXIETYbr==1  || HNDID: timew1w3w4, cov(un)


***************ANXIOUS************


//MODEL 1: INCLUDE ONLY AGE, SEX, RACE AND POVERTY STATUS///
mi estimate: mixed CES  c.timew1w3w4##c.w1Agecent48 c.timew1w3w4##Sex c.timew1w3w4##Race  c.timew1w3w4##PovStat  c.timew1w3w4##c.invmillsCES ///
c.timew1w3w4##c.Lnw1HCyscenter2p15   ///
if sample4obs==1 & w1ANXIETYbr==2  || HNDID: timew1w3w4, cov(un)


mi estimate: mixed CES_DA c.timew1w3w4##c.w1Agecent48 c.timew1w3w4##Sex c.timew1w3w4##Race  c.timew1w3w4##PovStat  c.timew1w3w4##c.invmillsCES ///
c.timew1w3w4##c.Lnw1HCyscenter2p15   ///
if sample4obs==1 & w1ANXIETYbr==2  || HNDID: timew1w3w4, cov(un)



mi estimate: mixed CES_IP c.timew1w3w4##c.w1Agecent48 c.timew1w3w4##Sex c.timew1w3w4##Race  c.timew1w3w4##PovStat  c.timew1w3w4##c.invmillsCES ///
c.timew1w3w4##c.Lnw1HCyscenter2p15   ///
if sample4obs==1 & w1ANXIETYbr==2  || HNDID: timew1w3w4, cov(un)



mi estimate: mixed CES_SC c.timew1w3w4##c.w1Agecent48 c.timew1w3w4##Sex c.timew1w3w4##Race  c.timew1w3w4##PovStat  c.timew1w3w4##c.invmillsCES ///
c.timew1w3w4##c.Lnw1HCyscenter2p15   ///
if sample4obs==1 & w1ANXIETYbr==2  || HNDID: timew1w3w4, cov(un)



mi estimate: mixed CES_WB c.timew1w3w4##c.w1Agecent48 c.timew1w3w4##Sex c.timew1w3w4##Race  c.timew1w3w4##PovStat  c.timew1w3w4##c.invmillsCES ///
c.timew1w3w4##c.Lnw1HCyscenter2p15   ///
if sample4obs==1 & w1ANXIETYbr==2  || HNDID: timew1w3w4, cov(un)


save "finaldata_imputed_FINAL.dta", replace



//MODEL 2: FULL MODEL///

mi estimate: mixed CES  c.timew1w3w4##c.w1Agecent48 c.timew1w3w4##Sex c.timew1w3w4##Race  c.timew1w3w4##PovStat  c.timew1w3w4##w1edubr c.timew1w3w4##c.invmillsCES ///
c.timew1w3w4##w1smoke  c.timew1w3w4##w1currdrugs c.timew1w3w4##c.w1hei2010_total_scorecent43 ///
c.timew1w3w4##c.w1BMIcent30 ///
c.timew1w3w4##c.Lnw1HCyscenter2p15   ///
if sample4obs==1 & w1ANXIETYbr==2  || HNDID: timew1w3w4, cov(un)


mi estimate: mixed CES_DA c.timew1w3w4##c.w1Agecent48 c.timew1w3w4##Sex c.timew1w3w4##Race  c.timew1w3w4##PovStat  c.timew1w3w4##w1edubr c.timew1w3w4##c.invmillsCES ///
c.timew1w3w4##w1smoke  c.timew1w3w4##w1currdrugs c.timew1w3w4##c.w1hei2010_total_scorecent43 ///
c.timew1w3w4##c.w1BMIcent30 ///
c.timew1w3w4##c.Lnw1HCyscenter2p15   ///
if sample4obs==1 & w1ANXIETYbr==2  || HNDID: timew1w3w4



mi estimate: mixed CES_IP c.timew1w3w4##c.w1Agecent48 c.timew1w3w4##Sex c.timew1w3w4##Race  c.timew1w3w4##PovStat  c.timew1w3w4##w1edubr c.timew1w3w4##c.invmillsCES ///
c.timew1w3w4##w1smoke  c.timew1w3w4##w1currdrugs c.timew1w3w4##c.w1hei2010_total_scorecent43 ///
c.timew1w3w4##c.w1BMIcent30 ///
c.timew1w3w4##c.Lnw1HCyscenter2p15   ///
if sample4obs==1 & w1ANXIETYbr==2  || HNDID: timew1w3w4



mi estimate: mixed CES_SC c.timew1w3w4##c.w1Agecent48 c.timew1w3w4##Sex c.timew1w3w4##Race  c.timew1w3w4##PovStat  c.timew1w3w4##w1edubr c.timew1w3w4##c.invmillsCES ///
c.timew1w3w4##w1smoke  c.timew1w3w4##w1currdrugs c.timew1w3w4##c.w1hei2010_total_scorecent43 ///
c.timew1w3w4##c.w1BMIcent30 ///
c.timew1w3w4##c.Lnw1HCyscenter2p15   ///
if sample4obs==1 & w1ANXIETYbr==2  || HNDID: timew1w3w4, cov(un)



mi estimate: mixed CES_WB c.timew1w3w4##c.w1Agecent48 c.timew1w3w4##Sex c.timew1w3w4##Race  c.timew1w3w4##PovStat  c.timew1w3w4##w1edubr c.timew1w3w4##c.invmillsCES ///
c.timew1w3w4##w1smoke  c.timew1w3w4##w1currdrugs c.timew1w3w4##c.w1hei2010_total_scorecent43 ///
c.timew1w3w4##c.w1BMIcent30 ///
c.timew1w3w4##c.Lnw1HCyscenter2p15   ///
if sample4obs==1 & w1ANXIETYbr==2  || HNDID: timew1w3w4


***************INTERACTION BY ANXIETY STATUS***************


//MODEL 1: INCLUDE ONLY AGE, SEX, RACE AND POVERTY STATUS///
mi estimate: mixed CES  c.timew1w3w4##c.w1Agecent48 c.timew1w3w4##Sex c.timew1w3w4##Race  c.timew1w3w4##PovStat  c.timew1w3w4##c.invmillsCES ///
c.timew1w3w4##c.Lnw1HCyscenter2p15##w1ANXIETYbr   ///
if sample4obs==1  || HNDID: timew1w3w4, cov(un)


mi estimate: mixed CES_DA c.timew1w3w4##c.w1Agecent48 c.timew1w3w4##Sex c.timew1w3w4##Race  c.timew1w3w4##PovStat  c.timew1w3w4##c.invmillsCES ///
c.timew1w3w4##c.Lnw1HCyscenter2p15##w1ANXIETYbr   ///
if sample4obs==1  || HNDID: timew1w3w4, cov(un)



mi estimate: mixed CES_IP c.timew1w3w4##c.w1Agecent48 c.timew1w3w4##Sex c.timew1w3w4##Race  c.timew1w3w4##PovStat  c.timew1w3w4##c.invmillsCES ///
c.timew1w3w4##c.Lnw1HCyscenter2p15##w1ANXIETYbr   ///
if sample4obs==1  || HNDID: timew1w3w4, cov(un)



mi estimate: mixed CES_SC c.timew1w3w4##c.w1Agecent48 c.timew1w3w4##Sex c.timew1w3w4##Race  c.timew1w3w4##PovStat  c.timew1w3w4##c.invmillsCES ///
c.timew1w3w4##c.Lnw1HCyscenter2p15##w1ANXIETYbr   ///
if sample4obs==1  || HNDID: timew1w3w4, cov(un)



mi estimate: mixed CES_WB c.timew1w3w4##c.w1Agecent48 c.timew1w3w4##Sex c.timew1w3w4##Race c.timew1w3w4##PovStat  c.timew1w3w4##c.invmillsCES ///
c.timew1w3w4##c.Lnw1HCyscenter2p15##w1ANXIETYbr   ///
if sample4obs==1  || HNDID: timew1w3w4, cov(un)


save, replace



//MODEL 2: FULL MODEL///

mi estimate: mixed CES  c.timew1w3w4##c.w1Agecent48 c.timew1w3w4##Sex c.timew1w3w4##Race  c.timew1w3w4##PovStat  c.timew1w3w4##w1edubr c.timew1w3w4##c.invmillsCES ///
c.timew1w3w4##w1smoke  c.timew1w3w4##w1currdrugs c.timew1w3w4##c.w1hei2010_total_scorecent43 ///
c.timew1w3w4##c.w1BMIcent30 ///
c.timew1w3w4##c.Lnw1HCyscenter2p15##w1ANXIETYbr   ///
if sample4obs==1  || HNDID: timew1w3w4, cov(un)


mi estimate: mixed CES_DA c.timew1w3w4##c.w1Agecent48 c.timew1w3w4##Sex c.timew1w3w4##Race  c.timew1w3w4##PovStat  c.timew1w3w4##w1edubr c.timew1w3w4##c.invmillsCES ///
c.*timew1w3w4##w1smoke  c.timew1w3w4##w1currdrugs c.timew1w3w4##c.w1hei2010_total_scorecent43 ///
c.timew1w3w4##c.w1BMIcent30 ///
c.timew1w3w4##c.Lnw1HCyscenter2p15##w1ANXIETYbr   ///
if sample4obs==1  || HNDID: timew1w3w4



mi estimate: mixed CES_IP c.timew1w3w4##c.w1Agecent48 c.timew1w3w4##Sex c.timew1w3w4##Race  c.timew1w3w4##PovStat  c.timew1w3w4##w1edubr c.timew1w3w4##c.invmillsCES ///
c.timew1w3w4##w1smoke  c.timew1w3w4##w1currdrugs c.timew1w3w4##c.w1hei2010_total_scorecent43 ///
c.timew1w3w4##c.w1BMIcent30 ///
c.timew1w3w4##c.Lnw1HCyscenter2p15##w1ANXIETYbr   ///
if sample4obs==1  || HNDID: timew1w3w4



mi estimate: mixed CES_SC c.timew1w3w4##c.w1Agecent48 c.timew1w3w4##Sex c.timew1w3w4##Race  c.timew1w3w4##PovStat  c.timew1w3w4##w1edubr c.timew1w3w4##c.invmillsCES ///
c.timew1w3w4##w1smoke  c.timew1w3w4##w1currdrugs c.timew1w3w4##c.w1hei2010_total_scorecent43 ///
c.timew1w3w4##c.w1BMIcent30 ///
c.timew1w3w4##c.Lnw1HCyscenter2p15##w1ANXIETYbr   ///
if sample4obs==1  || HNDID: timew1w3w4, cov(un)



mi estimate: mixed CES_WB c.timew1w3w4##c.w1Agecent48 c.timew1w3w4##Sex c.timew1w3w4##Race c.timew1w3w4##PovStat  c.timew1w3w4##w1edubr c.timew1w3w4##c.invmillsCES ///
c.timew1w3w4##w1smoke  c.timew1w3w4##w1currdrugs c.timew1w3w4##c.w1hei2010_total_scorecent43 ///
c.timew1w3w4##c.w1BMIcent30 ///
c.timew1w3w4##c.Lnw1HCyscenter2p15##w1ANXIETYbr   ///
if sample4obs==1  || HNDID: timew1w3w4, cov(un)




save, replace


capture log close

log using "E:\HANDLS_PAPER64_HCYDEPANXIETY_LONG\OUTPUT\TABLE3.smcl", replace


//////////////TABLE 3: TRAJECTORY OF HCys LOAD VS. DEPRESSIVE SYMPTOMS///////////////////////////////////


//MODEL 1: INCLUDE ONLY AGE, SEX, RACE AND POVERTY STATUS///
mi estimate: mixed CES  c.timew1w3w4##c.w1Agecent48 c.timew1w3w4##Sex c.timew1w3w4##Race  c.timew1w3w4##PovStat  c.timew1w3w4##c.invmillsCES ///
c.timew1w3w4##c.zw1w3w4HCysTRAJ   ///
if sample4obs==1 || HNDID: timew1w3w4, cov(un)


mi estimate: mixed CES_DA c.timew1w3w4##c.w1Agecent48 c.timew1w3w4##Sex c.timew1w3w4##Race  c.timew1w3w4##PovStat  c.timew1w3w4##c.invmillsCES ///
c.timew1w3w4##c.zw1w3w4HCysTRAJ   ///
if sample4obs==1 || HNDID: timew1w3w4, cov(un)



mi estimate: mixed CES_IP c.timew1w3w4##c.w1Agecent48 c.timew1w3w4##Sex c.timew1w3w4##Race  c.timew1w3w4##PovStat  c.timew1w3w4##c.invmillsCES ///
c.timew1w3w4##c.zw1w3w4HCysTRAJ   ///
if sample4obs==1 || HNDID: timew1w3w4, cov(un)



mi estimate: mixed CES_SC c.timew1w3w4##c.w1Agecent48 c.timew1w3w4##Sex c.timew1w3w4##Race  c.timew1w3w4##PovStat  c.timew1w3w4##c.invmillsCES ///
c.timew1w3w4##c.zw1w3w4HCysTRAJ   ///
if sample4obs==1 || HNDID: timew1w3w4, cov(un)



mi estimate: mixed CES_WB c.timew1w3w4##c.w1Agecent48 c.timew1w3w4##Sex c.timew1w3w4##Race  c.timew1w3w4##PovStat  c.timew1w3w4##c.invmillsCES ///
c.timew1w3w4##c.zw1w3w4HCysTRAJ   ///
if sample4obs==1 || HNDID: timew1w3w4, cov(un)


save, replace



//MODEL 2: FULL MODEL///

mi estimate: mixed CES  c.timew1w3w4##c.w1Agecent48 c.timew1w3w4##Sex c.timew1w3w4##Race  c.timew1w3w4##PovStat  c.timew1w3w4##w1edubr c.timew1w3w4##c.invmillsCES ///
c.timew1w3w4##w1smoke  c.timew1w3w4##w1currdrugs c.timew1w3w4##c.w1hei2010_total_scorecent43 ///
c.timew1w3w4##c.w1BMIcent30 ///
c.timew1w3w4##c.zw1w3w4HCysTRAJ   ///
if sample4obs==1 || HNDID: timew1w3w4, cov(un)


mi estimate: mixed CES_DA c.timew1w3w4##c.w1Agecent48 c.timew1w3w4##Sex c.timew1w3w4##Race  c.timew1w3w4##PovStat  c.timew1w3w4##w1edubr c.timew1w3w4##c.invmillsCES ///
c.timew1w3w4##w1smoke  c.timew1w3w4##w1currdrugs c.timew1w3w4##c.w1hei2010_total_scorecent43 ///
c.timew1w3w4##c.w1BMIcent30 ///
c.timew1w3w4##c.zw1w3w4HCysTRAJ   ///
if sample4obs==1 || HNDID: timew1w3w4, cov(un)



mi estimate: mixed CES_IP c.timew1w3w4##c.w1Agecent48 c.timew1w3w4##Sex c.timew1w3w4##Race  c.timew1w3w4##PovStat  c.timew1w3w4##w1edubr c.timew1w3w4##c.invmillsCES ///
c.timew1w3w4##w1smoke  c.timew1w3w4##w1currdrugs c.timew1w3w4##c.w1hei2010_total_scorecent43 ///
c.timew1w3w4##c.w1BMIcent30 ///
c.timew1w3w4##c.zw1w3w4HCysTRAJ   ///
if sample4obs==1 || HNDID: timew1w3w4, cov(un)



mi estimate: mixed CES_SC c.timew1w3w4##c.w1Agecent48 c.timew1w3w4##Sex c.timew1w3w4##Race  c.timew1w3w4##PovStat  c.timew1w3w4##w1edubr c.timew1w3w4##c.invmillsCES ///
c.timew1w3w4##w1smoke  c.timew1w3w4##w1currdrugs c.timew1w3w4##c.w1hei2010_total_scorecent43 ///
c.timew1w3w4##c.w1BMIcent30 ///
c.timew1w3w4##c.zw1w3w4HCysTRAJ   ///
if sample4obs==1 || HNDID: timew1w3w4, cov(un)



mi estimate: mixed CES_WB c.timew1w3w4##c.w1Agecent48 c.timew1w3w4##Sex c.timew1w3w4##Race  c.timew1w3w4##PovStat  c.timew1w3w4##w1edubr c.timew1w3w4##c.invmillsCES ///
c.timew1w3w4##w1smoke  c.timew1w3w4##w1currdrugs c.timew1w3w4##c.w1hei2010_total_scorecent43 ///
c.timew1w3w4##c.w1BMIcent30 ///
c.timew1w3w4##c.zw1w3w4HCysTRAJ   ///
if sample4obs==1 || HNDID: timew1w3w4, cov(un)


save, replace

capture log close

log using "E:\HANDLS_PAPER64_HCYDEPANXIETY_LONG\OUTPUT\TABLE3_BYSEXRACE.smcl", replace


*****************************************************************BY SEX***********************************************************************


*******WOMEN******************


//MODEL 1: INCLUDE ONLY AGE, SEX, RACE AND POVERTY STATUS///
mi estimate: mixed CES  c.timew1w3w4##c.w1Agecent48 c.timew1w3w4##Sex c.timew1w3w4##Race  c.timew1w3w4##PovStat  c.timew1w3w4##c.invmillsCES ///
c.timew1w3w4##c.zw1w3w4HCysTRAJ    ///
if sample4obs==1 & Sex==1 || HNDID: timew1w3w4, cov(un)


mi estimate: mixed CES_DA c.timew1w3w4##c.w1Agecent48 c.timew1w3w4##Sex c.timew1w3w4##Race  c.timew1w3w4##PovStat  c.timew1w3w4##c.invmillsCES ///
c.timew1w3w4##c.zw1w3w4HCysTRAJ    ///
if sample4obs==1 & Sex==1 || HNDID: timew1w3w4, cov(un)



mi estimate: mixed CES_IP c.timew1w3w4##c.w1Agecent48 c.timew1w3w4##Sex c.timew1w3w4##Race  c.timew1w3w4##PovStat  c.timew1w3w4##c.invmillsCES ///
c.timew1w3w4##c.zw1w3w4HCysTRAJ    ///
if sample4obs==1 & Sex==1 || HNDID: timew1w3w4, cov(un)



mi estimate: mixed CES_SC c.timew1w3w4##c.w1Agecent48 c.timew1w3w4##Sex c.timew1w3w4##Race  c.timew1w3w4##PovStat  c.timew1w3w4##c.invmillsCES ///
c.timew1w3w4##c.zw1w3w4HCysTRAJ    ///
if sample4obs==1 & Sex==1 || HNDID: timew1w3w4, cov(un)



mi estimate: mixed CES_WB c.timew1w3w4##c.w1Agecent48 c.timew1w3w4##Sex c.timew1w3w4##Race  c.timew1w3w4##PovStat  c.timew1w3w4##c.invmillsCES ///
c.timew1w3w4##c.zw1w3w4HCysTRAJ    ///
if sample4obs==1 & Sex==1 || HNDID: timew1w3w4, cov(un)


save, replace




//MODEL 2: FULL MODEL///

mi estimate: mixed CES  c.timew1w3w4##c.w1Agecent48 c.timew1w3w4##Sex c.timew1w3w4##Race  c.timew1w3w4##PovStat  c.timew1w3w4##w1edubr c.timew1w3w4##c.invmillsCES ///
c.timew1w3w4##w1smoke  c.timew1w3w4##w1currdrugs c.timew1w3w4##c.w1hei2010_total_scorecent43 ///
c.timew1w3w4##c.w1BMIcent30 ///
c.timew1w3w4##c.zw1w3w4HCysTRAJ    ///
if sample4obs==1 & Sex==1 || HNDID: timew1w3w4, cov(un)


mi estimate: mixed CES_DA c.timew1w3w4##c.w1Agecent48 c.timew1w3w4##Sex c.timew1w3w4##Race  c.timew1w3w4##PovStat  c.timew1w3w4##w1edubr c.timew1w3w4##c.invmillsCES ///
c.timew1w3w4##w1smoke  c.timew1w3w4##w1currdrugs c.timew1w3w4##c.w1hei2010_total_scorecent43 ///
c.timew1w3w4##c.w1BMIcent30 ///
c.timew1w3w4##c.zw1w3w4HCysTRAJ    ///
if sample4obs==1 & Sex==1 || HNDID: timew1w3w4, cov(un)



mi estimate: mixed CES_IP c.timew1w3w4##c.w1Agecent48 c.timew1w3w4##Sex c.timew1w3w4##Race  c.timew1w3w4##PovStat  c.timew1w3w4##w1edubr c.timew1w3w4##c.invmillsCES ///
c.timew1w3w4##w1smoke  c.timew1w3w4##w1currdrugs c.timew1w3w4##c.w1hei2010_total_scorecent43 ///
c.timew1w3w4##c.w1BMIcent30 ///
c.timew1w3w4##c.zw1w3w4HCysTRAJ    ///
if sample4obs==1 & Sex==1 || HNDID: timew1w3w4, cov(un)



mi estimate: mixed CES_SC c.timew1w3w4##c.w1Agecent48 c.timew1w3w4##Sex c.timew1w3w4##Race  c.timew1w3w4##PovStat  c.timew1w3w4##w1edubr c.timew1w3w4##c.invmillsCES ///
c.timew1w3w4##w1smoke  c.timew1w3w4##w1currdrugs c.timew1w3w4##c.w1hei2010_total_scorecent43 ///
c.timew1w3w4##c.w1BMIcent30 ///
c.timew1w3w4##c.zw1w3w4HCysTRAJ    ///
if sample4obs==1 & Sex==1 || HNDID: timew1w3w4, cov(un)



mi estimate: mixed CES_WB c.timew1w3w4##c.w1Agecent48 c.timew1w3w4##Sex c.timew1w3w4##Race  c.timew1w3w4##PovStat  c.timew1w3w4##w1edubr c.timew1w3w4##c.invmillsCES ///
c.timew1w3w4##w1smoke  c.timew1w3w4##w1currdrugs c.timew1w3w4##c.w1hei2010_total_scorecent43 ///
c.timew1w3w4##c.w1BMIcent30 ///
c.timew1w3w4##c.zw1w3w4HCysTRAJ    ///
if sample4obs==1 & Sex==1 || HNDID: timew1w3w4, cov(un)




********MEN******************

//MODEL 1: INCLUDE ONLY AGE, SEX, RACE AND POVERTY STATUS///
mi estimate: mixed CES  c.timew1w3w4##c.w1Agecent48 c.timew1w3w4##Sex c.timew1w3w4##Race  c.timew1w3w4##PovStat  c.timew1w3w4##c.invmillsCES ///
c.timew1w3w4##c.zw1w3w4HCysTRAJ    ///
if sample4obs==1 & Sex==2 || HNDID: timew1w3w4, cov(un)


mi estimate: mixed CES_DA c.timew1w3w4##c.w1Agecent48 c.timew1w3w4##Sex c.timew1w3w4##Race  c.timew1w3w4##PovStat  c.timew1w3w4##c.invmillsCES ///
c.timew1w3w4##c.zw1w3w4HCysTRAJ    ///
if sample4obs==1 & Sex==2 || HNDID: timew1w3w4, cov(un)



mi estimate: mixed CES_IP c.timew1w3w4##c.w1Agecent48 c.timew1w3w4##Sex c.timew1w3w4##Race  c.timew1w3w4##PovStat  c.timew1w3w4##c.invmillsCES ///
c.timew1w3w4##c.zw1w3w4HCysTRAJ    ///
if sample4obs==1 & Sex==2 || HNDID: timew1w3w4, cov(un)



mi estimate: mixed CES_SC c.timew1w3w4##c.w1Agecent48 c.timew1w3w4##Sex c.timew1w3w4##Race  c.timew1w3w4##PovStat  c.timew1w3w4##c.invmillsCES ///
c.timew1w3w4##c.zw1w3w4HCysTRAJ    ///
if sample4obs==1 & Sex==2 || HNDID: timew1w3w4, cov(un)



mi estimate: mixed CES_WB c.timew1w3w4##c.w1Agecent48 c.timew1w3w4##Sex c.timew1w3w4##Race  c.timew1w3w4##PovStat  c.timew1w3w4##c.invmillsCES ///
c.timew1w3w4##c.zw1w3w4HCysTRAJ    ///
if sample4obs==1 & Sex==2 || HNDID: timew1w3w4, cov(un)


save, replace


//MODEL 2: FULL MODEL///

mi estimate: mixed CES  c.timew1w3w4##c.w1Agecent48 c.timew1w3w4##Sex c.timew1w3w4##Race  c.timew1w3w4##PovStat  c.timew1w3w4##w1edubr c.timew1w3w4##c.invmillsCES ///
c.timew1w3w4##w1smoke  c.timew1w3w4##w1currdrugs c.timew1w3w4##c.w1hei2010_total_scorecent43 ///
c.timew1w3w4##c.w1BMIcent30 ///
c.timew1w3w4##c.zw1w3w4HCysTRAJ    ///
if sample4obs==1 & Sex==2 || HNDID: timew1w3w4, cov(un)


mi estimate: mixed CES_DA c.timew1w3w4##c.w1Agecent48 c.timew1w3w4##Sex c.timew1w3w4##Race  c.timew1w3w4##PovStat  c.timew1w3w4##w1edubr c.timew1w3w4##c.invmillsCES ///
c.timew1w3w4##w1smoke  c.timew1w3w4##w1currdrugs c.timew1w3w4##c.w1hei2010_total_scorecent43 ///
c.timew1w3w4##c.w1BMIcent30 ///
c.timew1w3w4##c.zw1w3w4HCysTRAJ    ///
if sample4obs==1 & Sex==2 || HNDID: timew1w3w4, cov(un)



mi estimate: mixed CES_IP c.timew1w3w4##c.w1Agecent48 c.timew1w3w4##Sex c.timew1w3w4##Race  c.timew1w3w4##PovStat  c.timew1w3w4##w1edubr c.timew1w3w4##c.invmillsCES ///
c.timew1w3w4##w1smoke  c.timew1w3w4##w1currdrugs c.timew1w3w4##c.w1hei2010_total_scorecent43 ///
c.timew1w3w4##c.w1BMIcent30 ///
c.timew1w3w4##c.zw1w3w4HCysTRAJ    ///
if sample4obs==1 & Sex==2 || HNDID: timew1w3w4, cov(un)



mi estimate: mixed CES_SC c.timew1w3w4##c.w1Agecent48 c.timew1w3w4##Sex c.timew1w3w4##Race  c.timew1w3w4##PovStat  c.timew1w3w4##w1edubr c.timew1w3w4##c.invmillsCES ///
c.timew1w3w4##w1smoke  c.timew1w3w4##w1currdrugs c.timew1w3w4##c.w1hei2010_total_scorecent43 ///
c.timew1w3w4##c.w1BMIcent30 ///
c.timew1w3w4##c.zw1w3w4HCysTRAJ    ///
if sample4obs==1 & Sex==2 || HNDID: timew1w3w4, cov(un)



mi estimate: mixed CES_WB c.timew1w3w4##c.w1Agecent48 c.timew1w3w4##Sex c.timew1w3w4##Race  c.timew1w3w4##PovStat  c.timew1w3w4##w1edubr c.timew1w3w4##c.invmillsCES ///
c.timew1w3w4##w1smoke  c.timew1w3w4##w1currdrugs c.timew1w3w4##c.w1hei2010_total_scorecent43 ///
c.timew1w3w4##c.w1BMIcent30 ///
c.timew1w3w4##c.zw1w3w4HCysTRAJ    ///
if sample4obs==1 & Sex==2 || HNDID: timew1w3w4, cov(un)




******INTERACTION BY SEX***********************************************************************

//MODEL 1: INCLUDE ONLY AGE, SEX, RACE AND POVERTY STATUS///
mi estimate: mixed CES  c.timew1w3w4##c.w1Agecent48 c.timew1w3w4##Sex c.timew1w3w4##Race  c.timew1w3w4##PovStat  c.timew1w3w4##c.invmillsCES ///
c.timew1w3w4##c.zw1w3w4HCysTRAJ ##Sex   ///
if sample4obs==1  || HNDID: timew1w3w4, cov(un)


mi estimate: mixed CES_DA c.timew1w3w4##c.w1Agecent48 c.timew1w3w4##Sex c.timew1w3w4##Race  c.timew1w3w4##PovStat  c.timew1w3w4##c.invmillsCES ///
c.timew1w3w4##c.zw1w3w4HCysTRAJ ##Sex   ///
if sample4obs==1  || HNDID: timew1w3w4, cov(un)



mi estimate: mixed CES_IP c.timew1w3w4##c.w1Agecent48 c.timew1w3w4##Sex c.timew1w3w4##Race  c.timew1w3w4##PovStat  c.timew1w3w4##c.invmillsCES ///
c.timew1w3w4##c.zw1w3w4HCysTRAJ ##Sex   ///
if sample4obs==1  || HNDID: timew1w3w4, cov(un)



mi estimate: mixed CES_SC c.timew1w3w4##c.w1Agecent48 c.timew1w3w4##Sex c.timew1w3w4##Race  c.timew1w3w4##PovStat  c.timew1w3w4##c.invmillsCES ///
c.timew1w3w4##c.zw1w3w4HCysTRAJ ##Sex   ///
if sample4obs==1  || HNDID: timew1w3w4, cov(un)



mi estimate: mixed CES_WB c.timew1w3w4##c.w1Agecent48 c.timew1w3w4##Sex c.timew1w3w4##Race  c.timew1w3w4##PovStat  c.timew1w3w4##c.invmillsCES ///
c.timew1w3w4##c.zw1w3w4HCysTRAJ ##Sex   ///
if sample4obs==1  || HNDID: timew1w3w4, cov(un)


save, replace



//MODEL 2: FULL MODEL///

mi estimate: mixed CES  c.timew1w3w4##c.w1Agecent48 c.timew1w3w4##Sex c.timew1w3w4##Race  c.timew1w3w4##PovStat  c.timew1w3w4##w1edubr c.timew1w3w4##c.invmillsCES ///
c.timew1w3w4##w1smoke  c.timew1w3w4##w1currdrugs c.timew1w3w4##c.w1hei2010_total_scorecent43 ///
c.timew1w3w4##c.w1BMIcent30 ///
c.timew1w3w4##c.zw1w3w4HCysTRAJ ##Sex   ///
if sample4obs==1  || HNDID: timew1w3w4, cov(un)


mi estimate: mixed CES_DA c.timew1w3w4##c.w1Agecent48 c.timew1w3w4##Sex c.timew1w3w4##Race  c.timew1w3w4##PovStat  c.timew1w3w4##w1edubr c.timew1w3w4##c.invmillsCES ///
c.timew1w3w4##w1smoke  c.timew1w3w4##w1currdrugs c.timew1w3w4##c.w1hei2010_total_scorecent43 ///
c.timew1w3w4##c.w1BMIcent30 ///
c.timew1w3w4##c.zw1w3w4HCysTRAJ ##Sex   ///
if sample4obs==1  || HNDID: timew1w3w4, cov(un)



mi estimate: mixed CES_IP c.timew1w3w4##c.w1Agecent48 c.timew1w3w4##Sex c.timew1w3w4##Race  c.timew1w3w4##PovStat  c.timew1w3w4##w1edubr c.timew1w3w4##c.invmillsCES ///
c.timew1w3w4##w1smoke  c.timew1w3w4##w1currdrugs c.timew1w3w4##c.w1hei2010_total_scorecent43 ///
c.timew1w3w4##c.w1BMIcent30 ///
c.timew1w3w4##c.zw1w3w4HCysTRAJ ##Sex   ///
if sample4obs==1  || HNDID: timew1w3w4, cov(un)



mi estimate: mixed CES_SC c.timew1w3w4##c.w1Agecent48 c.timew1w3w4##Sex c.timew1w3w4##Race  c.timew1w3w4##PovStat  c.timew1w3w4##w1edubr c.timew1w3w4##c.invmillsCES ///
c.timew1w3w4##w1smoke  c.timew1w3w4##w1currdrugs c.timew1w3w4##c.w1hei2010_total_scorecent43 ///
c.timew1w3w4##c.w1BMIcent30 ///
c.timew1w3w4##c.zw1w3w4HCysTRAJ ##Sex   ///
if sample4obs==1  || HNDID: timew1w3w4, cov(un)



mi estimate: mixed CES_WB c.timew1w3w4##c.w1Agecent48 c.timew1w3w4##Sex c.timew1w3w4##Race  c.timew1w3w4##PovStat  c.timew1w3w4##w1edubr c.timew1w3w4##c.invmillsCES ///
c.timew1w3w4##w1smoke  c.timew1w3w4##w1currdrugs c.timew1w3w4##c.w1hei2010_total_scorecent43 ///
c.timew1w3w4##c.w1BMIcent30 ///
c.timew1w3w4##c.zw1w3w4HCysTRAJ ##Sex   ///
if sample4obs==1  || HNDID: timew1w3w4, cov(un)



****************************************************************BY RACE********************************************************




****************WHITE*******************

//MODEL 1: INCLUDE ONLY AGE, SEX, RACE AND POVERTY STATUS///
mi estimate: mixed CES  c.timew1w3w4##c.w1Agecent48 c.timew1w3w4##Sex c.timew1w3w4##Race  c.timew1w3w4##PovStat  c.timew1w3w4##c.invmillsCES ///
c.timew1w3w4##c.zw1w3w4HCysTRAJ    ///
if sample4obs==1 & Race==1  || HNDID: timew1w3w4, cov(un)


mi estimate: mixed CES_DA c.timew1w3w4##c.w1Agecent48 c.timew1w3w4##Sex c.timew1w3w4##Race  c.timew1w3w4##PovStat  c.timew1w3w4##c.invmillsCES ///
c.timew1w3w4##c.zw1w3w4HCysTRAJ    ///
if sample4obs==1 & Race==1  || HNDID: timew1w3w4



mi estimate: mixed CES_IP c.timew1w3w4##c.w1Agecent48 c.timew1w3w4##Sex c.timew1w3w4##Race  c.timew1w3w4##PovStat  c.timew1w3w4##c.invmillsCES ///
c.timew1w3w4##c.zw1w3w4HCysTRAJ    ///
if sample4obs==1 & Race==1  || HNDID: timew1w3w4, cov(un)



mi estimate: mixed CES_SC c.timew1w3w4##c.w1Agecent48 c.timew1w3w4##Sex c.timew1w3w4##Race  c.timew1w3w4##PovStat  c.timew1w3w4##c.invmillsCES ///
c.timew1w3w4##c.zw1w3w4HCysTRAJ    ///
if sample4obs==1 & Race==1  || HNDID: timew1w3w4, cov(un)



mi estimate: mixed CES_WB c.timew1w3w4##c.w1Agecent48 c.timew1w3w4##Sex c.timew1w3w4##Race  c.timew1w3w4##PovStat  c.timew1w3w4##c.invmillsCES ///
c.timew1w3w4##c.zw1w3w4HCysTRAJ    ///
if sample4obs==1 & Race==1  || HNDID: timew1w3w4, cov(un)


save, replace



//MODEL 4: FULL MODEL///

mi estimate: mixed CES  c.timew1w3w4##c.w1Agecent48 c.timew1w3w4##Sex c.timew1w3w4##Race  c.timew1w3w4##PovStat  c.timew1w3w4##w1edubr c.timew1w3w4##c.invmillsCES ///
c.timew1w3w4##w1smoke  c.timew1w3w4##w1currdrugs c.timew1w3w4##c.w1hei2010_total_scorecent43 ///
c.timew1w3w4##c.w1BMIcent30 ///
c.timew1w3w4##c.zw1w3w4HCysTRAJ    ///
if sample4obs==1 & Race==1  || HNDID: timew1w3w4, cov(un)


mi estimate: mixed CES_DA c.timew1w3w4##c.w1Agecent48 c.timew1w3w4##Sex c.timew1w3w4##Race  c.timew1w3w4##PovStat  c.timew1w3w4##w1edubr c.timew1w3w4##c.invmillsCES ///
c.timew1w3w4##w1smoke  c.timew1w3w4##w1currdrugs c.timew1w3w4##c.w1hei2010_total_scorecent43 ///
c.timew1w3w4##c.w1BMIcent30 ///
c.timew1w3w4##c.zw1w3w4HCysTRAJ    ///
if sample4obs==1 & Race==1  || HNDID: timew1w3w4, cov(un)



mi estimate: mixed CES_IP c.timew1w3w4##c.w1Agecent48 c.timew1w3w4##Sex c.timew1w3w4##Race  c.timew1w3w4##PovStat  c.timew1w3w4##w1edubr c.timew1w3w4##c.invmillsCES ///
c.timew1w3w4##w1smoke  c.timew1w3w4##w1currdrugs c.timew1w3w4##c.w1hei2010_total_scorecent43 ///
c.timew1w3w4##c.w1BMIcent30 ///
c.timew1w3w4##c.zw1w3w4HCysTRAJ    ///
if sample4obs==1 & Race==1  || HNDID: timew1w3w4, cov(un)



mi estimate: mixed CES_SC c.timew1w3w4##c.w1Agecent48 c.timew1w3w4##Sex c.timew1w3w4##Race  c.timew1w3w4##PovStat  c.timew1w3w4##w1edubr c.timew1w3w4##c.invmillsCES ///
c.timew1w3w4##w1smoke  c.timew1w3w4##w1currdrugs c.timew1w3w4##c.w1hei2010_total_scorecent43 ///
c.timew1w3w4##c.w1BMIcent30 ///
c.timew1w3w4##c.zw1w3w4HCysTRAJ    ///
if sample4obs==1 & Race==1  || HNDID: timew1w3w4



mi estimate: mixed CES_WB c.timew1w3w4##c.w1Agecent48 c.timew1w3w4##Sex c.timew1w3w4##Race  c.timew1w3w4##PovStat  c.timew1w3w4##w1edubr c.timew1w3w4##c.invmillsCES ///
c.timew1w3w4##w1smoke  c.timew1w3w4##w1currdrugs c.timew1w3w4##c.w1hei2010_total_scorecent43 ///
c.timew1w3w4##c.w1BMIcent30 ///
c.timew1w3w4##c.zw1w3w4HCysTRAJ    ///
if sample4obs==1 & Race==1  || HNDID: timew1w3w4, cov(un)


***************AFRICAN-AMERICAN************


//MODEL 1: INCLUDE ONLY AGE, SEX, RACE AND POVERTY STATUS///
mi estimate: mixed CES  c.timew1w3w4##c.w1Agecent48 c.timew1w3w4##Sex c.timew1w3w4##Race  c.timew1w3w4##PovStat  c.timew1w3w4##c.invmillsCES ///
c.timew1w3w4##c.zw1w3w4HCysTRAJ    ///
if sample4obs==1 & Race==2  || HNDID: timew1w3w4, cov(un)


mi estimate: mixed CES_DA c.timew1w3w4##c.w1Agecent48 c.timew1w3w4##Sex c.timew1w3w4##Race  c.timew1w3w4##PovStat  c.timew1w3w4##c.invmillsCES ///
c.timew1w3w4##c.zw1w3w4HCysTRAJ    ///
if sample4obs==1 & Race==2  || HNDID: timew1w3w4, cov(un)



mi estimate: mixed CES_IP c.timew1w3w4##c.w1Agecent48 c.timew1w3w4##Sex c.timew1w3w4##Race  c.timew1w3w4##PovStat  c.timew1w3w4##c.invmillsCES ///
c.timew1w3w4##c.zw1w3w4HCysTRAJ    ///
if sample4obs==1 & Race==2  || HNDID: timew1w3w4, cov(un)



mi estimate: mixed CES_SC c.timew1w3w4##c.w1Agecent48 c.timew1w3w4##Sex c.timew1w3w4##Race  c.timew1w3w4##PovStat  c.timew1w3w4##c.invmillsCES ///
c.timew1w3w4##c.zw1w3w4HCysTRAJ    ///
if sample4obs==1 & Race==2  || HNDID: timew1w3w4, cov(un)



mi estimate: mixed CES_WB c.timew1w3w4##c.w1Agecent48 c.timew1w3w4##Sex c.timew1w3w4##Race  c.timew1w3w4##PovStat  c.timew1w3w4##c.invmillsCES ///
c.timew1w3w4##c.zw1w3w4HCysTRAJ    ///
if sample4obs==1 & Race==2  || HNDID: timew1w3w4, cov(un)


save, replace




//MODEL 2: FULL MODEL///

mi estimate: mixed CES  c.timew1w3w4##c.w1Agecent48 c.timew1w3w4##Sex c.timew1w3w4##Race  c.timew1w3w4##PovStat  c.timew1w3w4##w1edubr c.timew1w3w4##c.invmillsCES ///
c.timew1w3w4##w1smoke  c.timew1w3w4##w1currdrugs c.timew1w3w4##c.w1hei2010_total_scorecent43 ///
c.timew1w3w4##c.w1BMIcent30 ///
c.timew1w3w4##c.zw1w3w4HCysTRAJ    ///
if sample4obs==1 & Race==2  || HNDID: timew1w3w4, cov(un)


mi estimate: mixed CES_DA c.timew1w3w4##c.w1Agecent48 c.timew1w3w4##Sex c.timew1w3w4##Race  c.timew1w3w4##PovStat  c.timew1w3w4##w1edubr c.timew1w3w4##c.invmillsCES ///
c.timew1w3w4##w1smoke  c.timew1w3w4##w1currdrugs c.timew1w3w4##c.w1hei2010_total_scorecent43 ///
c.timew1w3w4##c.w1BMIcent30 ///
c.timew1w3w4##c.zw1w3w4HCysTRAJ    ///
if sample4obs==1 & Race==2  || HNDID: timew1w3w4



mi estimate: mixed CES_IP c.timew1w3w4##c.w1Agecent48 c.timew1w3w4##Sex c.timew1w3w4##Race  c.timew1w3w4##PovStat  c.timew1w3w4##w1edubr c.timew1w3w4##c.invmillsCES ///
c.timew1w3w4##w1smoke  c.timew1w3w4##w1currdrugs c.timew1w3w4##c.w1hei2010_total_scorecent43 ///
c.timew1w3w4##c.w1BMIcent30 ///
c.timew1w3w4##c.zw1w3w4HCysTRAJ    ///
if sample4obs==1 & Race==2  || HNDID: timew1w3w4, cov(un)



mi estimate: mixed CES_SC c.timew1w3w4##c.w1Agecent48 c.timew1w3w4##Sex c.timew1w3w4##Race  c.timew1w3w4##PovStat  c.timew1w3w4##w1edubr c.timew1w3w4##c.invmillsCES ///
c.timew1w3w4##w1smoke  c.timew1w3w4##w1currdrugs c.timew1w3w4##c.w1hei2010_total_scorecent43 ///
c.timew1w3w4##c.w1BMIcent30 ///
c.timew1w3w4##c.zw1w3w4HCysTRAJ    ///
if sample4obs==1 & Race==2  || HNDID: timew1w3w4, cov(un)



mi estimate: mixed CES_WB c.timew1w3w4##c.w1Agecent48 c.timew1w3w4##Sex c.timew1w3w4##Race  c.timew1w3w4##PovStat  c.timew1w3w4##w1edubr c.timew1w3w4##c.invmillsCES ///
c.timew1w3w4##w1smoke  c.timew1w3w4##w1currdrugs c.timew1w3w4##c.w1hei2010_total_scorecent43 ///
c.timew1w3w4##c.w1BMIcent30 ///
c.timew1w3w4##c.zw1w3w4HCysTRAJ    ///
if sample4obs==1 & Race==2  || HNDID: timew1w3w4, cov(un)


***************INTERACTION BY RACE***************


//MODEL 1: INCLUDE ONLY AGE, SEX, RACE AND POVERTY STATUS///
mi estimate: mixed CES  c.timew1w3w4##c.w1Agecent48 c.timew1w3w4##Sex c.timew1w3w4##Race  c.timew1w3w4##PovStat  c.timew1w3w4##c.invmillsCES ///
c.timew1w3w4##c.zw1w3w4HCysTRAJ ##Race   ///
if sample4obs==1  || HNDID: timew1w3w4, cov(un)


mi estimate: mixed CES_DA c.timew1w3w4##c.w1Agecent48 c.timew1w3w4##Sex c.timew1w3w4##Race  c.timew1w3w4##PovStat  c.timew1w3w4##c.invmillsCES ///
c.timew1w3w4##c.zw1w3w4HCysTRAJ ##Race   ///
if sample4obs==1  || HNDID: timew1w3w4, cov(un)



mi estimate: mixed CES_IP c.timew1w3w4##c.w1Agecent48 c.timew1w3w4##Sex c.timew1w3w4##Race  c.timew1w3w4##PovStat  c.timew1w3w4##c.invmillsCES ///
c.timew1w3w4##c.zw1w3w4HCysTRAJ ##Race   ///
if sample4obs==1  || HNDID: timew1w3w4, cov(un)



mi estimate: mixed CES_SC c.timew1w3w4##c.w1Agecent48 c.timew1w3w4##Sex c.timew1w3w4##Race  c.timew1w3w4##PovStat  c.timew1w3w4##c.invmillsCES ///
c.timew1w3w4##c.zw1w3w4HCysTRAJ ##Race   ///
if sample4obs==1  || HNDID: timew1w3w4, cov(un)



mi estimate: mixed CES_WB c.timew1w3w4##c.w1Agecent48 c.timew1w3w4##Sex c.timew1w3w4##Race  c.timew1w3w4##PovStat  c.timew1w3w4##c.invmillsCES ///
c.timew1w3w4##c.zw1w3w4HCysTRAJ ##Race   ///
if sample4obs==1  || HNDID: timew1w3w4, cov(un)


save, replace



//MODEL 2: FULL MODEL///

mi estimate: mixed CES  c.timew1w3w4##c.w1Agecent48 c.timew1w3w4##Sex c.timew1w3w4##Race  c.timew1w3w4##PovStat  c.timew1w3w4##w1edubr c.timew1w3w4##c.invmillsCES ///
c.timew1w3w4##w1smoke  c.timew1w3w4##w1currdrugs c.timew1w3w4##c.w1hei2010_total_scorecent43 ///
c.timew1w3w4##c.w1BMIcent30 ///
c.timew1w3w4##c.zw1w3w4HCysTRAJ ##Race   ///
if sample4obs==1  || HNDID: timew1w3w4, cov(un)


mi estimate: mixed CES_DA c.timew1w3w4##c.w1Agecent48 c.timew1w3w4##Sex c.timew1w3w4##Race  c.timew1w3w4##PovStat  c.timew1w3w4##w1edubr c.timew1w3w4##c.invmillsCES ///
c.timew1w3w4##w1smoke  c.timew1w3w4##w1currdrugs c.timew1w3w4##c.w1hei2010_total_scorecent43 ///
c.timew1w3w4##c.w1BMIcent30 ///
c.timew1w3w4##c.zw1w3w4HCysTRAJ ##Race   ///
if sample4obs==1  || HNDID: timew1w3w4, cov(un)



mi estimate: mixed CES_IP c.timew1w3w4##c.w1Agecent48 c.timew1w3w4##Sex c.timew1w3w4##Race  c.timew1w3w4##PovStat  c.timew1w3w4##w1edubr c.timew1w3w4##c.invmillsCES ///
c.timew1w3w4##w1smoke  c.timew1w3w4##w1currdrugs c.timew1w3w4##c.w1hei2010_total_scorecent43 ///
c.timew1w3w4##c.w1BMIcent30 ///
c.timew1w3w4##c.zw1w3w4HCysTRAJ ##Race   ///
if sample4obs==1  || HNDID: timew1w3w4, cov(un)



mi estimate: mixed CES_SC c.timew1w3w4##c.w1Agecent48 c.timew1w3w4##Sex c.timew1w3w4##Race  c.timew1w3w4##PovStat  c.timew1w3w4##w1edubr c.timew1w3w4##c.invmillsCES ///
c.timew1w3w4##w1smoke  c.timew1w3w4##w1currdrugs c.timew1w3w4##c.w1hei2010_total_scorecent43 ///
c.timew1w3w4##c.w1BMIcent30 ///
c.timew1w3w4##c.zw1w3w4HCysTRAJ ##Race   ///
if sample4obs==1  || HNDID: timew1w3w4, cov(un)



mi estimate: mixed CES_WB c.timew1w3w4##c.w1Agecent48 c.timew1w3w4##Sex c.timew1w3w4##Race  c.timew1w3w4##PovStat  c.timew1w3w4##w1edubr c.timew1w3w4##c.invmillsCES ///
c.timew1w3w4##w1smoke  c.timew1w3w4##w1currdrugs c.timew1w3w4##c.w1hei2010_total_scorecent43 ///
c.timew1w3w4##c.w1BMIcent30 ///
c.timew1w3w4##c.zw1w3w4HCysTRAJ ##Race   ///
if sample4obs==1  || HNDID: timew1w3w4, cov(un)


save, replace



****************************************************************BY ANXIETY STATUS********************************************************




****************NON-ANXIOUS*******************

//MODEL 1: INCLUDE ONLY AGE, SEX, RACE AND POVERTY STATUS///

mi estimate: mixed CES  c.timew1w3w4##c.w1Agecent48 c.timew1w3w4##Sex c.timew1w3w4##Race  c.timew1w3w4##PovStat  c.timew1w3w4##c.invmillsCES ///
c.timew1w3w4##c.zw1w3w4HCysTRAJ   ///
if sample4obs==1 & w1ANXIETYbr==1  || HNDID: timew1w3w4, cov(un)


mi estimate: mixed CES_DA c.timew1w3w4##c.w1Agecent48 c.timew1w3w4##Sex c.timew1w3w4##Race  c.timew1w3w4##PovStat  c.timew1w3w4##c.invmillsCES ///
c.timew1w3w4##c.zw1w3w4HCysTRAJ   ///
if sample4obs==1 & w1ANXIETYbr==1  || HNDID: timew1w3w4, cov(un)



mi estimate: mixed CES_IP c.timew1w3w4##c.w1Agecent48 c.timew1w3w4##Sex c.timew1w3w4##Race  c.timew1w3w4##PovStat  c.timew1w3w4##c.invmillsCES ///
c.timew1w3w4##c.zw1w3w4HCysTRAJ   ///
if sample4obs==1 & w1ANXIETYbr==1  || HNDID: timew1w3w4, cov(un)



mi estimate: mixed CES_SC c.timew1w3w4##c.w1Agecent48 c.timew1w3w4##Sex c.timew1w3w4##Race  c.timew1w3w4##PovStat  c.timew1w3w4##c.invmillsCES ///
c.timew1w3w4##c.zw1w3w4HCysTRAJ   ///
if sample4obs==1 & w1ANXIETYbr==1  || HNDID: timew1w3w4, cov(un)



mi estimate: mixed CES_WB c.timew1w3w4##c.w1Agecent48 c.timew1w3w4##Sex c.timew1w3w4##Race  c.timew1w3w4##PovStat  c.timew1w3w4##c.invmillsCES ///
c.timew1w3w4##c.zw1w3w4HCysTRAJ   ///
if sample4obs==1 & w1ANXIETYbr==1  || HNDID: timew1w3w4, cov(un)


save, replace



//MODEL 2: FULL MODEL///

mi estimate: mixed CES  c.timew1w3w4##c.w1Agecent48 c.timew1w3w4##Sex c.timew1w3w4##Race  c.timew1w3w4##PovStat  c.timew1w3w4##w1edubr c.timew1w3w4##c.invmillsCES ///
c.timew1w3w4##w1smoke  c.timew1w3w4##w1currdrugs c.timew1w3w4##c.w1hei2010_total_scorecent43 ///
c.timew1w3w4##c.w1BMIcent30 ///
c.timew1w3w4##c.zw1w3w4HCysTRAJ   ///
if sample4obs==1 & w1ANXIETYbr==1  || HNDID: timew1w3w4


mi estimate: mixed CES_DA c.timew1w3w4##c.w1Agecent48 c.timew1w3w4##Sex c.timew1w3w4##Race  c.timew1w3w4##PovStat  c.timew1w3w4##w1edubr c.timew1w3w4##c.invmillsCES ///
c.timew1w3w4##w1smoke  c.timew1w3w4##w1currdrugs c.timew1w3w4##c.w1hei2010_total_scorecent43 ///
c.timew1w3w4##c.w1BMIcent30 ///
c.timew1w3w4##c.zw1w3w4HCysTRAJ   ///
if sample4obs==1 & w1ANXIETYbr==1  || HNDID: timew1w3w4, cov(un)



mi estimate: mixed CES_IP c.timew1w3w4##c.w1Agecent48 c.timew1w3w4##Sex c.timew1w3w4##Race  c.timew1w3w4##PovStat  c.timew1w3w4##w1edubr c.timew1w3w4##c.invmillsCES ///
c.timew1w3w4##w1smoke  c.timew1w3w4##w1currdrugs c.timew1w3w4##c.w1hei2010_total_scorecent43 ///
c.timew1w3w4##c.w1BMIcent30 ///
c.timew1w3w4##c.zw1w3w4HCysTRAJ   ///
if sample4obs==1 & w1ANXIETYbr==1  || HNDID: timew1w3w4, cov(un)



mi estimate: mixed CES_SC c.timew1w3w4##c.w1Agecent48 c.timew1w3w4##Sex c.timew1w3w4##Race  c.timew1w3w4##PovStat  c.timew1w3w4##w1edubr c.timew1w3w4##c.invmillsCES ///
c.timew1w3w4##w1smoke  c.timew1w3w4##w1currdrugs c.timew1w3w4##c.w1hei2010_total_scorecent43 ///
c.timew1w3w4##c.w1BMIcent30 ///
c.timew1w3w4##c.zw1w3w4HCysTRAJ   ///
if sample4obs==1 & w1ANXIETYbr==1  || HNDID: timew1w3w4, cov(un)



mi estimate: mixed CES_WB c.timew1w3w4##c.w1Agecent48 c.timew1w3w4##Sex c.timew1w3w4##Race  c.timew1w3w4##PovStat  c.timew1w3w4##w1edubr c.timew1w3w4##c.invmillsCES ///
c.timew1w3w4##w1smoke  c.timew1w3w4##w1currdrugs c.timew1w3w4##c.w1hei2010_total_scorecent43 ///
c.timew1w3w4##c.w1BMIcent30 ///
c.timew1w3w4##c.zw1w3w4HCysTRAJ   ///
if sample4obs==1 & w1ANXIETYbr==1  || HNDID: timew1w3w4


***************ANXIOUS************


//MODEL 1: INCLUDE ONLY AGE, SEX, RACE AND POVERTY STATUS///
mi estimate: mixed CES  c.timew1w3w4##c.w1Agecent48 c.timew1w3w4##Sex c.timew1w3w4##Race  c.timew1w3w4##PovStat  c.timew1w3w4##c.invmillsCES ///
c.timew1w3w4##c.zw1w3w4HCysTRAJ   ///
if sample4obs==1 & w1ANXIETYbr==2  || HNDID: timew1w3w4, cov(un)


mi estimate: mixed CES_DA c.timew1w3w4##c.w1Agecent48 c.timew1w3w4##Sex c.timew1w3w4##Race  c.timew1w3w4##PovStat  c.timew1w3w4##c.invmillsCES ///
c.timew1w3w4##c.zw1w3w4HCysTRAJ   ///
if sample4obs==1 & w1ANXIETYbr==2  || HNDID: timew1w3w4, cov(un)



mi estimate: mixed CES_IP c.timew1w3w4##c.w1Agecent48 c.timew1w3w4##Sex c.timew1w3w4##Race  c.timew1w3w4##PovStat  c.timew1w3w4##c.invmillsCES ///
c.timew1w3w4##c.zw1w3w4HCysTRAJ   ///
if sample4obs==1 & w1ANXIETYbr==2  || HNDID: timew1w3w4



mi estimate: mixed CES_SC c.timew1w3w4##c.w1Agecent48 c.timew1w3w4##Sex c.timew1w3w4##Race  c.timew1w3w4##PovStat  c.timew1w3w4##c.invmillsCES ///
c.timew1w3w4##c.zw1w3w4HCysTRAJ   ///
if sample4obs==1 & w1ANXIETYbr==2  || HNDID: timew1w3w4, cov(un)



mi estimate: mixed CES_WB c.timew1w3w4##c.w1Agecent48 c.timew1w3w4##Sex c.timew1w3w4##Race  c.timew1w3w4##PovStat  c.timew1w3w4##c.invmillsCES ///
c.timew1w3w4##c.zw1w3w4HCysTRAJ   ///
if sample4obs==1 & w1ANXIETYbr==2  || HNDID: timew1w3w4, cov(un)


save, replace




//MODEL 2: FULL MODEL///

mi estimate: mixed CES  c.timew1w3w4##c.w1Agecent48 c.timew1w3w4##Sex c.timew1w3w4##Race  c.timew1w3w4##PovStat  c.timew1w3w4##w1edubr c.timew1w3w4##c.invmillsCES ///
c.timew1w3w4##w1smoke  c.timew1w3w4##w1currdrugs c.timew1w3w4##c.w1hei2010_total_scorecent43 ///
c.timew1w3w4##c.w1BMIcent30 ///
c.timew1w3w4##c.zw1w3w4HCysTRAJ   ///
if sample4obs==1 & w1ANXIETYbr==2  || HNDID: timew1w3w4, cov(un)


mi estimate: mixed CES_DA c.timew1w3w4##c.w1Agecent48 c.timew1w3w4##Sex c.timew1w3w4##Race c.timew1w3w4##PovStat  c.timew1w3w4##w1edubr c.timew1w3w4##c.invmillsCES ///
c.timew1w3w4##w1smoke  c.timew1w3w4##w1currdrugs c.timew1w3w4##c.w1hei2010_total_scorecent43 ///
c.timew1w3w4##c.w1BMIcent30 ///
c.timew1w3w4##c.zw1w3w4HCysTRAJ   ///
if sample4obs==1 & w1ANXIETYbr==2  || HNDID: timew1w3w4



mi estimate: mixed CES_IP c.timew1w3w4##c.w1Agecent48 c.timew1w3w4##Sex c.timew1w3w4##Race  c.timew1w3w4##PovStat  c.timew1w3w4##w1edubr c.timew1w3w4##c.invmillsCES ///
c.timew1w3w4##w1smoke  c.timew1w3w4##w1currdrugs c.timew1w3w4##c.w1hei2010_total_scorecent43 ///
c.timew1w3w4##c.w1BMIcent30 ///
c.timew1w3w4##c.zw1w3w4HCysTRAJ   ///
if sample4obs==1 & w1ANXIETYbr==2  || HNDID: timew1w3w4



mi estimate: mixed CES_SC c.timew1w3w4##c.w1Agecent48 c.timew1w3w4##Sex c.timew1w3w4##Race  c.timew1w3w4##PovStat  c.timew1w3w4##w1edubr c.timew1w3w4##c.invmillsCES ///
c.timew1w3w4##w1smoke  c.timew1w3w4##w1currdrugs c.timew1w3w4##c.w1hei2010_total_scorecent43 ///
c.timew1w3w4##c.w1BMIcent30 ///
c.timew1w3w4##c.zw1w3w4HCysTRAJ   ///
if sample4obs==1 & w1ANXIETYbr==2  || HNDID: timew1w3w4, cov(un)



mi estimate: mixed CES_WB c.timew1w3w4##c.w1Agecent48 c.timew1w3w4##Sex c.timew1w3w4##Race  c.timew1w3w4##PovStat  c.timew1w3w4##w1edubr c.timew1w3w4##c.invmillsCES ///
c.timew1w3w4##w1smoke  c.timew1w3w4##w1currdrugs c.timew1w3w4##c.w1hei2010_total_scorecent43 ///
c.timew1w3w4##c.w1BMIcent30 ///
c.timew1w3w4##c.zw1w3w4HCysTRAJ   ///
if sample4obs==1 & w1ANXIETYbr==2  || HNDID: timew1w3w4


***************INTERACTION BY ANXIETY STATUS***************


//MODEL 1: INCLUDE ONLY AGE, SEX, RACE AND POVERTY STATUS///
mi estimate: mixed CES  c.timew1w3w4##c.w1Agecent48 c.timew1w3w4##Sex c.timew1w3w4##Race  c.timew1w3w4##PovStat  c.timew1w3w4##c.invmillsCES ///
c.timew1w3w4##c.zw1w3w4HCysTRAJ##w1ANXIETYbr   ///
if sample4obs==1  || HNDID: timew1w3w4, cov(un)


mi estimate: mixed CES_DA c.timew1w3w4##c.w1Agecent48 c.timew1w3w4##Sex c.timew1w3w4##Race  c.timew1w3w4##PovStat  c.timew1w3w4##c.invmillsCES ///
c.timew1w3w4##c.zw1w3w4HCysTRAJ##w1ANXIETYbr   ///
if sample4obs==1  || HNDID: timew1w3w4, cov(un)



mi estimate: mixed CES_IP c.timew1w3w4##c.w1Agecent48 c.timew1w3w4##Sex c.timew1w3w4##Race  c.timew1w3w4##PovStat  c.timew1w3w4##c.invmillsCES ///
c.timew1w3w4##c.zw1w3w4HCysTRAJ##w1ANXIETYbr   ///
if sample4obs==1  || HNDID: timew1w3w4, cov(un)



mi estimate: mixed CES_SC c.timew1w3w4##c.w1Agecent48 c.timew1w3w4##Sex c.timew1w3w4##Race  c.timew1w3w4##PovStat  c.timew1w3w4##c.invmillsCES ///
c.timew1w3w4##c.zw1w3w4HCysTRAJ##w1ANXIETYbr   ///
if sample4obs==1  || HNDID: timew1w3w4, cov(un)



mi estimate: mixed CES_WB c.timew1w3w4##c.w1Agecent48 c.timew1w3w4##Sex c.timew1w3w4##Race  c.timew1w3w4##PovStat  c.timew1w3w4##c.invmillsCES ///
c.timew1w3w4##c.zw1w3w4HCysTRAJ##w1ANXIETYbr   ///
if sample4obs==1  || HNDID: timew1w3w4, cov(un)


save, replace




//MODEL 2: FULL MODEL///

mi estimate: mixed CES  c.timew1w3w4##c.w1Agecent48 c.timew1w3w4##Sex c.timew1w3w4##Race  c.timew1w3w4##PovStat  c.timew1w3w4##w1edubr c.timew1w3w4##c.invmillsCES ///
c.timew1w3w4##w1smoke  c.timew1w3w4##w1currdrugs c.timew1w3w4##c.w1hei2010_total_scorecent43 ///
c.timew1w3w4##c.w1BMIcent30 ///
c.timew1w3w4##c.zw1w3w4HCysTRAJ##w1ANXIETYbr   ///
if sample4obs==1  || HNDID: timew1w3w4, cov(un)


mi estimate: mixed CES_DA c.timew1w3w4##c.w1Agecent48 c.timew1w3w4##Sex c.timew1w3w4##Race  c.timew1w3w4##PovStat  c.timew1w3w4##w1edubr c.timew1w3w4##c.invmillsCES ///
c.*timew1w3w4##w1smoke  c.timew1w3w4##w1currdrugs c.timew1w3w4##c.w1hei2010_total_scorecent43 ///
c.timew1w3w4##c.w1BMIcent30 ///
c.timew1w3w4##c.zw1w3w4HCysTRAJ##w1ANXIETYbr   ///
if sample4obs==1  || HNDID: timew1w3w4



mi estimate: mixed CES_IP c.timew1w3w4##c.w1Agecent48 c.timew1w3w4##Sex c.timew1w3w4##Race  c.timew1w3w4##PovStat  c.timew1w3w4##w1edubr c.timew1w3w4##c.invmillsCES ///
c.timew1w3w4##w1smoke  c.timew1w3w4##w1currdrugs c.timew1w3w4##c.w1hei2010_total_scorecent43 ///
c.timew1w3w4##c.w1BMIcent30 ///
c.timew1w3w4##c.zw1w3w4HCysTRAJ##w1ANXIETYbr   ///
if sample4obs==1  || HNDID: timew1w3w4



mi estimate: mixed CES_SC c.timew1w3w4##c.w1Agecent48 c.timew1w3w4##Sex c.timew1w3w4##Race  c.timew1w3w4##PovStat  c.timew1w3w4##w1edubr c.timew1w3w4##c.invmillsCES ///
c.timew1w3w4##w1smoke  c.timew1w3w4##w1currdrugs c.timew1w3w4##c.w1hei2010_total_scorecent43 ///
c.timew1w3w4##c.w1BMIcent30 ///
c.timew1w3w4##c.zw1w3w4HCysTRAJ##w1ANXIETYbr   ///
if sample4obs==1  || HNDID: timew1w3w4, cov(un)



mi estimate: mixed CES_WB c.timew1w3w4##c.w1Agecent48 c.timew1w3w4##Sex c.timew1w3w4##Race  c.timew1w3w4##PovStat  c.timew1w3w4##w1edubr c.timew1w3w4##c.invmillsCES ///
c.timew1w3w4##w1smoke  c.timew1w3w4##w1currdrugs c.timew1w3w4##c.w1hei2010_total_scorecent43 ///
c.timew1w3w4##c.w1BMIcent30 ///
c.timew1w3w4##c.zw1w3w4HCysTRAJ##w1ANXIETYbr   ///
if sample4obs==1  || HNDID: timew1w3w4, cov(un)

capture log close
log using "E:\HANDLS_PAPER64_HCYDEPANXIETY_LONG\OUTPUT\TABLES1.smcl", replace


capture drop timew1w4
gen timew1w4=0 if HNDwave==1
replace timew1w4=w4Age-w1Age if HNDwave==4

capture drop w1CEScenter16
gen w1CEScenter16=w1CES-16

capture drop LnHCys
gen LnHCys=ln(HCys)

save, replace

*******************************TABLE S1: v1 DEPRESSIVE SYMPTOMS vs. HCYs CHANGE OVER TIME: OVERALL**************************************

//MODEL 1: INCLUDE ONLY AGE, SEX, RACE AND POVERTY STATUS///
mi estimate: mixed LnHCys c.timew1w3w4##c.w1CEScenter16  c.timew1w3w4##c.w1Agecent48 c.timew1w3w4##Sex c.timew1w3w4##Race  c.timew1w3w4##PovStat  c.timew1w3w4##c.invmillsCES ///
if sample4obs==1 || HNDID: timew1w3w4, cov(un)


mi estimate: mixed LnHCys c.timew1w3w4##c.w1w3w4bayes1CES  c.timew1w3w4##c.w1Agecent48 c.timew1w3w4##Sex c.timew1w3w4##Race  c.timew1w3w4##PovStat  c.timew1w3w4##c.invmillsCES ///
if sample4obs==1 || HNDID: timew1w3w4, cov(un)


mi estimate: mixed LnHCys c.timew1w3w4##c.w1ANXIETY_ORD  c.timew1w3w4##c.w1Agecent48 c.timew1w3w4##Sex c.timew1w3w4##Race  c.timew1w3w4##PovStat  c.timew1w3w4##c.invmillsCES ///
if sample4obs==1 || HNDID: timew1w3w4, cov(un)

mi estimate: mixed LnHCys c.timew1w3w4##c.zR_traj_ProbG2ANXIETY  c.timew1w3w4##c.w1Agecent48 c.timew1w3w4##Sex c.timew1w3w4##Race  c.timew1w3w4##PovStat  c.timew1w3w4##c.invmillsCES ///
if sample4obs==1 || HNDID: timew1w3w4, cov(un)

mi estimate: mixed LnHCys c.timew1w3w4##w1AnxietyDisorder  c.timew1w3w4##c.w1Agecent48 c.timew1w3w4##Sex c.timew1w3w4##Race  c.timew1w3w4##PovStat  c.timew1w3w4##c.invmillsCES ///
if sample4obs==1 || HNDID: timew1w3w4, cov(un)


save, replace



//MODEL 2: FULL MODEL///

mi estimate: mixed LnHCys c.timew1w3w4##c.w1CEScenter16 c.timew1w3w4##c.w1Agecent48 c.timew1w3w4##Sex c.timew1w3w4##Race  c.timew1w3w4##PovStat  c.timew1w3w4##w1edubr c.timew1w3w4##c.invmillsCES ///
c.timew1w3w4##w1smoke  c.timew1w3w4##w1currdrugs c.timew1w3w4##c.w1hei2010_total_scorecent43 ///
c.timew1w3w4##c.w1BMIcent30 ///
if sample4obs==1 || HNDID: timew1w3w4, cov(un)


mi estimate: mixed LnHCys c.timew1w3w4##c.w1w3w4bayes1CES c.timew1w3w4##c.w1Agecent48 c.timew1w3w4##Sex c.timew1w3w4##Race  c.timew1w3w4##PovStat  c.timew1w3w4##w1edubr c.timew1w3w4##c.invmillsCES ///
c.timew1w3w4##w1smoke  c.timew1w3w4##w1currdrugs c.timew1w3w4##c.w1hei2010_total_scorecent43 ///
c.timew1w3w4##c.w1BMIcent30 ///
if sample4obs==1 || HNDID: timew1w3w4, cov(un)


mi estimate: mixed LnHCys c.timew1w3w4##c.w1ANXIETY_ORD c.timew1w3w4##c.w1Agecent48 c.timew1w3w4##Sex c.timew1w3w4##Race  c.timew1w3w4##PovStat  c.timew1w3w4##w1edubr c.timew1w3w4##c.invmillsCES ///
c.timew1w3w4##w1smoke  c.timew1w3w4##w1currdrugs c.timew1w3w4##c.w1hei2010_total_scorecent43 ///
c.timew1w3w4##c.w1BMIcent30 ///
if sample4obs==1 || HNDID: timew1w3w4, cov(un)


mi estimate: mixed LnHCys c.timew1w3w4##c.zR_traj_ProbG2ANXIETY c.timew1w3w4##c.w1Agecent48 c.timew1w3w4##Sex c.timew1w3w4##Race  c.timew1w3w4##PovStat  c.timew1w3w4##w1edubr c.timew1w3w4##c.invmillsCES ///
c.timew1w3w4##w1smoke  c.timew1w3w4##w1currdrugs c.timew1w3w4##c.w1hei2010_total_scorecent43 ///
c.timew1w3w4##c.w1BMIcent30 ///
if sample4obs==1 || HNDID: timew1w3w4, cov(un)

mi estimate: mixed LnHCys c.timew1w3w4##c.w1AnxietyDisorder c.timew1w3w4##c.w1Agecent48 c.timew1w3w4##Sex c.timew1w3w4##Race  c.timew1w3w4##PovStat  c.timew1w3w4##w1edubr c.timew1w3w4##c.invmillsCES ///
c.timew1w3w4##w1smoke  c.timew1w3w4##w1currdrugs c.timew1w3w4##c.w1hei2010_total_scorecent43 ///
c.timew1w3w4##c.w1BMIcent30 ///
if sample4obs==1 || HNDID: timew1w3w4, cov(un)



capture log close
log using "E:\HANDLS_PAPER64_HCYDEPANXIETY_LONG\OUTPUT\TABLES2.smcl", replace


capture drop Lnodds_highANXIETY
gen Lnodds_highANXIETY=ln(R_traj_ProbG2ANXIETY/(1-R_traj_ProbG2ANXIETY))

save, replace

//MODEL 1: INCLUDE ONLY AGE, SEX, RACE AND POVERTY STATUS///

mi estimate: reg Lnodds_highANXIETY LnHCys  c.w1Agecent48 Sex Race  PovStat  c.invmillsCES ///
if sample4obs==1 & HNDwave==1


save, replace



//MODEL 2: FULL MODEL///

mi estimate: reg Lnodds_highANXIETY LnHCys c.w1Agecent48 Sex Race  PovStat  w1edubr c.invmillsCES ///
w1smoke  w1currdrugs c.w1hei2010_total_scorecent43 ///
c.w1BMIcent30 ///
if sample4obs==1 & HNDwave==1

save, replace

capture log close
log using "E:\HANDLS_PAPER64_HCYDEPANXIETY_LONG\OUTPUT\TABLES3.smcl", replace


*************************SENSITIVITY ANALYSIS 1: WITH CHANGE IN HCY BETWEEN WAVES 1 AND 3******************

use finaldata_imputed_FINAL,clear

capture drop w1w3HCys_change
gen w1w3HCys_change=(w3HCys-w1HCys)/(w3Age-w1Age)

capture drop zw1w3HCys_change
mi passive: egen zw1w3HCys_change=std(w1w3HCys_change) if sample4obs==1

save, replace




//////////////TABLE 3: TRAJECTORY OF HCys LOAD VS. DEPRESSIVE SYMPTOMS///////////////////////////////////


//MODEL 1: INCLUDE ONLY AGE, SEX, RACE AND POVERTY STATUS///
mi estimate: mixed CES  c.timew1w3w4##c.w1Agecent48 c.timew1w3w4##Sex c.timew1w3w4##Race  c.timew1w3w4##PovStat  c.timew1w3w4##c.invmillsCES ///
c.timew1w3w4##c.zw1w3HCys_change   ///
if sample4obs==1 || HNDID: timew1w3w4, cov(un)


mi estimate: mixed CES_DA c.timew1w3w4##c.w1Agecent48 c.timew1w3w4##Sex c.timew1w3w4##Race  c.timew1w3w4##PovStat  c.timew1w3w4##c.invmillsCES ///
c.timew1w3w4##c.zw1w3HCys_change   ///
if sample4obs==1 || HNDID: timew1w3w4, cov(un)



mi estimate: mixed CES_IP c.timew1w3w4##c.w1Agecent48 c.timew1w3w4##Sex c.timew1w3w4##Race  c.timew1w3w4##PovStat  c.timew1w3w4##c.invmillsCES ///
c.timew1w3w4##c.zw1w3HCys_change   ///
if sample4obs==1 || HNDID: timew1w3w4, cov(un)



mi estimate: mixed CES_SC c.timew1w3w4##c.w1Agecent48 c.timew1w3w4##Sex c.timew1w3w4##Race  c.timew1w3w4##PovStat  c.timew1w3w4##c.invmillsCES ///
c.timew1w3w4##c.zw1w3HCys_change   ///
if sample4obs==1 || HNDID: timew1w3w4, cov(un)



mi estimate: mixed CES_WB c.timew1w3w4##c.w1Agecent48 c.timew1w3w4##Sex c.timew1w3w4##Race  c.timew1w3w4##PovStat  c.timew1w3w4##c.invmillsCES ///
c.timew1w3w4##c.zw1w3HCys_change   ///
if sample4obs==1 || HNDID: timew1w3w4, cov(un)


save, replace




//MODEL 2: FULL MODEL///

mi estimate: mixed CES  c.timew1w3w4##c.w1Agecent48 c.timew1w3w4##Sex c.timew1w3w4##Race  c.timew1w3w4##PovStat  c.timew1w3w4##w1edubr c.timew1w3w4##c.invmillsCES ///
c.timew1w3w4##w1smoke  c.timew1w3w4##w1currdrugs c.timew1w3w4##c.w1hei2010_total_scorecent43 ///
c.timew1w3w4##c.w1BMIcent30 ///
c.timew1w3w4##c.zw1w3HCys_change   ///
if sample4obs==1 || HNDID: timew1w3w4, cov(un)


mi estimate: mixed CES_DA c.timew1w3w4##c.w1Agecent48 c.timew1w3w4##Sex c.timew1w3w4##Race  c.timew1w3w4##PovStat  c.timew1w3w4##w1edubr c.timew1w3w4##c.invmillsCES ///
c.timew1w3w4##w1smoke  c.timew1w3w4##w1currdrugs c.timew1w3w4##c.w1hei2010_total_scorecent43 ///
c.timew1w3w4##c.w1BMIcent30 ///
c.timew1w3w4##c.zw1w3HCys_change   ///
if sample4obs==1 || HNDID: timew1w3w4, cov(un)



mi estimate: mixed CES_IP c.timew1w3w4##c.w1Agecent48 c.timew1w3w4##Sex c.timew1w3w4##Race  c.timew1w3w4##PovStat  c.timew1w3w4##w1edubr c.timew1w3w4##c.invmillsCES ///
c.timew1w3w4##w1smoke  c.timew1w3w4##w1currdrugs c.timew1w3w4##c.w1hei2010_total_scorecent43 ///
c.timew1w3w4##c.w1BMIcent30 ///
c.timew1w3w4##c.zw1w3HCys_change   ///
if sample4obs==1 || HNDID: timew1w3w4, cov(un)



mi estimate: mixed CES_SC c.timew1w3w4##c.w1Agecent48 c.timew1w3w4##Sex c.timew1w3w4##Race  c.timew1w3w4##PovStat  c.timew1w3w4##w1edubr c.timew1w3w4##c.invmillsCES ///
c.timew1w3w4##w1smoke  c.timew1w3w4##w1currdrugs c.timew1w3w4##c.w1hei2010_total_scorecent43 ///
c.timew1w3w4##c.w1BMIcent30 ///
c.timew1w3w4##c.zw1w3HCys_change   ///
if sample4obs==1 || HNDID: timew1w3w4, cov(un)



mi estimate: mixed CES_WB c.timew1w3w4##c.w1Agecent48 c.timew1w3w4##Sex c.timew1w3w4##Race  c.timew1w3w4##PovStat  c.timew1w3w4##w1edubr c.timew1w3w4##c.invmillsCES ///
c.timew1w3w4##w1smoke  c.timew1w3w4##w1currdrugs c.timew1w3w4##c.w1hei2010_total_scorecent43 ///
c.timew1w3w4##c.w1BMIcent30 ///
c.timew1w3w4##c.zw1w3HCys_change   ///
if sample4obs==1 || HNDID: timew1w3w4, cov(un)


save finaldata_imputed_FINAL, replace

capture log close
log using "E:\HANDLS_PAPER64_HCYDEPANXIETY_LONG\OUTPUT\TABLES4.smcl", replace

use finaldata_imputed_FINAL,clear

capture mi stset,clear

capture drop failure
gen failure=CESDcut16

save, replace


mi stset timew1w3w4, failure(failure) id(HNDID)


**Overall**
stcox c.Lnw1HCyscenter2p15 c.w1Agecent48 Sex Race  PovStat  w1edubr c.invmillsCES w1smoke  w1currdrugs c.w1hei2010_total_scorecent43 c.w1BMIcent30 if sample4obs==1
stcox zw1w3w4HCysTRAJ c.w1Agecent48 Sex Race  PovStat  w1edubr c.invmillsCES w1smoke  w1currdrugs c.w1hei2010_total_scorecent43 c.w1BMIcent30 if sample4obs==1

**Women**
stcox c.Lnw1HCyscenter2p15 c.w1Agecent48 Sex Race  PovStat  w1edubr c.invmillsCES w1smoke  w1currdrugs c.w1hei2010_total_scorecent43 c.w1BMIcent30 if sample4obs==1 & Sex==1
stcox zw1w3w4HCysTRAJ c.w1Agecent48 Sex Race  PovStat  w1edubr c.invmillsCES w1smoke  w1currdrugs c.w1hei2010_total_scorecent43 c.w1BMIcent30 if sample4obs==1 & Sex==1


**Men**
stcox c.Lnw1HCyscenter2p15 c.w1Agecent48 Sex Race  PovStat  w1edubr c.invmillsCES w1smoke  w1currdrugs c.w1hei2010_total_scorecent43 c.w1BMIcent30 if sample4obs==1 & Sex==2
stcox zw1w3w4HCysTRAJ c.w1Agecent48 Sex Race  PovStat  w1edubr c.invmillsCES w1smoke  w1currdrugs c.w1hei2010_total_scorecent43 c.w1BMIcent30 if sample4obs==1 & Sex==2


**White**
stcox c.Lnw1HCyscenter2p15 c.w1Agecent48 Sex Race  PovStat  w1edubr c.invmillsCES w1smoke  w1currdrugs c.w1hei2010_total_scorecent43 c.w1BMIcent30 if sample4obs==1 & Race==1
stcox zw1w3w4HCysTRAJ c.w1Agecent48 Sex Race  PovStat  w1edubr c.invmillsCES w1smoke  w1currdrugs c.w1hei2010_total_scorecent43 c.w1BMIcent30 if sample4obs==1 & Race==1


**AA**
stcox c.Lnw1HCyscenter2p15 c.w1Agecent48 Sex Race  PovStat  w1edubr c.invmillsCES w1smoke  w1currdrugs c.w1hei2010_total_scorecent43 c.w1BMIcent30 if sample4obs==1 & Race==2
stcox zw1w3w4HCysTRAJ c.w1Agecent48 Sex Race  PovStat  w1edubr c.invmillsCES w1smoke  w1currdrugs c.w1hei2010_total_scorecent43 c.w1BMIcent30 if sample4obs==1 & Race==2


**Above Poverty**
stcox c.Lnw1HCyscenter2p15 c.w1Agecent48 Sex Race  PovStat  w1edubr c.invmillsCES w1smoke  w1currdrugs c.w1hei2010_total_scorecent43 c.w1BMIcent30 if sample4obs==1 & PovStat==1
stcox zw1w3w4HCysTRAJ c.w1Agecent48 Sex Race  PovStat  w1edubr c.invmillsCES w1smoke  w1currdrugs c.w1hei2010_total_scorecent43 c.w1BMIcent30 if sample4obs==1 & PovStat==1


**Below Poverty**
stcox c.Lnw1HCyscenter2p15 c.w1Agecent48 Sex Race  PovStat  w1edubr c.invmillsCES w1smoke  w1currdrugs c.w1hei2010_total_scorecent43 c.w1BMIcent30 if sample4obs==1 & PovStat==2
stcox zw1w3w4HCysTRAJ c.w1Agecent48 Sex Race  PovStat  w1edubr c.invmillsCES w1smoke  w1currdrugs c.w1hei2010_total_scorecent43 c.w1BMIcent30 if sample4obs==1 & PovStat==2


**Below Median Anxiety score**
stcox c.Lnw1HCyscenter2p15 c.w1Agecent48 Sex Race  PovStat  w1edubr c.invmillsCES w1smoke  w1currdrugs c.w1hei2010_total_scorecent43 c.w1BMIcent30 if sample4obs==1 & w1ANXIETYbr==1
stcox zw1w3w4HCysTRAJ c.w1Agecent48 Sex Race  PovStat  w1edubr c.invmillsCES w1smoke  w1currdrugs c.w1hei2010_total_scorecent43 c.w1BMIcent30 if sample4obs==1 & w1ANXIETYbr==1


**Above Median Anxiety score**
stcox c.Lnw1HCyscenter2p15 c.w1Agecent48 Sex Race  PovStat  w1edubr c.invmillsCES w1smoke  w1currdrugs c.w1hei2010_total_scorecent43 c.w1BMIcent30 if sample4obs==1 & w1ANXIETYbr==2
stcox zw1w3w4HCysTRAJ c.w1Agecent48 Sex Race  PovStat  w1edubr c.invmillsCES w1smoke  w1currdrugs c.w1hei2010_total_scorecent43 c.w1BMIcent30 if sample4obs==1 & w1ANXIETYbr==2

**Interaction by sex**
stcox c.Lnw1HCyscenter2p15##Sex c.w1Agecent48  Race  PovStat  w1edubr c.invmillsCES w1smoke  w1currdrugs c.w1hei2010_total_scorecent43 c.w1BMIcent30 if sample4obs==1
stcox c.zw1w3w4HCysTRAJ##Sex c.w1Agecent48 Sex Race  PovStat  w1edubr c.invmillsCES w1smoke  w1currdrugs c.w1hei2010_total_scorecent43 c.w1BMIcent30 if sample4obs==1


**Interaction by Race**
stcox c.Lnw1HCyscenter2p15##Race Sex c.w1Agecent48    PovStat  w1edubr c.invmillsCES w1smoke  w1currdrugs c.w1hei2010_total_scorecent43 c.w1BMIcent30 if sample4obs==1
stcox c.zw1w3w4HCysTRAJ##Race Sex c.w1Agecent48 Sex   PovStat  w1edubr c.invmillsCES w1smoke  w1currdrugs c.w1hei2010_total_scorecent43 c.w1BMIcent30 if sample4obs==1


**Interaction by Poverty Status**
stcox c.Lnw1HCyscenter2p15##PovStat Race Sex c.w1Agecent48      w1edubr c.invmillsCES w1smoke  w1currdrugs c.w1hei2010_total_scorecent43 c.w1BMIcent30 if sample4obs==1
stcox c.zw1w3w4HCysTRAJ##PovStat Race Sex c.w1Agecent48 Sex     w1edubr c.invmillsCES w1smoke  w1currdrugs c.w1hei2010_total_scorecent43 c.w1BMIcent30 if sample4obs==1



**Interaction by Anxiety score status**
stcox c.Lnw1HCyscenter2p15##w1ANXIETYbr PovStat Race Sex c.w1Agecent48      w1edubr c.invmillsCES w1smoke  w1currdrugs c.w1hei2010_total_scorecent43 c.w1BMIcent30 if sample4obs==1
stcox c.zw1w3w4HCysTRAJ##w1ANXIETYbr PovStat Race Sex c.w1Agecent48 Sex     w1edubr c.invmillsCES w1smoke  w1currdrugs c.w1hei2010_total_scorecent43 c.w1BMIcent30 if sample4obs==1




capture log close
log using "E:\HANDLS_PAPER64_HCYDEPANXIETY_LONG\OUTPUT\TERTILES.smcl", replace


*****************DISTRIBUTIONS OF KEY RE-CODED VARIABLES**************************

use finaldata_imputed_FINAL,clear

su w1w3HCys_change if sample4obs==1 & HNDwave==1 & _mi_m==0, det
su w1w3w4HCysTRAJ if sample4obs==1 & HNDwave==1 & _mi_m==0, det
bysort w1HCystert: su w1HCys if sample4obs==1 & HNDwave==1 & _mi_m==0, det
bysort w1HCystert: su Lnw1HCys if sample4obs==1 & HNDwave==1 & _mi_m==0, det
bysort w1ANXIETYbr: su w1ANXIETY_ORD if sample4obs==1 & HNDwave==1 & _mi_m==0, det
bysort w1ANXIETYbr: su w1w4ANXIETYTRAJ if sample4obs==1 & HNDwave==1 & _mi_m==0, det
bysort w1AnxietyDisorder: su w1ANXIETY_ORD if sample4obs==1 & HNDwave==1 & _mi_m==0, det
bysort w1AnxietyDisorder: su w1w4ANXIETYTRAJ if sample4obs==1 & HNDwave==1 & _mi_m==0, det
bysort w1AnxietyDisorder: su Lnodds_highANXIETY if sample4obs==1 & HNDwave==1 & _mi_m==0, det

su w1ANXIETY_ORD if sample4obs==1 & HNDwave==1 & _mi_m==0, det
su w1w4ANXIETYTRAJ if sample4obs==1 & HNDwave==1 & _mi_m==0, det
tab w1AnxietyDisorder if sample4obs==1 & HNDwave==1 & _mi_m==0
tab w1ANXIETYbr if sample4obs==1 & HNDwave==1 & _mi_m==0
su Lnodds_highANXIETY if sample4obs==1 & HNDwave==1 & _mi_m==0


capture log close
cd "E:\HANDLS_PAPER64_HCYDEPANXIETY_LONG\DATA"

log using "E:\HANDLS_PAPER64_HCYDEPANXIETY_LONG\OUTPUT\FIGURE4.smcl", replace


//////////////////////////////////////FIGURE 4: HCY AT V1 VS. CES-D, TOTAL POPULATION///////////////////////



use finaldata_imputed_FINAL, clear


mi extract 1
save final_imputed_one, replace


mixed CES  c.timew1w3w4##c.w1Agecent48 c.timew1w3w4##Sex c.timew1w3w4##Race  c.timew1w3w4##PovStat  c.timew1w3w4##c.invmillsCES ///
c.timew1w3w4##c.Lnw1HCyscenter2p15   ///
if sample4obs==1 || HNDID: timew1w3w4, cov(un)

margins, at(c.timew1w3w4=(0(1)13) c.Lnw1HCyscenter2p15=(-1(1)1)) 


marginsplot, recast(line) recastci(rarea) ciopt(color(gs10) alwidth(none) fintensity(90)) ci1opt(color(gs15) alwidth(none) fintensity(90)) ci2opt(color(gs12) alwidth(none) fintensity(90)) plotopts(lc(gs0) lpattern(solid)) plot1opts(lc(gs0) lpattern(dot)) plot2opts(lc(gs0) lpattern(dash)) legend(order(1 "Lnw1HCyscenter2p15=-1" 2 "Lnw1HCyscenter2p15=0" 3 "Lnw1HCyscenter2p15=1") ) 

graph save "FIGURE4.gph",replace 


su Lnw1HCyscenter2p15 if HNDwave==1

capture log close
