APCDFORM ; IHS/CMI/TUCSON - UPDATE FORMS TRACKING FILE ; [ 09/03/02  8:04 AM ]
 ;;2.0;IHS RPMS/PCC Data Entry;**5**;MAR 09, 1999
 ;
 K DIADD
 L +^XTMP("APCDFORM",DT):20 E  W !!,"CANNOT LOCK FORMS TRACKING GLOBAL!",! D EXIT Q
 S DIC="^APCDFORM(",DIC(0)="L",X=DT,DLAYGO=9001001.5 D ^DIC K DIC,DIADD,DLAYGO
 I Y=-1 W !!,"FORMS TRACKING FAILED -- NOTIFY PROGRAMMER!",! D EXIT Q
 K DIU,DIV,DA,DIE
 S DA=+Y,DR="1101///""`"_APCDFV_"""",DIE="^APCDFORM(",DR(2,9001001.51101)=".02////^S X=DUZ"
 D ^DIE
 I $D(Y) W !!,"FORMS TRACKING ERROR--notify programmer!",$C(7)
EXIT ;
 L -^XTMP("APCDFORM",DT)
 K DIE,DR,DIC,DIU,DIV,X,Y,DA
 Q
