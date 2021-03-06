APCDALGP ; IHS/CMI/LAB - PRINT ALLERGY LIST FROM PROBLEM LIST ;  [ 02/06/04  10:14 AM ]
 ;;2.0;IHS RPMS/PCC Data Entry;**7**;MAR 09, 1999
 ;
START ;
 D XIT
 I '$D(IOF) D HOME^%ZIS
 W @(IOF),!!
 W "*******  LIST OF PATIENTS WITH ALLERGIES ON PROBLEM LIST  *******",!
 W "This report will produce a list of patients who have an allergy or NKA",!
 W "entered on the PCC Problem List.",!,"The pharmacy staff can use this list to add these allergies "
 W !,"into the Allergy Tracking module.  When you have finished processing this list"
 W !,"you can then run the Option 'List Patients w/Allergies entered in a Date Range'"
 W !,"to pick up any allergies entered onto the Problem list after you"
 W !,"ran this report.  Deceased patients and patients with inactive charts"
 W !,"are not included on this list."
 W !!,"This list can be very long at sites with many patients and whose"
 W !,"providers have been maintaining up to date problem lists."
 W !,"In order to make the list more manageable at those sites you will be"
 W !,"prompted to enter the beginning and ending first character of "
 W !,"the last name the patient.  You can then print all patients whose last"
 W !,"name begins with A through C the first time and D through H the second, etc."
 W !,"If you want all patients then when prompted to do so enter A and Z as the"
 W !,"beginning and ending characters.",!!
GETDATES ;
 S APCDBC=""
 S DIR(0)="F^1:1",DIR("A")="Start with last names beginning with" KILL DA D ^DIR KILL DIR
 I $D(DIRUT) D XIT Q
 S APCDBC=Y
 S APCDEC=""
 S DIR(0)="F^1:1",DIR("A")="End with last names beginning with" KILL DA D ^DIR KILL DIR
 I $D(DIRUT) D XIT Q
 S APCDEC=Y
 ;
ZIS ;
 S XBRC="PROC^APCDALGP",XBRP="PRINT^APCDALGP",XBNS="APCD",XBRX="XIT^APCDALGP"
 D ^XBDBQUE
XIT ;
 D EN^XBVK("APCD")
 D ^XBFMK
 Q
XTMP(N,T) ;EP
 I $G(N)="" Q
 S ^XTMP(N,0)=$$FMADD^XLFDT(DT,14)_U_DT_U_T
 Q
 ;
PROC ;EP - entry point for processing
 S APCDJOB=$J,APCDBTH=$H,APCDTOT=0,APCDBT=$H
 D XTMP("APCDALGP","PCC PROBLEM LIST ALLERGY LIST")
 S APCDET=$H
 S DFN=0 F  S DFN=$O(^AUPNPAT(DFN)) Q:DFN'=+DFN  D PROC1
 Q
PROC1 ;
 Q:$$DOD^AUPNPAT(DFN)]""  ;no deceased patients
 I $P($G(^AUPNPAT(DFN,41,DUZ(2),0)),U,5)="I" Q  ;no inactive patients
 ;Q:'$$LASTVD(DFN,APCDBD,APCDED)  ;no visit in time perio
 S APCDX=0 F  S APCDX=$O(^AUPNPROB("AC",DFN,APCDX)) Q:APCDX'=+APCDX  S G=0 D  I G S ^XTMP("APCDALGP",APCDJOB,APCDBTH,DFN,APCDX)=""
 .S C=$E($G(^DPT(DFN,0)))
 .I APCDBC]C Q
 .I C]APCDEC Q
 .S APCDP=$P($G(^AUPNPROB(APCDX,0)),U)
 .Q:APCDP=""
 .S APCDICD=$P($G(^ICD9(APCDP,0)),U)
 .Q:APCDICD=""
 .I $P(^AUPNPROB(APCDX,0),U,5)="" Q  ;IHS/CMI/LAB - no narr
 .S APCDSNKA=0
 .I APCDICD="692.3" S G=1 Q
 .I APCDICD="693.0" S G=1 Q
 .I APCDICD="995.0" S G=1 Q
 .I APCDICD=995.2 S G=1 Q
 .I (+APCDICD'<999.4),(+APCDICD'>999.8) S G=1 Q
 .I APCDICD?1"V14."1E S G=1 Q
 .I APCDICD="692.5" S G=1 Q
 .I APCDICD="693.1" S G=1 Q
 .I APCDICD["V15.0" S G=1 Q
 .I $E(APCDICD,1,3)=692,APCDICD'="692.9" S G=1 Q
 .I APCDICD="693.8" S G=1 Q
 .I APCDICD="693.9" S G=1 Q
 .I APCDICD="989.5" S G=1 Q
 .I APCDICD="995.3" S G=1 Q
 .S N=$P(^AUTNPOV($P(^AUPNPROB(APCDX,0),U,5),0),U) I APCDICD="799.9"!(APCDICD="V82.9"),N["NO KNOWN ALLERG"!(N["NKA")!(N["NKDA")!(N["NO KNOWN DRUG ALLERG") S APCDSNKA=1 S G=1 Q
 Q
LASTVD(P,BDATE,EDATE) ;
 I '$D(^AUPNVSIT("AC",P)) Q ""
 K ^TMP($J,"A")
 S A="^TMP($J,""A"",",B=P_"^ALL VISITS;DURING "_$$FMTE^XLFDT(BDATE)_"-"_$$FMTE^XLFDT(EDATE),E=$$START1^APCLDF(B,A)
 I '$D(^TMP($J,"A",1)) Q ""
 S (X,G)=0 F  S X=$O(^TMP($J,"A",X)) Q:X'=+X!(G)  S V=$P(^TMP($J,"A",X),U,5) D
 .Q:'$D(^AUPNVSIT(V,0))
 .Q:'$P(^AUPNVSIT(V,0),U,9)
 .Q:$P(^AUPNVSIT(V,0),U,11)
 .Q:'$D(^AUPNVPRV("AD",V))
 .Q:"SAHOIRCT"'[$P(^AUPNVSIT(V,0),U,7)
 .Q:"V"[$P(^AUPNVSIT(V,0),U,3)
 .S G=1
 .Q
 Q G
PRINT ;
 S APCD80D="-------------------------------------------------------------------------------"
 ;S Y=APCDBD D DD^%DT S APCDBDD=Y S Y=APCDED D DD^%DT S APCDEDD=Y
 S APCDPG=0
 I '$D(^XTMP("APCDALGP",APCDJOB,APCDBTH)) D HEAD W !!,"NO PATIENTS TO REPORT" G DONE
 D HEAD
 S DFN=0 F  S DFN=$O(^XTMP("APCDALGP",APCDJOB,APCDBTH,DFN)) Q:DFN'=+DFN!($D(APCDQ))  D
 .I $Y>(IOSL-6) D HEAD Q:$D(APCDQ)
 .W !!,$P(^DPT(DFN,0),U),?31,$$HRN^AUPNPAT(DFN,DUZ(2)),?42,$$DOB^AUPNPAT(DFN,"E")
 .W !?3,"DATE ADDED",?17,"DX",?24,"PROVIDER NARRATIVE"
 .W !?3,"----------",?17,"--",?24,"------------------"
 .S APCDP=0 F  S APCDP=$O(^XTMP("APCDALGP",APCDJOB,APCDBTH,DFN,APCDP)) Q:APCDP=""!($D(APCDQ))  D
 ..W !?3,$$VAL^XBDIQ1(9000011,APCDP,.08),?17,$$VAL^XBDIQ1(9000011,APCDP,.01),?24,$$VAL^XBDIQ1(9000011,APCDP,.05)
DONE ;
 K ^XTMP("APCDALGP",APCDJOB,APCDBTH),APCDJOB,APCDBTH
 Q
CTR(X,Y) ;EP - Center X in a field Y wide.
 Q $J("",$S($D(Y):Y,1:IOM)-$L(X)\2)_X
         ;----------
USR() ;EP - Return name of current user from ^VA(200.
 Q $S($G(DUZ):$S($D(^VA(200,DUZ,0)):$P(^(0),U),1:"UNKNOWN"),1:"DUZ UNDEFINED OR 0")
         ;----------
LOC() ;EP - Return location name from file 4 based on DUZ(2).
 Q $S($G(DUZ(2)):$S($D(^DIC(4,DUZ(2),0)):$P(^(0),U),1:"UNKNOWN"),1:"DUZ(2) UNDEFINED OR 0")
HEAD I 'APCDPG G HEAD1
 I $E(IOST)="C",IO=IO(0) W ! S DIR(0)="EO" D ^DIR K DIR I Y=0!(Y="^")!($D(DTOUT)) S APCDQ="" Q
HEAD1 ;
 W:$D(IOF) @IOF S APCDPG=APCDPG+1
 W $P(^VA(200,DUZ,0),U,2),?72,"Page ",APCDPG,!
 W ?(80-$L($P(^DIC(4,DUZ(2),0),U))/2),$P(^DIC(4,DUZ(2),0),U),!
 S X="PATIENTS WITH ALLERGIES OR DOCUMENTED NO KNOWN ALLERGIES ON PCC PROBLEM LIST" W $$CTR(X),!
 S X="PATIENTS WITH LAST NAMES BEGINNING WITH "_APCDBC_" through "_APCDEC W $$CTR(X),!
 W "PATIENT NAME",?31,"CHART #",?45,"DOB",!,APCD80D
 Q
