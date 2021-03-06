XBFIXPT ; IHS/ADC/GTH - FIX ALL "PT" NODES ; [ 11/04/97  10:26 AM ]
 ;;3.0;IHS/VA UTILITIES;**5**;FEB 07, 1997
 ; XB*3*5 IHS/ADC/GTH 10-31-97 Prevent UNDEF if ^DD entry incorrect.
 ;
 ; This routine fixes all "PT" nodes for files 1 through the
 ; highest file number in the current UCI.
 ;
START ;
 W:'$D(XBFIXPT("NOTALK")) !!,"This routine insures the ""PT"" node of each FileMan file is correct.",!
 W:'$D(XBFIXPT("NOTALK")) !!,"Now checking false positives.",!
 S U="^"
 S XBFFILE=.99999999
 F XBFL=0:0 S XBFFILE=$O(^DD(XBFFILE)) Q:XBFFILE'=+XBFFILE  I $D(^DD(XBFFILE,0,"PT")) W:'$D(XBFIXPT("NOTALK")) !,XBFFILE D FPOS
 W:'$D(XBFIXPT("NOTALK")) !!,"Now checking false negatives.",!
 D FNEG
 KILL XBFFILE,XBFL
 W:'$D(XBFIXPT("NOTALK")) !!,"DONE",!
 Q
 ;
FPOS ; CHECK FOR FALSE POSITIVES
 S XBFPFILE=""
 F XBFL=0:0 S XBFPFILE=$O(^DD(XBFFILE,0,"PT",XBFPFILE)) Q:XBFPFILE=""  S XBFPFLD="" F XBFL=0:0 S XBFPFLD=$O(^DD(XBFFILE,0,"PT",XBFPFILE,XBFPFLD)) Q:XBFPFLD=""  D CHKIT
 KILL XBFPFILE,XBFPFLD,XBFX
 Q
 ;
CHKIT ;
 W:'$D(XBFIXPT("NOTALK")) "."
 I '$D(^DD(XBFPFILE)) W:'$D(XBFIXPT("NOTALK")) "|" KILL ^DD(XBFFILE,0,"PT",XBFPFILE) Q
 ; I '$D(^DD(XBFPFILE,XBFPFLD)) W:'$D(XBFIXPT("NOTALK")) "|" KILL ^DD(XBFFILE,0,"PT",XBFPFILE,XBFPFLD) Q  ; XB*3*5 IHS/ADC/GTH 10-31-97 Prevent UNDEF if ^DD entry incorrect.
 I '$D(^DD(XBFPFILE,XBFPFLD,0)) W:'$D(XBFIXPT("NOTALK")) "|" KILL ^DD(XBFFILE,0,"PT",XBFPFILE,XBFPFLD) Q  ; XB*3*5 IHS/ADC/GTH 10-31-97 Prevent UNDEF if ^DD entry incorrect.
 S XBFX=$P(^DD(XBFPFILE,XBFPFLD,0),U,2)
 I XBFX["P",XBFX[XBFFILE Q
 I XBFX["V",$D(^DD(XBFPFILE,XBFPFLD,"V","B",XBFFILE)) Q
 W:'$D(XBFIXPT("NOTALK")) "|"
 KILL ^DD(XBFFILE,0,"PT",XBFPFILE,XBFPFLD)
 Q
 ;
FNEG ; CHECK FOR FALSE NEGATIVES
 S XBFFILE=.99999999
 F XBFL=0:0 S XBFFILE=$O(^DD(XBFFILE)) Q:XBFFILE'=+XBFFILE  W:'$D(XBFIXPT("NOTALK")) !,XBFFILE S XBFFLD=0 F XBFL=0:0 S XBFFLD=$O(^DD(XBFFILE,XBFFLD)) Q:XBFFLD'=+XBFFLD  D:$D(^(XBFFLD,0))#2 PTRCHK
 KILL XBFFILE,XBFFLD,XBFX,XBFI
 Q
 ;
PTRCHK ;
 S XBFX=$P(^DD(XBFFILE,XBFFLD,0),U,2)
 I XBFX["V" D PTRCHK2 Q
 Q:XBFX'["P"
 F XBFI=1:1:$L(XBFX)+1 Q:$E(XBFX,XBFI)?1N
 Q:XBFI>$L(XBFX)
 S XBFX=$E(XBFX,XBFI,999),XBFX=+XBFX
 Q:'XBFX
 Q:XBFX<1  ;*** DOES NOT MESS WITH FILE NUMBERS < 1 ***
 W:'$D(XBFIXPT("NOTALK")) "."
 Q:'$D(^DIC(XBFX))
 Q:'$D(^DD(XBFX,0))
 I '$D(^DD(XBFX,0,"PT",XBFFILE,XBFFLD)) W "|" S ^(XBFFLD)=""
 Q
 ;
PTRCHK2 ; VARIABLE POINTER CHECK
 S XBFX=""
 F XBFL=0:0 S XBFX=$O(^DD(XBFFILE,XBFFLD,"V","B",XBFX)) Q:XBFX=""  I '$D(^DD(XBFX,0,"PT",XBFFILE,XBFFLD)) W:'$D(XBFIXPT("NOTALK")) "|" S ^(XBFFLD)=""
 Q
 ;
