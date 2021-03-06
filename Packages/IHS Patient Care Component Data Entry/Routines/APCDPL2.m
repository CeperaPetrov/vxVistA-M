APCDPL2 ; IHS/CMI/TUCSON - NO DESCRIPTION PROVIDED ; [ 08/19/02  8:22 AM ]
 ;;2.0;IHS RPMS/PCC Data Entry;**5**;MAR 09, 1999
 ;
NO1 ;EP
 W:$D(IOF) @IOF
 W !!,"Adding a Note to the following problem on ",$P($P(^DPT(DFN,0),U),",",2)," ",$P($P(^(0),U),","),"'s Problem List.",!
 S (X,D)=0 F  S X=$O(^TMP($J,"APCDPL","IDX",X)) Q:X'=+X!D  S Y=$O(^TMP($J,"APCDPL","IDX",X,0)) S:Y>APCDPIEN D=1 I ^TMP($J,"APCDPL","IDX",X,Y)=APCDPIEN W !,^TMP($J,"APCDPL",X,0)
 I $O(^AUPNPROB(APCDPIEN,11,0)) D
 .W !!?6,IORVON,"Problem Notes:  ",IORVOFF S L=0 F  S L=$O(^AUPNPROB(APCDPIEN,11,L)) Q:L'=+L  I $O(^AUPNPROB(APCDPIEN,11,L,11,0)) W !?6,$P(^DIC(4,$P(^AUPNPROB(APCDPIEN,11,L,0),U),0),U) D
 ..S X=0 F  S X=$O(^AUPNPROB(APCDPIEN,11,L,11,X)) Q:X'=+X  W !?8,"Note#",$P(^AUPNPROB(APCDPIEN,11,L,11,X,0),U)," ",$$FMTE^XLFDT($P(^(0),U,5),5),?30,$P(^AUPNPROB(APCDPIEN,11,L,11,X,0),U,3)
 W ! S DIR(0)="Y",DIR("A")="Add a new Problem Note for this Problem",DIR("B")="Y" K DA D ^DIR K DIR
 G:$D(DIRUT) NOX
 G:Y=0 NOX
NUM ;
 ;add location multiple if necessary, otherwise get ien in multiple
 S APCDNIEN=$O(^AUPNPROB(APCDPIEN,11,"B",$S($G(APCDLOC):APCDLOC,1:DUZ(2)),0))
 I APCDNIEN="" S DIADD=9000011.11,X="`"_$S($G(APCDLOC):APCDLOC,1:DUZ(2)),DIC="^AUPNPROB("_APCDPIEN_",11,",DA(1)=APCDPIEN,DIC(0)="L",DIC("P")=$P(^DD(9000011,1101,0),U,2) D
 .D ^DIC K DIC,DA,DR,Y,DIADD,X S APCDNIEN=$O(^AUPNPROB(APCDPIEN,11,"B",$S($G(APCDLOC):APCDLOC,1:DUZ(2)),0))
 I APCDNIEN="" W $C(7),$C(7),"ERROR UPDATING NOTE LOCATION MULTIPLE" G NOX
 S (Y,X)=0 F  S Y=$O(^AUPNPROB(APCDPIEN,11,APCDNIEN,11,"B",Y)) S:Y X=Y I 'Y S X=X+1 K Y Q
 S APCDNUM=X
 W !!,"Adding Note #",X
 K DIC S X=APCDNUM,DA(1)=APCDNIEN,DA(2)=APCDPIEN,DIC="^AUPNPROB("_APCDPIEN_",11,"_APCDNIEN_",11,",DIC("P")=$P(^DD(9000011.11,1101,0),U,2),DIC(0)="L" D ^DIC K DA,DR,DIADD,DLAYGO,DD,DO,D0
 I Y=-1 W !!,$C(7),$C(7),"ERROR when updating note number multiple",! G NOX
 S DIE=DIC K DIC W ?8 S DA=+Y,DR=".03;.05////"_$S($G(APCDDATE)]"":$P(APCDDATE,"."),1:DT) D ^DIE K DIE,DR,DA,Y W !!
 D ^XBFMK
 K DIADD
 G NO1
NOX ;
 K Y,APCDPIEN,X,L,APCDNUM,APCDL,DIC,DA,DD,APCDC,APCDN,APCDNIEN,DR,DIADD
 Q
RNO1 ;EP - called from APCDPL1 - remove a note
 W:$D(IOF) @IOF
 K APCDN,APCDL,APCDX,APCDC
 W !!,"Removing a Note from the following problem on ",$P($P(^DPT(DFN,0),U),",",2)," ",$P($P(^(0),U),","),"'s Problem List.",!
 S (X,D)=0 F  S X=$O(^TMP($J,"APCDPL","IDX",X)) Q:X'=+X!D  S Y=$O(^TMP($J,"APCDPL","IDX",X,0)) S:Y>APCDPIEN D=1 I ^TMP($J,"APCDPL","IDX",X,Y)=APCDPIEN W !,^TMP($J,"APCDPL",X,0)
 S APCDC=0 I $O(^AUPNPROB(APCDPIEN,11,0)) D
 .W !!?6,IORVON,"Problem Notes:  ",IORVOFF S (APCDC,APCDL)=0 F  S APCDL=$O(^AUPNPROB(APCDPIEN,11,APCDL)) Q:APCDL'=+APCDL  I $O(^AUPNPROB(APCDPIEN,11,APCDL,11,0)) W !?6,$P(^DIC(4,$P(^AUPNPROB(APCDPIEN,11,APCDL,0),U),0),U) D
 ..S APCDX=0 F  S APCDX=$O(^AUPNPROB(APCDPIEN,11,APCDL,11,APCDX)) Q:APCDX'=+APCDX  D
  ...S APCDC=APCDC+1,APCDN(APCDC)=APCDL_U_APCDX W !?8,APCDC,")  Note#",$P(^AUPNPROB(APCDPIEN,11,APCDL,11,APCDX,0),U)," ",$$FMTE^XLFDT($P(^(0),U,5),5),?30,$P(^AUPNPROB(APCDPIEN,11,APCDL,11,APCDX,0),U,3)
 I APCDC=0 W !?8,"No note on file for this problem" G RNO1X
 W ! K DIR S DIR(0)="N^1:"_APCDC_":",DIR("A")="Remove which one" D ^DIR K DIR S:$D(DUOUT) DIRUT=1
 I $D(DIRUT) W !,"Okay, bye." G RNO1X
 I 'Y W !,"No Note selected"  G RNO1X
 S APCDY=+Y
RSURE ;
 W !! S DIR(0)="Y",DIR("A")="Are you sure you want to delete this NOTE",DIR("B")="N" D ^DIR K DIR S:$D(DUOUT) DIRUT=1
 I $D(DIRUT) W !,"okay, not deleted." G RNO1X
 I 'Y W !,"Okay, not deleted." G RNO1X
 S DA(1)=$P(APCDN(APCDY),U),DA(2)=APCDPIEN,DIE="^AUPNPROB("_APCDPIEN_",11,"_$P(APCDN(APCDY),U)_",11,",DIC("P")=$P(^DD(9000011.11,1101,0),U,2)
 S DA=$P(APCDN(APCDY),U,2),DR=".01///@" D ^DIE K DIE,DR,DA,Y W !!
RNO1X ;xit
 K APCDPIEN,APCDL,APCDX,APCDN,APCDY
 Q
MN1 ;EP - called to modify a note
 W:$D(IOF) @IOF
 K APCDN,APCDL,APCDX,APCDC
 W !!,"Editing a Note on the following problem on ",$P($P(^DPT(DFN,0),U),",",2)," ",$P($P(^(0),U),","),"'s Problem List.",!
 S (X,D)=0 F  S X=$O(^TMP($J,"APCDPL","IDX",X)) Q:X'=+X!D  S Y=$O(^TMP($J,"APCDPL","IDX",X,0)) S:Y>APCDPIEN D=1 I ^TMP($J,"APCDPL","IDX",X,Y)=APCDPIEN W !,^TMP($J,"APCDPL",X,0)
 S APCDC=0 I $O(^AUPNPROB(APCDPIEN,11,0)) D
 .W !!?6,IORVON,"Problem Notes:  ",IORVOFF S (APCDC,APCDL)=0 F  S APCDL=$O(^AUPNPROB(APCDPIEN,11,APCDL)) Q:APCDL'=+APCDL  I $O(^AUPNPROB(APCDPIEN,11,APCDL,11,0)) W !?6,$P(^DIC(4,$P(^AUPNPROB(APCDPIEN,11,APCDL,0),U),0),U) D
 ..S APCDX=0 F  S APCDX=$O(^AUPNPROB(APCDPIEN,11,APCDL,11,APCDX)) Q:APCDX'=+APCDX  D
  ...S APCDC=APCDC+1,APCDN(APCDC)=APCDL_U_APCDX W !?8,APCDC,")  Note#",$P(^AUPNPROB(APCDPIEN,11,APCDL,11,APCDX,0),U)," ",$$FMTE^XLFDT($P(^(0),U,5),5),?30,$P(^AUPNPROB(APCDPIEN,11,APCDL,11,APCDX,0),U,3)
 I APCDC=0 W !?8,"No notes on file for this problem" G RNO1X
 W ! K DIR S DIR(0)="N^1:"_APCDC_":",DIR("A")="Edit which one" D ^DIR K DIR S:$D(DUOUT) DIRUT=1
 I $D(DIRUT) W !,"Okay, bye." G RNO1X
 I 'Y W !,"No Note selected"  G RNO1X
 S APCDY=+Y
MSURE ;
 S DA(1)=$P(APCDN(APCDY),U),DA(2)=APCDPIEN,DIE="^AUPNPROB("_APCDPIEN_",11,"_$P(APCDN(APCDY),U)_",11,",DIC("P")=$P(^DD(9000011.11,1101,0),U,2)
 S DA=$P(APCDN(APCDY),U,2),DR=".01;.03" D ^DIE K DIE,DR,DA,Y W !!
MNO1X ;
 K APCDPIEN,APCDL,APCDX,APCDN,APCDY
 Q
