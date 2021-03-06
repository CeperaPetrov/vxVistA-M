APCDKBV ; IHS/CMI/TUCSON - LINK DIF DAY BLOOD BANK VISITS ; [ 08/26/03  1:58 PM ]
 ;;2.0;IHS RPMS/PCC Data Entry;**7**;MAR 09, 1999
 ;
 ; -- ** THANKS TO LINDA FELS
 ;    ** FOR THE ORIGINAL ROUTINE.
 ; -- This routine takes visits with only v blood bank entries and completes
 ;     them with a pov of lab draw and lab tech as the provider.
 ;     Using the order date, the original visit is searched for. 
 ;     If found, the original visit is set in the Billing Link field
 ;     of the Visit file for the lab only visit.
 ;
 Q
 ;
QUEUE ;EP; entry point to run linker in background
 I '$D(ZTQUEUED) W !!,"Orphaned V Blood Bank Linker is being queued to run in the background!",!,"Dates of the run will be automatically calculated based on the PCC delay",!,"value.",!
 NEW DELAY,X1,X2,X
 Q:'$$LABTECH  Q:'$$LABCLN
 S DELAY=$$VALI^XBDIQ1(9001005.1,1,.03),DELAY=DELAY+7
 S X1=DT,X2=-DELAY D C^%DTC S APCDED=X
 S X1=APCDED,X2=-60 D C^%DTC S APCDBD=X
 NEW X
 S X=$P(^AUTTSITE(1,0),U,24)
 Q:X=""  ;visit relinker has not been run - send mail message?
 I X<APCDED Q  ;visit relinker not run up to ending date
 D START(1)
 Q
 ;
 ;
MANUAL ;EP; entry to run linker manually
 NEW DIR,X,Y,DELAY,X1,X2
 D ^XBCLS W !!?20,"FIX UNLINKED BLOOD BANK VISITS",!!
 ;
 I '$$LABTECH D  Q
 . W !!,$C(7),"You do not have a generic Lab Technician provider entry"
 . W !,"in your database.  Cannot run fix for unlinked V BLOOD BANK visits."
 . S DIR(0)="E",DIR("A")="Press ENTER" D ^DIR
 ;
 I '$$LABCLN D  Q
 . W !!,$C(7),"You do not have LABORATORY as a clinic stop.  Cannot run"
 . W !,"fix for unlinked labs."
 . S DIR(0)="E",DIR("A")="Press ENTER" D ^DIR
 ;
DATES K APCDED,APCDBD
 K DIR W ! S DIR(0)="DO^::EXP",DIR("A")="Enter Beginning Date for Search"
 D ^DIR Q:Y<1  S APCDBD=Y
 K DIR S DIR(0)="DO^::EXP",DIR("A")="Enter Ending Date for Search"
 D ^DIR Q:Y<1  S APCDED=Y
 ;
 I APCDED<APCDBD D  G DATES
 . W !!,$C(7),"Sorry, Ending Date MUST not be earlier than Beginning Date."
 ;
 S DELAY=$$VALI^XBDIQ1(9001005.1,1,.03)
 S X1=DT,X2=-DELAY D C^%DTC I APCDED>X D  G DATES
 . W !!,$C(7),"Sorry, Cannot pick date within PCC Delay.  Select a date"
 . W !,"earlier than ",$$FMTE^XLFDT(X,5),"."
 ;
 S DELAY=$P(^AUTTSITE(1,0),U,24)
 I DELAY="" D  G DATES
 .W !!,$C(7),"PCC Visit Relinker has not been run.   You cannot complete blood bank visits"
 .W !,"until the relinker is run.  See your site manager for assistance."
 I DELAY<APCDED D  G DATES
 .W !!,$C(7),"You have picked a date that is later than the date the visit relinker",!,"was last run.  You must run the visit relinker first.  See your site manager",!,"for assistance."
 .W "  You must pick an ending date which is earlier than ",$$FMTE^XLFDT(DELAY,5),".",!
 K DIR S DIR(0)="Y"
 S DIR("A")="Do you want these visits transmitted to the Data Center"
 S DIR("?",1)="Answer YES if the data range you have selected is for"
 S DIR("?",2)="the current fiscal year.  You WILL want those visits"
 S DIR("?",3)="transmitted to DDPS.",DIR("?",4)=" "
 S DIR("?",5)="Answer NO if you are running this for past fiscal years."
 S DIR("?")=" " D ^DIR Q:Y=U
 ;
 W !!,"Search begun"
 D START(Y)
 W !!,"Search COMPLETED.  ",+$G(APCDCNT)," Visits fixed."
 Q
 ;
 ;
START(APCDZMOD) ; begin of linker logic
 ; APCDZMOD=1 if MOD^AUPNVSIT is to be called
 NEW APCDT,APCDEND,APCDV,X,Y
 Q:'$G(APCDBD)  Q:'$G(APCDED)
 ;
 ; -- loop visit dates to find unlinked labs
 S APCDT=APCDBD-.0001,APCDEND=APCDED+.2400
 F  S APCDT=$O(^AUPNVSIT("B",APCDT)) Q:'APCDT!(APCDT>APCDEND)  D
 . S APCDV=0
 . F  S APCDV=$O(^AUPNVSIT("B",APCDT,APCDV)) Q:'APCDV  D
 .. I $D(^AUPNVPOV("AD",APCDV))!$D(^AUPNVPRV("AD",APCDV)) Q  ;good vst
 .. Q:'$D(^AUPNVBB("AD",APCDV))  ;not a lab visit
 .. S X=$$VALI^XBDIQ1(9000010,APCDV,.07) I (X'="A"),(X'="S") Q
 .. ;S X=$O(^AUPNVBB("AD",APCDV,0)) I X,$$GET1^DIQ(9000010.31,X,1202)\1=APCDT\1 Q  ;if ordered on same date, quit
 .. S X=$O(^AUPNVBB("AD",APCDV,0)) I X,($P($P($G(^AUPNVBB(X,12)),U,11),".")=$P(APCDT,".")) Q
 .. ;
 .. D LINK(APCDV) ;link to original visit
 .. D STUFF(APCDV,APCDZMOD) ;stuff pov and provider
 .. I '$D(ZTQUEUED) S APCDCNT=$G(APCDCNT)+1 W "."
 .. I $P($G(^APCDSITE(DUZ(2),0)),U,24)="Y" D
 ... K DD,D0,DO,DINUM,DIC,DA,DR S DIC(0)="EL",DIC="^APCDLLOG(",DLAYGO=9001001.7,DIADD=1,X=APCDV,DIC("DR")=".02////"_DT_";.03///B" D FILE^DICN K DIC,DR,DIE,DIADD,DLAYGO,X,D0
 .. ;W !,APCDT,?20,APCDV Q  ;used to watch progress of rtn
 K APCDED,APCDBD
 Q
 ;
 ;
LINK(APCDVST) ; -- find orig visit and set link
 NEW APCDX,APCDLAB,ORDT,ORDPRV,DFN,DATE,PRV,ORDV,LINK
 ;
 ; -- get first lab entry for visit
 S APCDLAB=$O(^AUPNVBB("AD",APCDVST,0)) Q:'APCDLAB
 K APCDX D ENP^XBDIQ1(9000010.31,APCDLAB,".02;1202;1211","APCDX(","I")
 S ORDT=APCDX(1211,"I") Q:ORDT=""        ;order date
 S ORDPRV=APCDX(1202,"I") Q:ORDPRV=""    ;ordering provider
 S DFN=APCDX(.02,"I") Q:DFN=""           ;patient
 ;
 ; -- look for orig visit based on order date for patient and provider
 K LINK S DATE=$$RVDT(ORDT)-.0001,END=$$RVDT(ORDT)+.9999999
 F  S DATE=$O(^AUPNVSIT("AA",DFN,DATE)) Q:'DATE!(DATE>END)!($D(LINK))  D
 . ; -- find all visits for patient on order date
 . S ORDV=0 F  S ORDV=$O(^AUPNVSIT("AA",DFN,DATE,ORDV)) Q:'ORDV  D
 .. ; -- find if ordering provider linked to this visit
 .. S PRV=0 F  S PRV=$O(^AUPNVPRV("AD",ORDV,PRV)) Q:'PRV!($D(LINK))  D
 ... I +^AUPNVPRV(PRV,0)=ORDPRV S LINK=ORDV ;orig visit found
 ;
 ; -- if orig visit found, set link
 I $G(LINK) S DIE=9000010,DA=APCDVST,DR=".28////"_LINK D ^DIE
 Q
 ;
 ;
STUFF(AUPNVSIT,APCDZMOD) ; -- stuff pov and provider
 NEW APCDT,APCDV ;protect variables from loop
 NEW APCDALVR,DFN
 S DFN=$$VALI^XBDIQ1(9000010,AUPNVSIT,.05) Q:DFN=""
 ;
 ; -- if okay to transmit, set date modified
 I APCDZMOD D MOD^AUPNVSIT
 ;
 ; -- stuff lab as clinic if clinic is blank
 I $$VALI^XBDIQ1(9000010,AUPNVSIT,.08)="" D
 . S DIE="^AUPNVSIT(",DA=AUPNVSIT,DR=".08////"_$$LABCLN D ^DIE
 ;
 ; -- create purpose of visit entry
 ; -- uses lab draw (ICD code V72.6)
 K APCDALVR
 S APCDALVR("APCDPAT")=DFN,APCDALVR("APCDVSIT")=AUPNVSIT
 S APCDALVR("APCDATMP")="[APCDALVR 9000010.07 (ADD)]"
 S APCDALVR("APCDTPOV")="V72.6"
 S APCDALVR("APCDTNQ")="LABORATORY EXAMINATION"
 D ^APCDALVR
 I $D(APCDALVR("APCDAFLG")) Q
 ;
 ; -- create v provider entry
 ; -- uses lab tech (23) plus affiliation based on PCC site type
 K APCDALVR
 S APCDALVR("APCDPAT")=DFN,APCDALVR("APCDVSIT")=AUPNVSIT
 S APCDALVR("APCDATMP")="[APCDALVR 9000010.06 (ADD)]"
 I $$PROVP=6 S X=$O(^DIC(6,"GIHS",$$LABTECH,0)) Q:'X
 I $$PROVP=200 S X=$O(^VA(200,"GIHS",$$LABTECH,0)) Q:'X
 S APCDALVR("APCDTPRO")="`"_X
 S APCDALVR("APCDTPS")="P"
 D ^APCDALVR
 Q
 ;
RVDT(X) ; -- returns reverse date 
 Q 9999999-X
 ;
LABTECH() ; -- returns code if lab tech entry exists in file 200
 NEW SITE,CODE
 S SITE=$$VALI^XBDIQ1(9001000,DUZ(2),.04) I SITE="" Q 0
 S CODE=$P($T(@SITE),";;",2)_"23999"
 I $$PROVP=200,'$D(^VA(200,"GIHS",CODE)) Q 0
 I $$PROVP=6,'$D(^DIC(6,"GIHS",CODE)) Q 0
 Q CODE
 ;
PROVP() ; -- returns pointer file # for providers
 NEW X S X=$P(^DD(9000010.06,.01,0),U,2)
 Q $S(X["200":200,1:6)
 ;
LABCLN() ; -- returns ien for lab clinic code
 Q +$O(^DIC(40.7,"C","76",0))
 ;
AFFIL ;; affiliation recode
I ;;1;;IHS
C ;;2;;CONTRACT       
T ;;3;;TRIBAL
O ;;9;;OTHER
6 ;;8;;638
V ;;9;;VA (OTHER)
P ;;3;;TRIBAL
U ;;9;;OTHER
