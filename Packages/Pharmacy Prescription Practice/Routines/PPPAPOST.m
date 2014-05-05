PPPAPOST ;BIRMFO/DAD - Post Init Routine for Patch 2 ; 2/1/96
 ;;V1.0;PHARMACY PRESCRIPTION PRACTICE;**2**;APR 7,1995
 ;
 ;deleting menu options logfile and xref
 F POPT=$O(^DIC(19,"B","PPP PURGE LOGFILE",0)),$O(^DIC(19,"B","PPP XREF PURGE",0)) I POPT D
 .S DFN=$O(^DIC(19,"B","PPP MAIN",0)),IFN=0
 .F  S IFN=$O(^DIC(19,DFN,10,IFN)) Q:'IFN  I $P(^DIC(19,DFN,10,IFN,0),"^")=POPT D
 ..S DR=".01////@",DA(1)=DFN,DIE="^DIC(19,"_DA(1)_",10,",DA=IFN D ^DIE
 K DIE,DA,X,Y,DIC,DR
 ;creating ppp merged site edit option
 ;
 W !!,"Creating the following options:",!!?5,"PPP MERGED SITE EDIT...",!
 S DIC="^DIC(19,",DIC(0)="L",X="PPP MERGED SITE EDIT",DIC("DR")="1////Add/Edit Merged Sites;4////R;3////PPP UTIL;12////PHARMACY PRESCRIPTION PRACTICE;25////EDITSITE^PPPPDX1" K DD,DO D:'$O(^DIC(19,"B","PPP MERGED SITE EDIT",0))
 .D FILE^DICN
 .S X=$O(^DIC(19,"B","PPP MERGED SITE EDIT",0)),FLAG=0,OPTION=X,IFN=0 K DIC,DD,DO
 .F  S IFN=$O(^DIC(19,DFN,10,IFN)) Q:'IFN  I $P(^DIC(19,DFN,10,IFN,0),"^")=OPTION
 .D:'FLAG
 ..S DA(1)=DFN,DIC="^DIC(19,"_DA(1)_",10,",DIC(0)="L",DIC("DR")="2////CONS" K DD,DO D FILE^DICN K DIC,X ;adds to PPP main menu
 K DIE,DA,X,Y,DIC,DR
 ;create logfile and xref background options
 W !?5,"PPP BACKGROUND PURGE LOGFILE...",!
 W !?5,"PPP BACKGROUND PURGE XREF...",!
 F X="PPP BACKGROUND PURGE LOGFILE","PPP BACKGROUND PURGE XREF" D
 .S DIC="^DIC(19,",DIC(0)="L",ROUTINE=$S(X="PPP BACKGROUND PURGE LOGFILE":"LOG1^PPPPURG",1:"XREF^PPPPURG")
 .S DIC("DR")="1////"_$S(X="PPP BACKGROUND PURGE LOGFILE":"Background Purge Logfile",1:"Purge Other Facility Xref")_";4////R;3////PPP UTIL;12////PHARMACY PRESCRIPTION PRACTICE;25////"_ROUTINE
 .K DD,DO D:'$O(^DIC(19,"B",X,0)) FILE^DICN K DIC,X
 K DIE,DA,X,Y,DIC,DR
 ;
 ;creating logfile and xref sub menus
 ;
 W !?5,"PPP PURGE LOGFILE MENU...",!
 W !?5,"PPP PURGE XREF MENU...",!
 F X="PPP PURGE LOGFILE MENU","PPP PURGE XREF MENU" D
 .S DIC="^DIC(19,",DIC(0)="L"
 .S DIC("DR")="1////"_$S(X="PPP PURGE LOGFILE MENU":"Purge Logfile Menu",1:"Purge Xref Menu")_";4////M;3////PPP UTIL;12////PHARMACY PRESCRIPTION PRACTICE"
 .K DD,DO D:'$O(^DIC(19,"B",X,0)) FILE^DICN K DIC
 K DIE,DA,X,Y,DIC,DR
 ;
 ;create xref and logfile "init" jobs and add to sub menus
 ;
 W !?5,"PPP INIT PURGE LOGFILE JOB...",!
 W !?5,"PPP INIT PURGE XREF JOB...",!
 S DIC="^DIC(19,",DIC(0)="L",X="PPP INIT PURGE LOGFILE JOB",DIC("DR")="1////Initialize Logfile Purge;4////R;3////PPP UTIL;12////PHARMACY PRESCRIPTION PRACTICE;25////SETUP1^PPPPURG"
 K DD,DO D:'$O(^DIC(19,"B","PPP INIT PURGE LOGFILE JOB",0)) FILE^DICN
 K DIC,X,DR,DIE,DIC,DA S IFN=0
 F OPT=$O(^DIC(19,"B","PPP INIT PURGE LOGFILE JOB",0)),$O(^DIC(19,"B","PPP PURGE LOGFILE",0)) D
 .S DR=".01////"_OPT_";2////"_$S($P(^DIC(19,OPT,0),"^")="PPP INIT PURGE LOGFILE JOB":"BPRG",1:"LPRG")
 .S IFN=IFN+1,DA=IFN
 .S DA(1)=$O(^DIC(19,"B","PPP PURGE LOGFILE MENU",0)),^DIC(19,DA(1),10,0)="^19.01IP^2^2"
 .S DIE="^DIC(19,"_DA(1)_",10," D ^DIE K DR,DIE,DA
 ;
 S DIC="^DIC(19,",DIC(0)="L",X="PPP INIT PURGE XREF JOB",DIC("DR")="1////Initialize Xref Purge;4////R;3////PPP UTIL;12////PHARMACY PRESCRIPTION PRACTICE;25////SETUP2^PPPPURG"
 K DD,DO D:'$O(^DIC(19,"B","PPP INIT PURGE XREF JOB",0)) FILE^DICN
 ;
 K DIC,X,DR,DIE,DIC,DA S IFN=0
 F OPT=$O(^DIC(19,"B","PPP INIT PURGE XREF JOB",0)),$O(^DIC(19,"B","PPP XREF PURGE",0)) D
 .S DR=".01////"_OPT_";2////"_$S($P(^DIC(19,OPT,0),"^")="PPP INIT PURGE XREF JOB":"BPRG",1:"LPRG")
 .S IFN=IFN+1,DA=IFN
 .S DA(1)=$O(^DIC(19,"B","PPP PURGE XREF MENU",0)),^DIC(19,DA(1),10,0)="^19.01IP^2^2"
 .S DIE="^DIC(19,"_DA(1)_",10," D ^DIE K DR,DIE,DA
 ;
 ;add logfile and xref menu to ppp main menu
 ;
 S COUNT=0
 F OPTS=$O(^DIC(19,"B","PPP PURGE LOGFILE MENU",0)),$O(^DIC(19,"B","PPP PURGE XREF MENU",0)) I OPTS S VAR=0,COUNT=COUNT+1 D
 .S DFN=$O(^DIC(19,"B","PPP MAIN",0)),IFN=0
 .F  S IFN=$O(^DIC(19,DFN,10,IFN)) Q:'IFN  I $P(^DIC(19,DFN,10,IFN,0),"^")=OPTS S VAR=1
 .D:'VAR
 ..S SYN=$S(COUNT=1:"LPRG",1:"XPRG")
 ..S X=OPTS K DIC,DD,DO S DA(1)=DFN,DIC="^DIC(19,"_DA(1)_",10,",DIC(0)="L",DIC("DR")="2////"_SYN K DD,DO D FILE^DICN K DIC,X
 K COUNT,DFN,FLAG,IFN,OPT,OPTION,OPTS,POPT,ROUTINE,SYN,VAR