XBSANP ;IHS/ITSC/LAB/FJE;SANITIZE RPMS DATABASE; [ 01/29/2004  11:10 AM ]
 ;;1.0T3
 W !,"This routine sanitizes and deletes RPMS data.  To use you must type:  D START^XBSAN",!!
 Q
START ;
 S (XBDUZ,XBDEL,XBPAT,XBPHR,XBBH,XBCHR,XBPOS,XB3PB,XBAR,XBLAB,XBMMDEL,XBAUDEL,XBNCDEL)=0
 K ^XTMP("SAN")
 S ^XTMP("SAN","LASTDFN")=0
 ;W !,"This routine will first sanitize AND randomize the NEW PERSON file in the RPMS database."
 ;S DIR(0)="Y",DIR("A")="Do you want to convert the new person data?",DIR("B")="N" KILL DA D ^DIR KILL DIR
 ;S:Y=1 XBDUZ=1
 W !,"This routine will then REMOVE/DELETE UNNEEDED PATIENT DATA in the RPMS database."
 S DIR(0)="Y",DIR("A")="Do you want this data deleted?",DIR("B")="N" KILL DA D ^DIR KILL DIR
 S:Y=1 XBDEL=1
 W !!,"This routine will then sanitize the PATIENT FILES of a RPMS database."
 S DIR(0)="Y",DIR("A")="Do you want to convert the patient data",DIR("B")="N" KILL DA D ^DIR KILL DIR
 S:Y=1 XBPAT=1
 W !!,"This routine will then sanitize the POLICY HOLDER FILE of a RPMS database."
 S DIR(0)="Y",DIR("A")="Do you want to convert the POLICY HOLDER data?",DIR("B")="N" KILL DA D ^DIR KILL DIR
 S:Y=1 XBPHR=1
 W !!,"This routine will then delete SENSITIVE CHR DATA from a RPMS database."
 S DIR(0)="Y",DIR("A")="Do you want to delete this CHR patient data?",DIR("B")="N" KILL DA D ^DIR KILL DIR
 S:Y=1 XBCHR=1
 W !!,"This routine will then delete SENSITIVE BH VERSION 3.0 COMPLIANT DATA from a RPMS database."
 S DIR(0)="Y",DIR("A")="Do you want to delete this CHR patient data?",DIR("B")="N" KILL DA D ^DIR KILL DIR
 S:Y=1 XBBH=1
 W !,"This routine will then REMOVE/DELETE UNNEEDED POS DATA in the RPMS database."
 S DIR(0)="Y",DIR("A")="Do you want this data deleted?",DIR("B")="N" KILL DA D ^DIR KILL DIR
 S:Y=1 XBPOS=1
 W !,"This routine will then REMOVE/DELETE UNNEEDED 3PB DATA in the RPMS database."
 S DIR(0)="Y",DIR("A")="Do you want this data deleted?",DIR("B")="N" KILL DA D ^DIR KILL DIR
 S:Y=1 XB3PB=1
 W !,"This routine will then REMOVE/DELETE UNNEEDED AR DATA in the RPMS database."
 S DIR(0)="Y",DIR("A")="Do you want this data deleted?",DIR("B")="N" KILL DA D ^DIR KILL DIR
 S:Y=1 XBAR=1
 W !,"This routine will then REMOVE/DELETE UNNEEDED LAB DATA in the RPMS database."
 S DIR(0)="Y",DIR("A")="Do you want this data deleted?",DIR("B")="N" KILL DA D ^DIR KILL DIR
 S:Y=1 XBLAB=1
 W !,"This routine will then REMOVE/DELETE MAILMAN MESSAGES in the RPMS database."
 S DIR(0)="Y",DIR("A")="Do you want this data deleted?",DIR("B")="N" KILL DA D ^DIR KILL DIR
 S:Y=1 XBMMDEL=1
 W !,"This routine will then REMOVE/DELETE AUDIT DATA in the RPMS database."
 S DIR(0)="Y",DIR("A")="Do you want this data deleted?",DIR("B")="N" KILL DA D ^DIR KILL DIR
 S:Y=1 XBAUDEL=1
 W !,"This routine will then REMOVE/DELETE NAME COMPONENTS in the RPMS database."
 S DIR(0)="Y",DIR("A")="Do you want this data deleted?",DIR("B")="N" KILL DA D ^DIR KILL DIR
 S:Y=1 XBNCDEL=1
 W !,"All failed fileman update data can be found in: ^XTMP(""SAN"",""FAILURE"", GLOBAL"
 W !,"?? display usually means that there was a fileman update failure"
 W !,"If a hard error like an UNDEFINED occurs during the Patient scrambling,"
 W !,"   you can restart at the next patient by typing:  RESTART^XBSAN    "
 W !,"This routine does not purge HL7, or ARMS data."
 W !,"When finished...don't forget to manually address the above and RENAME Institutions",!!
 W !!,"This routine is about to scramble the RPMS database."
 S DIR(0)="Y",DIR("A")="Last chance: Do you want your RPMS data SANITIZED?",DIR("B")="N" KILL DA D ^DIR KILL DIR
 Q:Y'=1
 D ^XBKVAR
 W !,"Collecting random names" D CLEAN
 I XBDUZ W !,"SCRAMBLING FILE 200" D DUZ
 I XBDEL W !,"DELETING PAT INFO" D PATDEL
RESTART ;WILL RESTART PAT SCRAMBLE IF HARD ERROR OCCURS
 I $G(^XTMP("SAN","LASTDFN"))>0 S ^XTMP("SAN","FAILURE","PATDFN",^XTMP("SAN","LASTDFN"))=""
 I XBPAT W !,"SCRAMBLING PAT FILE" D PAT
 I XBPHR W !,"SCRAMBLING POLICY FILE" D PHR
 I XBCHR W !,"SCRAMBLING CHR FILE" D CHR
 I XBBH W !,"DELETING BH INFO" D BH
 I XBPOS W !,"DELETING POS INFO" D POSDEL
 I XB3PB W !,"SCRAMBLING 3PB FILE" D TPB
 I XBAR W !,"SCRAMBLING AR FILE" D AR
 I XBLAB W !,"SCRAMBLING LAB FILES" D LAB
 I XBMMDEL W !,"DELETING MAILMAN MESSAGES" D MMDEL
 I XBAUDEL W !,"DELETING AUDIT DATA" D AUDEL
 I XBNCDEL W !,"DELETING NAME COMPONENTS" D NCDEL
 D PAT2
 S ^XTMP("SAN","PROCESS","XBSAN")="FINISHED"
 W !,"FINISHED"
 D LISTE
 D EOJ
 Q
 ;
PAT D ^XBKVAR
 S XBCHART=100000
 S DFN=+$G(^XTMP("SAN","LASTDFN")) I DFN W !,"RESTARTING PATIENT SCRAMBLE AFTER "_DFN,!
 F  S DFN=$O(^DPT(DFN)) Q:DFN'=+DFN  D PROCPAT
 S ^XTMP("SAN","PROCESS","PAT")="FINISHED"
 Q
 ;
PAT2 D ^XBKVAR
 S XBCHART=100000
 W !,"RETRYING FAILED PATIENTS",!
 S DFN=0 F  S DFN=$O(^XTMP("SAN","FAILURE","PATNAME",DFN)) Q:DFN'=+DFN  D
 .S Y=DFN D ^AUPNPAT
 .S XBSCR=$S(AUPNSEX="M":3,1:2)
 .D FNAME
 .D LNAME
 .S XBNAME=XBLNAME_","_XBFNAME
 .S DA=DFN,DIE="^DPT(",DR=".01///"_XBNAME D ^DIE
 .I $D(Y) S ^XTMP("SAN","FAILURE","PATNAME2",DFN)="" W !,$P(^DPT(DFN,0),U,1),"  ",XBNAME
 .D ^XBFMK
 S ^XTMP("SAN","PROCESS","PAT")="FINISHED"
 Q
CHR ;
 S X=0 F  S X=$O(^BCHR(X)) Q:X'=+X  K ^BCHR(X,51),^BCHR(X,61),^BCHR(X,71)
 S ^XTMP("SAN","PROCESS","CHR")="FINISHED"
 Q
BH ;version 3.0 compliant only
 S X=0 F  S X=$O(^AMHREC(X)) Q:X'=+X  K ^AMHREC(X,31),^AMHREC(X,81),^AMHREC(X,21)
 S X=0 F  S X=$O(^AMHPTXP(X)) Q:X'=+X  K ^AMHPTXP(X,18)
 S ^XTMP("SAN","PROCESS","BH")="FINISHED"
 Q
PHR ;
 ;policy holders not pointing to a patient
 S XBP=0 F  S XBP=$O(^AUPN3PPH(XBP)) Q:XBP'=+XBP  D
 .Q:$P(^AUPN3PPH(XBP,0),U,2)  ;already converted
 .S XBS=$P(^AUPN3PPH(XBP,0),U,8) I XBS="" S XBS="M"
 .S XBSCR=$S(XBS="M":3,1:2)
 .D FNAME
 .D LNAME
 .S XBNAME=XBLNAME_","_XBFNAME
 .D PHNR
 .S XBPHN="555-777-"_XBPHN
 .S DA=XBP,DIE="^AUPN3PPH(",DR=".01///"_XBNAME_";.14///"_XBPHN D ^DIE
 .I $D(Y) S ^XTMP("SAN","FAILURE","POLICYPHONE",DFN)=""
 .D ^XBFMK
 .D SSNR
 .S DA=XBP,DIE="^AUPN3PPH(",DR=".04///"_XBSSN D ^DIE
 .I $D(Y) S ^XTMP("SAN","FAILURE","POLICYSSN",DFN)=""
 .D ^XBFMK
 .S X=^XTMP("SAN",1888,"ADL1") D R S XBADDR=^XTMP("SAN",1888,"ADL1",X)
 .S $P(^AUPN3PPH(XBP,0),U,9)=XBADDR
 .S XBD=$P(^AUPN3PPH(XBP,0),U,19) I XBD]"" S XBD=$$FMADD^XLFDT(XBD,-33)
 .S DA=XBP,DIE="^AUPN3PPH(",DR=".19///"_XBD D ^DIE
 .I $D(Y) S ^XTMP("SAN","FAILURE","POLICYDOB",DA)=""
 .D ^XBFMK
 S ^XTMP("SAN","PROCESS","POLICY")="FINISHED"
 Q
PROCPAT ;
 S ^XTMP("SAN","LASTDFN")=DFN
 I '(DFN#5000) W !,"."_DFN_"."
 D ^XBFMK
 S Y=DFN D ^AUPNPAT
 D F201
 D F203 ;subtract 33 days from dob
 D F209
 D F2111
 D F2131
 D F2132
 D F2211
 D F2212
 D F2213
 D F2219
 D F22401
 D F22402
 D F22403
 D OTHNAME
 D TEN ;tribal enrollment number
 D BRTH
 D DTH
 D PN
 D EMPL
 D NKR
 D ECR
 D XBCHART
 D INSURE
 D POLICY
 Q
EOJ ;
 D EN^XBVK("XB")
 K DFN,XBH,OTDFN,XBB,AUPNSEX,X,X2,XB3PB,XBAR,XBAUDEL
 K DA,DIE,DIK,DIR,DR,DUZSSN,I,XBA,XBADDR,XBADL1
 K XBBH,XBC,XBCHART,XBCHR,XBD,XBDAD,XBDEANUM,XBDEL,XBDFIRST,XBDLAST,XBDNAME
 K XBDOB,XBDUZ,XBFIRST,XBFNAME,XBH,XBLAB,XBLNAME,XBMDFN,XBMMDEL,XBMOM
 K XBNAME,XBNCDEL,XBNOK,XBNOKADL,XBP,XBPAT,XBPHN,XBPHR,XBPOS,XBS
 K XBSCR,XBSEX,XBSSN,XBTEN,XBVAL,XBVANUM,XBX,Y,Z
 W !,"If all data appears correct and you have chaecked failures, kill the ^XTMP(""SAN"") global",!!
 Q
NKR ;
 I $P($G(^AUPNPAT(DFN,28)),U,2)]"" S DA=DFN,DIE="^AUPNPAT(",DR="2802///`"_$O(^AUTTRLSH("B","MOTHER",0)) D ^DIE I $D(Y) S ^XTMP("SAN","FAILURE","PATNKR",DFN)=""
 D ^XBFMK
 Q
ECR ;
 I $P($G(^AUPNPAT(DFN,31)),U,2)]"" S DA=DFN,DIE="^AUPNPAT(",DR="3102///`"_$O(^AUTTRLSH("B","MOTHER",0)) D ^DIE I $D(Y) S ^XTMP("SAN","FAILURE","PATECR",DFN)=""
 D ^XBFMK
 Q
EMPL ;employer .19
 I $P($G(^AUPNPAT(DFN,0)),U,19)]"" S DA=DFN,DIE="^AUPNPAT(",DR=".19///FIRST AMERICAN BANK" D ^DIE I $D(Y) S ^XTMP("SAN","FAILURE","PATEMP",DFN)=""
 D ^XBFMK
 Q
PN ;
 I $P($G(^AUPNPAT(DFN,0)),U,31)]"" S DA=DFN,DIE="^AUPNPAT(",DR=".31///"_$P(^DPT(DFN,0),U) D ^DIE I $D(Y) S ^XTMP("SAN","FAILURE","PATPN",DFN)=""
 D ^XBFMK
 Q
TEN ;
 S XBTEN="TN - "_DFN
 I $P($G(^AUPNPAT(DFN,0)),U,7)]"" S DA=DFN,DIE="^AUPNPAT(",DR=".07///"_XBTEN D ^DIE I $D(Y) S ^XTMP("SAN","FAILURE","PATTEN",DFN)=""
 D ^XBFMK
 Q
BRTH ;
 I $P($G(^AUPNPAT(DFN,11)),U,5)]"" S XBTEN=$E(DFN_"000000",1,7),DA=DFN,DIE="^AUPNPAT(",DR="1105///"_XBTEN D ^DIE I $D(Y) S ^XTMP("SAN","FAILURE","PATBIRTH",DFN)=""
 D ^XBFMK
 Q
DTH ;
 I $P($G(^AUPNPAT(DFN,11)),U,16)]"" S XBTEN=$E("D"_DFN_"00000",1,7),DA=DFN,DIE="^AUPNPAT(",DR="1105///"_XBTEN D ^DIE I $D(Y) S ^XTMP("SAN","FAILURE","PATDEATH",DFN)=""
 D ^XBFMK
 Q
F201 ;
 S XBSCR=$S(AUPNSEX="M":3,1:2)
 D FNAME
 D LNAME
 S XBNAME=XBLNAME_","_XBFNAME
 S DA=DFN,DIE="^DPT(",DR=".01///"_XBNAME D ^DIE
 I $D(Y) S ^XTMP("SAN","FAILURE","PATNAME",DFN)=""
 D ^XBFMK
 Q
FNAME ;
 I XBSCR=3 S X=^XTMP("SAN",1888,"FIRSTM") D R S XBFNAME=^XTMP("SAN",1888,"FIRSTM",X) Q
 S X=^XTMP("SAN",1888,"FIRSTF") D R S XBFNAME=^XTMP("SAN",1888,"FIRSTF",X)
 Q
LNAME ;
 S X=^XTMP("SAN",1888,"LAST") D R S XBLNAME=^XTMP("SAN",1888,"LAST",X)
 Q
F203 ;dob
 S XBDOB=$P(^DPT(DFN,0),U,3)
 I XBDOB="" Q
 S XBDOB=$$FMADD^XLFDT(XBDOB,-33)
 S DIE="^DPT(",DA=DFN,DR=".03///"_XBDOB D ^DIE
 I $D(Y) S ^XTMP("SAN","FAILURE","PATDOB",DFN)=""
 D ^XBFMK
 Q
F2211 ;nok/emergency contact name
 S XBSCR=2 D FNAME S XBNOK=XBLNAME_","_XBFNAME
 I $P($G(^DPT(DFN,.21)),U,1)]"" D
 .D ^XBFMK
 .S DIE="^DPT(",DR=".211///"_XBNOK,DA=DFN D ^DIE
 .I $D(Y) S ^XTMP("SAN","FAILURE","PATNOK",DFN)=""
 .D ^XBFMK
 I $P($G(^DPT(DFN,.33)),U,1)]"" D
 .S DIE="^DPT(",DR=".331///"_XBNOK,DA=DFN D ^DIE
 .I $D(Y) S ^XTMP("SAN","FAILURE","PATECN",DFN)=""
 .D ^XBFMK
 Q
F2212 ;
 D ^XBFMK
 I $P($G(^DPT(DFN,.21)),U,2)]"" D
 .S DA=DFN,DIE="^DPT(",DR=".212///MOTHER" D ^DIE
 .I $D(Y) S ^XTMP("SAN","FAILURE","PATNOKMOTHER",DFN)=""
 .D ^XBFMK
 I $P($G(^DPT(DFN,.33)),U,2)]"" D
 .S DA=DFN,DIE="^DPT(",DR=".332///"_"MOTHER" D ^DIE
 .I $D(Y) S ^XTMP("SAN","FAILURE","PATECNMOTHER",DFN)=""
 .D ^XBFMK
 Q
F22401 ;father's name
 I $P($G(^DPT(DFN,.24)),U,1)="" Q
 S XBSCR=3 D FNAME S XBDAD=XBLNAME_","_XBFNAME
 S DIE="^DPT(",DR=".2401///"_XBDAD,DA=DFN D ^DIE
 I $D(Y) S ^XTMP("SAN","FAILURE","PATFATHER",DFN)=""
 D ^XBFMK
 Q
F22402 ;mother's name
 S XBSCR=2 D FNAME S XBMOM=XBLNAME_","_XBFNAME
 I $P($G(^DPT(DFN,.24)),U,2)="" Q
 S DIE="^DPT(",DR=".2402///"_XBMOM,DA=DFN D ^DIE
 I $D(Y) S ^XTMP("SAN","FAILURE","PATMOTHER",DFN)=""
 D ^XBFMK
 Q
F22403 ;mother's maiden name
 D LNAME
 S XBMMN=XBLNAME_","_$P(XBMOM,",",2)
 I $P($G(^DPT(DFN,.24)),U,3)="" Q
 S DIE="^DPT(",DR=".2403///"_XBMMN,DA=DFN D ^DIE
 I $D(Y) S ^XTMP("SAN","FAILURE","PATMOTHMAIDNAM",DFN)=""
 D ^XBFMK
 Q
OTHNAME ;
 S OTDFN=0 F  S OTDFN=$O(^DPT(DFN,.01,OTDFN)) Q:OTDFN'=+OTDFN  D
 .D LNAME
 .S XBNAME=XBLNAME_","_XBFNAME
 .S DA=OTDFN,DIE="^DPT("_DFN_",.01,",DA(1)=DFN,DR=".01///"_XBNAME D ^DIE
 .I $D(Y) S ^XTMP("SAN","FAILURE","PATOTHRNAME",DFN)=""
 .D ^XBFMK
 Q
F2111 ;
 I $P($G(^DPT(DFN,.11)),U,1)]"" D
 .S X=^XTMP("SAN",1888,"ADL1") D R S XBADDR=^XTMP("SAN",1888,"ADL1",X)
 .S DIE="^DPT(",DR=".111///"_XBADDR,DA=DFN D ^DIE
 .I $D(Y) S ^XTMP("SAN","FAILURE","PATADDRESS",DFN)=""
 .D ^XBFMK
 .S $P(^DPT(DFN,.11),U,2)=""  ;addr 2nd line
 .S $P(^DPT(DFN,.11),U,3)=""  ;addr 3rd line
 Q
F2213 ;
 I $P($G(^DPT(DFN,.21)),U,3)]"" D
 .S X=^XTMP("SAN",1888,"ADL1") D R S XBADDR=^XTMP("SAN",1888,"ADL1",X)
 .S DIE="^DPT(",DR=".213///"_XBADDR,DA=DFN D ^DIE
 .I $D(Y) S ^XTMP("SAN","FAILURE","PATADDRESSL11",DFN)=""
 .D ^XBFMK
 I $P($G(^DPT(DFN,.33)),U,3)]"" D
 .S X=^XTMP("SAN",1888,"ADL1") D R S XBADDR=^XTMP("SAN",1888,"ADL1",X)
 .S DIE="^DPT(",DR=".333.//"_XBADDR,DA=DFN D ^DIE
 .I $D(Y) S ^XTMP("SAN","FAILURE","PATADDRESSL111",DFN)=""
 .D ^XBFMK
 Q
POLICY ;
 ;loop through policy holder
 ;if has patient pointer use patient name and address and 
 D ^XBFMK
 S XBP=$O(^AUPN3PPH("C",DFN,0))
 I 'XBP K XBP Q
 S XBTEN=$P($G(^DPT(DFN,.11)),U,1)
 S DA=XBP,DIE="^AUPN3PPH(",DR=".01///"_XBNAME_";.04///"_XBSSN_";.09///"_XBTEN_";.11///@;.13///@;.14///@;.19///"_XBDOB D ^DIE
 I $D(Y) S ^XTMP("SAN","FAILURE","PATPOLICY",DA)=""
 D ^XBFMK
 Q
INSURE ;
 D MCR,PI,MCD,RR
 Q
MCR ;
 ;MEDICARE
 Q:'$D(^AUPNMCR(DFN))
 S X=^XTMP("SAN",1888,"DLAST") D R S XBDLAST=^XTMP("SAN",1888,"DLAST",X)
 S X=^XTMP("SAN",1888,"DFIRST") D R S XBDFIRST=^XTMP("SAN",1888,"DFIRST",X)
 S XBDLAST=XBDLAST_","_XBDFIRST
 D SSNR
 S DIE="^AUPNMCR(",DA=DFN,DR=".03///"_XBSSN_";.14///"_XBDLAST_";2101///"_$P(^DPT(DFN,0),U,1)_";2102///"_$P(^DPT(DFN,0),U,3) D ^DIE
 I $D(Y) S ^XTMP("SAN","FAILURE","PATMEDICARE",DFN)=""
 D ^XBFMK
         Q
PI ;
 Q:'$D(^AUPNPRVT(DFN))
 Q:'$D(^AUPNPRVT(DFN,11))
 S XBMDFN=0 F  S XBMDFN=$O(^AUPNPRVT(DFN,11,XBMDFN)) Q:XBMDFN'=+XBMDFN  D
 .S $P(^AUPNPRVT(DFN,11,XBMDFN,0),U,2)=XBSSN
 .S $P(^AUPNPRVT(DFN,11,XBMDFN,0),U,4)=XBNAME
 .S $P(^AUPNPRVT(DFN,11,XBMDFN,0),U,12)=""
 .S $P(^AUPNPRVT(DFN,11,XBMDFN,0),U,14)=""
 Q
 ;
RR ;
 Q:'$D(^AUPNRRE(DFN))
 S X=^XTMP("SAN",1888,"DLAST") D R S XBDLAST=^XTMP("SAN",1888,"DLAST",X)
 S X=^XTMP("SAN",1888,"DFIRST") D R S XBDFIRST=^XTMP("SAN",1888,"DFIRST",X)
 S XBDLAST=XBDLAST_","_XBDFIRST
 D SSNR
 S DIE="^AUPNRRE(",DA=DFN,DR=".04///"_XBSSN_";.14///"_XBDLAST_";2101///"_$P(^DPT(DFN,0),U,1)_";2102///"_$P(^DPT(DFN,0),U,3) D ^DIE
 I $D(Y) S ^XTMP("SAN","FAILURE","PATRAILROAD",DFN)=""
 D ^XBFMK
 Q
MCD ;
 S XBMDFN=0 F  S XBMDFN=$O(^AUPNMCD("B",DFN,XBMDFN)) Q:XBMDFN'=+XBMDFN  D
 .S X=^XTMP("SAN",1888,"DLAST") D R S XBDLAST=^XTMP("SAN",1888,"DLAST",X)
 .S X=^XTMP("SAN",1888,"DFIRST") D R S XBDFIRST=^XTMP("SAN",1888,"DFIRST",X)
 .S DIE="^AUPNMCD(",DA=XBMDFN,DR=".05///@;.12///@;.13///@" D ^DIE
 .D ^XBFMK
 .S XBDNAME=XBDLAST_","_XBDFIRST
 .D SSNR
 .S DIE="^AUPNMCD(",DA=XBMDFN,DR=".03///"_XBSSN_";.14///"_XBDNAME_";2101///"_$P(^DPT(DFN,0),U,1)_";2102///"_$P(^DPT(DFN,0),U,3)_";.05///"_$P(^DPT(DFN,0),U,1) D ^DIE
 .I $D(Y) S ^XTMP("SAN","FAILURE","PATMEDICAID",DA)=""
 .D ^XBFMK
 Q
XBCHART ;
 S XBH=0 F  S XBH=$O(^AUPNPAT(DFN,41,XBH)) Q:XBH'=+XBH  S XBCHART=XBCHART+1 D
 .S DA=XBH,DIE="^AUPNPAT("_DFN_",41,",DA(1)=DFN,DR=".02///"_XBCHART D ^DIE
 .I $D(Y) S ^XTMP("SAN","FAILURE","PATCHART",DFN)=""
 .D ^XBFMK
 Q
F209 ;
 I $P($G(^DPT(DFN,0)),U,9)="" Q
 D SSNR
 S DIE="^DPT(",DA=DFN,DR=".09///"_XBSSN D ^DIE
 I $D(Y) S DA=DFN,DIE="^DPT(",DR=".09///@" D ^DIE
 I $D(Y) S ^XTMP("SAN","FAILURE","PATSSN",DFN)=""
 D ^XBFMK
 Q
F2219 ;nok phone
 I $P($G(^DPT(DFN,.21)),U,9)]"" D PHNR D  ;S $P(^DPT(DFN,.21),U,9)="555-888-"_XBPHN
 .S XBPHN="555-888-"_XBPHN
 .S DIE="^DPT(",DA=DFN,DR=".219///"_XBPHN D ^DIE
 .I $D(Y) S ^XTMP("SAN","FAILURE","PATPHONE",DFN)=""
 .D ^XBFMK
 I $P($G(^DPT(DFN,.33)),U,9)]"" D PHNR D  ;S $P(^DPT(DFN,.33),U,9)="555-888-"_XBPHN
 .S XBPHN="555-888-"_XBPHN
 .S DIE="^DPT(",DA=DFN,DR=".339///"_XBPHN D ^DIE
 .I $D(Y) S ^XTMP("SAN","FAILURE","PATPHONE1",DFN)=""
 .D ^XBFMK
 Q
F2131 ;
 I $P($G(^DPT(DFN,.13)),U,1)]"" D PHNR D
 .S XBPHN="555-555-"_XBPHN
 .S DIE="^DPT(",DA=DFN,DR=".131///"_XBPHN D ^DIE
 .I $D(Y) S ^XTMP("SAN","FAILURE","PATPHONE2",DFN)=""
 .D ^XBFMK
 Q
F2132 ;
 Q:$P($G(^DPT(DFN,.13)),U,2)=""  ;no office phone
 D PHNR S XBPHN="555-999-"_XBPHN
 S DIE="^DPT(",DA=DFN,DR=".132///"_XBPHN D ^DIE
 I $D(Y) S ^XTMP("SAN","FAILURE","PATPHONE3",DFN)=""
 D ^XBFMK
 Q
 ;
DELP ;delete patients with no visits
 ;S XBCNT=0,XBP=0 F  S XBP=$O(^DPT(XBP)) Q:XBP'=+XBP  D
 ;.Q:$D(^AUPNVSIT("AC",XBP))
 ;.S DA=XBP,DIK="^DPT(" D ^DIK
 ;.S DA=XBP,DIK="^AUPNPAT(" D ^DIK
 ;.W DA,":" S XBCNT=XBCNT+1
 ;.Q
 ;W !,XBCNT
 ;Q
CLEAN ;
 K ^XTMP("SAN",1888,"FIRSTM")
 K ^XTMP("SAN",1888,"FIRSTF")
 K ^XTMP("SAN",1888,"ADL1")
 K ^XTMP("SAN",1888,"NOKADL")
 K ^XTMP("SAN","FAILURE")
 K ^XTMP("SAN",1888,"DLAST")
 K ^XTMP("SAN",1888,"DFIRST")
 K ^XTMP("SAN","PROCESS","DUZ")
 K ^XTMP("SAN","DUZFAILURE")
 D ^XBKVAR
 S (XBC(1),XBC(2))=0,XBX=1 F  S XBX=$O(^VA(200,XBX)) Q:+XBX=0  D
 .S XBNAME=$P($G(^VA(200,XBX,0)),U,1)
 .S XBLAST=$P(XBNAME,",",1) S:'$L(XBLAST) XBLAST="MOUSE"
 .S XBFIRST=$P(XBNAME,",",2) S:'$L(XBFIRST) XBFIRST="MICKEY"_+XBX
 .S XBC(1)=XBC(1)+1,^XTMP("SAN",1888,"DLAST")=XBC(1),^XTMP("SAN",1888,"DLAST",XBC(1))=XBLAST
 .S XBC(2)=XBC(2)+1,^XTMP("SAN",1888,"DFIRST")=XBC(2),^XTMP("SAN",1888,"DFIRST",XBC(2))=XBFIRST
 D ^XBKVAR
 F I=1:1:5 S XBC(I)=0
 S Y=0 F  S Y=$O(^DPT(Y)) Q:+Y=0  D
 .S XBVAL=$G(^DPT(Y,0))
 .S XBNAME=$P(XBVAL,U,1)
 .S XBLAST=$P(XBNAME,",",1)
 .S XBFIRST=$P(XBNAME,",",2)
 .S XBSEX=$P(XBVAL,U,2)
 .S XBADL1=$P($G(^DPT(Y,.11)),U,1)
 .S XBNOKADL=$P($G(^DPT(Y,.33)),U,3)
SET .S XBC(1)=XBC(1)+1,^XTMP("SAN",1888,"LAST")=XBC(1),^XTMP("SAN",1888,"LAST",XBC(1))=XBLAST
 .I $L(XBSEX) S:XBSEX="M" XBC(2)=XBC(2)+1,^XTMP("SAN",1888,"FIRSTM")=XBC(2),^XTMP("SAN",1888,"FIRSTM",XBC(2))=XBFIRST
 .I $L(XBSEX) S:XBSEX="F" XBC(3)=XBC(3)+1,^XTMP("SAN",1888,"FIRSTF")=XBC(3),^XTMP("SAN",1888,"FIRSTF",XBC(3))=XBFIRST
 .I $L(XBADL1) S XBC(5)=XBC(5)+1,^XTMP("SAN",1888,"ADL1")=XBC(5),^XTMP("SAN",1888,"ADL1",XBC(5))=XBADL1
 .I $L(XBNOKADL) S XBC(5)=XBC(5)+1,^XTMP("SAN",1888,"ADL1")=XBC(5),^XTMP("SAN",1888,"ADL1",XBC(5))=XBNOKADL
 Q
R S X2=$R(X) I X2=0 G R
 S X=X2
 Q
 ;
DUZ ;SCRAMBLES USER NAMES
 K ^XTMP("SAN","FAILURE","DUZ")
 K ^XTMP("SAN","FAILURE","DUZA")
DUZA D ^XBFMK
 S XBX=1 F  S XBX=$O(^VA(200,XBX)) Q:+XBX=0  D
 .S X=^XTMP("SAN",1888,"DLAST") D R S XBLAST=^XTMP("SAN",1888,"DLAST",X)
 .S X=^XTMP("SAN",1888,"DFIRST") D R S XBFIRST=^XTMP("SAN",1888,"DFIRST",X)
 .D DUZSSN
 .;W !,$P(^VA(200,XBX,0),"^",1),"  ",XBLAST,"   ",XBFIRST,$P($G(^VA(200,XBX,1)),"^",9),"  ",DUZSSN
 .I DUZSSN S DA=XBX,DIE=200,DR=".01///"_XBLAST_","_XBFIRST_";9///"_DUZSSN D ^DIE I $D(Y) S ^XTMP("SAN","FAILURE","DUZ",XBX)=""
 .I 'DUZSSN S DA=XBX,DIE=200,DR=".01///"_XBLAST_","_XBFIRST D ^DIE I $D(Y) S ^XTMP("SAN","FAILURE","DUZ",XBX)=""
 .S DA=XBX,DIE=200,DR=";1///"_$E(XBLAST,1,3)_";13///"_$E(XBLAST,1,8) D ^DIE I $D(Y) S ^XTMP("SAN","FAILURE","DUZINITIALS",XBX)=""
 .S XBVANUM=1000000+XBX
 .S XBDEANUM=2000000+XBX
 .S DA=XBX,DIE=200,DR=";53.2///"_XBDEANUM_";53.3///"_XBVANUM D ^DIE I $D(Y) S ^XTMP("SAN","FAILURE","DUZDEAVA",XBX)=""
 .D ^XBFMK
 S ^XTMP("SAN","PROCESS","DUZ")="FINISHED"
 Q
DUZSSN ;CHANGES SSN FOR USER FILE
 S DUZSSN=$P($G(^VA(200,XBX,1)),"^",9)
 I DUZSSN D DUZSSNR S DUZSSN=XBSSN
 Q
DUZSSNR ;FIND RANDOM SSN
 F  S XBSSN=$R(999999999) Q:XBSSN>100000000&(XBSSN<800000000)
 I $D(^VA(200,"SSN",XBSSN)) G DUZSSNR
 Q
ALLSSN ;ADDS SSN TO EVERY PATIENT
 D ^XBFMK
 S XBX=0 F  S XBX=$O(^DPT(XBX)) Q:+XBX=0  D
 .Q:$L($P($G(^DPT(XBX,0)),"^",9))
 .D SSNR
 .S DA=XBX,DIE=2,DR=".09///"_XBSSN D ^DIE K DIE,DA
 .D ^XBFMK
 S ^XTMP("SAN","PROCESS","SSN-ALL")="FINISHED"
 Q
SSNR ;FIND RANDOM SSN
 F  S XBSSN=$R(999999999) Q:XBSSN>100000000&(XBSSN<800000000)
 I $D(^DPT("SSN",XBSSN)) G SSNR
 I XBSSN>698999999&(XBSSN<729000001) G SSNR
 Q
PHNR ;FIND RANDOM PHONE
 F  S XBPHN=$R(9999) Q:XBPHN>1000&(XBPHN<9999)
 Q
 ;
PATDEL ;
 S DFN=0 F  S DFN=$O(^DPT(DFN)) Q:DFN'=+DFN  D
 .I $P($G(^DPT(DFN,0)),U,10)]"" S DA=DFN,DIE=2,DR=".091///@" D ^DIE S:$D(Y) ^XTMP("SAN","FAILURE","PATDEL091",DFN)="" D ^XBFMK
 .I $P($G(^DPT(DFN,.101)),U,1)]"" S DA=DFN,DIE=2,DR=".101///@" D ^DIE S:$D(Y) ^XTMP("SAN","FAILURE","PATDEL101",DFN)="" D ^XBFMK
 .I $P($G(^DPT(DFN,.111)),U,1)]"" S DA=DFN,DIE=2,DR=".1181///@" D ^DIE S:$D(Y) ^XTMP("SAN","FAILURE","PATDEL1181",DFN)="" D ^XBFMK
 .I $P($G(^DPT(DFN,.111)),U,2)]"" S DA=DFN,DIE=2,DR=".1182///@" D ^DIE S:$D(Y) ^XTMP("SAN","FAILURE","PATDEL1182",DFN)="" D ^XBFMK
 .I $P($G(^DPT(DFN,.111)),U,3)]"" S DA=DFN,DIE=2,DR=".1183///@" D ^DIE S:$D(Y) ^XTMP("SAN","FAILURE","PATDEL1183",DFN)="" D ^XBFMK
 .I $P($G(^DPT(DFN,.111)),U,4)]"" S DA=DFN,DIE=2,DR=".1184///@" D ^DIE S:$D(Y) ^XTMP("SAN","FAILURE","PATDEL1184",DFN)="" D ^XBFMK
 .I $P($G(^DPT(DFN,.111)),U,5)]"" S DA=DFN,DIE=2,DR=".1185///@" D ^DIE S:$D(Y) ^XTMP("SAN","FAILURE","PATDEL1185",DFN)="" D ^XBFMK
 .I $P($G(^DPT(DFN,.111)),U,6)]"" S DA=DFN,DIE=2,DR=".1186///@" D ^DIE S:$D(Y) ^XTMP("SAN","FAILURE","PATDEL1186",DFN)="" D ^XBFMK
 .I $P($G(^DPT(DFN,.111)),U,7)]"" S DA=DFN,DIE=2,DR=".1187///@" D ^DIE S:$D(Y) ^XTMP("SAN","FAILURE","PATDEL1187",DFN)="" D ^XBFMK
 .I $P($G(^DPT(DFN,.12)),U,1)]"" S DA=DFN,DIE=2,DR=".121///@" D ^DIE S:$D(Y) ^XTMP("SAN","FAILURE","PATDEL121",DFN)="" D ^XBFMK
 .I $P($G(^DPT(DFN,.12)),U,2)]"" S DA=DFN,DIE=2,DR=".122///@" D ^DIE S:$D(Y) ^XTMP("SAN","FAILURE","PATDEL122",DFN)="" D ^XBFMK
 .I $P($G(^DPT(DFN,.12)),U,3)]"" S DA=DFN,DIE=2,DR=".123///@" D ^DIE S:$D(Y) ^XTMP("SAN","FAILURE","PATDEL123",DFN)="" D ^XBFMK
 .I $P($G(^DPT(DFN,.12)),U,4)]"" S DA=DFN,DIE=2,DR=".124///@" D ^DIE S:$D(Y) ^XTMP("SAN","FAILURE","PATDEL124",DFN)="" D ^XBFMK
 .I $P($G(^DPT(DFN,.12)),U,5)]"" S DA=DFN,DIE=2,DR=".125///@" D ^DIE S:$D(Y) ^XTMP("SAN","FAILURE","PATDEL125",DFN)="" D ^XBFMK
 .I $P($G(^DPT(DFN,.12)),U,6)]"" S DA=DFN,DIE=2,DR=".126///@" D ^DIE S:$D(Y) ^XTMP("SAN","FAILURE","PATDEL126",DFN)="" D ^XBFMK
 .I $P($G(^DPT(DFN,.12)),U,7)]"" S DA=DFN,DIE=2,DR=".127///@" D ^DIE S:$D(Y) ^XTMP("SAN","FAILURE","PATDEL127",DFN)="" D ^XBFMK
 .I $P($G(^DPT(DFN,.121)),U,1)]"" S DA=DFN,DIE=2,DR=".1211///@" D ^DIE S:$D(Y) ^XTMP("SAN","FAILURE","PATDEL1211",DFN)="" D ^XBFMK
 .I $P($G(^DPT(DFN,.121)),U,2)]"" S DA=DFN,DIE=2,DR=".1212///@" D ^DIE S:$D(Y) ^XTMP("SAN","FAILURE","PAT1212",DFN)="" D ^XBFMK
 .I $P($G(^DPT(DFN,.121)),U,3)]"" S DA=DFN,DIE=2,DR=".1213///@" D ^DIE S:$D(Y) ^XTMP("SAN","FAILURE","PAT1213",DFN)="" D ^XBFMK
 .I $P($G(^DPT(DFN,.121)),U,4)]"" S DA=DFN,DIE=2,DR=".1214///@" D ^DIE S:$D(Y) ^XTMP("SAN","FAILURE","PAT1214",DFN)="" D ^XBFMK
 .I $P($G(^DPT(DFN,.121)),U,5)]"" S DA=DFN,DIE=2,DR=".1215///@" D ^DIE S:$D(Y) ^XTMP("SAN","FAILURE","PAT1215",DFN)="" D ^XBFMK
 .I $P($G(^DPT(DFN,.121)),U,6)]"" S DA=DFN,DIE=2,DR=".1216///@" D ^DIE S:$D(Y) ^XTMP("SAN","FAILURE","PATDEL1216",DFN)="" D ^XBFMK
 .I $P($G(^DPT(DFN,.121)),U,7)]"" S DA=DFN,DIE=2,DR=".1217///@" D ^DIE S:$D(Y) ^XTMP("SAN","FAILURE","PATDEL1217",DFN)="" D ^XBFMK
 .I $P($G(^DPT(DFN,.121)),U,8)]"" S DA=DFN,DIE=2,DR=".1218///@" D ^DIE S:$D(Y) ^XTMP("SAN","FAILURE","PATDEL1218",DFN)="" D ^XBFMK
 .I $P($G(^DPT(DFN,.121)),U,10)]"" S DA=DFN,DIE=2,DR=".1219///@" D ^DIE S:$D(Y) ^XTMP("SAN","FAILURE","PATDEL1219",DFN)="" D ^XBFMK
 .I $P($G(^DPT(DFN,.111)),U,1)]"" S DA=DFN,DIE=2,DR=".1181///@" D ^DIE S:$D(Y) ^XTMP("SAN","FAILURE","PATDEL1181",DFN)="" D ^XBFMK
 .I $P($G(^DPT(DFN,.13)),U,3)]"" S DA=DFN,DIE=2,DR=".133///@" D ^DIE S:$D(Y) ^XTMP("SAN","FAILURE","PATDEL133",DFN)="" D ^XBFMK
 .I $P($G(^DPT(DFN,.13)),U,4)]"" S DA=DFN,DIE=2,DR=".134///@" D ^DIE S:$D(Y) ^XTMP("SAN","FAILURE","PATDEL134",DFN)="" D ^XBFMK
 .I $P($G(^AUPNPAT(DFN,3)),U,2)]"" S DA=DFN,DIE="AUPNPAT(",DR=".32///@" D ^DIE S:$D(Y) ^XTMP("SAN","FAILURE","PATDEL32",DFN)="" D ^XBFMK
 .I $P($G(^AUPNPAT(DFN,11)),U,18)]"" S DA=DFN,DIE="AUPNPAT(",DR="1118///@" D ^DIE S:$D(Y) ^XTMP("SAN","FAILURE","PATDEL1118",DFN)="" D ^XBFMK
 .I $P($G(^AUPNPAT(DFN,26)),U,2)]"" S DA=DFN,DIE="AUPNPAT(",DR="2602///@" D ^DIE S:$D(Y) ^XTMP("SAN","FAILURE","PATDEL2602",DFN)="" D ^XBFMK
 .I $P($G(^AUPNPAT(DFN,26)),U,5)]"" S DA=DFN,DIE="AUPNPAT(",DR="2605///@" D ^DIE S:$D(Y) ^XTMP("SAN","FAILURE","PATDEL2605",DFN)="" D ^XBFMK
 .I $P($G(^AUPNPAT(DFN,99999999)),U,1)]"" S DA=DFN,DIE="AUPNPAT(",DR="99999999///@" D ^DIE S:$D(Y) ^XTMP("SAN","FAILURE","PATDEL99999999",DFN)="" D ^XBFMK
 .F X=12:1:15 K ^AUPNPAT(DFN,X)
 .K ^AUPNPAT(DFN,42)
 S ^XTMP("SAN","PROCESS","PATDELETEDATA")="FINISHED"
 Q
POSDEL ;
 S XBX=0 F  S XBX=$O(^ABSPC(XBX)) Q:+XBX=0  D
 .S DA=XBX,DIK="^ABSPC(" D ^DIK,^XBFMK
 S XBX=0 F  S XBX=$O(^ABSPR(XBX)) Q:+XBX=0  D
 .S DA=XBX,DIK="^ABSPR(" D ^DIK,^XBFMK
 S DA=1,DIE="ABSP(9002313.56,",DR=".01///OUTPATIENT SITE;.02///12345;.03///456789;.05///123456789;.06///987654"
 D ^DIE S:$D(Y) ^XTMP("SAN","FAILURE","POSDELETE",DA)="" D ^XBFMK
 K ^ABSP(9002313.56,1,"ADDR")
 K ^ABSP(9002313.56,1,"INSURER-ASSIGNED #")
 K ^ABSP(9002313.56,1,"OPSITE")
 S ^XTMP("SAN","PROCESS","POSDEL")="FINNISHED"
 Q
AR ;
 D ^XBFMK S U="^",XBA=0 F  S XBA=$O(^BARBL(XBA)) Q:+XBA=0  D
 .S XBB=0 F  S XBB=$O(^BARBL(XBA,XBB)) Q:+XBB=0  D
 ..I $P($G(^BARBL(XBA,XBB,0)),U,12)]"" S DA=XBB,DIE="90050.01",DUZ(2)=XBA,DR="12///@" D ^DIE,^XBFMK
 ..I $P($G(^BARBL(XBA,XBB,1)),U,5)]"" D
 ...D SSNR S DA=XBB,DIE="90050.01",DUZ(2)=XBA,DR="105///"_XBSSN D ^DIE S:$D(Y) ^XTMP("SAN","FAILURE","AR105",DA)="" D ^XBFMK
 ..I $P($G(^BARBL(XBA,XBB,1)),U,6)]"" S DA=XBB,DIE="90050.01",DUZ(2)=XBA,DR="106///@" D ^DIE S:$D(Y) ^XTMP("SAN","FAILURE","AR106",DA)="" D ^XBFMK
 ..I $P($G(^BARBL(XBA,XBB,1)),U,7)]"" D
 ...D SSNR S XBTEN=$E(XBSSN,1,5),DA=XBB,DIE="90050.01",DUZ(2)=XBA,DR="107///"_XBTEN D ^DIE S:$D(Y) ^XTMP("SAN","FAILURE","AR107E",DA)="" D ^XBFMK
 ..I $P($G(^BARBL(XBA,XBB,1)),U,16)]"" S DA=XBB,DIE="90050.01",DUZ(2)=XBA,DR="116///@" D ^DIE S:$D(Y) ^XTMP("SAN","FAILURE","AR116",DA)="" D ^XBFMK
 ..I $P($G(^BARBL(XBA,XBB,2)),U,3)]"" S DA=XBB,DIE="90050.01",DUZ(2)=XBA,DR="203///@" D ^DIE S:$D(Y) ^XTMP("SAN","FAILURE","AR203",DA)="" D ^XBFMK
 ..I $P($G(^BARBL(XBA,XBB,2)),U,4)]"" S DA=XBB,DIE="90050.01",DUZ(2)=XBA,DR="204///@" D ^DIE S:$D(Y) ^XTMP("SAN","FAILURE","AR204",DA)="" D ^XBFMK
 ..I $P($G(^BARBL(XBA,XBB,2)),U,16)]"" S DA=XBB,DIE="90050.01",DUZ(2)=XBA,DR="216///@" D ^DIE S:$D(Y) ^XTMP("SAN","FAILURE","AR216",DA)="" D ^XBFMK
 ..I $P($G(^BARBL(XBA,XBB,2)),U,17)]"" S DA=XBB,DIE="90050.01",DUZ(2)=XBA,DR="217///@" D ^DIE S:$D(Y) ^XTMP("SAN","FAILURE","AR217",DA)="" D ^XBFMK
 ..S DUZ(2)=XBA K ^BARBL(DUZ(2),XBB,10),^BARBL(DUZ(2),XBB,5),^BARBL(DUZ(2),XBB,6)
 ..I $P($G(^BARBL(XBA,XBB,7)),U,1)]"" S DA=XBB,DIE="90050.01",DUZ(2)=XBA,DR="701///@" D ^DIE S:$D(Y) ^XTMP("SAN","FAILURE","AR701",DA)="" D ^XBFMK
 ..I $P($G(^BARBL(XBA,XBB,7)),U,2)]"" S DA=XBB,DIE="90050.01",DUZ(2)=XBA,DR="702///@" D ^DIE S:$D(Y) ^XTMP("SAN","FAILURE","AR702",DA)="" D ^XBFMK
 S ^XTMP("SAN","PROCESS","AR-BILL")="FINISHED"
 S XBA=0 F  S XBA=$O(^BARCOL(XBA)) Q:+XBA=0  D
 .S XBB=0 F  S XBB=$O(^BARCOL(XBA,XBB)) Q:+XBB=0  K ^BARTR(XBA,XBB,10)
 S ^XTMP("SAN","PROCESS","AR-TRAN")="FINISHED"
 S XBA=0 F  S XBA=$O(^BARCOL(XBA)) Q:+XBA=0  D
 .S XBB=0 F  S XBB=$O(^BARCOL(XBA,XBB)) Q:+XBB=0  D
 ..S XBC=0 F  S XBC=$O(^BARCOL(XBA,XBB,"1",XBC)) Q:+XBC=0  D
 ...I $P($G(^BARCOL(XBA,XBB,1,XBC,0)),U,12)]"" S DIE="^BARCOL(XBA,XBB,1,",DA=XBC,DA(1)=XBB,DUZ(2)=XBA,DR="12///@" D ^DIE S:$D(Y) ^XTMP("SAN","FAILURE","ARCOL12",DA)="" D ^XBFMK
 ...I $P($G(^BARCOL(XBA,XBB,1,XBC,0)),U,13)]"" S DIE="^BARCOL(XBA,XBB,1,",DA=XBC,DA(1)=XBB,DUZ(2)=XBA,DR="13///@" D ^DIE S:$D(Y) ^XTMP("SAN","FAILURE","ARCOL13",DA)="" D ^XBFMK
 ...I $P($G(^BARCOL(XBA,XBB,1,XBC,0)),U,14)]"" S DIE="^BARCOL(XBA,XBB,1,",DA=XBC,DA(1)=XBB,DUZ(2)=XBA,DR="14///@" D ^DIE S:$D(Y) ^XTMP("SAN","FAILURE","ARCOL14",DA)="" D ^XBFMK
 ...K ^BARCOL(XBA,XBB,"1",XBC,5)
 S ^XTMP("SAN","PROCESS","AR-COLL")="FINISHED"
 S XBA=0 F  S XBA=$O(^BAREDI("I",XBA)) Q:+XBA=0  D
 .S XBB=0 F  S XBB=$O(^BAREDI("I",XBA,XBB)) Q:+XBB=0  D
 ..S DIK="^BAREDI(""I"",XBA,",DA=XBB,DUZ(2)=XBA=XBA D ^DIK,^XBFMK
 S ^XTMP("SAN","PROCESS","AR-EDIIMP")="FINISHED"
 S XBA=0 F  S XBA=$O(^BAREDI("C",XBA)) Q:+XBA=0  D
 .S XBB=0 F  S XBB=$O(^BAREDI("C",XBA,XBB)) Q:+XBB=0  D
 ..I $P($G(^BAREDI("C",XBA,XBB,0)),U,3)]"" S DIE="^BAREDI(""C"",XBA,XBB,",DA=XBB,DUZ(2)=XBA,DR=".03///@" D ^DIE S:$D(Y) ^XTMP("SAN","FAILURE","BAREDI03",DA)="" D ^XBFMK
 S ^XTMP("SAN","PROCESS","AR-EDIC")="FINISHED"
 S XBA=0 F  S XBB=$O(^BAR835(XBA)) Q:+XBA=0  D
 .I $P($G(^BAR835(XBA,1)),U,1)]"" S DIE="^BAR835,",DA=XBA,DR=".11///@" D ^DIE S:$D(Y) ^XTMP("SAN","FAILURE","AR11",DA)="" D ^XBFMK
 S ^XTMP("SAN","PROCESS","AR-EDI835")="FINISHED"
 Q
TPB ;3RD PARTY BILLING
 D ^XBFMK
 S U="^",XBA=0 F  S XBA=$O(^ABMDCLM(XBA)) Q:+XBA=0  D
 .S XBB=0 F  S XBB=$O(^ABMDCLM(XBA,XBB)) Q:+XBB=0  D
 ..I $L($P($G(^ABMDCLM(XBA,XBB,8)),U,8)) D
 ...S X=^XTMP("SAN",1888,"DLAST") D R S XBLAST=^XTMP("SAN",1888,"DLAST",X)
 ...S X=^XTMP("SAN",1888,"DFIRST") D R S XBFIRST=^XTMP("SAN",1888,"DFIRST",X)
 ...S DA=XBB,DIE="9002274.3",DUZ(2)=XBA,DR=".88///"_XBLAST_","_XBFIRST D ^DIE S:$D(Y) ^XTMP("SAN","FAILURE","ABM88",DA)="" D ^XBFMK
 ..I $L($P($G(^ABMDCLM(XBA,XBB,8)),U,11)) D
 ...S DA=XBB,DIE="9002274.3",DUZ(2)=XBA,DR=".885///"_(100000+DA) D ^DIE S:$D(Y) ^XTMP("SAN","FAILURE","ABM885",DA)="" D ^XBFMK
 ..I $L($P($G(^ABMDCLM(XBA,XBB,9)),U,12)) D
 ...S X=^XTMP("SAN",1888,"DLAST") D R S XBLAST=^XTMP("SAN",1888,"DLAST",X)
 ...S X=^XTMP("SAN",1888,"DFIRST") D R S XBFIRST=^XTMP("SAN",1888,"DFIRST",X)
 ...S DA=XBB,DIE="9002274.3",DUZ(2)=XBA,DR=".912///"_XBLAST_","_XBFIRST D ^DIE S:$D(Y) ^XTMP("SAN","FAILURE","ABM912",DA)="" D ^XBFMK
 S ^XTMP("SAN","PROCESS","3P-CLAIM")="FINISHED"
 S XBA=0 F  S XBA=$O(^ABMDBILL(XBA)) Q:+XBA=0  D
 .S XBB=0 F  S XBB=$O(^ABMDBILL(XBA,XBB)) Q:+XBB=0  D
 ..I $L($P($G(^ABMDBILL(XBA,XBB,8)),U,8)) D
 ...S X=^XTMP("SAN",1888,"DLAST") D R S XBLAST=^XTMP("SAN",1888,"DLAST",X)
 ...S X=^XTMP("SAN",1888,"DFIRST") D R S XBFIRST=^XTMP("SAN",1888,"DFIRST",X)
 ...S DA=XBB,DIE="9002274.4",DUZ(2)=XBA,DR=".88///"_XBLAST_","_XBFIRST D ^DIE S:$D(Y) ^XTMP("SAN","FAILURE","ABM88",DA)="" D ^XBFMK
 ..I $L($P($G(^ABMDBILL(XBA,XBB,8)),U,11)) D
 ...S DA=XBB,DIE="9002274.4",DUZ(2)=XBA,DR=".885///"_(200000+DA) D ^DIE S:$D(Y) ^XTMP("SAN","FAILURE","ABM885",DA)="" D ^XBFMK
 ..I $L($P($G(^ABMDBILL(XBA,XBB,9)),U,12)) D
 ...S X=^XTMP("SAN",1888,"DLAST") D R S XBLAST=^XTMP("SAN",1888,"DLAST",X)
 ...S X=^XTMP("SAN",1888,"DFIRST") D R S XBFIRST=^XTMP("SAN",1888,"DFIRST",X)
 ...S DA=XBB,DIE="9002274.4",DUZ(2)=XBA,DR=".912///"_XBLAST_","_XBFIRST D ^DIE S:$D(Y) ^XTMP("SAN","FAILURE","ABM912",DA)="" D ^XBFMK
 S ^XTMP("SAN","PROCESS","3P-BILL")="FINISHED"
 Q
LAB ;
 S X=0 F  S X=$O(^LR(X)) Q:X'=+X  D
 .S Y=0 F  S Y=$O(^LR(X,"CH",Y)) Q:Y'=+Y  D
 ..I $D(^LR(X,"CH",Y,1)) S Z=$P(^LR(X,"CH",Y,1,0),U,1,2) K ^LR(X,"CH",Y,1) S ^LR(X,"CH",Y,1,0)=Z
 .S Y=0 F  S Y=$O(^LR(X,"MI",Y)) Q:Y'=+Y  D
 ..I $D(^LR(X,"MI",Y,4)) S Z=$P(^LR(X,"MI",Y,4,0),U,1,2) K ^LR(X,"MI",Y,4) S ^LR(X,"MI",Y,4,0)=Z
 ..I $D(^LR(X,"MI",Y,19)) S Z=$P(^LR(X,"MI",Y,19,0),U,1,2) K ^LR(X,"MI",Y,19) S ^LR(X,"MI",Y,19,0)=Z
 ..I $D(^LR(X,"MI",Y,20)) S Z=$P(^LR(X,"MI",Y,20,0),U,1,2) K ^LR(X,"MI",Y,20) S ^LR(X,"MI",Y,20,0)=Z
 ..I $D(^LR(X,"MI",Y,21)) S Z=$P(^LR(X,"MI",Y,21,0),U,1,2) K ^LR(X,"MI",Y,21) S ^LR(X,"MI",Y,21,0)=Z
 ..I $D(^LR(X,"MI",Y,22)) S Z=$P(^LR(X,"MI",Y,22,0),U,1,2) K ^LR(X,"MI",Y,22) S ^LR(X,"MI",Y,22,0)=Z
 ..I $D(^LR(X,"MI",Y,23)) S Z=$P(^LR(X,"MI",Y,23,0),U,1,2) K ^LR(X,"MI",Y,23) S ^LR(X,"MI",Y,23,0)=Z
 ..K ^LR(X,"MI",Y,99)
 S X=0 F  S X=$O(^LRO(69,X)) Q:X'=+X  D
 .I $D(^LRO(69,X,1,"AL")) K ^LRO(69,X,1,"AL")
 .I $D(^LRO(69,X,1,"AP")) K ^LRO(69,X,1,"AP")
 .I $D(^LRO(69,X,1,"AR")) K ^LRO(69,X,1,"AR")
 S X=$P(^BLRTXLOG(0),U,1,2) K ^BLRTXLOG S ^BLRTXLOG(0)=X
 S ^XTMP("SAN","PROCESS","LAB")="FINISHED"
 D ^LROC
 Q
LISTE ;
 W !,"Listed below are the nodes and number of records that did not"
 W !,"update properly.  At the end of the sanitization, the records"
 W !,"for Patient Name failures are rerun.  PATNAME2 nodes represent"
 W !,"Patient Names that should be manually changed with fileman."
 W !,"XTMP(""SAN"",""PROCESS"") nodes:"
 W !,"XTMP(""SAN"",""FAILURE"") nodes:"
 S X="" F  S X=$O(^XTMP("SAN","FAILURE",X)) Q:X=""  D
 .S (Y,Z)=0 F  S Y=$O(^XTMP("SAN","FAILURE",X,Y)) Q:+Y=0  D
 ..S Z=Z+1
 .W !,"Failure:  "_X_"  "_Z
 W !,"FINISHED" Q
LISTD ;
 W !,"Listed below are the processes completed."
 W !,"XTMP(""SAN"",""PROCESS"") nodes:"
 S X="" F  S X=$O(^XTMP("SAN","PROCESS",X)) Q:X=""  D
 .W !,"Process:  "_X
 W !,"FINISHED" Q 
MCDE ;
 S DFN=0 F  S DFN=$O(^AUPNMCD("B",DFN)) Q:+DFN=0  D
 .S XBMDFN=0 F  S XBMDFN=$O(^AUPNMCD("B",DFN,XBMDFN)) Q:XBMDFN'=+XBMDFN  D
 ..S X=^XTMP("SAN",1888,"DLAST") D R S XBDLAST=^XTMP("SAN",1888,"DLAST",X)
 ..S X=^XTMP("SAN",1888,"DFIRST") D R S XBDFIRST=^XTMP("SAN",1888,"DFIRST",X)
 ..S DIE="^AUPNMCD(",DA=XBMDFN,DR=".05///@;.12///@;.13///@" D ^DIE
 ..I $D(Y) S ^XTMP("SAN","FAILURE","PATMCDEA",DA)=""
 ..D ^XBFMK
 ..S XBDNAME=XBDLAST_","_XBDFIRST
 ..D SSNR
 ..S DIE="^AUPNMCD(",DA=XBMDFN,DR=".03///"_XBSSN_";.14///"_XBDNAME_";2101///"_$P(^DPT(DFN,0),U,1)_";2102///"_$P(^DPT(DFN,0),U,3)_";.05///"_$P(^DPT(DFN,0),U,1) D ^DIE
 ..I $D(Y) S ^XTMP("SAN","FAILURE","PATMCDEB",DA)=""
 ..D ^XBFMK
 S ^XTMP("SAN","PROCESS","MCD")="FINISHED"
 Q 
MMDEL ;DELETES MAILMAN MESSAGES
 K ^XMB(3.9)
 S ^XMB(3.9,0)="MESSAGE^3.9s^0^0"
 Q
AUDEL ;DELETES AUDIT FILE
 K ^DIA
 S ^DIA(0)="AUDIT^1.1|"
 Q
NCDEL ;DELETES NAME COMPONENTS FILE
 K ^VA(20)
 S ^VA(20,0)="NAME COMPONENTS^20IA^^"
 Q
STU ;SETS STUDENT NAMES
 K ^XTMP("SAN","FAILURE","STU")
 K ^XTMP("SAN","FAILURE","STUA")
STUA D ^XBFMK
 S XBX=50 F  S XBX=$O(^VA(200,XBX)) Q:+XBX>76  D
 .S XBLAST=$E("ABCDEFGHIJKLMNOPQRSTUVWXYZ",XBX-50,XBX-50)_"STUDENT"
 .S XBFIRST="USER"
 .S DA=XBX,DIE=200,DR=".01///"_XBLAST_","_XBFIRST D ^DIE I $D(Y) S ^XTMP("SAN","FAILURE","STU",XBX)=""
 .S DA=XBX,DIE=200,DR="1///"_$E(XBLAST,1,2)_"U;13///"_$E(XBLAST,1,8) D ^DIE I $D(Y) S ^XTMP("SAN","FAILURE","STUINITIALS",XBX)=""
 .S DA=XBX,DIE=200,DR="201///`29" D ^DIE I $D(Y) S ^XTMP("SAN","FAILURE","STUMENU",XBX)=""
 .D ^XBFMK
 W !,"FINISHED"
 Q
FJADD1 ;
 S DFN=0 F  S DFN=$O(^XTMP("SAN","FAILURE","PATADDRESS",DFN)) Q:+DFN=0  I $P($G(^DPT(DFN,.11)),U,1)]"" D
  .S XBADDR=DFN_" SMITH STREET"
  .S DIE="^DPT(",DR=".111///"_XBADDR,DA=DFN D ^DIE
 .I $D(Y) S ^XTMP("SAN","FAILURE","PATADDRESSFJ",DFN)=""
 .D ^XBFMK
 .S $P(^DPT(DFN,.11),U,2)=""  ;addr 2nd line
 .S $P(^DPT(DFN,.11),U,3)=""  ;addr 3rd line
 Q
A2213 ;
 I $P($G(^DPT(DFN,.21)),U,3)]"" D
 .S X=^XTMP("SAN",1888,"ADL1") D R S XBADDR=^XTMP("SAN",1888,"ADL1",X)
 .S DIE="^DPT(",DR=".213///"_XBADDR,DA=DFN D ^DIE
 .I $D(Y) S ^XTMP("SAN","FAILURE","PATADDRESSL11",DFN)=""
 .D ^XBFMK
 I $P($G(^DPT(DFN,.33)),U,3)]"" D
 .S X=^XTMP("SAN",1888,"ADL1") D R S XBADDR=^XTMP("SAN",1888,"ADL1",X)
 .S DIE="^DPT(",DR=".333.//"_XBADDR,DA=DFN D ^DIE
 .I $D(Y) S ^XTMP("SAN","FAILURE","PATADDRESSL111",DFN)=""
 .D ^XBFMK
 Q
A2219 ;nok phone
 S DFN=0 F  S DFN=$O(^XTMP("SAN","FAILURE","PATPHONE",DFN)) Q:+DFN=0  I $P($G(^DPT(DFN,.21)),U,9)]"" D
 .S $P(^DPT(DFN,.21),U,9)="555-888-"_$E(DFN_"9999",1,4)
  Q
 S DFN=0 F  S DFN=$O(^XTMP("SAN","FAILURE","PATPHONE1",DFN)) Q:+DFN=0  I $P($G(^DPT(DFN,.33)),U,9)]"" D
 .S $P(^DPT(DFN,.33),U,9)="555-888-"_$E(DFN_"9999",1,4)
 Q
