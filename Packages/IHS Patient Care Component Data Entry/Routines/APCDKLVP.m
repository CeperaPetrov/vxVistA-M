APCDKLVP ; IHS/CMI/TUCSON - PURGE COMPLETED LAB VISIT LOG ; [ 06/17/02  10:20 AM ]
 ;;2.0;IHS RPMS/PCC Data Entry;**5**;MAR 09, 1999
 D INIT
 D GETDATE
 I $D(APCDQUIT) D EOJ Q
ZIS W !! S %ZIS="PQ" D ^%ZIS
 I POP D EOJ Q
 I $D(IO("Q")) D TSKMN,EOJ Q
DRIVER ;
 D PURGE
 W !!,"A Total of ",APCDCNT," entries Purged.",!
 D EOJ
 Q
 ;
INIT ;
 W !!,"Purging Data from Completed Lab/Radiology/Pharmacy Visit Log!"
 S APCDCNT=0
 K APCDQUIT
 Q
 ;
GETDATE ;
 S Y=DT X ^DD("DD") S APCDDTP=Y
 S %DT("A")="Purge log up to and including what POSTING DATE?  ",%DT="AEPX" W ! D ^%DT
 I Y=-1 S APCDQUIT="" Q
 S APCDPGE=Y X ^DD("DD") S APCDPGEY=Y
 Q
 ;
PURGE ;
 S APCDX=0 F  S APCDX=$O(^APCDLLOG("AC",APCDX)) Q:APCDX=""!(APCDX>APCDPGE)  D
  .S APCDY=0 F  S APCDY=$O(^APCDLLOG("AC",APCDX,"")) Q:APCDY'=+APCDY  D KILL
 Q
 ;
KILL ;
 K DIE,DIU,DIV,DA,X,Y
 S DIE="^APCDLLOG(",DA=APCDY,DR=".01///@" D ^DIE
 I $D(Y),'$D(ZTSK) W !,"****ERROR DELETING POSTING DATE ",APCDX," ***** - Notify Programmer!" Q
 K DIE,DR,DA,X,Y
 S APCDCNT=APCDCNT+1
 Q
 ;
TSKMN ;
 K ZTSAVE F %="APCDPGE","APCDCNT" S ZTSAVE(%)=""
 S ZTIO=ION,ZTCPU=$G(IOCPU),ZTRTN="DRIVER^APCDKLVP",ZTDTH="",ZTDESC="PURGE DATA ENTRY LAB LOG FILE" D ^%ZTLOAD
 Q
EOJ ;
 K APCDCNT,APCDPGE,X,Y,DIC,DA,DIE,DR,%DT,D,D0,D1,DQ,APCDDTP,APCDPGEY,POP,APCDX,APCDDUZ,APCDY
 I $D(ZTQUEUED) S ZTREQ="@" K ZTSK
 D ^%ZISC
 Q
