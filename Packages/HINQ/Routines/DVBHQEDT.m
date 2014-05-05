DVBHQEDT ;ALB/JLU -THIS ROUTINE CHECKS THE ONE MANY ALL INPUT FOR HINQ SCREENS. ;3/19/90
 ;;4.0;HINQ;**6,49**;03/25/92 
A ;ENTRY POINT FROM TEMPLATE DVBHINQEDT
 S ERROR=0,Z="" K Z2,Z3
 I "Aa"[ANS D L3 Q
 I ANS'?.NP S ERROR=1 D ERR Q
 I +ANS>$E(DVBJS,2) S ERROR=1 D ERR Q
 I (ANS?1N)!(ANS?1N1",") S Z=$P(ANS,",")_"^" D EX Q
 I ANS?1N1"-"1N D L0,EX:'ERROR,ERR:ERROR Q
 F Z0=1:2:$L(ANS) S Z1=$E(ANS,Z0,Z0),Z2=$E(ANS,Z0+1,Z0+1) D L1 Q:ERROR!(Z2="")
 I 'ERROR F Z4=0:0 S Z4=$O(Z3(Z4)) Q:'Z4  S Z=Z_Z4_"^"
 I ANS=0 F Z1=1:1:$E(DVBJS,2) S Z=Z_Z1_"^" W Z
 D ERR:ERROR Q
EX I $E(Z,$L(Z)-1,$L(Z)-1)>$E(DVBJS,2) W !,"Number too large for selectable numbers." S ERROR=1 D ERR Q
 Q
ERR W !!,*7,?9,"Check boundaries and/or syntax and try again.",!,?9,"Use '?' if still having problems OK!!   <RET>" R DVBZ:DTIME K DVBZ Q
 ;
L0 I $P(ANS,"-",2)>$P(ANS,"-") F Z1=$P(ANS,"-"):1:$P(ANS,"-",2) S Z=Z_Z1_"^"
 E  S ERROR=1 Q
 D ERR:ERROR K Z1 Q
L1 I Z1'?1N,Z0=1 S ERROR=1 Q
 I (Z1?1N),((Z2=",")!(Z2="")) S Z3(Z1)="" Q
 I Z1?1N,Z2="-" D L2 Q
 Q
L2 I Z1>$E(ANS,Z0+2,Z0+2) S ERROR=1 Q
 I $E(ANS,Z0+3,Z0+3)'=",",($E(ANS,Z0+3,Z0+3)'="") S ERROR=1 Q
 F Z4=Z1:1:$E(ANS,Z0+2,Z0+2) S Z3(Z4)=""
 S Z0=Z0+2
 Q
L3 F Z1=1:1:$E(DVBJS,2) S Z=Z_Z1_"^"
 Q
 ;
B ;THIS IS THE ENTRY POINT FOR THE HELP SCREEN IN THE HINQ UPLOAD.
 W @$S('$D(IOF):"#",IOF="":"#",1:IOF)
 W !,?25,DVBON,"HINQ Help Screen",DVBOFF
 W !!,?5,DVBON,"<RET>",DVBOFF,"  press return to continue on to the next display screen.",!!,?6,DVBON,"'^'",DVBOFF,"   use the up arrow to get out of the upload mode."
 W !!,?14,"To upload you have a choice of ONE, MANY, or ALL."
 W !!,?27,DVBON,"N",DVBOFF,"     for a single selection.",!,?27,DVBON,"N,N,N",DVBOFF," for specific fields.",!,?27,DVBON,"N-N",DVBOFF,"   for a range of fields."
 W !,?27,DVBON,"A",DVBOFF,"     for the entire screen."
 W !!,?8,"Except for the first screen which is the verification screen,"
 W !,?8,"highlighted numbers in ",DVBON,"[]",DVBOFF," can be uploaded where as highlighted"
 W !,?8,"numbers in ",DVBON,"<>",DVBOFF," can not."
 W !!,?8,"Screen jumping is also allowed to some extent.  You are able"
 W !,?8,"to jump from any one of the three screens except from 3 to any"
 W !,?8,"of the others.  1->2  1->3    2->1  2->3  but not 3->N"
 W !,?8,"The correct format is ^N (Ex. to go from 2 to 1   ^1)"
 W !!,?20,"<Press return to continue.>"
 Q
KA1 K JU,J,JZ,K1,K2,L,L1,X,XX,Y,Z,DFN,DGEDCN,DI,DVBJ2,DVBOFF,DVBON,DVBOUT,I,D0,DVBJA,DVB8,DVB9,ERROR,Y1,DVBY,DVBJ1,ZTSK,DVBLIT,DVBENT,DVBLP,DVBMM,DVBUQ,DVBLIT1,DVBLIT2,DVBS,DVBBLF,DVBBLO,DVBDIQ,DVBX,DVBSCRN
 K DVBI,DVBUSER,N,O,R,R1,Y0,ANS
KA K DVBERR,DVBERR1,DVBIXMZ,DVBNETER,DVBOTM,DVBOXMZ,DVBREQST,DVBREQUE,DVBV,DVBAAHB,DVBADR,DVBADRLN,DVBASVC,DVBBOS,DVBCHDOB,DVBCHECK,DVBCHILD,DVBCHNO,DVBCI,DVBCN,DVBCPS,DVBCSVC,DVBDOB,DVBDX,DVBDXNO,DVBDXPCT,DVBDXSC,DVBDXX,DVBENT
 K DVBEI,DVBEINC,DVBEOD,DVBFIDUC,DVBFL,DVBINC,DVBEOD,DVBLEN,DVBNAME,DVBOINC,DVBP,DVBPOW,DVBPTI,DVBRAD,DVBRETO,DVBRETT,DVBRTYP,DVBRTYPE,DVBSPDOB,DVBSPENC,DVBSPETO,DVBSPINC,DVBSPNAM,DVBSPRET,DVBSPSSA,DVBSSA,DVBZIP,DVBSN
 K DVBPOA,DVBPAT,DVBCAP,DVBBOSRC,DVBCSVC,DVBCSVCN,DVBEODN,DVBNMREC,DVBPNAM,DVBPOWD,DVBRADN,DVBSNREC,DVBSSN,DVBTOTAS,DXS,DVBJS,JL,JU,DIC,DIE,DR,DVB,DVB1,ZTRTN,ZTDESC,ZTIO,POP,DIR,ZTSAVE,DVBJC,JP,Z1,Z2,DVB4,DVB5,DVB6,DVB7,DVBOH
 K DIQ,DIQ2,DVBADD,DVBBAS,DVBBIR,DVBCHI,DVBDBE,DVBSSAJ,DVBDBF,DVBDIA,DVBFUE,DVBFUF,DVBMM2,DVBMON,DVBREF,DVBV1,DVBV2,DVBVET,DVBWIT,LP,LX,LY,LP1,LP2,DVBSEX
 Q
DX ;left to ensure no error
 Q