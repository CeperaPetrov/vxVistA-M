HBHCADM ; LR VAMC(IRMS)/MJT-HBHC eval/adm data entry, obtain demographic info from ^DPT, verify patient D/C from last episode/care before creating episode, calls ACTION^HBHCUTL, BIRTHYR^HBHCUTL1, SEXRACE^HBHCUTL1 ; May 2000
 ;;1.0;HOSPITAL BASED HOME CARE;**2,6,8,16**;NOV 01, 1993
START ; Initialization
 S HBHCFORM=3
PROMPT ; Prompt user for patient name
 K DIC,HBHCFLG,HBHCPRCT S DIC="^HBHC(631,",DIC(0)="AELMQZ" D ^DIC
 G:Y=-1 EXIT
 S HBHCDFN=+Y,HBHCDPT=$P(Y,U,2),HBHCDPT0=^DPT(HBHCDPT,0)
 I $P(HBHCDPT0,U,9)'?9N W !!,"Patient has 'pseudo' social security number (SSN) on file.  If patient was",!,"not chosen in error, contact MAS to correct the invalid SSN.  Patient must",!,"have a valid SSN to be selected.",! H 3 G PROMPT
 S HBHCXMT3=$P($G(^HBHC(631,HBHCDFN,1)),U,17)
 I $P(^HBHC(631,HBHCDFN,0),U,40)]"" W *7,!!!,"***  Record contains Discharge data indicating a Complete Episode of Care  ***",!! H 3
 I (HBHCXMT3]"")&(HBHCXMT3'="N") D FORMMSG^HBHCUTL1 G:$D(HBHCNHSP) EXIT G:HBHCPRCT'=1 PROMPT
 I $P(Y,U,3) S $P(^HBHC(631,HBHCDFN,1),U,17)="N",^HBHC(631,"AE","N",HBHCDFN)="" S HBHCBXRF="" F  S HBHCBXRF=$O(^HBHC(631,"B",HBHCDPT,HBHCBXRF)) Q:(HBHCBXRF="")!(HBHCBXRF=HBHCDFN)  D CHECK
 G:$D(HBHCFLG) PROMPT
 D DEMO
 K DIE S DIE="^HBHC(631,",DA=HBHCDFN,DIE("NO^")="OUTOK"
 S DR="K HBHCQ;17;2:5;D BIRTHYR^HBHCUTL1;7;D SEXRACE^HBHCUTL1;10:13;14;D ACTION^HBHCUTL;15;16;I $D(HBHCQ) K HBHCQ S Y=37;18;68;19:36;37:38;67"
 L +^HBHC(631,HBHCDFN):0 I $T D ^DIE L -^HBHC(631,HBHCDFN) G PROMPT
 W *7,!!,"Another user is editing this entry.",!! G PROMPT
EXIT ; Exit module
 K DA,DIC,DIE,DIK,DR,HBHCAFLG,HBHCBXRF,HBHCCNTY,HBHCDFN,HBHCDPT,HBHCDPT0,HBHCEL,HBHCELGE,HBHCFLG,HBHCFORM,HBHCI,HBHCIEN,HBHCINFO,HBHCJ,HBHCMARE,HBHCMS,HBHCNHSP,HBHCPRCT,HBHCPS,HBHCPSRV,HBHCQ,HBHCRFLG,HBHCST,HBHCXMT3,HBHCWRD1
 K HBHCWRD2,HBHCWRD3,HBHCY0,HBHCZIP,X,Y
 Q
CHECK ; Check previous episode(s) of care for 'Reject' in Admit/Reject Action or Discharge Date to ensure completed episode of care before allowing another episode of care to be created
 Q:($P(^HBHC(631,HBHCBXRF,0),U,15)=2)!($P(^HBHC(631,HBHCBXRF,0),U,40)]"")
 W *7,!!,"Patient must be discharged from last episode of care before new episode",!,"can be entered.  Current episode not created.",! H 3
 K DIK S DIK="^HBHC(631,",DA=HBHCDFN D ^DIK
 S HBHCFLG=1
 Q
DEMO ; Obtain patient demographic info
 S (HBHCST,HBHCCNTY,HBHCZIP,HBHCEL,HBHCELGE,HBHCPS,HBHCPSRV,HBHCMS,HBHCMARE)=""
 I $D(^DPT(HBHCDPT,.11)) S HBHCINFO=^DPT(HBHCDPT,.11),HBHCCNTY=$P(HBHCINFO,U,7),HBHCZIP=$P(HBHCINFO,U,12),HBHCST=$P(HBHCINFO,U,5) I HBHCST]"" S HBHCIEN="" F  S HBHCIEN=$O(^HBHC(631.8,"B",HBHCST,HBHCIEN)) Q:HBHCIEN=""  S HBHCST=HBHCIEN
 I $D(^DPT(HBHCDPT,.36)) S HBHCEL=$P($G(^DIC(8,(+^DPT(HBHCDPT,.36)),0)),U,9),HBHCELGE=$S(HBHCEL=1:"01",HBHCEL=2:"02",HBHCEL=15:"02",HBHCEL=3:"03",HBHCEL=4:"04",1:"05")
 I $D(^DPT(HBHCDPT,.32)) S HBHCINFO=^DPT(HBHCDPT,.32),HBHCPS=$P(HBHCINFO,U,3),HBHCPSRV=$S(((HBHCPS>0)&(HBHCPS<9)):HBHCPS,HBHCPS=9:10,HBHCPS=121:11,1:"")
 S HBHCINFO=^DPT(HBHCDPT,0),HBHCMS=$P(HBHCINFO,U,5),HBHCMARE=$S(HBHCMS=1:4,HBHCMS=2:1,HBHCMS=4:2,HBHCMS=5:3,HBHCMS=6:5,1:"")
 I HBHCST]"" S:($P(Y(0),U,3)="")&($D(^HBHC(631.8,HBHCST,0))) $P(^HBHC(631,HBHCDFN,0),U,3)=HBHCST I (HBHCCNTY]"")&($P(Y(0),U,4)="") S:$D(^HBHC(631.8,HBHCST,0)) $P(^HBHC(631,HBHCDFN,0),U,4)=HBHCCNTY
 S:(HBHCZIP]"")&(($P(Y(0),U,5)="")!($P(Y(0),U,5)'?9N)) $P(^HBHC(631,HBHCDFN,0),U,5)=HBHCZIP
 S:(HBHCELGE]"")&($P(Y(0),U,6)="") $P(^HBHC(631,HBHCDFN,0),U,6)=HBHCELGE
 S:(HBHCPSRV]"")&($P(Y(0),U,8)="") $P(^HBHC(631,HBHCDFN,0),U,8)=HBHCPSRV
 S:(HBHCMARE]"")&($P(Y(0),U,11)="") $P(^HBHC(631,HBHCDFN,0),U,11)=HBHCMARE
 Q
