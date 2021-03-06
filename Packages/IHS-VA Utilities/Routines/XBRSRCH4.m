XBRSRCH4 ; IHS/ADC/GTH - SEARCH XREFS FOR ROUTINES ; [ 02/07/97   3:02 PM ]
 ;;3.0;IHS/VA UTILITIES;;FEB 07, 1997
 ;
 ; Part of XBRSRCH
 ;
START ;
 W !!,"This routine searches a file for XREFS that call routines.",!
 S U="^",DIC="^DIC(",DIC(0)="AEMQ"
 D ^DIC
 I Y<0 D EOJ Q
 S XBSXREF("FILE")=+Y
 KILL ^UTILITY("XBRSRCH",$J)
 S XBSXREF("MASTER")=""
EN ;EP - ENTRY POINT FOR CALLING ROUTINES
 S XBSXREF("LAST FILE")=""
 D SBTRACE
 D:$D(XBSXREF("MASTER")) LIST
 D EOJ
 Q
 ;
SBTRACE ; CHECK ALL SUB-FILES
 KILL XBSXREFF
 S XBSXREF("CNT")=1,XBSXREFF(XBSXREF("CNT"))=XBSXREF("FILE")
 F XBSXREF("L")=0:0 S XBSXREF("LCTL")=$O(XBSXREFF("")) Q:XBSXREF("LCTL")=""  S XBSXREF("FILE")=XBSXREFF(XBSXREF("LCTL")) D SBTRACE2 S XBSXREF("LCTL")=$O(XBSXREFF("")) D FILE KILL XBSXREFF(XBSXREF("LCTL"))
 Q
 ;
SBTRACE2 ;
 S XBSXREF("LCTL")=0
 F XBSXREF("L")=0:0 S XBSXREF("LCTL")=$O(^DD(XBSXREF("FILE"),"SB",XBSXREF("LCTL"))) Q:XBSXREF("LCTL")=""  S XBSXREF("CNT")=XBSXREF("CNT")+1,XBSXREFF(XBSXREF("CNT"))=XBSXREF("LCTL")
 Q
 ;
FILE ; CHECK ONE FILE OR SUB-FILE
 S XBSXREF("FIELD")=0
 F XBSXREF("L")=0:0 S XBSXREF("FIELD")=$O(^DD(XBSXREF("FILE"),XBSXREF("FIELD"))) Q:XBSXREF("FIELD")'=+XBSXREF("FIELD")  D FIELD
 Q
 ;
FIELD ; CHECK FIELD'S XREFS
 Q:'$D(^DD(XBSXREF("FILE"),XBSXREF("FIELD"),1))
 S XBSXREF("XREF")=0
 F XBSXREF("L")=0:0 S XBSXREF("XREF")=$O(^DD(XBSXREF("FILE"),XBSXREF("FIELD"),1,XBSXREF("XREF"))) Q:XBSXREF("XREF")'=+XBSXREF("XREF")  D CHKXREF
 Q
 ;
CHKXREF ; CHECK ONE XREF
 S X=^DD(XBSXREF("FILE"),XBSXREF("FIELD"),1,XBSXREF("XREF"),1)
 D CHKSK
 S X=^DD(XBSXREF("FILE"),XBSXREF("FIELD"),1,XBSXREF("XREF"),2)
 D CHKSK
 Q
 ;
CHKSK ; CHECK XREF SET/KILL
 Q:X'[U
 S XBRSRCH("FOUND")=0,XBSXREF("COUNT")=$L(X,U)
 F XBSXREF("I")=XBSXREF("COUNT"):-1:2 S Y=$P(X,U,XBSXREF("I")) D ^XBRSRCH1
 D:XBRSRCH("FOUND") WRITE
 Q
 ;
WRITE ;
 I $D(XBRSRCH("NO DETAIL")) W "." Q
 I XBSXREF("FILE")'=XBSXREF("LAST FILE") S XBSXREF("LAST FILE")=XBSXREF("FILE") W !
 W !,XBSXREF("FILE"),",",XBSXREF("FIELD"),?20,$E(X,1,59)
 F XBSXREF("L")=0:0 S X=$E(X,60,999) Q:X=""  W !?20,$E(X,1,59)
 Q
 ;
LIST ; LIST ROUTINE NAMES
 Q:'$D(^UTILITY("XBRSRCH",$J))
 W !!,"Sorted list of routines found:",!
 S X=""
 F XBSXREF("L")=0:0 S X=$O(^UTILITY("XBRSRCH",$J,X)) Q:X=""  W !,"^",X
 KILL ^UTILITY("XBRSRCH",$J)
 W !
 Q
 ;
EOJ ;
 KILL DIC,X,X0,X1,X2,Y,YY
 K:$D(XBSXREF("MASTER")) XBRSRCH
 KILL XBSXREF,XBSXREFF
 Q
 ;
