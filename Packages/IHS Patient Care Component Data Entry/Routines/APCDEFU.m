APCDEFU ;cmi/sitka/maw - APCD Auto Print PCC Encounter Form Utility [ 12/22/03  11:24 AM ]
 ;;2.0;IHS RPMS PCC/Data Entry;**3,7**;MAR 09, 1999
 ;
 ;This routine contains the header, footer, and form feed utilities
 ;for the Automated PCC Encounter Form
 ;
 ;
HEAD ;EP-- this is the report header
 S APCDQ=0 I $E(IOST,1,2)'="P-" W:$D(IOF) @IOF
XHEAD W !!?13,"********** CONFIDENTIAL PATIENT INFORMATION **********"
 W !?30,"PCC ENCOUNTER RECORD"
 W !?18,"***  Computer Generated Encounter Record  ***"
 W !!,$TR($J("",80)," ","*")
 W !!?3,"Visit Date/Time:  ",APCDVDT
 W ?40,"Primary Provider: ",$$PRIMPROV^APCLV(APCDVIEN,"N")
 W !?3,"Clinic:  ",$E(APCDVCLN,1,25),?39,$E(APCDVSC,1,14),?55,$E(APCDVHL,1,24)
 W !?3,"Location:  ",APCDVLOC,"   ",$$LOCENC^APCLV(APCDVIEN,"C")
 W !,$TR($J("",80)," ","_")
 Q
 ;
FOOT ;EP-- page footer    
 S APCDPAT=$P(APCDVREC,U,5)
 S APCDHRN=$$HRN^AUPNPAT(APCDPAT,DUZ(2))
 S:APCDHRN="" APCDHRN="<?????>"
 W !,?3,"HR#:  ",APCDHRN,?30,"SSN:  ",$$SSN^AUPNPAT(APCDPAT)
 W !,?3,"NAME:  ",$$VAL^XBDIQ1(2,APCDPAT,.01)
 W ?30,"SEX: ",$$EXTSET^XBFUNC(2,.02,$P(^DPT(APCDPAT,0),U,2))
 W !?3,"DOB:  ",$$DOB^AUPNPAT(APCDPAT,"E")
 W ?30,"TRIBE: ",$$TRIBE^AUPNPAT(APCDPAT,"E")
 W !?3,"RESIDENCE:  ",$$COMMRES^AUPNPAT(APCDPAT,"E")
 W !?3,"FACILITY: ",$E($$VAL^XBDIQ1(4,DUZ(2),.01),1,25)
 W !!?30,"PROVIDER SIGNATURE:  "
 W !
 W !,$TR($J("",80)," ","*")
 Q
 ;
FF ;-- form feed
 Q:$Y<(IOSL-5)
 S DFN=$P(APCDVREC,U,5)
 S APCDHRN=$$HRN^AUPNPAT(DFN,DUZ(2))
 S:APCDHRN="" APCDHRN="<?????>"
 W !,?3,"HR#:  ",APCDHRN,?30,"SSN:  ",$P(^DPT(DFN,0),U,9)
 W !,?3,"NAME:  ",APCDPAT
 I $E(IOST)="C" D
 . I IO=IO(0) W ! S DIR(0)="EO"
 . D ^DIR K DIR I Y=0!(Y="^")!($D(DTOUT)) S APCDQ=1 Q
 W:$D(IOF) @IOF
 Q:$E(IOST,1,1)="C"
 D XHEAD
 Q
 ;
DONE ;EP-- kill tmp
 K ^XTMP(APCDJ,APCDH,"APCDEF")
 Q
 ;
