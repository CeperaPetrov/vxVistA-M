PSSDOSCR ;BIR/RTR-Dosage creation routine ;03/09/00
 ;;1.0;PHARMACY DATA MANAGEMENT;**34,38**;9/30/97
 ;Reference to ^PS(50.607 supported by DBIA 2221
 ;
 S PSSTRAC=+$O(^PS(59.7,0))
 S PSSCLEAN=0
 S PSSTRACK=$P($G(^PS(59.7,PSSTRAC,80)),"^",3)
 I PSSTRACK=1 S Y=$P($G(^PS(59.7,PSSTRAC,80)),"^",4) D:Y DD^%DT W !!!,$C(7),"Dosage conversion has already been queued for "_$G(Y),! K PSSTRAC,PSSTRACK,Y Q
 I PSSTRACK=2 W !!!,$C(7),"Dosage conversion is currently running, cannot run at this time.",! K PSSTRAC,PSSTRACK Q
 W !!,"This option will queue the conversion that populates the Possible Dosages",!,"and Local Possible Dosages in the Drug file. New dosages will be added to",!,"dosages that are already in the file.",!
 I PSSTRACK=3 K PSSOUT D  I $G(PSSOUT) W !!,"Nothing queued.",! G ENDX
 .K PSSSTART,PSSSTOP,PSSWHO S Y=$P($G(^PS(59.7,PSSTRAC,80)),"^",4) D DD^%DT S PSSSTART=Y S Y=$P($G(^PS(59.7,PSSTRAC,80)),"^",5) D DD^%DT S PSSSTOP=Y I $P($G(^PS(59.7,PSSTRAC,80)),"^",6) D WHO
 .W !,"The dosage conversion was last run by "_$G(PSSWHO),!,"It started on "_$G(PSSSTART)_" and ended on "_$G(PSSSTOP),!
 .K DIR S DIR(0)="Y",DIR("B")="N",DIR("A")="Are you sure you want to run the Dosage conversion again",DIR("?")=" "
 .S DIR("?",1)="If you run the Dosage conversion again, any new Dosages that can be created",DIR("?",2)="will be merged with the Dosages that you have already built in your DRUG file."
 .W $C(7) D ^DIR K DIR I Y'=1 S PSSOUT=1 Q
 S:$G(PSSTRACK)="" PSSTRACK=0
 W ! S PSSDUZ=+$G(DUZ) K ZTDTH S ZTRTN="EN^PSSDOSCR",ZTDESC="DOSAGE CONVERSION",ZTIO="",ZTSAVE("PSSDUZ")="",ZTSAVE("PSSTRAC")="",ZTSAVE("PSSTRACK")="",ZTSAVE("PSSCLEAN")="" D ^%ZTLOAD I $D(ZTSK)[0 W !!,"Nothing queued.",! G ENDX
 K %,X I $G(ZTSK("D"))'="" S %H=ZTSK("D") D YX^%DTC K %H
 S $P(^PS(59.7,PSSTRAC,80),"^",3)=1,$P(^(80),"^",4)=$G(X)_$G(%),$P(^(80),"^",5)="",$P(^(80),"^",6)=$G(DUZ) K X,%
 W !!,"Dosage Conversion queued!",! G ENDX
EN ;
 K PSSBOTH,PSSTODOS,PSSD,PSSFLAG,PSSND,PSSNODE,PSSDF,PSSST,PSSUN,PSSFLAGZ,PSI,PSO,PSSTOT,PSSDUPD,PSSTOTX,PSSONLYO,PSSONLYI
 S $P(^PS(59.7,PSSTRAC,80),"^",3)=2 D NOW^%DTC S $P(^PS(59.7,PSSTRAC,80),"^",4)=%,$P(^(80),"^",6)=$G(PSSDUZ)
 S PSSTRACK=$S($G(PSSTRACK):1,1:0)
 I $G(PSSTRACK),'$G(PSSCLEAN) G ^PSSDOSCX
 F PZZ=0:0 S PZZ=$O(^PSDRUG(PZZ)) Q:'PZZ  K ^PSDRUG(PZZ,"DOS"),^PSDRUG(PZZ,"DOS1"),^PSDRUG(PZZ,"DOS2")
 F PSSD=0:0 S PSSD=$O(^PSDRUG(PSSD)) Q:'PSSD  D  D:'$G(PSSFLAG) LOCAL
 .S (PSSFLAG,PSSONLYI,PSSONLYO,PSSBOTH)=0
 .S PSSND=$P($G(^PSDRUG(PSSD,"ND")),"^",3),PSSND1=$P($G(^("ND")),"^") Q:'PSSND!('PSSND1)
 .S X=$$DFSU^PSNAPIS(PSSND1,PSSND) S PSSDF=$P(X,"^"),PSSST=$P(X,"^",4),PSSUN=$P(X,"^",5) K X
 .Q:'PSSDF!('PSSUN)!($G(PSSST)="")
 .Q:'$D(^PS(50.606,PSSDF,0))!('$D(^PS(50.607,PSSUN,0)))
 .I PSSST'?.N&(PSSST'?.N1".".N) Q
 .S (PSSFLAGZ,PSI,PSO)=0 D  Q:'$G(PSSFLAGZ)
 ..I $D(^PS(50.606,"ACONI",PSSDF,PSSUN)),$O(^PS(50.606,"ADUPI",PSSDF,0)) S (PSSFLAGZ,PSI)=1
 ..I $D(^PS(50.606,"ACONO",PSSDF,PSSUN)),$O(^PS(50.606,"ADUPO",PSSDF,0)) S (PSSFLAGZ,PSO)=1
 .;CONVERT POSSIBLE DOSAGES
 .I 'PSI,'PSO S PSSBOTH=1 Q
 .I PSI,'PSO D  S:PSSTOT>1 PSSTOTX=PSSTOT-1,^PSDRUG(PSSD,"DOS")=PSSST_"^"_PSSUN,PSSONLYO=1,^PSDRUG(PSSD,"DOS1",0)="^50.0903^"_$G(PSSTOTX)_"^"_$G(PSSTOTX) Q
 ..S PSSTOT=1 F PSSDUPD=0:0 S PSSDUPD=$O(^PS(50.606,"ADUPI",PSSDF,PSSDUPD)) Q:'PSSDUPD  D
 ...S PSSTODOS=PSSDUPD*PSSST
 ...S ^PSDRUG(PSSD,"DOS1",PSSTOT,0)=PSSDUPD_"^"_PSSTODOS_"^I",^PSDRUG(PSSD,"DOS1","B",PSSDUPD,PSSTOT)="" S PSSTOT=PSSTOT+1
 .I PSO,'PSI D  S:PSSTOT>1 PSSTOTX=PSSTOT-1,^PSDRUG(PSSD,"DOS")=PSSST_"^"_PSSUN,PSSONLYI=1,^PSDRUG(PSSD,"DOS1",0)="^50.0903^"_$G(PSSTOTX)_"^"_$G(PSSTOTX) Q
 ..S PSSTOT=1 F PSSDUPD=0:0 S PSSDUPD=$O(^PS(50.606,"ADUPO",PSSDF,PSSDUPD)) Q:'PSSDUPD  D
 ...S PSSTODOS=PSSDUPD*PSSST
 ...S ^PSDRUG(PSSD,"DOS1",PSSTOT,0)=PSSDUPD_"^"_PSSTODOS_"^O",^PSDRUG(PSSD,"DOS1","B",PSSDUPD,PSSTOT)="" S PSSTOT=PSSTOT+1
 .I PSO,PSI D  S:PSSTOT>1 PSSTOTX=PSSTOT-1,^PSDRUG(PSSD,"DOS")=PSSST_"^"_PSSUN,PSSFLAG=1,^PSDRUG(PSSD,"DOS1",0)="^50.0903^"_$G(PSSTOTX)_"^"_$G(PSSTOTX)
 ..S PSSTOT=1 F PSSDUPD=0:0 S PSSDUPD=$O(^PS(50.606,"ADUPI",PSSDF,PSSDUPD)) Q:'PSSDUPD  D
 ...S PSSTODOS=PSSDUPD*PSSST
 ...S ^PSDRUG(PSSD,"DOS1",PSSTOT,0)=PSSDUPD_"^"_PSSTODOS S $P(^PSDRUG(PSSD,"DOS1",PSSTOT,0),"^",3)=$S($D(^PS(50.606,"ADUPO",PSSDF,PSSDUPD)):"IO",1:"I") S ^PSDRUG(PSSD,"DOS1","B",PSSDUPD,PSSTOT)="" S PSSTOT=PSSTOT+1
 .I PSO,PSI D  S:PSSTOT>1 PSSTOTX=PSSTOT-1,^PSDRUG(PSSD,"DOS")=PSSST_"^"_PSSUN,PSSFLAG=1,^PSDRUG(PSSD,"DOS1",0)="^50.0903^"_$G(PSSTOTX)_"^"_$G(PSSTOTX)
 ..F PSSDUPD=0:0 S PSSDUPD=$O(^PS(50.606,"ADUPO",PSSDF,PSSDUPD)) Q:'PSSDUPD  D
 ...I $D(^PS(50.606,"ADUPI",PSSDF,PSSDUPD)) Q
 ...S PSSTODOS=PSSDUPD*PSSST
 ...S ^PSDRUG(PSSD,"DOS1",PSSTOT,0)=PSSDUPD_"^"_PSSTODOS_"^O",^PSDRUG(PSSD,"DOS1","B",PSSDUPD,PSSTOT)="" S PSSTOT=PSSTOT+1
END ;
 S $P(^PS(59.7,PSSTRAC,80),"^",3)=3 D NOW^%DTC S $P(^PS(59.7,PSSTRAC,80),"^",5)=%
 S XMDUZ="PHARMACY DATA MANAGEMENT",XMY(PSSDUZ)="",XMSUB="PDM DOSAGE CONVERSION"
 K PSSDTEXT S PSSDTEXT(1)="The PDM Auto Create Dosages Job has run to completion.",PSSDTEXT(2)="Please use the Dosages Review Report to print out results."
 S XMTEXT="PSSDTEXT(" D ^XMD K PSSDTEXT,XMDUZ,XMY,XMSUB,XMTEXT
ENDX ;
 K %,PSSTODOS,PSSD,PSSBOTH,PSSFLAG,PSSND,PSSND1,PSSDF,PSSST,PSSUN,PSSFLAGZ,PSI,PSO,PSSTOT,PSSDUSP,PSSTOTX,PSSOI,PSSOID,PSDOD,PSNOUN,PSNOUNPA,PSALL,PSNOUNPT,PSSLTOT,PSSLTOTX,PSSTRAC,PSSTRACK,PSSOUT,PSSSTART,PSSSTOP,PSSWHO,PSSONLYO,PSSONLYI
 K PSSDUZ,PSSCLEAN S:$D(ZTQUEUED) ZTREQ="@"
 Q
LOCAL ;DO LOCAL POSSIBLE DOSES HERE
 K PSSOI,PSSOID,PSDOD,PSDUPDPT,PSNOUN,PSNOUNPT,PSNOUNPA,PSALL,PSSLTOT,PSSLTOTX
 S PSSOI=$P($G(^PSDRUG(PSSD,2)),"^") Q:'PSSOI
 S PSSOID=+$P($G(^PS(50.7,PSSOI,0)),"^",2) Q:'PSSOID
 Q:'$O(^PS(50.606,PSSOID,"NOUN",0))
 I $O(^PS(50.606,PSSOID,"DUPD",0)) D  S:PSSLTOT>1 PSSLTOTX=PSSLTOT-1,^PSDRUG(PSSD,"DOS2",0)="^50.0904^"_$G(PSSLTOTX)_"^"_$G(PSSLTOTX) Q
 .S PSSLTOT=1
 .F PSNOUN=0:0 S PSNOUN=$O(^PS(50.606,PSSOID,"NOUN",PSNOUN)) Q:'PSNOUN  S PSNOUNPT=$P($G(^(PSNOUN,0)),"^"),PSNOUNPA=$P($G(^(0)),"^",2) D:PSNOUNPT'=""
 ..Q:PSNOUNPA=""
 ..F PSDOD=0:0 S PSDOD=$O(^PS(50.606,PSSOID,"DUPD",PSDOD)) Q:'PSDOD  S PSDUPDPT=$P($G(^(PSDOD,0)),"^") D:PSDUPDPT'=""
 ...I $G(PSSONLYO),PSNOUNPA'["O" Q
 ...I $G(PSSONLYI),PSNOUNPA'["I" Q
 ...D TEST
 ...S PSALL=$G(PSDUPDPT)_" "_$S($G(PSSNLF):$G(PSSNLX),1:$G(PSNOUNPT)) K PSSNL,PSSNLF,PSSNLX
 ...S ^PSDRUG(PSSD,"DOS2",PSSLTOT,0)=$G(PSALL)_"^"_$G(PSNOUNPA),^PSDRUG(PSSD,"DOS2","B",$E(PSALL,1,30),PSSLTOT)="" S PSSLTOT=PSSLTOT+1
 S PSSLTOT=1 F PSNOUN=0:0 S PSNOUN=$O(^PS(50.606,PSSOID,"NOUN",PSNOUN)) Q:'PSNOUN  S PSNOUNPT=$P($G(^(PSNOUN,0)),"^"),PSNOUNPA=$P($G(^(0)),"^",2) D:PSNOUNPT'=""
 .Q:PSNOUNPA=""
 .I $G(PSSONLYI),PSNOUNPA'["I" Q
 .I $G(PSSONLYO),PSNOUNPA'["O" Q
 .S ^PSDRUG(PSSD,"DOS2",PSSLTOT,0)=PSNOUNPT_"^"_$G(PSNOUNPA),^PSDRUG(PSSD,"DOS2","B",$E(PSNOUNPT,1,30),PSSLTOT)="" S PSSLTOT=PSSLTOT+1
 I PSSLTOT>1 S PSSLTOTX=PSSLTOT-1 S ^PSDRUG(PSSD,"DOS2",0)="^50.0904^"_$G(PSSLTOTX)_"^"_$G(PSSLTOTX)
 Q
WHO ;
 K PSSWHOAR S DA=+$P($G(^PS(59.7,PSSTRAC,80)),"^",6),DIC=200,DR=".01",DIQ(0)="E",DIQ="PSSWHOAR" D EN^DIQ1 S PSSWHO=$G(PSSWHOAR(200,DA,.01,"E")) K DIQ,PSSWHOAR,DR,DA,DIC
 Q
TEST ;
 K PSSNL,PSSNLF,PSSNLX
 Q:$G(PSNOUNPT)=""
 Q:$L(PSNOUNPT)'>3
 S PSSNL=$E(PSNOUNPT,($L(PSNOUNPT)-2),$L(PSNOUNPT))
 I $G(PSSNL)="(S)"!($G(PSSNL)="(s)") S PSSNLF=1 D
 .I $G(PSDUPDPT)'>1 S PSSNLX=$E(PSNOUNPT,1,($L(PSNOUNPT)-3))
 .I $G(PSDUPDPT)>1 S PSSNLX=$E(PSNOUNPT,1,($L(PSNOUNPT)-3))_$E(PSSNL,2)
 Q
