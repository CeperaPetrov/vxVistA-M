XBDH ; IHS/ADC/GTH - HEADER EDITOR MAIN ROUTINE ; [ 02/07/97   3:02 PM ]
 ;;3.0;IHS/VA UTILITIES;;FEB 07, 1997
 ;
 ; Thanks to Dr. Dave Grau, OHPRD/TUCSON, for the original
 ; routine.
 ;
 ; THIS ROUTINE IS DEDICATED TO MY FRIEND AND MENTOR,
 ; KEN FLESHMAN M.D.
 ;
 ; Version 11.1 is dedicated to Maureen Hoye and Tami Winn
 ; who made it possible to create a "legal", distributable
 ; package.  Sincere thanks!!!
 ;
VAR ;
 NEW XBDHMORE,DHD,V,X,Y,XBDHPDFN,XBDHPDNA,XBDHTHLW,XBDHL,XBDHI,%Y,%,A,C,Z,I,XBDHMFLG,XBDHWOFF
 KILL ^TMP("XBDH",$J)
 I '$D(DUZ) W !!,"KERNEL VARIABLES REQUIRED",!!,*7 G EXIT
 KILL:'$D(XBDHDATA) ^TMP("XBDH",$J)
 I $P($T(+2^DI),";",3)<17.77 W !!,"SORRY... THIS ROUTINE IS NOT COMPATABLE WITH YOUR VERSION OF FILEMAN" G EXIT
 S XBDHWOFF=""
 F %=2,8,15,16 I ^DD("OS")=% S XBDHWOFF="U 0:(0)" Q
 S IOP=0
 D ^%ZIS
 S V="|"
 ;
TITLE ;
 W @IOF,!,$$C^XBFUNC("*****  HEADER LINE PROCESSOR  *****"),!,$$C^XBFUNC("Version "_$P($T(XBDH+1),";",3))
 ; 
XBDHD ;
 D ^XBDHD
 I $D(XBDHQUIT) KILL XBDHQUIT G EXIT
 D:$D(^TMP("XBDH",$J,"HEADER"))=11 ^XBDHDSV
 I $D(^TMP("XBDH",$J,"SAVE")) G XBDHD
EXIT ;
 KILL:'$D(XBDHDATA) ^TMP("XBDH",$J)
 KILL XBDHDATA
 Q
 ; 
