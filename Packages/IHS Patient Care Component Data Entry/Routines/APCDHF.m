APCDHF ; IHS/CMI/TUCSON - DISPLAY HEALTH FACTORS ON HF MNEMONIC ; [ 12/21/03  1:09 PM ]
 ;;2.0;IHS RPMS/PCC Data Entry;**7**;MAR 09, 1999
HFACT ; ******************** HEALTH FACTORS * 9000019 *********
OUTPUT S APCDSCVD="S:Y]"""" Y=+Y,Y=$E(Y,4,5)_""/""_$E(Y,6,7)_""/""_(1700+$E(Y,1,3))"
 ; <SETUP>
 Q:'$D(^AUPNVHF("AC",AUPNPAT))
 W !!,"******************PCC HEALTH FACTORS*****************",!
 ; <DISPLAY>
 S APCDSFC="" F  S APCDSFC=$O(^AUTTHF("AD","C",APCDSFC)) Q:'APCDSFC  S (APCDSFT,APCDSFD)="" D ONECAT
 ; <CLEANUP>
HFACTX K APCDSCFI,APCDSDAT,APCDSDT2,APCDSFC,APCDSFD,APCDSFDP,APCDSFN,APCDSFSS,APCDSFT,APCDSFTB,APCDSHFI,APCDSHFS,APCDSHP,APCDSI,APCDSIVD,APCDSNDT,APCDSNI,APCDSPVD,APCDSSDM,APCDSSNM,APCDSTNP,Y,APCDSCVD,APCDSN
 Q
 ;
ONECAT ;
 S:APCDSFD="" APCDSFD="Y"
 S:APCDSFT="" APCDSFT=$P(^AUTTHF(APCDSFC,0),U)
 S APCDSTNP=1
 K APCDSFTB
 S APCDSCFI="" F  S APCDSCFI=$O(^AUTTHF("AC",APCDSFC,APCDSCFI)) Q:'APCDSCFI  D ONEFACT
 D DISPDATA
 Q
ONEFACT ;
 S APCDSN=^AUTTHF(APCDSCFI,0),APCDSFN=$P(APCDSN,U)
 S APCDSPVD=0
 F APCDSIVD=0:0 S APCDSIVD=$O(^AUPNVHF("AA",AUPNPAT,APCDSCFI,APCDSIVD)) Q:APCDSIVD=""  D ONEDATE
 Q
 ;
ONEDATE ;
 S Y=-APCDSIVD\1+9999999 X APCDSCVD S APCDSDAT=Y S APCDSNDT=(APCDSDAT'=APCDSPVD)
 D:APCDSTNP TPRINT
 S APCDSNI="" F  S APCDSNI=$O(^AUPNVHF("AA",AUPNPAT,APCDSCFI,APCDSIVD,APCDSNI)) Q:'APCDSNI  D SETFACT
 Q
SETFACT S APCDSN=^AUPNVHF(APCDSNI,0)
 S APCDSFSS="" S X=$P(APCDSN,U,4) I X]"" S Y=$P(^DD(9000019,.04,0),U,3) F APCDSI=1:1:$L(Y,";") S APCDSFDP=$P(Y,";",APCDSI) I X=$P(APCDSFDP,":") S APCDSFSS=$P(APCDSFDP,":",2) Q
 S APCDSFTB(APCDSIVD,APCDSDAT_U_APCDSFN_U_APCDSFSS)=""
 Q
DISPDATA ; DISPLAY TABLED DATA
 S APCDSDT2=""
 S APCDSIVD=0 F  S APCDSIVD=$O(APCDSFTB(APCDSIVD)) Q:'APCDSIVD  S APCDSN="" F  S APCDSN=$O(APCDSFTB(APCDSIVD,APCDSN)) Q:APCDSN=""  D DISP2
 Q
DISP2 ;
 S APCDSDAT=$P(APCDSN,U),APCDSFN=$P(APCDSN,U,2),APCDSFSS=$P(APCDSN,U,3)
 W:APCDSDAT'=APCDSDT2 APCDSDAT W ?12,APCDSFN W:APCDSFSS]"" " (",APCDSFSS,")" W !
 S APCDSDT2=APCDSDAT
 Q
TPRINT ; PRINT TITLE
 S APCDSTNP=0
 W !,"-- ",APCDSFT," --",! ;temporary
 Q
