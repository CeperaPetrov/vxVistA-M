APCDEAPC ; IHS/CMI/TUCSON - ENTRY OF DATA FROM APC FORMS ; [ 02/15/00  10:57 AM ]
 ;;2.0;IHS RPMS/PCC Data Entry;**2**;MAR 09, 1999
 ;FILE 200 CONV
 ;
 ;
 ;
HDR ; Write Header
 W:$D(IOF) @IOF
 F APCDJ=1:1:5 S APCDX=$P($T(TEXT+APCDJ),";;",2) W !?80-$L(APCDX)\2,APCDX
 K APCDX,APCDJ
 W !!
 D ^APCDEIN S APCDTPLT=0
 Q:APCDFLG
PROC ;
 D GETLOC
 G:APCDLOC="" EOJ
 S APCDDATE="" F  D GETDATE Q:APCDDATE=""  F  S APCDPAT="" D GETPAT Q:APCDPAT=""  D PROCESS
 D EOJ
 Q
 ;
 ;
 ;
GETLOC ; GET LOCATION OF ENCOUNTER
 S APCDLOC="",APCDTYPE="",APCDCAT=""
 S APCDTYPE=$P(APCDPARM,U,11) I APCDTYPE="" W !!,"Default TYPE FOF VISIT NOT in Site Parameter File",$C(7),$C(7) H 4 Q
 S APCDCAT="A"
 S APCDLOC="" I $D(APCDDEFL),APCDDEFL]"" S DIC("B")=$P(^DIC(4,APCDDEFL,0),U)
 S DIC("A")="Enter LOCATION of VISIT......: ",DIC="^AUTTLOC(",DIC(0)="AEMQ" D ^DIC K DIC
 Q:Y<0
 S APCDLOC=+Y
 Q
 ;
 ;
GETDATE ; GET DATE OF ENCOUNTER
 S APCDDATE=""
 W !,"Enter VISIT DATE.............: " R X:$S($D(DTIME):DTIME,1:300) S:'$T X=""
 Q:X=""!(X="^")
 S %DT="ET" D ^%DT G:Y<0 GETDATE
 I Y>DT W "  <Future dates not allowed>",$C(7),$C(7) K X G GETDATE
 S (APCDDATE,APCDHDAT)=Y
 Q
GETPAT ; GET PATIENT
 S APCDDATE=APCDHDAT
 W:$D(IOF) @IOF W !!,"Entering forms for ",$P(^DIC(4,APCDLOC,0),U)," for visit date ",$$FMTE^XLFDT(APCDDATE,1)
 S APCDPAT=""
 S DIC("A")="Enter PATIENT NAME...........: ",DIC="^AUPNPAT(",DIC(0)="AEMQ" D ^DIC K DIC
 Q:Y<0
 I $D(APCDPARM),$P(APCDPARM,U,3)="Y" W !?25,"Ok" S %=1 D YN^DICN Q:%'=1
 S APCDPAT=+Y
 I DUZ("AG")="I" D ^APCDEMDI I $D(^APCDSITE(DUZ(2),11)) D ^APCDECC
 Q
 ;
PROCESS ; PROCESS PATIENT
TIME ;
 S DIR(0)="SB^1:8AM - NOON;2:NOON - 5PM;3:5PM - 10PM;4:10PM - 8AM",DIR("A")="Enter TIME OF DAY" K DA D ^DIR K DIR
 I $D(DIRUT) W !,"Time is required",!! Q
 S APCDDATE=APCDDATE_"."_$S(Y=1:"08",Y=2:12,Y=3:17,Y=4:22,1:12)
CLINIC ;
 K DIC S DIC(0)="AEMQ",DIC="^DIC(40.7,",DIC("A")="Enter TYPE OF CLINIC CODE....: " D ^DIC K DIC
 I Y<0 W !!,"Clinic is required",!! H 2 Q
 ;S DIR(0)="9000010,.08",DIR("A")="Enter TYPE OF CLINIC CODE...." K DA D ^DIR K DIR
 ;I $D(DIRUT) W !!,"Clinic is required",!! Q
 S APCDCLN="`"_+Y
 D VISIT
 Q
 ;
VISIT ; create visit
 ;W !!,"Creating PCC Visit for ",$P(^DPT(APCDPAT,0),U)," on ",$$FMTE^XLFDT(APCDDATE,"1P"),!!
 S X=$$FMTE^XLFDT(APCDDATE,1) X $P(^DD(9000010,.01,0),U,5,99)
 I '$D(X) W !!,"Visit information NOT correct for this patient.",!,$C(7),$C(7) H 3 Q
 K APCDALVR
 D ^APCDALV
 I $D(APCDALVR("APCDAFLG")) W !!,$C(7),$C(7),"Visit creation failed!!",! Q
 I '$G(APCDVSIT) W !!,"No visit selected!!" Q
 K APCDALVR
 D PROVIDER
 I '$$PRIMPROV^APCLV(APCDVSIT,"I") W !!,$C(7),$C(7),"Primary Provider Not Entered correctly.  Deleting incomplete visit.",! H 5 D DELETE Q
 D APCPOV
 I '$$PRIMPOV^APCLV(APCDVSIT,"I") W !!,$C(7),$C(7),"Purpose of Visit Not Entered correctly.  Deleting incomplete visit.",! H 5 D DELETE Q
 D MNEPROC
 Q
MNEPROC ; PROCESS MNEMONICS UNTIL DONE
 W !!,"You may now enter any other information using the PCC mnemonics.",!
 S APCDMPQ=0
 F  D GETMNE Q:APCDMPQ
 D GETMNEK
 K APCDMPQ
 Q
 ;
GETMNE ; GET MNEMONIC
 W !
 S DIC="^APCDTKW(",DIC(0)="AEMQ",DIC("A")="MNEMONIC: ",DIC("S")="I $L($P(^(0),U))<5" D ^DIC K DIC("A"),DIC("S")
 I Y<0 D CHECK^APCDEGP0 Q
 S APCDMNE=+Y,APCDMNE("NAME")=$P(Y,U,2)
 K APCDMOD
 D ^APCDEA3
 I $D(APCDEQX) D ^APCDEQX I $D(APCDEQX) S APCDMPQ=1 Q
 I $D(APCDMOD) W !!,"Switching to Modify Mode for ONE Mnemonic ONLY!" S APCDMODE="M",APCDVLK=APCDVSIT D GETMNE K APCDVLK,APCDMOD S APCDMODE="A" W !!,"Switching back to ENTER Mode!" Q
 Q
 ;
GETMNEK ; KILL GETMNE SPECIFIC VARIABLES
 K APCDVSIT,APCDEGX,APCDEQX
 Q
APCPOV ;get APC RECODES AND FILE
 K APCDALVR
 S DIC="^AUTTRCD(",DIC(0)="AEMQ",DIC("A")="Enter APC CODE...............: " D ^DIC K DIC,DA
 I Y=-1&((X="")!(X="^"))&('$$PRIMPOV^APCLV(APCDVSIT,"I")) G ICDPOV
 Q:Y=-1
 S APCDAPCC=$P(Y,U,2),APCDAPC=+Y I APCDAPCC>699&(APCDAPCC<800) D INJ
 S APCDICD=$P(^AUTTRCD(APCDAPC,0),U,6) I APCDICD="" W !!,$C(7),$C(7),"NO ICD CODE ASSOCIATED WITH APC CODE ",APCDAPCC H 3 Q
 S APCDALVR("APCDTPOV")=APCDICD
 S APCDALVR("APCDVSIT")=APCDVSIT,APCDALVR("APCDATMP")="[APCDALVR 9000010.07 (ADD)]",APCDALVR("APCDPAT")=APCDPAT
 S APCDALVR("APCDTNQ")=$P(^AUTTRCD(APCDAPC,0),U,3)
 D ^APCDALVR
 I $D(APCDALVR("APCDAFLG")) W !!,$C(7),$C(7),"Creating V Provider failed..."
 G APCPOV
 Q
ICDPOV ;
 K APCDALVR
 S DIC="^APCDTKW(",DIC(0)="E",X="IPV" D ^DIC K DIC,DA
 I Y=-1 W !!,$C(7),$C(7),"Can't find IPV mnemonic!!",! H 4 Q
 S APCDMNE=+Y,APCDMNE("NAME")=$P(Y,U,2)
 D ^APCDEA3
 Q
PROVIDER ;
 X:$D(^DD(9000010.06,.01,12.1)) ^DD(9000010.06,.01,12.1)
 S DIC=$S($P(^DD(9000010.06,.01,0),U,2)[200:"^VA(200,",1:"^DIC(6,"),DIC(0)="AEMQ",DIC("A")=$S('$$PRIMPROV^APCLV(APCDVSIT,"I"):"Enter PRIMARY Provider.......: ",1:"Enter OTHER Provider.........: ") D ^DIC K DIC
 Q:Y=-1
PROV11 ;
 S APCDALVR("APCDTPRO")="`"_+Y
 S APCDALVR("APCDVSIT")=APCDVSIT,APCDALVR("APCDATMP")="[APCDALVR 9000010.06 (ADD)]",APCDALVR("APCDPAT")=APCDPAT
 S APCDALVR("APCDTPS")=$S($$PRIMPROV^APCLV(APCDVSIT,"I"):"S",1:"P")
 D ^APCDALVR
 I $D(APCDALVR("APCDAFLG")) W !!,$C(7),$C(7),"Creating V Provider failed..."
 G PROVIDER
 Q
INJ ;
CAUSE ;
 S DIC="^AUTTRIJ(",DIC(0)="AEMQ",DIC("A")="Enter EXTERNAL CAUSE OF INJURY: " D ^DIC K DA,DIC
 I Y=-1 W !,"NO External Cause entered.",! G PLACE
 S APCDALVR("APCDTCI")=$P(^AUTTRIJ(+Y,0),U,3)
 S APCDALVR("APCDTFR")="F"
PLACE ;
 S DIR(0)="9000010.07,.11",DIR("A")="Enter PLACE OF INJURY" K DA D ^DIR K DIR
 G:$D(DIRUT) CAUSEDX
 G:Y="" CAUSEDX
 S APCDALVR("APCDTPA")=Y
CAUSEDX ;
 S DIR(0)="9000010.07,.07",DIR("A")="Enter CAUSE OF DX (if alcohol related)" K DA D ^DIR K DIR
 W !
 Q:$D(DIRUT)
 Q:Y=""
 S APCDALVR("APCDTCD")=Y
 Q
DELETE ;
 S APCDVDLT=APCDVSIT D ^APCDVDLT
 W !!,"Deleted.",!
 Q
EOJ ; END OF JOB
 D KILL^AUPNPAT
 K APCDVSIT,APCDAPC,APCDAPCC,APCDHDAT,APCDDATE,APCDLOC,APCDTYPE,APCDCAT,APCDMNE,APCDALVR,APCDICD,APCDRV,APCDTCB,APCDTCM,APCDTORH
 D ^APCDEKL
 Q
TEXT ;
 ;;PCC Data Entry Module
 ;;
 ;;***********************
 ;;* APC FORM ENTRY Mode *
 ;;***********************
 ;;