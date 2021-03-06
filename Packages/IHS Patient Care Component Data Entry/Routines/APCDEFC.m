APCDEFC ;cmi/sitka/maw - APCD Auto Print PCC Encounter Form Compute [ 03/18/04  2:24 PM ]
 ;;2.0;IHS RPMS PCC/Data Entry;**3,4,5,6,7**;MAR 09, 1999
 ;
 ;This routine will compute the automated PCC encounter form for
 ;a particular visit.  The visit IEN needs to be passed in for it
 ;to run.  This will typically be called after data entry.
 ;
 ;
MAIN ;-- loop through temp and print out the data
 I '$D(^XTMP(APCDJ,APCDH,"APCDEF")) Q
 D SET
 Q
 ;
SET ;-- set up the data to print
 S APCDPOVC=0,APCDCPTC=0
 S APCDATMP="^XTMP(APCDJ,APCDH,""APCDEF"")"
 S APCDA=0 F  S APCDA=$O(@APCDATMP@(APCDA)) Q:'APCDA  D
 . S APCDFN=0 F  S APCDFN=$O(@APCDATMP@(APCDA,APCDFN)) Q:APCDFN=""  D
 .. S APCDIEN=0 F  S APCDIEN=$O(@APCDATMP@(APCDA,APCDFN,APCDIEN)) Q:'APCDIEN  D
 ... S APCDTREC=$G(@APCDATMP@(APCDA,APCDFN,APCDIEN))
 ... Q:$T(@APCDFN)=""
 ... D @APCDFN
 Q
 ;
VMSR ;-- v measurement to external
 S APCDT=$$VAL^XBDIQ1(9999999.07,$P(APCDTREC,U),.01)
 S APCDV=$P(APCDTREC,U,4)
 S APCDMSR(APCDT)=APCDV
 Q
 ;
VXAM ;-- v exam to external
 S APCDT=$$VAL^XBDIQ1(9000010.13,APCDTREC,.01)
 S APCDV=$$VAL^XBDIQ1(9000010.13,APCDTREC,.04)
 S APCDXAM(APCDT)=APCDV
 Q
 ;
VPOV ;-- v pov to external
 S APCDPOVC=$G(APCDPOVC)+1
 S APCDPOV=$$VAL^XBDIQ1(9000010.07,APCDTREC,.01)
 S APCDPRVN=$$VAL^XBDIQ1(9000010.07,APCDTREC,.04)
 S APCDPOV(APCDPOVC)=APCDPOV_U_APCDPRVN
 S APCDP=3 F APCDX=.05,.06,.07,.09,.11,.13,.18,.19 S $P(APCDPOV(APCDPOVC),U,APCDP)=$$VAL^XBDIQ1(9000010.07,APCDTREC,APCDX),APCDP=APCDP+1
 K APCDP,APCDX,APCDPRVN
 Q
 ;
VMED ;-- v med to external
 S APCDMED=$$VAL^XBDIQ1(50,$P(APCDTREC,U),.01)
 S APCDSIG=$P(APCDTREC,U,5)
 S APCDQTY=$P(APCDTREC,U,6)
 S APCDDP=$P(APCDTREC,U,7)
 S APCDMED(APCDMED)=APCDSIG_U_APCDQTY_U_APCDDP
 Q
 ;
VEYE ;-- v eye glass to external
 S APCDRO=$$EXTSET^XBFUNC(9000010.04,1901,$P(APCDTREC,U))
 S APCDRES=$P(APCDTREC,U,2)
 S APCDREC=$P(APCDTREC,U,3)
 S APCDREA=$P(APCDTREC,U,4)
 S APCDLES=$P(APCDTREC,U,5)
 S APCDLEC=$P(APCDTREC,U,6)
 S APCDLEA=$P(APCDTREC,U,7)
 S APCDRAR=$P(APCDTREC,U,8)
 S APCDRAL=$P(APCDTREC,U,9)
 S APCDES=$P(APCDTREC,U,10)
 S APCDBR=$P(APCDTREC,U,11)
 S APCDTM=$P(APCDTREC,U,12)
 S APCDPDN=$P(APCDTREC,U,13)
 S APCDPDF=$P(APCDTREC,U,14)
 Q
 ;
VDEN ;-- v dental to external
 S APCDADA=$$VAL^XBDIQ1(9999999.31,$P(APCDTREC,U),.01)
 S APCDNOU=$P(APCDTREC,U,4)
 S APCDOS=$S($P(APCDTREC,U,5):$$VAL^XBDIQ1(9002010.03,$P(APCDTREC,U,5),.01),1:"")
 S APCDTS=$P(APCDTREC,U,6)
 S APCDDEN(APCDADA)=APCDNOU_U_APCDOS_U_APCDTS
 Q
 ;
VCPT ;--v cpt to external
 S APCDCPTC=$G(APCDCPTC)+1
 S APCDCPT=$$VAL^XBDIQ1(81,$P(APCDTREC,U),.01)
 S APCDUNI=$P(APCDTREC,U,16)
 I $P(APCDTREC,U,8)]"" S APCDMD1=$$VAL^XBDIQ1(9999999.88,$P(APCDTREC,U,8),.01)
 I $P(APCDTREC,U,9)]"" S APCDMD2=$$VAL^XBDIQ1(9999999.88,$P(APCDTREC,U,9),.01)
 S APCDCPT(APCDCPTC)=APCDCPT_U_APCDUNI_U_$G(APCDMD1)_U_$G(APCDMD2)
 Q
VPRC ;-- v procedure to external
 S APCDPRC=$$VAL^XBDIQ1(80.1,$P(APCDTREC,U),.01)
 S APCDPRN=$S($P(APCDTREC,U,4):$$VAL^XBDIQ1(9999999.27,$P(APCDTREC,U,4),.01),1:"")
 S APCDPDT=$$FMTE^XLFDT($P(APCDTREC,U,6))
 S APCDPRC(APCDPRC)=APCDPRN_U_APCDPDT
 Q
 ;
VLAB ;-- v lab to external
 S APCDLAB=$$VAL^XBDIQ1(60,$P(APCDTREC,U),.01)
 S APCDRES=$P(APCDTREC,U,4)
 S APCDABN=$P(APCDTREC,U,5)
 S APCDLAB(APCDLAB)=APCDRES_U_APCDABN
 Q
 ;
VIMM ;-- v immunization to external
 S APCDIMM=$$VAL^XBDIQ1(9999999.14,$P(APCDTREC,U),.01)
 S APCDSER=$S($P(APCDTREC,U,4):$$EXTSET^XBFUNC(9000010.11,.04,$P(APCDTREC,U,4)),1:"")
 S APCDLOT=$S($P(APCDTREC,U,3):$$VAL^XBDIQ1(9999999.41,$P(APCDTREC,U,3),.01),1:"")
 S APCDREA=$S($P(APCDTREC,U,6):$$EXTSET^XBFUNC(9000010.11,.06,$P(APCDTREC,U,6)),1:"")
 S APCDIMM(APCDIMM)=APCDSER_U_APCDLOT_U_APCDREA
 Q
 ;
VSK ;-- v skin test to external
 S APCDSK=$$VAL^XBDIQ1(9999999.28,$P(APCDTREC,U),.01)
 S APCDRES=$S($P(APCDTREC,U,4):$$EXTSET^XBFUNC(9000010.12,$P(APCDTREC,U,4),.04),1:"")
 S APCDREA=$P(APCDTREC,U,5)
 S APCDDTR=$$FMTE^XLFDT($P(APCDTREC,U,6))
 S APCDSK(APCDSK)=APCDRES_U_APCDREA_U_APCDDTR
 Q
 ;
VTRT ;-- v treatement to external
 S APCDTRT=$$VAL^XBDIQ1(9999999.17,$P(APCDTREC,U),.01)
 S APCDHM=$P(APCDTREC,U,4)
 S APCDPRV=$P(APCDTREC,U,5)
 I APCDPRV S APCDPRV=$S($P(^DD(9000010.15,.05,0),U,2)[200:$P(^VA(200,$P(APCDTREC,U,5),0),U),1:$P(^DIC(16,$P(APCDTREC,U,5),0),U))
 S APCDTRT(APCDTRT)=APCDHM_U_APCDPRV
 Q
 ;
VPED ;-- v patient education to external
 S APCDPED=$$VAL^XBDIQ1(9000010.16,APCDTREC,.01)
 S APCDC=1 F APCDX=".06",".07",".08",".09",".11",".13",".14","1101" S $P(APCDPED(APCDPED),U,APCDC)=$$VAL^XBDIQ1(9000010.16,APCDTREC,APCDX),APCDC=APCDC+1
 Q
 ;
VPT ;-- v physical therapy to external
 S APCDPT=$$VAL^XBDIQ1(9999999.46,$P(APCDTREC,U),.02)
 S APCDQTY=$P(APCDTREC,U,4)
 S APCDPT(APCDPT)=APCDQTY
 Q
 ;
VACT ;-- v activity time to external
 S APCDACT=$P(APCDTREC,U)
 S APCDTT=$P(APCDTREC,U,4)
 S APCDACT(APCDACT)=APCDTT
 Q
 ;
VDXP ;-- v diagnostic procedure result to external
 D VDXP^APCDEFC1
 Q
 ;
VRAD ;-- v radiology to external
 D VRAD^APCDEFC1
 Q
 ;
VHF ;-- v health factors to external
 D VHF^APCDEFC1
 Q
 ;
VMIC ;-- v microbiology to external
 D VMIC^APCDEFC1
 Q
 ;
VBB ;-- v blood bank to external
 D VBB^APCDEFC1
 Q
 ;
VPHN ;-- v public health nurse to external
 D VPHN^APCDEFC1
 Q
 ;
VNT ;-- v narrative text to external
 D VNT^APCDEFC1
 Q
 ;
