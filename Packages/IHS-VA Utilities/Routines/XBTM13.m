XBTM13 ; IHS/ADC/GTH - TECH MANUAL : INSTALL NOTES ; [ 02/07/97   3:02 PM ]
 ;;3.0;IHS/VA UTILITIES;;FEB 07, 1997
 ;
 NEW A,B
 S A=$O(^DIC(9.4,"C","XB",0)),B=$O(^DIC(9.4,A,22,"B",^DIC(9.4,A,"VERSION"),0))
 S %=0
 F  S %=$O(^DIC(9.4,A,22,B,"I",%)) Q:'%   D PR(^(%,0)) Q:$D(DUOUT)
 Q:$D(DUOUT)
 D ^DIWW
 Q
 ;
PR(X) NEW %,A,B D PR^XBTM(X) Q
 ;
