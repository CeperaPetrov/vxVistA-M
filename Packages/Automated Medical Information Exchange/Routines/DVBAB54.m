DVBAB54 ;ALB/VM - CAPRI ADMISSION REPORT ;09/06/00
 ;;2.7;AMIE;**35**;Apr 10, 1995
 ;
STRT(ZMSG,BDATE,EDATE)  ;ENTER HERE
 S DVBABCNT=0,RO="N",RONUM=0
 K ^TMP($J) G TERM
SET Q:'$D(^DPT(DA,0))  S DFN=DA,DVBASC="" D SC^DVBAVDPT Q:DVBASC'="Y"  Q:CFLOC'=RONUM&(RO="Y")&(CFLOC'=0)&(CFLOC'=376)  S ^TMP($J,XCN,CFLOC,MB,DA)=MA
 Q
 ;
PRINTB S ADMDT=$P(DATA,U),DFN=DA D ADM^DVBAVDPT
 ;W:(IOST?1"C-".E)!($D(DVBAON2)) @IOF
 ;W !!!,?(80-$L(HEAD)\2),HEAD,!,?(80-$L(HEAD1)\2),HEAD1,!!
 S:ADMDT]"" ADMDT=$E(ADMDT,4,5)_"/"_$E(ADMDT,6,7)_"/"_$E(ADMDT,2,3) S:DCHGDT]"" DCHGDT=$E(DCHGDT,4,5)_"/"_$E(DCHGDT,6,7)_"/"_$E(DCHGDT,2,3)
 S ZMSG(DVBABCNT)="",DVBABCNT=DVBABCNT+1
 S ZMSG(DVBABCNT)="",DVBABCNT=DVBABCNT+1
 S ZMSG(DVBABCNT)="          Patient Name:   "_PNAM,DVBABCNT=DVBABCNT+1
 S ZMSG(DVBABCNT)="              Claim No:   "_CNUM,DVBABCNT=DVBABCNT+1
 S ZMSG(DVBABCNT)="      Claim Folder Loc:   "_CFLOC,DVBABCNT=DVBABCNT+1
 S ZMSG(DVBABCNT)="         Social Sec No:   "_SSN,DVBABCNT=DVBABCNT+1
 S ZMSG(DVBABCNT)="        Admission Date:   "_ADMDT,DVBABCNT=DVBABCNT+1
 S ZMSG(DVBABCNT)="   Admitting Diagnosis:   "_DIAG,DVBABCNT=DVBABCNT+1
 S ZMSG(DVBABCNT)="        Discharge Date:   "_DCHGDT,DVBABCNT=DVBABCNT+1
 S ZMSG(DVBABCNT)="           Bed Service:   "_BEDSEC,DVBABCNT=DVBABCNT+1
 S ZMSG(DVBABCNT)="             Recv A&A?:   "_$S(RCVAA=0:"NO",RCVAA=1:"YES",1:"Not specified"),DVBABCNT=DVBABCNT+1
 S ZMSG(DVBABCNT)="              Pension?:   "_$S(RCVPEN=0:"NO",RCVPEN=1:"YES",1:"Not specified"),DVBABCNT=DVBABCNT+1
 ;D ELIG^DVBAVDPT
ELIG S ELIG=DVBAELIG,INCMP=""
 I ELIG]"" S ELIG=ELIG_" ("_$S(DVBAELST="P":"Pend Ver",DVBAELST="R":"Pend Re-verif",DVBAELST="V":"Verified",1:"Not Verified")_")"
 I $D(^DPT(DA,.29)) S INCMP=$S($P(^(.29),U,12)=1:"Incompetent",1:"")
 S ZMSG(DVBABCNT)="      Eligibility data:   "_ELIG_$S(ELIG]"":", ",1:""),DVBABCNT=DVBABCNT+1
 I $X>60 S ZMSG(DVBABCNT)=INCMP,DVBABCNT=DVBABCNT+1
 ;Q
 ;***VM-OUT*I IOST?1"C-".E W *7,!,"Press RETURN to continue or ""^"" to stop    " R ANS:DTIME S:ANS=U!('$T) QUIT=1 I '$T S DVBAQUIT=1
 S DVBAON2=""
 Q
 ;
PRINT K MA S QUIT=""
 S XCN="" F M=0:0 S XCN=$O(^TMP($J,XCN)) Q:XCN=""!(QUIT=1)  S CFLOC="" F J=0:0 S CFLOC=$O(^TMP($J,XCN,CFLOC)) Q:CFLOC=""!(QUIT=1)  D PRINT1
 Q
PRINT1 S ADM="" F K=0:0 S ADM=$O(^TMP($J,XCN,CFLOC,ADM)) Q:ADM=""!(QUIT=1)  S DA="" F L=0:0 S DA=$O(^TMP($J,XCN,CFLOC,ADM,DA)) Q:DA=""!(QUIT=1)  S DATA=^(DA) D PRINTB
 Q
 ;
TERM ;D HOME^%ZIS K NOASK
 ;
 ;W @IOF,!,"VARO SERVICE-CONNECTED ADMISSION REPORT" D NOPARM^DVBAUTL2 G:$D(DVBAQUIT) KILL^DVBAUTIL
 S DTAR=^DVB(396.1,1,0),FDT(0)=$E(DT,4,5)_"-"_$E(DT,6,7)_"-"_$E(DT,2,3)
 S HEAD="SERVICE-CONNECTED ADMISSION REPORT",HEAD1="FOR "_$P(DTAR,U,1)_" ON "_FDT(0)
 ;W !,HEAD1
 ;W !!,"Please enter dates for search, oldest date first, most recent date last.",!!,"Last report was run on " S Y=$P(DTAR,U,8) X ^DD("DD") W Y,!!
 ;D DATE^DVBAUTIL
 ;G:X=""!(Y<0) KILL
 ;S %ZIS="Q" D ^%ZIS K %ZIS G:POP KILL^DVBAUTIL
 ;
 ;I $D(IO("Q")) S ZTRTN="DEQUE^DVBASCRP",ZTIO=ION,NOASK=1,ZTDESC="AMIE SC ADMISSION REPORT" F I="FDT(0)","HEAD","HEAD1","BDATE","EDATE","TYPE","RO","RONUM","NOASK" S ZTSAVE(I)=""
 ;I $D(IO("Q")) D ^%ZTLOAD W:$D(ZTSK) !!,"Request queued.",!! G KILL
 ;
GO S MA=BDATE F J=0:0 S MA=$O(^DGPM("AMV1",MA)) Q:$P(MA,".")>EDATE!(MA="")  F DA=0:0 S DA=$O(^DGPM("AMV1",MA,DA)) Q:DA=""  F MB=0:0 S MB=$O(^DGPM("AMV1",MA,DA,MB)) Q:MB=""  D SET W:'$D(NOASK) "."
 I '$D(^TMP($J)) S ZMSG(DVBABCNT)="No data found for parameters entered." H 2 G KILL
 D PRINT I $D(DVBAQUIT) K DVBAON2 D:$D(ZTQUEUED) KILL^%ZTLOAD G KILL^DVBAUTIL
 ;
KILL D:$D(ZTQUEUED) KILL^%ZTLOAD D ^%ZISC S X=8 K DVBAON2 G FINAL^DVBAUTIL
 ;
DEQUE K ^TMP($J) G GO
