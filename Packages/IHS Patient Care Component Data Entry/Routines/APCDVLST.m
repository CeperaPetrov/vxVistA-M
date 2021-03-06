APCDVLST ; IHS/CMI/TUCSON - VISIT LIST BY PATIENT ; [ 06/17/02  10:29 AM ]
 ;;2.0;IHS RPMS/PCC Data Entry;**2,3,5**;MAR 09, 1999
 W:$D(IOF) @IOF W !,"This routine will list all Visits for a Selected Patient in a",!,"specified Posting Date or Visit Date Range.",!
 ;
RDPV ; Determine to run by Posting date or Visit date
 S APCDBEEP=$C(7)_$C(7),APCDSITE="" S:$D(DUZ(2)) APCDSITE=DUZ(2)
 I '$D(DUZ(2)) S APCDSITE=+^AUTTSITE(1,0)
 S DIR(0)="S^1:Posting Date;2:Visit Date",DIR("A")="Run Report by",DIR("B")="P" D ^DIR K DIR S:$D(DUOUT) DIRUT=1
 I $D(DIRUT) G EOJ
 S Y=$E(Y),APCDX=$S(Y=1:"P",Y=2:"V",1:Y)
GETDATES ;
BD ;get beginning date
 W ! S DIR(0)="D^:DT:EP",DIR("A")="Enter beginning "_$S(APCDX="P":"Posting",APCDX="V":"Visit",1:"Posting")_" Date for Search" D ^DIR K DIR S:$D(DUOUT) DIRUT=1
 S APCDBD=Y
 I $D(DIRUT) G EOJ
 S APCDBD=Y D DD^%DT S APCDBDD=Y
ED ;get ending date
 W ! S DIR(0)="DA^"_APCDBD_":DT:EP",DIR("A")="Enter ending "_$S(APCDX="P":"Posting",APCDX="V":"Visit",1:"Posting")_" Date for Search: " S Y=APCDBD D DD^%DT S DIR("B")=Y,Y="" D ^DIR K DIR S:$D(DUOUT) DIRUT=1
 I $D(DIRUT) G BD
 S APCDED=Y D DD^%DT S APCDEDD=Y
 S X1=APCDBD,X2=-1 D C^%DTC S APCDSD=X
 ;
GETPAT ; GET PATIENT
 K AUPNDOB,AUPNDOD,AUPNSEX
 W !
 S AUPNLK("INAC")=""
 S AUPNPAT=""
 S DIC="^AUPNPAT(",DIC(0)="AEMQ" D ^DIC K DIC
 G:Y<0 EOJ
 S AUPNPAT=+Y
BRPR ;
 S DIR(0)="SO^B:BROWSE Output on Screen;P:PRINT Output to Printer",DIR("A")="Do you want to",DIR("B")="B" K DA D ^DIR K DIR
 G:$D(DIRUT) GETPAT
 I Y="B" D BROWSE,EOJ Q
 S XBRP="DRIVER^APCDVLST",XBRC="PROC^APCDVLST",XBRX="EOJ^APCDVLST",XBNS="APCD;AUPN"
 D ^XBDBQUE
 D EOJ
 Q
 ;
DRIVER ; Driver
 S APCDF=1
 D @APCDX
 Q
 ;
PROC ;EP - called from xbdbque
 Q
EOJ ; EOJ Clean up and xit.
 K AUPNLK("INAC")
 K APCDX,APCDBD,APCDBDD,APCDT,APCDED,APCDSD,APCDODAT,APCDVDFN,APCDLST,APCDHRN,APCDVR,APCDCAT,APCDTYPE,%,%1,APCDEDD,IO("Q"),APCDF
 Q
 ;
BROWSE ;
 D VIEWR^XBLM("DRIVER^APCDVLST","Visit List in Date Range")
 Q
DISP ;
 S APCDHRN="" S:$D(^AUPNPAT(AUPNPAT,41,DUZ(2),0)) APCDHRN=$P(^AUPNPAT(AUPNPAT,41,DUZ(2),0),U,2)
 W:APCDF !!,"Visits for ",$P(^DPT(AUPNPAT,0),U)," in ",$S(APCDX="P":"Posting",APCDX="V":"Visit",1:"Posting")," date range ",APCDBDD," to ",APCDEDD,!,"Health Record Number: ",APCDHRN,!
 S APCDF=0
 S DA=APCDVDFN,DIC="^AUPNVSIT(",DR="0:VCN" D EN^DIQ
 NEW POV S POV=0 F  S POV=$O(^AUPNVPOV("AD",APCDVDFN,POV)) Q:POV'=+POV  W ?5,$$GET1^DIQ(9000010.07,POV,.01),?14,$$GET1^DIQ(9000010.07,POV,.04),!
 Q
 ;
P ; Run by Posting date  
 S APCDODAT=$O(^AUPNVSIT("AMRG",APCDSD)) Q:APCDODAT=""
 S APCDVDFN=$O(^AUPNVSIT("AMRG",APCDODAT,"")) I APCDVDFN="" W !,"An error has occurred in the AMRG cross reference.  Please notify your Supervisor" Q
 S APCDVDFN=APCDVDFN-1
 F APCDL=0:0 S APCDVDFN=$O(^AUPNVSIT("AC",AUPNPAT,APCDVDFN)) Q:APCDVDFN'=+APCDVDFN  S:$D(^AUPNVSIT(APCDVDFN,0)) APCDODAT=$P(^AUPNVSIT(APCDVDFN,0),U,2) Q:(APCDODAT>APCDED)  I $D(^AUPNVSIT(APCDVDFN,0)),'$P(^(0),U,11) D DISP
 Q
V ; Run by visit date
 S APCDODAT=9999999-(APCDED+1),APCDLST=(9999999-APCDBD)_".9999"
 F  S APCDODAT=$O(^AUPNVSIT("AA",AUPNPAT,APCDODAT)) Q:APCDODAT=""  Q:APCDODAT>APCDLST  D V1
 Q
V1 ;
 S APCDVDFN=0 F  S APCDVDFN=$O(^AUPNVSIT("AA",AUPNPAT,APCDODAT,APCDVDFN)) Q:APCDVDFN'=+APCDVDFN  I '$P(^AUPNVSIT(APCDVDFN,0),U,11) D DISP
 Q
ERR W !,"Must be a valid date and be Today or earlier. Time not allowed!" Q
 Q
