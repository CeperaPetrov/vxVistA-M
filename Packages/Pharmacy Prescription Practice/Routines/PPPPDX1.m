PPPPDX1 ;ALB/DMB - PPP PDX ROUTINES ; 2/21/92
 ;;V1.0;PHARMACY PRESCRIPTION PRACTICE;**2,8,21**;APR 7,1995
 ;;Per VHA Directive 10-93-142, this routine should not be modified.
 ;
SNDPDX(PATDFN,SPARRY,ERRARRY) ; Send a PDX message for a patient
 ;
 N ARRYNM,DA,DIC,DIQ,DR,DUOUT,DTOUT,DOMAIN
 N ERR,FFXIFN,I,PARMERR,PDXERR,RFNERR,STAPTR,TMP
 N X,DOMARR,SEGARR,NOTARR,MSGPOS
 ;
 S ERR=0
 S PDXERR=-9008
 S PARMERR=-9001
 S RFNERR=-9009
 S FFXIFN=0
 ;
 I '$D(PATDFN) Q PARMERR
 I '$D(@SPARRY) Q PARMERR
 I PATDFN<1 Q PARMERR
 I '$D(PDXSNT) S PDXSNT=0
 ;
 S X="VAQUIN01" X ^%ZOSF("TEST") I ('$T) Q RFNERR
 ;
 ; Order through the station pointer array and generate PDX Request
 ;
 F STAPTR=0:0 D  Q:STAPTR=""
 .S STAPTR=$O(@SPARRY@(STAPTR)) Q:STAPTR=""
 .;
 .;  First get the domain name from the FFX file
 .;
 .S FFXIFN=$O(^PPP(1020.2,"APOV",PATDFN,STAPTR,""))
 .I FFXIFN="" D  Q
 ..S TMP=$$POSTERR(ERRARRY,FFXIFN,"Could Not Find Entry In APOV xref for Patient DFN "_PATDFN)
 .S DOMAIN=$P($G(^PPP(1020.2,FFXIFN,1)),"^",5)
 .S LNUM=0 I DOMAIN]"" S LNUM=$O(^PPP(1020.128,"A",DOMAIN,0))
 .I LNUM S DOMAIN=$P(^PPP(1020.128,LNUM,0),"^",2)
PTCH .;DAVE B (PPP*1*21)
 .S DATA=$G(^PPP(1020.2,FFXIFN,0))
 .I DOMAIN="",$P(DATA,"^",2)'="" S DOMAIN=$$GETDOMNM^PPPGET3($P(DATA,"^",2))
 .S XX=FFXIFN,DATA=$G(^PPP(1020.2,FFXIFN,0)),ERRTXT="No Domain Entry in FFX file for --> "
 .I DOMAIN="" F IDX=1:1 S TMP=$O(@SPARRY@(IDX)) Q:TMP=""
 .I DOMAIN="" S @ERRARRY@(IDX+1)=ERRTXT_$S($P(DATA,"^")="":FFXIFN,1:$$GETPATNM^PPPGET1($P(DATA,"^")))_" at "_$P(DATA,"^",2) Q
 .K DOMARR
 .S DOMARR(DOMAIN)=""
 .;SET SEGMENT ARRAY (REQUEST MINIMAL AND MED PROFILE LONG)
 .K SEGARR
 .S SEGARR("PDX*MIN")=""
 .S SEGARR("PDX*MPL")=""
 .;SET NOTIFY ARRAY (DON'T NOTIFY ANYONE)
 .K NOTARR
 .S NOTARR=""
 .;REQUEST PDX INFORMATION
 .S X=$$PDX^VAQUIN01("REQ",PATDFN,"","","","DOMARR","SEGARR","NOTARR")
 .;ERROR
 .I (+X) D  Q
 ..S TMP=$$POSTERR(ERRARRY,FFXIFN,"Error sending PDX to "_DOMAIN)
 ..S ERR=PDXERR
 .S PDXSNT=PDXSNT+1
 .S TMP=$$POSTMSG(ERRARRY,FFXIFN,PDXSNT)
 .;
 .; Update the last batch request date field
 .;
 .S DIE=1020.2,DA=FFXIFN,DR="6///TODAY" D ^DIE
 ;UPDATE STATISTICS
 I PDXSNT>0 D
 .S TMP=$$STATUPDT^PPPMSC1(2,PDXSNT)
 .S @ERRARRY@(10001)=""
 .S @ERRARRY@(10002)=""
 .S @ERRARRY@(10003)="The following PDX request were generated by PPP on "_$$SLASHDT^PPPCNV1(DT)
 .S @ERRARRY@(10004)=""
 .S @ERRARRY@(10005)="NAME                       SSN         STATION"
 .S @ERRARRY@(10006)="-------------------------  ----------  -------------------------"
 .S MSGPOS=10006+PDXSNT
 .;S @ERRARRY@(MSGPOS+1)=""
 .;S @ERRARRY@(MSGPOS+2)=""
 .;S @ERRARRY@(MSGPOS+3)="Total Sent = "_PDXSNT
 ;
 Q ERR
 ;
POSTERR(ARRYNM,XRFIFN,ERRTXT) ; Add an error to the error list
 ;
 N IDX,LKUPERR,PARMERR,PATDFN,PATNAME,SNIFN,STANAME,STATCODE,STATIFN
 N STATTXT,TMP
 ;
 S PARMERR=-9001
 S LKUPERR=-9003
 ;
 ; Check Parameters
 ;
 I '$D(ARRYNM) Q PARMERR
 I '$D(XRFIFN) Q PARMERR
 I ARRYNM="" Q PARMERR
 I '$D(ERRTXT) S ERRTXT=""
 ;
 ; Get the patient name and station name
 ;
 S PATNAME="UNKNOWN"
 I FFXIFN'="" D
 .S PATDFN=$P($G(^PPP(1020.2,XRFIFN,0)),"^")
 .I PATDFN'="" S PATNAME=$$GETPATNM^PPPGET1(PATDFN)
 ;
 ; Set the array
 ;
 F IDX=1:1 S TMP=$O(@ARRYNM@(IDX)) Q:TMP=""
 S @ARRYNM@(IDX+1)=ERRTXT_" --> Entry #: "_$S(PATNAME="UNKNOWN":$G(XRFIFN),1:PATNAME)_" at "_$S($G(DOMAIN)="":$P($G(^PPP(1020.2,XRFIFN,0)),"^",2),1:DOMAIN)
 ;
 Q 0
 ;
POSTMSG(ARRYNM,XRFIFN,MSGCNT) ; Add message line for PDX's sent
 ;
 N IDX,LKUPERR,PARMERR,PATDFN,PATNAME,SNIFN,STANAME
 N TMP,PATSSN,SP25
 ;
 S PARMERR=-9001
 S LKUPERR=-9003
 S SP25="                        "
 ;
 ; Check Parameters
 ;
 I '$D(ARRYNM) Q PARMERR
 I '$D(XRFIFN) Q PARMERR
 I ARRYNM="" Q PARMERR
 I '$D(MSGCNT) Q PARMERR
 ;
 ; Get the patient name and station name and SSN
 ;
 S PATNAME="UNKNOWN"
 I FFXIFN'="" D
 .S PATDFN=$P($G(^PPP(1020.2,XRFIFN,0)),"^")
 .I PATDFN'="" S PATNAME=$$GETPATNM^PPPGET1(PATDFN),PATSSN=$$GETSSN^PPPGET1(PATDFN)
 ; Set the array, beginning at 10,006
 ;
 S IDX=10006+MSGCNT
 S @ARRYNM@(IDX)=$E(PATNAME_SP25,1,25)_"  "_$E(PATSSN_SP25,1,10)_"  "_DOMAIN
 ;
 Q 0
EDITSITE ;
 W ! S DIC("A")="Select LEGACY SITE: ",DIC="^PPP(1020.128,",DIC(0)="QEALMZ",DLAYGO="1020.128"
 D ^DIC I $D(DTOUT)!$D(DUOUT)!(Y<1) G END
 S DIE="^PPP(1020.128,",(DA,PPPDA)=+Y,DR=".01;.02;1" D ^DIE
 I $P($G(^PPP(1020.128,PPPDA,0)),"^",2)="" W !!,"Missing Merged Site for ",$P($G(^DIC(4.2,PPPDA,0)),"^"),!,"Now Deleting Entry." S DIK="^PPP(1020.128,",DA=PPPDA D ^DIK
 G EDITSITE
END ;
 K DIC,DIE,DA,Y,DR,DIK,PPPDA
 Q
