ONCFUNC ;Hines OIFO/GWB - ONCOLOGY FUNCTIONS ;05/26/00
 ;;2.11;ONCOLOGY;**24,25,26,27,28,30,32,33,35,36,41**;Mar 07, 1995
 ;
SHN() ;STATE HOSPITAL NUMBER (160.1,1.03)
 N OSP
 S OSP=$O(^ONCO(160.1,"C",DUZ(2),0))
 I OSP="" S OSP=$O(^ONCO(160.1,0))
 S SHN=$$GET1^DIQ(160.1,OSP,1.03,"I")
 Q SHN
IIN() ;INSTITUTION ID NUMBER (160.1,27)
 N OSP
 S OSP=$O(^ONCO(160.1,"C",DUZ(2),0))
 I OSP="" S OSP=$O(^ONCO(160.1,0))
 S IIN=$$GET1^DIQ(160.1,OSP,27,"I")
 S IIN=$$GET1^DIQ(160.19,IIN,.01,"I")
 Q IIN
FLNAME(NAME) ;
 S TNAME=NAME,DFN=D0
 D NAME^VAFCPID2(DFN,.TNAME,0)
 ; make sure 3rd parameter in above call is 0 or it will update ^DPT(DFN
 ; put name in format LAST,FIRST MIDDLE SUFFIX
 S LAST=$P(TNAME,","),TNAME=$P(TNAME,",",2)
 S FIRST=$P(TNAME," "),MIDDLE=$P(TNAME," ",2)
 S SUFFIX=$P(TNAME," ",3)
 I MIDDLE["""" S MIDDLE=""
 S TNAME=FIRST_" "_MIDDLE_" "_LAST_" "_SUFFIX
SP I $F(TNAME,"  ") S PL=$F(TNAME,"  "),TNAME=$E(TNAME,1,PL-2)_$E(TNAME,PL,$L(TNAME)) G SP
 Q TNAME
DIV(IEN) ;DIVISION (165.5,2000)
 N DIV
 S DIV=$G(^ONCO(165.5,IEN,"DIV"))
 Q DIV
 ;
SUSDIV(IEN,SUSIEN) ;DIVISION (160,30)
 N DIV
 S DIV=$P($G(^ONCO(160,IEN,"SUS",SUSIEN,0)),U,4)
 Q DIV
 ;
PFTD(IEN) ;Primaries for this division
 N PFTD
 S PFTD="N"
 S PRI=0 F  S PRI=$O(^ONCO(165.5,"C",IEN,PRI)) Q:PRI'>0  I $P($G(^ONCO(165.5,PRI,"DIV")),U,1)=DUZ(2) S PFTD="Y"
 Q PFTD
 ;
PRICNT ;TOTAL PRIMARIES FOR PATIENT (160,17)
 S PRI=0,PRICNT=0 F  S PRI=$O(^ONCO(165.5,"C",D0,PRI)) Q:PRI'>0  I $P($G(^ONCO(165.5,PRI,"DIV")),U,1)=DUZ(2) D
 .S PRICNT=PRICNT+1
 S X=PRICNT K PRI,PRICNT
 Q
 ;
DIDIV(IEN) ;Disease Index Division screen
 N DIVMATCH
 S DIVMATCH="N"
 S VIPNT=$P($G(^AUPNVPOV(D0,0)),U,3) G:VIPNT="" DIDIVEX
 S HLPNT=$P($G(^AUPNVSIT(VIPNT,0)),U,22) G:HLPNT="" DIDIVEX
 S MCPNT=$P($G(^SC(HLPNT,0)),U,15) G:MCPNT="" DIDIVEX
 S INPNT=$P($G(^DG(40.8,MCPNT,0)),U,7)
 I (INPNT=DUZ(2))!(AFLDIV[INPNT) S DIVMATCH="Y"
DIDIVEX K VIPNT,HLPNT,MCPNT,INPNT
 Q DIVMATCH
 ;
HIST(IEN) ;Histology ICD-O-2 (165.5,22) or Histology ICD-O-3 (165.5,22.3)
 S ONCDTDX=$P($G(^ONCO(165.5,IEN,0)),U,16)
 S ICDNUM=3 I ONCDTDX<3010000 S ICDNUM=2
 S HNODE=$S(ICDNUM=3:2.2,1:2),ICDFILE=$S(ICDNUM=3:169.3,1:164.1)
 S HSTFLD=$S(ICDNUM=3:22.3,1:22)
 S HISTICD=$P($G(^ONCO(165.5,IEN,HNODE)),U,3)
 S HISTNAM=""
 I HISTICD'="" S HISTNAM=$P($G(^ONCO(ICDFILE,HISTICD,0)),U,1)
 Q HISTICD
 ;
LYMPHOMA(IEN) ;Hodgkin and Non-Hodgin Lymphomas
 N LYMPHOMA
 S LYMPHOMA=0
 S HSTICD=$$HIST^ONCFUNC(IEN)
 S HST123=$E(HSTICD,1,3)
 I ONCDTDX<3010000,(HST123>958)&(HST123<972) S LYMPHOMA=1
 I ONCDTDX>3001231,(HST123>958)&(HST123<973) S LYMPHOMA=1
 K HSTICD,HST123,ONCDTDX
 Q LYMPHOMA
 ;
CC ;COMORBIDITY/COMPLICATION #1-6 screen
 I $E($P(^ICD9(Y,0),U,1),1)="V",+($E($P(^ICD9(Y,0),U,1),2,9)>7.1)&+($E($P(^ICD9(Y,0),U,1),2,9)<7.4) Q 
 I $E($P(^ICD9(Y,0),U,1),1)="V",+($E($P(^ICD9(Y,0),U,1),2,9)>9.91)&+($E($P(^ICD9(Y,0),U,1),2,9)<16) Q 
 I $E($P(^ICD9(Y,0),U,1),1)="V",+($E($P(^ICD9(Y,0),U,1),2,9)>21.9)&+($E($P(^ICD9(Y,0),U,1),2,9)<23.2) Q 
 I $E($P(^ICD9(Y,0),U,1),1)="V",+($E($P(^ICD9(Y,0),U,1),2,9)>25.3)&+($E($P(^ICD9(Y,0),U,1),2,9)<25.5) Q 
 I $E($P(^ICD9(Y,0),U,1),1)="V",+($E($P(^ICD9(Y,0),U,1),2,9)>43.89)&+($E($P(^ICD9(Y,0),U,1),2,9)<46) Q 
 I $E($P(^ICD9(Y,0),U,1),1)="V",+($E($P(^ICD9(Y,0),U,1),2,9)>50.4)&+($E($P(^ICD9(Y,0),U,1),2,9)<50.8) Q 
 I $E($P(^ICD9(Y,0),U,1),1)'="V",$E($P(^ICD9(Y,0),U,1),1)="E",($E($P(^ICD9(Y,0),U,1),2,9)>869.9)&($E($P(^ICD9(Y,0),U,1),2,9)<880) Q 
 I $E($P(^ICD9(Y,0),U,1),1)'="V",$E($P(^ICD9(Y,0),U,1),1)="E",($E($P(^ICD9(Y,0),U,1),2,9)>929.9)&($E($P(^ICD9(Y,0),U,1),2,9)<950) Q 
 I $E($P(^ICD9(Y,0),U,1),1)'="V",$E($P(^ICD9(Y,0),U,1),1)'="E",($P(^ICD9(Y,0),U,1)<140)!($P(^ICD9(Y,0),U,1)>239.9) Q
 Q
 ;
DSTS(IEN) ;DATE SYSTEMIC THERAPY STARTED
 N X
 S X=$$GET1^DIQ(165.5,IEN,53,"I") I X'="" S DSTSDT(X)=""
 S X=$$GET1^DIQ(165.5,IEN,54,"I") I X'="" S DSTSDT(X)=""
 S X=$$GET1^DIQ(165.5,IEN,55,"I") I X'="" S DSTSDT(X)=""
 S DSTS=$O(DSTSDT(0))
 S X=$$DATE^ONCACDU1(DSTS)
 K DSTSDT,DSTS
 Q X
