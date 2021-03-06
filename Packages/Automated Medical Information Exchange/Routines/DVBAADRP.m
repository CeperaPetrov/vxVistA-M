DVBAADRP ;ALB/GTS-557/THM-AMIE COMPLETE ADMISSION RPT ; 1/22/91  1:19 PM
 ;;2.7;AMIE;**17,42,53,108**;Apr 10, 1995
 N DVBGUI
 S DVBGUI=0
 K ^TMP($J) G TERM
 Q
 ;
ENBROKER(Y) ;
 ; Returns some info for the CAPRI GUI to display prior
 ; to the user running this report
 N DVBGUI
 S DVBGUI=1
 K ^TMP($J)
 D HOME^%ZIS K NOASK,QUIT1
 D NOPARM^DVBAUTL2 G:$D(DVBAQUIT) KILL^DVBAUTIL
 ;
 S Y(1)="VARO COMPLETE ADMISSION REPORT" S DTAR=^DVB(396.1,1,0),FDT(0)=$$FMTE^XLFDT(DT,"5DZ")
 S HEAD="TOTAL ADMISSION REPORT",HEAD1="FOR "_$P(DTAR,U,1)_" ON "_FDT(0)
 S Y(2)=HEAD1,Y(3)=""
 S Y(4)="Please enter dates for search, oldest date first, most recent date last."
 S Y=$P(DTAR,U,3) X ^DD("DD")
 S Y(5)=""
 S Y(6)="Last report was run on "_Y
 Q
ENBROKE2(MSG,BDATE,EDATE,RO,RONUM) ;
 ; This is the entry point to run the actual report from
 ; the CAPRI GUI.
 N DVBHFS,DVBERR,DVBGUI,I
 K ^TMP("DVBA",$J)
 S DVBGUI=1,DVBERR=0,DVBHFS=$$HFS^DVBAB82()
 S X=BDATE,Y=EDATE
 ; DVBA*2.7*108 - Correct next line.  CAPRI GUI already adds 1 to EDATE
 ; S BDATE=BDATE-.5,EDATE=EDATE+.5
 S BDATE=BDATE-.5,EDATE=EDATE-.5
 K ^TMP($J)
 D HOME^%ZIS K NOASK,QUIT1
 D NOPARM^DVBAUTL2 G:$D(DVBAQUIT) KILL^DVBAUTIL
 ;
 S HEAD="TOTAL ADMISSION REPORT",HEAD1="FOR "_$P(DTAR,U,1)_" ON "_FDT(0)
 I $D(X) D
 . G:X=""!(Y<0) KILL S %ZIS="AEQ" D ^%ZIS K %ZIS
 D HFSOPEN^DVBAB82("DVBRP",DVBHFS,"W") I DVBERR D END^DVBAB82 Q
 I POP K DVBAON2,DCHPTR,M,Y,J G KILL^DVBAUTIL
 U IO
 D DEQUE
 D END^DVBAB82
 Q
SET Q:'$D(^DPT(DA,0))  S DFN=DA D RCV^DVBAVDPT Q:CFLOC'=RONUM&(RO="Y")&(CFLOC'=0)&(CFLOC'=376)
 S ^TMP($J,XCN,CFLOC,MB,DA)=MA_U_RCVAA_U_RCVPEN_U_CNUM
 Q
 ;
PRINTB S MA=$P(DATA,U),RCVAA=$P(DATA,U,2),RCVPEN=$P(DATA,U,3),CNUM=$P(DATA,U,4),DFN=DA,QUIT1=1 D ADM^DVBAVDPT
 S:ADMDT]"" ADMDT=$$FMTE^XLFDT(ADMDT,"5DZ")
 S:DCHGDT]"" DCHGDT=$$FMTE^XLFDT(DCHGDT,"5DZ")
 W:(IOST?1"C-".E!($D(DVBAON2))) @IOF
 I DVBGUI=0 W !!!,?(80-$L(HEAD)\2),HEAD,!,?(80-$L(HEAD1)\2),HEAD1,!!
 I DVBGUI=1 W !!
 W ?10,"Patient Name:",?26,PNAM,!!,?14,"Claim No:",?26,CNUM,!,?6,"Claim Folder Loc:",?26,CFLOC,!,?9,"Social Sec No:",?26,SSN,!,?8,"Admission Date:",?26,ADMDT,!,?3,"Admitting Diagnosis:",?26,DIAG,!
 W ?8,"Discharge Date:",?26,DCHGDT,!,?11,"Bed Service:",?26,BEDSEC,!,?13,"Recv A&A?:",?26,$S(RCVAA=0:"NO",RCVAA=1:"YES",1:"Not specified"),!
 W ?14,"Pension?:",?26,$S(RCVPEN=0:"NO",RCVPEN=1:"YES",1:"Not specified"),! D ELIG^DVBAVDPT I IOST'?1"C-".E S DVBAON2=""
 I IOST?1"C-".E DO
 .I ($O(^TMP($J,XCN))'=""!($O(^TMP($J,XCN,CFLOC))'=""!($O(^TMP($J,XCN,CFLOC,ADM))'=""!($O(^TMP($J,XCN,CFLOC,ADM,DA))'="")))) DO
 ..I DVBGUI=0 D
 ...W *7,!,"Press RETURN to continue or ""^"" to stop    "
 ...R ANS:DTIME
 ...S:ANS=U!('$T) QUIT=1
 ...I '$T S DVBAQUIT=1
 .I ($O(^TMP($J,XCN))=""&($O(^TMP($J,XCN,CFLOC))=""&($O(^TMP($J,XCN,CFLOC,ADM))=""&($O(^TMP($J,XCN,CFLOC,ADM,DA))="")))) DO
 ..I DVBGUI=0 D
 ...W *7,!,"Press RETURN to continue  "
 ...R ANS:DTIME
 Q
 ;
PRINT U IO S QUIT="" K MA,MB
 S XCN="" F M=0:0 S XCN=$O(^TMP($J,XCN)) Q:XCN=""!(QUIT=1)  S CFLOC="" F J=0:0 S CFLOC=$O(^TMP($J,XCN,CFLOC)) Q:CFLOC=""!(QUIT=1)  D PRINT1
 Q
PRINT1 S ADM="" F K=0:0 S ADM=$O(^TMP($J,XCN,CFLOC,ADM)) Q:ADM=""!(QUIT=1)  S DA="" F L=0:0 S DA=$O(^TMP($J,XCN,CFLOC,ADM,DA)) Q:DA=""!(QUIT=1)  S DATA=^(DA) D PRINTB
 Q
 ;
TERM D HOME^%ZIS K NOASK,QUIT1
 D NOPARM^DVBAUTL2 G:$D(DVBAQUIT) KILL^DVBAUTIL
 ;
SETUP W @IOF,!,"VARO COMPLETE ADMISSION REPORT" S DTAR=^DVB(396.1,1,0),FDT(0)=$$FMTE^XLFDT(DT,"5DZ")
 S HEAD="TOTAL ADMISSION REPORT",HEAD1="FOR "_$P(DTAR,U,1)_" ON "_FDT(0)
 W !,HEAD1
EN1 W !!,"Please enter dates for search, oldest date first, most recent date last.",!!,"Last report was run on " S Y=$P(DTAR,U,3) X ^DD("DD") W Y,!!
 D DATE^DVBAUTIL
 G:X=""!(Y<0) KILL S %ZIS="AEQ" D ^%ZIS K %ZIS
 I POP K DVBAON2,DCHPTR,M,Y,J G KILL^DVBAUTIL
 ;
QUEUE I $D(IO("Q")) S ZTRTN="DEQUE^DVBAADRP",ZTIO=ION,NOASK=1,ZTDESC="AMIE ADMISSION REPORT" F I="BDATE","EDATE","HEAD","HEAD1","RO","RONUM","FDT(0)","NOASK" S ZTSAVE(I)=""
 I $D(IO("Q")) D ^%ZTLOAD W:$D(ZTSK) !!,"Request queued.",!! G KILL
 ;
GO S MA=BDATE F J=0:0 S MA=$O(^DGPM("AMV1",MA)) Q:$P(MA,".")>EDATE!(MA="")  W:'$D(NOASK) "." F DA=0:0 S DA=$O(^DGPM("AMV1",MA,DA)) Q:DA=""  F MB=0:0 S MB=$O(^DGPM("AMV1",MA,DA,MB)) Q:MB=""  I MA'>EDATE D SET
 I '$D(^TMP($J)) U IO W !!,*7,"No data found for parameters entered",!! H 2 G KILL
 I $G(DVBGUI)=1 W !,HEAD,!,HEAD1,!
 I $D(^TMP($J)) D PRINT I $D(DVBAQUIT) K DVBAON2,DCHPTR,M,Y,J G KILL^DVBAUTIL
 ;
KILL ;
 D ^%ZISC S X=3 K DVBAON2,DCHPTR,M,Y,J D:$D(ZTQUEUED) KILL^%ZTLOAD G FINAL^DVBAUTIL
 ;
DEQUE K ^TMP($J) G GO
