/* Libname Raw_d"/home/u40260356/STUDY/RAW_DATA" ; */
Libname SDTM_d"/home/u40260356/STUDY/SDTM_DATA" ;

data mh1;
set SDTM_d.mh;
length mhseql $ 40.;
mhseql=put(mhseq,best.);
ASTDY=MHSTDY;
AENDY=MHENDY;
run;

data MH2;
length Studyid $ 12.;
set MH1;
if length(mhstdtc)=10 then do;
ASTDTC=mhstdtc;
ASTDTF="";
end;

if length(mhstdtc)=7 then do;
ASTDTC=catx('-',mhstdtc,'01');
ASTDTF="D";
end;

if length(mhstdtc)=4 then do;
ASTDTC=catx('-',mhstdtc,'01','01');
ASTDTF="M";
end;

if length(mhendtc)=10 then do;
AENDTC=mhendtc;
AENDTF="";
end;

if length(mhendtc)=7 then do;
if substr(mhendtc,6,2) = '02' then AENDTC=catx('-',mhendtc,'28');
else if substr(mhendtc,6,2) in('04' '06' '09' '11' ) then AENDTC=catx('-',mhendtc,'30');
else AENDTC=catx('-',mhendtc,'31'); 
AENDTF="D";
end;

if length(mhendtc)=4 then do;
AENDTC=catx('-',mhendtc,'12','30');
AENDTF="M";
end;

if length(astdtc)=10 then ASTDT=input(astdtc,yymmdd10.);

if length(aendtc)=10 then AENDT=input(aendtc,yymmdd10.);
FORMAT ASTDT AENDT DATE9.;
drop Domain;
run;

DATA SUPPMH1;
SET SDTM_D.SUPPMH(DROP=RDOMAIN STUDYID);
mhseql=IDVARVAL;
IF QNAM="MHCLSIG" THEN MHCLSIG=QVAL;
RUN;
 
DATA ADSL1;
SET SDTM_D.ADSL;
STUDYID="XXX-YYY-103";
USUBJID=catx("-",studyid,"01",subjid);
TRTP=TRT01P;
TRTPN=TRT01PN;
TRTA=TRT01A;
TRTAN=TRT01AN;
RUN;

data MS;
merge MH2 (in=A) SUPPMH1(in=B);
by usubjid mhseql;
DOMAIN="ADMH";
run;

data AMS;
merge MS(in=X) ADSL1(in=Y);
by usubjid;
if X;
run;

%let keep_admh = STUDYID USUBJID DOMAIN SUBJID RFSTDTC SITEID AGE SEX RACE 
ETHNIC ENRLFL SCRNFL COMPLFL SAFFL SCRFL DCSREAS DCSREASP TRT01P TRT01PN 
TRT01A TRT01AN TRTSDT TRTSTM TRTSDTM TRTEDT TRTETM TRTEDTM COHORT COHORTN 
DOSE DTHDT DTHFL EOSDT SUBDISP MHSEQ MHTERM MHLLT MHLLTCD MHDECOD MHPTCD MHHLT 
MHHLTCD MHHLGT MHHLGTCD MHCAT MHBODSYS MHBDSYCD MHSOC MHSOCCD MHSTDTC MHENDTC 
MHENRF MHCLSIG ASTDT AENDT ASTDY AENDY TRTP TRTPN TRTA TRTAN;

data adam.admh(keep=&keep_admh);
retain &keep_admh;
set AMS;
label STUDYID='Study Identifier' USUBJID='Unique Subject Identifier'
      SUBJID='Subject Identifier for the Study'
      RFSTDTC='Subject Reference Start Date/Time' SITEID='Study Site Identifier'
      AGE='Age' SEX='Sex' RACE='Race' ETHNIC='Ethnicity' ENRLFL='Enrolled Flag'
      SCRNFL='Screen Failure Flag' COMPLFL='Completers Population Flag'
      SAFFL='Safety Population Flag' SCRFL='Screened Population Flag'
      DCSREAS='Reason for Discontinuation from Study'
      DCSREASP='Reason spec for Discont from study'
      TRT01P='Planned Treatment for Period 01'
      TRT01PN='Planned Treatment for Period 01 (N)'
      TRT01A='Actual Treatment for Period 01'
      TRT01AN='Actual Treatment for Period 01 (N)'
      TRTSDT='Date of First Exposure to Treatment'
      TRTSTM='Time of First Exposure to Treatment'
      TRTSDTM='Datetime of First Exposure to Treatment'
      TRTEDT='Date of Last Exposure to Treatment'
      TRTETM='Time of Last Exposure to Treatment'
      TRTEDTM='Datetime of Last Exposure to Treatment' COHORT='Cohort'
      COHORTN='Cohort (N)' DOSE='Dose' DTHDT='Date of Death'
      DTHFL='Subject Death Flag' EOSDT='End of Study Date'
      SUBDISP='Subject Id/Age/Gender/Race' DOMAIN='Domain Abbreviation'
      MHSEQ='Sequence Number' MHTERM='Reported Term for the Medical History'
      MHLLT='Lowest Level Term' MHLLTCD='Lowest Level Term Code'
      MHDECOD='Dictionary-Derived Term' MHPTCD='Preferred Term Code'
      MHHLT='High Level Term' MHHLTCD='High Level Term Code'
      MHHLGT='High Level Group Term' MHHLGTCD='High Level Group Term Code'
      MHCAT='Category for Medical History' MHBODSYS='Body System or Organ Class'
      MHBDSYCD='Body System or Organ Class Code' MHSOC='Primary System Organ Class'
      MHSOCCD='Primary System Organ Class Code'
      MHSTDTC='Start Date/Time of Medical History Event'
      MHENDTC='End Date/Time of Medical History Event'
      MHENRF='End Relative to Reference Period' MHCLSIG='Clinically Significant'
      ASTDT='Analysis Start Date' AENDT='Analysis End Date'
      ASTDY='Analysis Start Relative Day' AENDY='Analysis End Relative Day'
      TRTP='Planned Treatment' TRTPN='Planned Treatment (N)'
      TRTA='Actual Treatment'  TRTAN='Actual Treatment (N)';
run;

libname adam "/home/u63364757/ADAM code/Adam data";