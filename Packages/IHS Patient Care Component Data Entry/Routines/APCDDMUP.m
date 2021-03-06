APCDDMUP ; IHS/CMI/LAB - EDITS FOR AUPNVSIT (VISIT:9000010) 24-MAY-1993 ; [ 01/06/04  8:59 AM ]
 ;;2.0;IHS RPMS/PCC Data Entry;**3,4,5,7**;MAR 09, 1999
 ;
 W:$D(IOF) @IOF
 W !,$$CTR("PCC DATA ENTRY",80)
 W !!,$$CTR("Diabetes Patient Data Update",80)
 W !
 S APCDDMPT="" D GETPAT
 I APCDDMPT="" D XIT Q
 W !!,"The data you enter for the above patient will be updated in the PCC",!,"database.",!
 S DIR(0)="Y",DIR("A")="Do you wish to continue",DIR("B")="Y" KILL DA D ^DIR KILL DIR
 I $D(DIRUT) D XIT Q
 I 'Y D XIT Q
 S APCDDA="" D CREATE
 I APCDDA="" W !!,"Exiting..." H 2 D XIT Q
 ;do screenman
 S DA=APCDDA,DDSFILE=9001002.2,DR="[APCD DM UPDATE]" D ^DDS
 I $D(DIMSG) W !!,"ERROR IN SCREENMAN FORM!!  ***NOTIFY PROGRAMMER***" D DEL K DIMSG H 3 D XIT Q
 D UPDPCC
 D XIT
 Q
 ;
UPDPCC ;update PCC
 K APCDDMER
 W !!,"Updating PCC database....hold on a moment...",!
 S APCDREC=^APCDDMUP(APCDDA,0)
 S APCDREC1=$G(^APCDDMUP(APCDDA,11))
 D PROB
 D HT
 D WT
 D BP^APCDDMU2
 D SMOKEHF
 D TBHF^APCDDMU2
 D SGHF^APCDDMU2
 D FOOT^APCDDMU1
 D EYE^APCDDMU1
 D DENTAL^APCDDMU1
 D PAP^APCDDMU1
 D MAM^APCDDMU1
 D FLU^APCDDMU1
 D PNEU^APCDDMU1
 D TD^APCDDMU1
 D PPD^APCDDMU2
 D EKG^APCDDMU2
 D EDUC^APCDDMU2
 D LAB^APCDDMU2
 D MED^APCDDMU2
 D RTLHF^APCDDMU3
 D LPHF^APCDDMU3
 D BTLHF^APCDDMU3
 I $D(APCDDMER) D
 .;call dir
 .S DIR(0)="E",DIR("A")="Please note the above messages, press enter to continue" KILL DA D ^DIR KILL DIR
 .Q
REF ;update refusals?
 S DIR(0)="Y",DIR("A")="Do you want to enter any Patient REFUSALS",DIR("B")="N" KILL DA D ^DIR KILL DIR
 I $D(DIRUT) G DEL
 I 'Y G DEL
 D REF^APCDDMU3
DEL S DA=APCDDA,DIK="^APCDDMUP(" D ^DIK
 Q
XIT ;
 D KILL^AUPNPAT
 K DIADD,DLAYGO
 D EN^XBVK("APCD"),EN^XBVK("AUPN")
 D ^XBFMK
 Q
PROB ;
 I $P(APCDREC,U,3)="" Q
 I $P(APCDREC,U,4)="" Q
 S N=$P(APCDREC,U,4) ;problem number to update
 S APCDN=$$PROBNUM(N)
 I 'APCDN W !!,"<<< Could not update Problem Number ",N," with Date of DM Onset. >>>" S APCDDMER=1 Q
 S APCDD=$P(APCDREC,U,3)
 D ^XBFMK
 S DA=APCDN,DIE="^AUPNPROB(",DR=".13///"_$$FMTE^XLFDT(APCDD) D ^DIE
 I $D(Y) W !!,"<<< Could not update Problem Number ",N," with Date of DM Onset.  DIE failed. >>>" S APCDDMER=1
 D ^XBFMK
 Q
HT ;
 K APCDVSIT
 I $P(APCDREC,U,5)="" Q
 I $P(APCDREC,U,6)="" Q
 S APCDDMDT=$P(APCDREC,U,5)
 S APCDMTYP=$O(^AUTTMSR("B","HT",0))
 D EVSIT ;get event visit
 I '$G(APCDVSIT) W !!,"Could not Create PCC Visit when attempting to update height.",! S APCDDMER=1 Q
 S (X,G)=0 F  S X=$O(^AUPNVMSR("AD",APCDVSIT,X)) Q:X'=+X!(G)  I $P(^AUPNVMSR(X,0),U)=APCDMTYP,$P(^AUPNVMSR(X,0),U,4)=$P(APCDREC,U,6) S G=1
 I G W !!,"Already have a height of ",$P(APCDREC,U,6)," on Visit Date ",$$FMTE^XLFDT($P(^AUPNVSIT(APCDVSIT,0),U)) S APCDDMER=1 Q
 K APCDALVR
 S APCDALVR("APCDPAT")=APCDDMPT
 S APCDALVR("APCDVSIT")=APCDVSIT
 S APCDALVR("APCDATMP")="[APCDALVR 9000010.01 (ADD)]"
 S APCDALVR("APCDTTYP")="`"_APCDMTYP
 S APCDALVR("APCDTVAL")=$P(APCDREC,U,6)
 D ^APCDALVR
 I $D(APCDALVR("APCDAFLG")) W !!,"Error creating V Measurement Entry for Height.  PCC not updated.",! S APCDDMER=1
 K APCDALVR
 Q
WT ;
 K APCDVSIT
 I $P(APCDREC,U,7)="" Q
 I $P(APCDREC,U,8)="" Q
 S APCDDMDT=$P(APCDREC,U,7)
 S APCDMTYP=$O(^AUTTMSR("B","WT",0))
 D EVSIT ;get event visit
 I '$G(APCDVSIT) W !!,"Could not Create PCC Visit when attempting to update weight.",! S APCDDMER=1 Q
 S (X,G)=0 F  S X=$O(^AUPNVMSR("AD",APCDVSIT,X)) Q:X'=+X!(G)  I $P(^AUPNVMSR(X,0),U)=APCDMTYP,$P(^AUPNVMSR(X,0),U,4)=$P(APCDREC,U,8) S G=1
 I G W !!,"Already have a weight of ",$P(APCDREC,U,8)," on Visit Date ",$$FMTE^XLFDT($P(^AUPNVSIT(APCDVSIT,0),U)) S APCDDMER=1 Q
 K APCDALVR
 S APCDALVR("APCDPAT")=APCDDMPT
 S APCDALVR("APCDVSIT")=APCDVSIT
 S APCDALVR("APCDATMP")="[APCDALVR 9000010.01 (ADD)]"
 S APCDALVR("APCDTTYP")="`"_APCDMTYP
 S APCDALVR("APCDTVAL")=$P(APCDREC,U,8)
 D ^APCDALVR
 I $D(APCDALVR("APCDAFLG")) W !!,"Error creating V Measurement Entry for Weight.  PCC not updated.",! S APCDDMER=1
 K APCDALVR
 Q
SMOKEHF ;
 K APCDVSIT
 I $P(APCDREC,U,9)="" Q
 S APCDDMDT=DT
 S APCDMTYP=$P(APCDREC,U,9)
 S APCDMCAT=$P(^AUTTHF(APCDMTYP,0),U,3)
 D EVSIT ;get event visit
 I '$G(APCDVSIT) W !!,"Could not Create PCC Visit when attempting to update smoking health factor.",! S APCDDMER=1 Q
 S (X,G)=0 F  S X=$O(^AUPNVHF("AD",APCDVSIT,X)) Q:X'=+X!(G)  I $P(^AUPNVHF(X,0),U)=APCDMTYP S G=1
 I G W !!,"Already have a health factor of ",$P(^AUTTHF($P(APCDREC,U,9),0),U)," on Visit Date ",$$FMTE^XLFDT($P(^AUPNVSIT(APCDVSIT,0),U)) S APCDDMER=1 Q
 K APCDALVR
 S APCDALVR("APCDPAT")=APCDDMPT
 S APCDALVR("APCDVSIT")=APCDVSIT
 S APCDALVR("APCDATMP")="[APCDALVR 9000010.23 (ADD)]"
 S APCDALVR("APCDTHF")="`"_APCDMTYP
 D ^APCDALVR
 I $D(APCDALVR("APCDAFLG")) W !!,"Error creating V Health Factor Entry for Smoking.  PCC not updated.",! S APCDDMER=1
 K APCDALVR
 ;update health status
 S APCDHSE="",X=0 F  S X=$O(^AUPNHF("AC",APCDDMPT,X)) Q:X'=+X!(APCDHSE)  I $P(^AUTTHF($P(^AUPNHF(X,0),U),0),U,3)=APCDMCAT S APCDHSE=X
 I APCDHSE D  Q
 .D ^XBFMK K DIADD
 .S DA=APCDHSE,DIE="^AUPNHF(",DR=".01///`"_APCDMTYP_";.03////"_DT D ^DIE
 .I $D(Y) W !!,"Error updating Health Status entry for Tobacco." S APCDDMER=1
 .D ^XBFMK
 D ^XBFMK
 S X=APCDMTYP,DIC("DR")=".02////"_APCDDMPT_";.03////"_DT,DIC(0)="L",DIADD=1,DLAYGO=9000019,DIC="^AUPNHF(" D FILE^DICN
 I Y=-1 W !!,"Error adding health status entry for Tobacco." S APCDDMER=1
 D ^XBFMK K DIADD
 Q
EVSIT ;get/create event visit
 K APCDVSIT
 K APCDALVR
 S APCDALVR("APCDAUTO")=""
 S APCDALVR("APCDPAT")=APCDDMPT
 S APCDALVR("APCDCAT")="E"
 S APCDALVR("APCDLOC")=DUZ(2)
 S APCDALVR("APCDTYPE")=$S($P($G(^APCCCTRL(DUZ(2),0)),U,4)]"":$P(^APCCCTRL(DUZ(2),0),U,4),1:"O")
 S APCDALVR("APCDDATE")=APCDDMDT_".12"
 D ^APCDALV
 S APCDVSIT=$G(APCDALVR("APCDVSIT"))
 I $G(APCDALVR("APCDVSIT","NEW")) D DEDT^APCDEA2(APCDVSIT)
 K APCDALVR
 Q
CREATE ;create entry in fileman file
 S APCDDA=""
 D ^XBFMK
 S X=APCDDMPT,DIC(0)="L",DIC("DR")=".02////^S X=DT",DIC="^APCDDMUP(",DIADD=1,DLAYGO=9001002.2 K DD,DO,D0 D FILE^DICN
 I Y=-1 W !!!,"Error creating fileman file entry.  Notify programmer" Q
 S APCDDA=+Y
 D ^XBFMK K DIADD,DLAYGO
 Q
GETPAT ;
 S APCDDMPT=""
 S DIC="^AUPNPAT(",DIC(0)="AEMQ" D ^DIC K DIC
 Q:Y<0
 S APCDDMPT=+Y
 I DUZ("AG")="I" D ^APCDEMDI
 Q
 ;
VSIT01 ;EP;9000010,.01 (VISIT,VISIT/ADMIT DATE&TIME)
 I '$D(AUPNPAT) D:'$D(AUPNTALK)&('$D(ZTQUEUED)) EN^DDIOL(" <No direct entry allowed>") K X Q
 S:$E(X,6,7)="00" X=$E(X,1,5)_"01" S:$E(X,4,5)="00" X=$E(X,1,3)_"01"_$E(X,6,7)
 I $D(AUPNDOB),$D(AUPNDOD),AUPNDOB,$D(DT),DT D VSIT01B Q
 I '$D(AUPNTALK),'$D(ZTQUEUED) D EN^DDIOL("  <Required variables do not exist>")
 K X
 Q
VSIT01B ;
 I '$D(APCDFVOK),DT_".9999"<X D:'$D(AUPNTALK)&('$D(ZTQUEUED)) EN^DDIOL("  <Future dates not allowed>") K X Q
 I DUZ("AG")="I",AUPNDOD,$P(X,".",1)>AUPNDOD D:'$D(AUPNTALK)&('$D(ZTQUEUED)) EN^DDIOL("  <Patient died before this date>") K X Q
 I $P(X,".",1)<AUPNDOB D:'$D(AUPNTALK)&('$D(ZTQUEUED)) EN^DDIOL("  <Patient born after this date>") K X Q
 Q
 ;
ID ;
 S:$E(APCDDMDT,6,7)="00" APCDDMDT=$E(APCDDMDT,1,5)_"01" S:$E(APCDDMDT,4,5)="00" APCDDMDT=$E(APCDDMDT,1,3)_"01"_$E(APCDDMDT,6,7)
 Q
PROBN ;EP
 NEW APCDPLOC,APCDPPL,APCDPN,APCDPI
 S X=$$UP^XLFSTR(X)
 S:X["#" X=$P(X,"#")_$P(X,"#",2)
 S APCDPPL="" F APCDPI=1:1:$L(X) Q:$E(X,APCDPI)?1N  S APCDPPL=APCDPPL_$E(X,APCDPI)
 I APCDPPL="" D EN^DDIOL("No facility code has been entered.") K X Q
 S APCDPLOC="",APCDPLOC=$O(^AUTTLOC("D",APCDPPL,APCDPLOC)) I APCDPLOC="" D EN^DDIOL("NO Location Abbreviation - PLEASE NOTIFY YOUR SUPERVISOR") K X Q
 S APCDPN=$P(X,APCDPPL,2) I APCDPN=""!(APCDPN<0)!(APCDPN>999.99) D EN^DDIOL("Invalid problem number") K X Q
 S APCDPN=" "_$E("000",1,(3-$L($P(APCDPN,"."))))_$P(APCDPN,".")_"."_$P(APCDPN,".",2)_$E("00",1,(2-$L($P(APCDPN,".",2))))
 I '$D(^AUPNPROB("AA",AUPNPAT,APCDPLOC,APCDPN)) D EN^DDIOL("No Problem Number "_APCDPN_" on file for this patient for location "_$P(^AUTTLOC(APCDPLOC,0),U,2)_".") K X Q
 Q
PROBNUM(X) ;get problem ien given problem number
 I $G(X)="" Q ""
 NEW APCDPLOC,APCDPPL,APCDPN,APCDPI,P
 S X=$$UP^XLFSTR(X)
 S:X["#" X=$P(X,"#")_$P(X,"#",2)
 S APCDPPL="" F APCDPI=1:1:$L(X) Q:$E(X,APCDPI)?1N  S APCDPPL=APCDPPL_$E(X,APCDPI)
 I APCDPPL="" Q ""
 S APCDPLOC="",APCDPLOC=$O(^AUTTLOC("D",APCDPPL,APCDPLOC)) I APCDPLOC="" Q ""
 S APCDPN=$P(X,APCDPPL,2) I APCDPN=""!(APCDPN<0)!(APCDPN>999.99) Q ""
 S APCDPN=" "_$E("000",1,(3-$L($P(APCDPN,"."))))_$P(APCDPN,".")_"."_$P(APCDPN,".",2)_$E("00",1,(2-$L($P(APCDPN,".",2))))
 S P=$O(^AUPNPROB("AA",AUPNPAT,APCDPLOC,APCDPN,0))
 Q P
 N DIC,DA,D,DZ S DIC="^AUTTLOC(",DIC(0)="E",D="D",DZ="??" D DQ^DICQ K Y,DIC,D
 Q
CTR(X,Y) ;EP - Center X in a field Y wide.
 Q $J("",$S($D(Y):Y,1:IOM)-$L(X)\2)_X
 ;----------
