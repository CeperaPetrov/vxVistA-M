APCDVMDD ; IHS/CMI/TUCSON - VISIT MERGE ; [ 07/10/02  5:57 AM ]
 ;;2.0;IHS RPMS/PCC Data Entry;**5**;MAR 09, 1999
 ;
 W !!,"This option is used to merge 2 visits on 2 different dates.",!,"Be very careful in using this option.  This will normally need to be used only",!,"when a lab or radiology visit that occurred after midnight needs to be merged",!
 W "to a visit that occurred before midnight.",!!
 ;merge 2 visits during data entry process.
 D GETPAT
 I 'APCDPAT D EOJ Q
 W !!,"Select 'From' visit.",!
 S APCDVV="APCDVMF" D GETVISIT
 I 'APCDVMF D EOJ Q
 ;S APCDVLDT=+^AUPNVSIT(APCDVMF,0)\1
 W !!,"Select 'To' visit.",!
 S APCDVV="APCDVMT" D GETVISIT
 I 'APCDVMT D EOJ Q
 I APCDVMF=APCDVMT W !!,"'From' and 'To' the same.  Bye!" D EOJ Q
 I $D(^ABSBITMS(9002302,"AD",APCDVMF)) W !!,"Cannot merge from a visit that has a Claim associate with it." D EOJ Q  ;IHS/CMI/LAB - patch 3 per FSI
 W !!!,"You will be merging the following 2 visits:"
 W !,"FROM VISIT:" S APCDAX=APCDVMF D WRITE
 W !,"TO VISIT:" S APCDAX=APCDVMT D WRITE
 W !! S DIR(0)="Y",DIR("A")="Do you want to continue",DIR("B")="N" KILL DA D ^DIR KILL DIR
 I $D(DIRUT) D EOJ Q
 I 'Y D EOJ Q
 W !!,"*** FROM VISIT ***"
 K DR S APCDVDSP=APCDVMF D ^APCDVDSP
 W !!,"*** TO VISIT ***"
 K DR S APCDVDSP=APCDVMT D ^APCDVDSP
EN1 ;EP
RDR ;EP
 I 'APCDVMT W !!,$C(7),$C(7),"'TO' VISIT NOT DEFINED" D EOJ Q
 I 'APCDVMF W !!,$C(7),$C(7),"'FROM' VISIT NOT DEFINED" D EOJ Q
 R !!,"Do you want to merge the two visits? (Y/N) Y//",APCDVMX:$S($D(DTIME):DTIME,1:300) S:'$T APCDVMX="N" S:APCDVMX="" APCDVMX="Y" S APCDVMX=$E(APCDVMX) I "YyNn"'[APCDVMX W $C(7) G RDR
 I "Nn"[APCDVMX D EOJ Q
 D ^APCDVM2
 I $D(APCDVMQF) W !!,"*** ERROR encountered.  QFLG=",APCDVMQF D EOJ Q
 S $P(^AUPNVSIT(APCDVMF,0),U,37)=APCDVMT ;direct set as visit is being deleted.  set for billing
 S AUPNVSIT=APCDVMF D DEL^AUPNVSIT
 W !!,"*** MERGED VISIT ***"
 D ZTSK
 K DR S APCDVDSP=APCDVMT D ^APCDVDSP
 S APCDVSIT=APCDVMT D ^APCDVCHK K APCDVSIT
 D EOJ
 Q
 ;
GETPAT ; GET PATIENT
 W !
 S APCDPAT=""
 S DIC="^AUPNPAT(",DIC(0)="AEMQ" D ^DIC K DIC
 Q:Y<0
 S APCDPAT=+Y
 Q
 ;
GETVISIT ;
 K APCDVLK
 S APCDLOOK=""
 D ^APCDVLK
 S @APCDVV=APCDLOOK
 K APCDLOOK
 Q
 ;
ZTSK ;
 S X="APCDVM3" X ^%ZOSF("TEST") Q:'$T
 K ZTSAVE F %="APCDVMF","APCDVMT" S ZTSAVE(%)=""
 S ZTRTN="^APCDVM3",ZTDESC="PACKAGE VISIT MERGE",ZTIO="",ZTDTH=DT D ^%ZTLOAD
 K ZTSK
 Q
 ;
 ;
WRITE ; WRITE VISITS FOR SELECT
 NEW APCDA11,APCDAT
 S APCDA11=$G(^AUPNVSIT(APCDAX,11)),APCDAX=^AUPNVSIT(APCDAX,0)
 S APCDAT=$P(+APCDAX,".",2),APCDAT=$S(APCDAT="":"<NONE>",$L(APCDAT)=1:APCDAT_"0:00 ",1:$E(APCDAT,1,2)_":"_$E(APCDAT,3,4)_$E("00",1,2-$L($E(APCDAT,3,4)))_" ")
 W !,$$FMTE^XLFDT($P($P(APCDAX,U),".")),"  TIME: ",APCDAT,"TYPE: ",$P(APCDAX,U,3),"  CATEGORY: ",$P(APCDAX,U,7)
 W "  CLINIC: ",$S($P(APCDAX,U,8)]"":$E($P(^DIC(40.7,$P(APCDAX,U,8),0),U),1,8),1:"<NONE>"),?56,"DEC: ",$S($P(APCDAX,U,9):$P(APCDAX,U,9),1:0)
 I $P(APCDA11,U,3)]"" W ?64,"VCN: ",$P(APCDA11,U,3)
 K APCDAT
 Q
EOJ ; EOJ CLEAN UP
 K APCDCAT,APCDCLN,APCDDATE,APCDDOB,APCDDOD,APCDLOC,APCDPAT,APCDSEX,APCDTYPE,APCDVSIT,APCDVMF,APCDVMT,APCDVMX,APCDVV
 K AUPNPAT,AUPNSEX,AUPNDAYS,AUPNDOB,AUPNVSIT,AUPNDOD
 Q
