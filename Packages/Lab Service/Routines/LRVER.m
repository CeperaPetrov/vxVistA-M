LRVER ;DALOI/STAFF - LAB ROUTINE DATA VERIFICATION ;11/23/11  12:08
 ;;5.2;LAB SERVICE;**153,286,350**;Sep 27, 1994;Build 7
 ;
 D ^LRPARAM
 S LRCW=8,LREND=0,LRPANEL=0,LRUID=""
 K DIC,LRPER,DUOUT
 D REV
 I LREND D QUIT Q
 D VERDIS
 I LREND D QUIT Q
 D CMTDSP^LRVERA
 S (LRAA,LRAD,LRAN)=0
 N LRVBY
 S LRVBY=$$GET^XPAR("USR^DIV^PKG","LR VER EM VERIFY BY UID",1,"Q")
 I LRVBY<2 S LRVBY=$$SELBY^LRWU4("Verify by",LRVBY+1)
 D:LRVBY=1 ^LRVERA D:LRVBY=2 UID^LRVERA
 I 'LRVBY!(LRAA<1) D QUIT Q
 S X=$$SELPL^LRVERA(DUZ(2))
 I X<1 D QUIT Q
 I X'=DUZ(2) N LRDUZ S LRDUZ(2)=X
 I $P(LRPARAM,U,14),$P($G(^LRO(68,LRAA,0)),U,16) D ^LRCAPV G QUIT:$G(LREND)
SLOW S LRSS=$P(^LRO(68,LRAA,0),U,2)
 ;
 I LRSS="MI" D  Q
 . S X=DUZ D DUZ^LRX S LRTEC=LRUSI
 . S LRPTP=-1,LRMIDEF=$P(^LAB(69.9,1,1),U,10),LRMIOTH=$P(^(1),U,11)
 . D ^LRMIEDZ2,END^LRMIEDZ,QUIT
 ;
 ;
 I LRSS'="CH" D QUIT Q
 ;
 ; The rest of the code only works on the "CH" area.
DAT I LRAD<1 D ADATE^LRWU
 Q:LRAD<1
 S %H=$H-$P(^LAB(69.9,1,0),U,7) D YMD^%DTC S LRTM60=9999999-X
 I LRAN>0 D WLN1 G QUIT:$G(LREND) G L11
 I $P(^LRO(68,LRAA,0),U,3)="D" S I=0 F  S I=$O(^LRO(68,LRAA,1,LRAD,1,I)) Q:I<1  I $D(^LRO(68,LRAA,1,LRAD,1,I,3)),'$P(^(3),U,4) S LRAN=I Q
 S:$D(^LRO(68,LRAA,1,LRAD,2))&(LRAN<1) LRAN=$P(^(2),U,4)
 ;
L10 K LRTEST,LRSET,LRLDT,DIC,LRNAME,LRNG,LRDEL,T,LRTX,LRFP,LRAB,LRVERVER,Y,Z
 G QUIT:$G(LREND) D WLN G QUIT:$G(LREND)
 ;
L11 I $D(LRFASTS) D ^LRVER1,SLOWK^LRFASTS Q
 D ^LRVER1,NEXT
 G L10
 ;
YN S DUOUT=0 S:'$D(%) %=1 D YN^DICN S:%<0 DUOUT=1 W:%=0 !,"Answer with a YES or NO or '^' to exit" Q:%  G YN
 ;
WLN I LRVBY=2 S:LRAN<1 LRUID="" S:$L(LRAN) LRUID=$P($G(^LRO(68,LRAA,1,LRAD,1,LRAN,.3)),"^") D UID^LRVERA G LREND:LRUID="" G WLN1
 ;
 S:LRAN<1 LRAN=""
 K DIR,DIRUT,DTOUT,DUOUT
 S DIR(0)="NAO^1:999999:0"
 S DIR("A")="Accession NUMBER: ",DIR("?")="^D LW^LRVR"
 I LRAN'="" S DIR("B")=LRAN
 D ^DIR K DIR
 I $D(DIRUT) G LREND
 S LRAN=Y
 G WLN:LRAN=""
WLN1 I '$D(^LRO(68,LRAA,1,LRAD,1,LRAN,0)) W !,"Accession does not exist." D NEXT G WLN
 S LRDFN=+^LRO(68,LRAA,1,LRAD,1,LRAN,0),LRORD=$S($D(^(.1)):^(.1),1:0),LRODT=+$S($P(^(0),U,4):$P(^(0),U,4),1:$P(^(0),U,3)),LRSN=+$P(^(0),U,5)
 S LRUID=$P($G(^LRO(68,LRAA,1,LRAD,1,LRAN,.3)),"^")
 S LRDPF=$P(^LR(LRDFN,0),U,2),DFN=$P(^(0),U,3) D PT^LRX
 ;DSS/RAF - BEGIN MOD - add MRN and DOB to display
 ;W !,PNM,?30,SSN
 I $G(VA("MRN"))]"" W !,PNM,?30,$G(VA("MRN",0))_": "_SSN,?49,"DOB: ",$P($G(VADM(3)),U,2)
 E  W !,PNM,?30,SSN
 ;DSS/RAF - END MOD
 W:LRDPF=2 "   LOC:",$S($L(LRWRD):LRWRD,1:$S($L($P(^LRO(68,LRAA,1,LRAD,1,LRAN,0),U,7)):$P(^(0),U,7),1:"??"))
 W !
 S LRCDT=$P($G(^LRO(68,LRAA,1,LRAD,1,LRAN,3)),U)
 ; If no lab arrival time then have user update order/accession
 I '$P($G(^LRO(68,LRAA,1,LRAD,1,LRAN,3)),U,3) D
 . N %DT,LRA1,LRA2,LRA3
 . S %DT("B")=$$FMTE^XLFDT(LRCDT,"1")
 . S LRSTATUS="C",LRA1=LRAA,LRA2=LRAD,LRA3=LRAN
 . D P15^LROE1
 . S LRAA=LRA1,LRAD=LRA2,LRAN=LRA3
 . Q:LRCDT<1
 . I '$P($G(^LRO(68,LRAA,1,LRAD,1,LRAN,3)),U,3) S $P(^(3),U,3)=$$NOW^XLFDT
 ; If user did not update then go to next accession
 I '$P($G(^LRO(68,LRAA,1,LRAD,1,LRAN,3)),U,3) D NEXT G WLN
 S LRCDT=$P($G(^LRO(68,LRAA,1,LRAD,1,LRAN,3)),U)
 I $G(LRCDT)<1 S LRCDT=1 D NEXT G WLN
 ; Check for valid pointer to file #63 and entry in file #63.
 S LRIDT=$P($G(^LRO(68,LRAA,1,LRAD,1,LRAN,3)),U,5)
 I LRIDT<1 D  G WLN
 . W !,">>>>ERROR - NO POINTER TO FILE #63 - PLEASE NOTIFY SYSTEM MANAGER<<<<<",!
 . D NEXT
 I '$D(^LR(LRDFN,"CH",LRIDT,0)) D  G WLN
 . W !,">>>>ERROR - NO ENTRY IN FILE #63 - PLEASE NOTIFY SYSTEM MANAGER<<<<<",!
 . D NEXT
 I $D(^LRO(69,LRODT,1,LRSN)),'$D(^(LRSN,1)) W !,"This Order # has not been collected",$C(7) D NEXT G WLN
 I $D(^LRO(69,LRODT,1,LRSN,1)),$P(^LRO(69,LRODT,1,LRSN,1),U,4)'="C" W !,"You cannot verify an accession which has not been collected.",$C(7) D NEXT G WLN
 Q
 ;
 ;
LREND I $D(^LRO(68,LRAA,1,LRAD,0)) S:'$D(^(2)) ^(2)="^^" S ^(2)=$P(^(2),U,1,3)_U_LRAN_U_$P(^(2),U,5,99)
 S LREND=1 K ^TMP("LR",$J,"TMP"),LRORD,LRM
 Q
 ;
 ;
NEXT ;
 S LRAN=$O(^LRO(68,LRAA,1,LRAD,1,LRAN))
 I LRAN<1 W !,"LAST IN WORK LIST" S LRAN="",LREND=1
 Q
 ;
 ;
QUIT ;
 I $D(LRCSQ),'$O(^XTMP("LRCAP",LRCSQ,DUZ,0)) K ^XTMP("LRCAP",LRCSQ,DUZ),LRCSQ
 I $D(LRCSQ),$D(LRAA),$P($G(^LRO(68,+LRAA,0)),U,16) D STD^LRCAPV
 ;
SLOQ ;
 D STOP^LRCAPV,^LRCAPV2
 K %,A,AGE,D1,DFN,DIC,DIE,DIR,DL,DLAYGO,DOB,DQ,DR,DX,I,J,LRACC,LRVF,LRCDT,LRCW,LRDAT,LRDFN,LRDPF,LRDV,LRDVF,LREAL,LREDIT,LREND,LRFLG,LRIDT,LRINI,LRLCT,LRLLOC,LRMETH,LRNG2,LRNG3,LRAD,LRAN,LRSPEC,LRPER,LRALL
 K LRNG4,LRNG5,LRNT,LRNTN,LRNX,LRODT,LROUTINE,LROWLE,LRSAMP,LRSN,LRSS,LRSSP,LRSUB,LRTEC,LRTN,LRTS,LRUSI,LRUSNM,LRWRD,LRXD,LRXDP,PNM,S,SEX,SSN,X,X1,X2,X3,Y,Z
 K %DT,%H,%X,%Y,B,C,D,DA,DR,G,G1,G2,G4,LRACD,LRAOD,LREDT,LREXEC,LRGVP,LRIOZERO,LRM,LRMA,LRNAME,LRORD,LRPLOC,LRSA,LRSB,LRSDT,LRSSQ,LRTK,LRTX,LRURG,LRVOL,LRVRM,LRWDTL,LRXDH,N,POP,T1,X9,Z1,Z2,^TMP("LR",$J)
 K LRT,LRCFL,D0,GLB,LRAA,LRCNT,LRCODE,LRCODEN,LRCMTDSP,LRCWT,LRI,LRNOW,LRP,LRPN,LRQC,LRSSC,LRSSCX,LRSTD,NODE,NODE0,NOW,S2,ZTSK,Y,LRTIME,LRMAX2,LRMAXX,LRMX,LRODTSV,LRSNSV,LRSPN,LRTNSV,LRTY
 K W,Y,Z,Z1,Z2,I1,LRALERT,LRDIYCNT,LRNOCODE,LRREP,LRSTATUS,LRUN,LRX,LRTIM,LRAL,LRPANEL,LRTM60,LRNDISP
 D KVA^VADPT K LRIDIV,LROLLOC,LRORIFN,LRPRAC,LRRB,LRSD,LRTREA,LRTT,LRUID
 K NAME,LRSUFO,LRCSQQ
 Q
 ;
 ;
REV ; Ask if user wants to review data before and after editing
 N DIR,DIROUT,DIRUT,DTOUT,DUOUT,X,Y
 S DIR(0)="YO",DIR("B")="YES"
 S DIR("A")="Do you want to review the data before and after you edit"
 S DIR("?",1)="Answer YES, and the data will be displayed in its entirety as a panel before"
 S DIR("?",2)="you edit if data already exists, and will be displayed after you edit."
 S DIR("?")="NO, will skip the extra displays."
 D ^DIR
 I $D(DIRUT) S LREND=1
 I Y=0 S LRPER=""
 Q
 ;
 ;
VERDIS ; Prevent test not selected by the user with verified data
 ; entered from being displayed on the editing screens.
 N DIR,DIROUT,DIRUT,DTOUT,DUOUT,X,Y
 S DIR(0)="YO",DIR("B")="NO"
 S DIR("A")="Do you wish to see all previously verified results"
 S DIR("?",1)="Do you want to see every test that has results entered"
 S DIR("?",2)="or only the test(s) you select to edit "
 S DIR("?")="Answer with YES or NO"
 D ^DIR
 I $D(DIRUT) S LREND=1
 I Y=0 S LRNDISP=1
 Q