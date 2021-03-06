XBFUNC1 ; IHS/ADC/GTH - FUNCTION LIBRARY CONTINUED ; [ 02/07/97   3:02 PM ]
 ;;3.0;IHS/VA UTILITIES;;FEB 07, 1997
 ;
PROVCLS(PROV,FORM) ;PEP - Retrieve Provider Class from New Person File
 I $G(PROV)="" Q ""
 I '$D(^VA(200,PROV)) Q ""
 NEW X,Z,Y,CLS,DIC,DR,DA,DIQ
 S DIC=200,DR="53.5",DA=PROV,DIQ="CLS"
 S:$G(FORM)="I" DIQ(0)="I"
 D ENDIQ1
 S CLS=$S($G(FORM)="I":CLS(200,PROV,"53.5","I"),1:CLS(200,PROV,"53.5"))
 Q $S(CLS="":"UNKNOWN",1:CLS)
 ;
PROVCLSC(PROV) ;PEP - Retrieve Provider Class Code given New Person File IEN
 I $G(PROV)="" Q ""
 I '$D(^VA(200,PROV)) Q ""
 NEW X,Z,Y,CODE,DIC,DR,DA,DIQ,CLASS
 S CLASS=$$PROVCLS^XBFUNC1(PROV,"I")
 I CLASS="UNKNOWN" Q "UNKNOWN"
 S DIC=7,DR="9999999.01",DA=CLASS,DIQ="CODE"
 D ENDIQ1
 S CODE=CODE(7,CLASS,"9999999.01")
 Q $S(CODE="":"UNKNOWN",1:CODE)
 ;
PROVAFFL(PROV,FORM) ;PEP - Retrieve provider affiliation in int or ext format
 I $G(PROV)="" Q ""
 I '$D(^VA(200,PROV)) Q ""
 NEW X,Z,Y,AFFL,DIC,DR,DA,DIQ
 S DIC=200,DR="9999999.01",DA=PROV,DIQ="AFFL"
 S:$G(FORM)="I" DIQ(0)="I"
 D ENDIQ1
 S AFFL=$S($G(FORM)="I":AFFL(200,PROV,"9999999.01","I"),1:AFFL(200,PROV,"9999999.01"))
 Q AFFL
 ;
PROVCODE(PROV) ;PEP - Retrieve provider code
 I $G(PROV)="" Q ""
 I '$D(^VA(200,PROV)) Q ""
 NEW X,Z,Y,CODE,DIC,DR,DA,DIQ
 S DIC=200,DR="9999999.02",DA=PROV,DIQ="CODE",DIQ(0)="E"
 D ENDIQ1
 Q CODE(200,PROV,"9999999.02","E")
 ;
PROVINI(PROV) ;PEP - Retrieve provider initials
 I '$G(PROV) Q ""
 I '$D(^VA(200,PROV)) Q ""
 NEW X,Z,Y,INIT,DIC,DR,DA,DIQ
 S DIC=200,DR="1",DA=PROV,DIQ="INIT",DIQ(0)="E"
 D ENDIQ1
 Q INIT(200,PROV,"1","E")
 ;
ENDIQ1 ;
 NEW CLASS,FORM,PROV,X,Y,Z
 D EN^DIQ1
 Q
 ;
