PPPP37 ;BHM/DB - Correct Domain name enties ;6FEB03
 ;;V1.0;PHARMACY PRESCRIPTION PRACTICE;**37**;APR 7, 1995
 W @IOF,!!,"PPP DOMAIN NAME CONVERSION UTILITY",!!!,"Current Name",?40,"New Name ",! F X=1:1:(IOM-4) W "="
 S PPPIEN=0
1 S PPPIEN=$O(^PPP(1020.8,PPPIEN)) G 2:PPPIEN'>0 S PPPDOMNM=$P($G(^PPP(1020.8,PPPIEN,0)),"^",2) W !,$G(PPPDOMNM)
 K X1
 I $G(PPPDOMNM)[".MED" W ?40,"--" G 1
 I $G(PPPDOMNM)'="",PPPDOMNM'[".MED" S X1=$P(PPPDOMNM,".",1),X2=$P(PPPDOMNM,".",2,99)
 I $G(X1)="" G 1
 S X3=X1_".MED."_X2 W ?40,X3
 S $P(^PPP(1020.8,PPPIEN,0),"^",2)=X3
 G 1
2 ;re-index 'C' X-REF
 W !,"Re-indexing"
 K ^PPP(1020.8,"C") K DIK S DIK(1)=".02^C",DIK="^PPP(1020.8," D ENALL^DIK
 S PPPIEN=0 K ^PPP(1020.128,"A")
 W !,"Correcting entries in (#1020.128)"
3 S PPPIEN=$O(^PPP(1020.128,PPPIEN)) G DONE:PPPIEN'>0
 S PPPDOMNM=$P($G(^PPP(1020.128,PPPIEN,0)),"^",2)
 I $G(PPPDOMNM)[".MED" W ?40,"--" G 3
 I $G(PPPDOMNM)'="",PPPDOMNM'[".MED" S X1=$P(PPPDOMNM,".",1),X2=$P(PPPDOMNM,".",2,99),X3=X1_".MED."_X2 W !,PPPDOMNM,?40,X3 S $P(^PPP(1020.128,PPPIEN,0),"^",2)=X3
 G 3
DONE W !,"Re-indexing" K DIK S DIK(1)=".01^A",DIK="^PPP(1020.128," D ENALL^DIK K DIK
EXITQ K PPPDOMNM,PPPIEN,X,X1,X2,X3,Y Q
