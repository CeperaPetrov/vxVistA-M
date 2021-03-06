APCDAAC1 ; IHS/CMI/TUCSON - CDMIS PCC LINK ; [ 02/15/00  10:56 AM ]
 ;;2.0;IHS RPMS/PCC Data Entry;**2**;MAR 09, 1999
 ;FILE 200 CONV
 ;
 ;
 ;
VFILES ;EP Create v file entries
 D PROV
 I $G(APCDQUIT) D VFERROR
 D POV
 D AT
 I $D(APCDQUIT) D VFERROR
 D EOJ
 Q
 ;
PROV ; v provider
 ; ***************** MULTIPLE PROVIDERS *******************
 S APCDFILE="V PROVIDER"
 D KILL
 S APCDALVR("APCDVSIT")=APCDVSIT
 S APCDALVR("APCDATMP")="[APCDALVR 9000010.06 (ADD)]"
 S APCDALVR("APCDPAT")=ACDEV("PAT")
 S APCDALVR("APCDTPS")="P"
 S X=ACDEV("PRI PROV") I $P(^DD(9000010.06,.01,0),U,2)[6 S P=ACDEV("PRI PROV"),A=$P(^DIC(3,P,0),U,16) D  K A,P
 .I A="" S APCDQUIT=42,X="" Q
 .I $P(^VA(200,P,0),U)'=$P(^DIC(16,A,0),U) S APCDQUIT=42,X="" Q
 .S X=A
 .Q
 I X="" S APCDQUIT=41 Q
 I X]"" S APCDALVR("APCDTPRO")="`"_X
 D APCDALVR
 Q
 ;
POV ;create V POVS
 S APCDFILE="V POV"
 S (APCDY,APCDGOT)=0
 F  S APCDY=$O(ACDEV("POV",APCDY)) Q:'APCDY  D
 .D KILL
 .S APCDALVR("APCDTPOV")=+ACDEV("POV",APCDY) I APCDALVR("APCDTPOV")="" S APCDQUIT=43 D VFERROR Q
 .S APCDALVR("APCDVSIT")=APCDVSIT
 .S APCDALVR("APCDATMP")="[APCDALVR 9000010.07 (ADD)]"
 .S APCDALVR("APCDPAT")=ACDEV("PAT")
 .S APCDALVR("APCDOVRR")=""
 .;************* WHAT IS APCDTNQ ***************
 .S APCDALVR("APCDTNQ")="`"_$P(ACDEV("POV",APCDY),U,6)
 .D APCDALVR
 .Q
 Q
 ;
AT ;create v activity time record
 Q:'$G(ACDEV("TIME"))  ;          quit if no time
 S APCDFILE="V ACTIVITY TIME"
 D KILL
 S APCDALVR("APCDTACT")=ACDEV("TIME")
 S APCDALVR("APCDVSIT")=APCDVSIT
 S APCDALVR("APCDATMP")="[APCDALVR 9000010.19 (ADD)]"
 S APCDALVR("APCDPAT")=ACDEV("PAT")
 S APCDALVR("APCDTTM")="**************************"
 D APCDALVR
 Q
 ;
APCDALVR ;D APCDALVR
 D ^APCDALVR
 I $D(APCDALVR("APCDAFLG")) S APCDQUIT=APCDALVR("APCDAFLG") D VFERROR Q
 S APCDV("VFILES",APCDALVR("APCDAVF"),APCDALVR("APCDADFN"))=""
 Q
 ;
KILL ;
 K APCDALVR,APCDPAT,APCDLOC,APCDTYPE,APCDCAT,APCDCLN,APCDTPRO,APCDTPS,APCDTPOV,APCDTNQ,APCDTTOP,APCDTLOU,APCDTPRV,APCDTAT,APCDATMP,APCDAFLG,APCDAUTO,APCDANE,AUPNTALK,APCDAPPT
 Q
 ;
EOJ ;
 D KILL
 K APCDDATK,APCDPAT,APCDX,APCDACTL,APCDLOC
 Q
 ;
VFERROR ;EP
 S APCDIEN=ACDEV("VISIT")
 S APCDERR="VE"_APCDQUIT,APCDERR=$P($T(@APCDERR),";;",2)
 D LBULL^APCDALD
 K APCDQUIT,APCDERR
 Q
 ;
VE1 ;;incorrect template specification
VE2 ;;invalid values being passed to V file.
VE3 ;;invalid visit parameters (date, location etc.)
VE41 ;;No PROVIDER ENTRY PASSED from CDMIS SYSTEM.
VE42 ;;Could NOT convert 200 Pointer to 6 pointer.
VE43 ;;Could not find ICD9 code in ICD Diagnosis file.
