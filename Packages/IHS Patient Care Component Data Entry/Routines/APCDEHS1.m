APCDEHS1 ; IHS/CMI/TUCSON - HS IN DATA ENTRY ; [ 03/16/2000   3:17 PM ]
 ;;2.0;IHS RPMS/PCC Data Entry;**2**;MAR 09, 1999
 ;
 N DIC,DA,D0,X,Y,DP,DI,DL
 I $G(AUPNPAT)="" W !!,$C(7),$C(7),"Sorry I don't know the patient.",! Q
 D GETTYPE
 G:APCHSTYP="" XIT
 I $G(IO)="" S IOP="HOME" D ^%ZIS
 S APCHSPAT=AUPNPAT
 D EN^APCHS
 S (DFN,Y)=APCHSPAT D ^AUPNPAT
 K APCHSPAT,APCHSTYP,APCHSTAT,APCHSMTY,AMCHDAYS,AMCHDOB,APCDHDR
 Q
XIT ;
 K %,Y
 K APCHSTYP,APCHSPAT
 Q
GETTYPE ;
 I $G(AUPNPARM)="" D DEFAULT Q
 S APCHSTYP=$P(AUPNPARM,U,14) I APCHSTYP="" D DEFAULT Q
 I '$D(^APCHSCTL(APCHSTYP)) W !,"Error in Site Parameter File!",$C(7),$C(7) S APCHSTYP="" Q
 Q
DEFAULT ;
 S APCHSTYP=""
 S X="ADULT REGULAR",DIC(0)="",DIC="^APCHSCTL(" D ^DIC K DIC,DA
 I Y=-1 W !!,"PCC DATA ENTRY HEALTH SUMMARY TYPE IS MISSING!!  NOTIFY YOUR SUPERVISOR OR SITE MANAGER.",!! Q
 S APCHSTYP=+Y
 Q
