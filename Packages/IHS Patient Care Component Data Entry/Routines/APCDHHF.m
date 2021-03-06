APCDHHF ; IHS/CMI/TUCSON - GET HISTORICAL VISIT DATE ; [ 01/20/04  8:01 AM ]
 ;;2.0;IHS RPMS/PCC Data Entry;**2,7**;MAR 09, 1999
 ;
ENHHF(PATDFN,TEXT,APCDTEMP,SRVCAT) ;
 S APCDTDA=""
 D EN^XBNEW("ENHHF1^APCDHHF","PATDFN;TEXT;APCDTEMP;APCDTDA;SRVCAT")
 Q
ENHHF1 ;
 S (APCDPAT,AUPNPAT)=PATDFN
 S Y=AUPNPAT D ^AUPNPAT
 S DIR(0)="D^::EP",DIR("A")="Enter Date of Historical "_TEXT KILL DA D ^DIR KILL DIR
 I $D(DIRUT) W !!,"Not date entered." Q
 S APCDTX=Y
 S:$E(APCDTX,6,7)="00" APCDTX=$E(APCDTX,1,5)_"01" S:$E(APCDTX,4,5)="00" APCDTX=$E(APCDTX,1,3)_"01"_$E(APCDTX,6,7) S:APCDTX'["." APCDTX=APCDTX_".12" ;Y2000
 ;end Y2K
 S X=APCDTX
 X $P(^DD(9000010,.01,0),"^",5,99) I '$D(X) W !!,APCDTMG1,!,APCDTMG2,! S APCDTX="" G ENHHF1
 S APCDVLDT=APCDTX,APCDLOOK=""
 S APCDGHVD="",APCDTERR=0,APCDTMG1="Enter a Date betwen the Patient's DOB and Today.",APCDTMG2="Can be imprecise (e.g. 1975 or 3/1975 or 3/4/1975).  Time optional."
 D ^APCDVLK
 K APCDCLN
 I APCDGHVD="^" S APCDTERR=1 G XIT
 I APCDLOOK="" D CREATE I APCDVSIT="" G ENHHF1
 S Y=PATDFN D ^AUPNPAT
 ;call DIE to update V File
 S APCDPAT=PATDFN
 S DA=APCDVSIT,DIE="^AUPNVSIT(",DR=APCDTEMP
 D ^DIE
 D ^XBFMK
XIT ;
 K Y,X,APCDVLDT,APCDTMG1,APCDTMG2,APCDGHVD
 Q
CREATE ;
 W !,"Creating PCC Visit...",!
 S APCDVSIT=""
 S Y=AUPNPAT D ^AUPNPAT
 K APCDALVR
 S APCDALVR("APCDPAT")=PATDFN
 S APCDALVR("APCDDATE")=APCDTX
 ;get type of visit
 K DIR
 S DIR("B")=$P($G(^APCDSITE(DUZ(2),0)),U,17)
 S DIR(0)="9000010,.03",DIR("A")="TYPE" D ^DIR K DIR
 I $D(DIRUT) W !!,"Visit Type is required!" D ^XBFMK K APCDALVR Q
 S APCDALVR("APCDTYPE")=Y
LOC ;get location and outside location
 S APCDLOC=""
 S DIC(0)="AEMQ",DIC="^AUTTLOC(" D ^DIC K DIC
 I Y=-1 W !!,"Location is required.  ^ NOT ALLOWED" G LOC
 S APCDALVR("APCDLOC")=+Y
 I $E($P(^AUTTLOC(+Y,0),U,10),5,6)<50 G CAT
 I $P($G(^APCDSITE(DUZ(2),0)),U,16)'="Y" G CAT
 S DIR(0)="9000010,2101",DIR("A")="Enter OUTSIDE Location" KILL DA D ^DIR KILL DIR
 I Y]"" S APCDALVR("APCDOLOC")=Y
CAT ;
 S APCDALVR("APCDCAT")=$S($G(SRVCAT)]"":SRVCAT,1:"E")
 S APCDALVR("APCDAUTO")="",APCDALVR("APCDADD")=""
 D ^APCDALV
 I $D(APCDALVR("APCDAFLG")) W !!,"creating visit failed" K APCDALVR D ^XBFMK Q
 S APCDVSIT=APCDALVR("APCDVSIT")
 Q
