MPIFSA2 ;SF/CMC-STAND ALONE QUERY PART 2 ;APRIL 22, 2003
 ;;1.0; MASTER PATIENT INDEX VISTA ;**28,29,35,38,43**;30 Apr 99
 ;
 ;Integration Agreements: $$EN^HLCSAC - #3471
 ;
FIELD ;
 ;;@00108.1;LAST NAME;ST;30
 ;;@00122;SSN;ST;9
 ;;@00110;DOB;TS;8
 ;;@00756;PRIMARY CARE SITE;ST;6
 ;;@00105;ICN;ST;19
 ;;@00108.2;FIRST NAME;ST;30
 ;;@00169;TREATING FACILITY (MULTIPLE--FILE 985.5);ST;999
 ;;@00740;DATE OF DEATH;TS;8
 ;;@00108.3;MIDDLE;ST;16
 ;;@00111;SEX;ST;1
 ;;@00126.1;BIRTH PLACE CITY;ST;30
 ;;@00126.2;BIRTH PLACE STATE;ST;3
 ;;@00108.5;NAME PREFIX;ST;15
 ;;@00108.4;NAME SUFFIX;ST;10
 ;;@00109.1;MOTHER'S MAIDEN NAME;ST;20
 ;;@ZEL6;CLAIM NUMBER;ST;9
 ;;@CASE#;MPI DUP CASE#;ST;69
 ;;@POW;POW STATUS;ST;1
 ;;@00127;MULTIPLE BIRTH INDICATOR;ST;1
 ;;@00112.1;ALIAS LAST NAME;ST;30
 ;;@00112.2;ALIAS FIRST NAME;ST;25
 ;;@00112.3;ALIAS MIDDLE NAME;ST;25
 ;;@00112.5;ALIAS PREFIX;ST;10
 ;;@00112.4;ALIAS SUFFIX;ST;10
 ;;
VTQ(MPIVAR) ;
 ;DSS/LM - Begin Mod - Disable Connect to MPI
 G EXIT
 ;DSS/LM - Mod End
 N TIME,% D NOW^%DTC S TIME=%
 W !!,"Attempting to connect to the Master Patient Index in Austin...",!,"If DOB is inexact or if SSN is not passed or if common name,",!,"this could take some time - please be patient...."
 N HL,MPIQRYNM,MPIINM,MPIOUT,MPIIN,MPIMCNT,MPICNT,MPICS,HEADER,RDF,QUERY,TEST,SITE,MPIDC,MPINM,MPI1NM,MPI2NM,MPIESC,MPIHDOB,MPIRS,MPISCS,QUEDDOB,MPIFLDV
 S HLP("ACKTIME")=300,HL("ECH")="^~\&",HL("FS")="|",MPIIN="",MPICNT=1,MPICS=$E(HL("ECH"),1)
 ;**43 CHANGING QUERY NAME FROM VTQ_PID_ICN_NO_LOAD TO VTQ_DISPLAY_ONLY_QUERY to enable the returning of potential matches and not just exact matches
 S MPIQRYNM="VTQ_DISPLAY_ONLY_QUERY"
 I '$D(MPIVAR("DFN")) S MPIVAR("DFN")=""
 S MPIMCNT=MPIVAR("DFN")
 ;SETUP VTQ
 S MPICS=$E(HL("ECH"),1),MPIRS=$E(HL("ECH"),2),MPISCS=$E(HL("ECH"),4),MPIESC=$E(HL("ECH"),3)
 D BLDRDF(.MPIOUT,3,MPIRS,MPICS)
 ; ^ fields to be returned in query response
 S QUERY="VTQ"_HL("FS")_$G(MPIVAR("DFN"))_HL("FS")_"T"_HL("FS")_MPIQRYNM_HL("FS")_"ICN"_HL("FS")
 S MPI2NM=$P($G(MPIVAR("NM")),",",1),QUERY=QUERY_"@00108.1"_MPICS_"EQ"_MPICS_MPI2NM ; ^ sending last name
 I MPIVAR("SSN")'="" S QUERY=QUERY_MPICS_"AND"_MPIRS_"@00122"_MPICS_"EQ"_MPICS_$G(MPIVAR("SSN")) ; ^ sending SSN
 S MPI1NM=$P($G(MPIVAR("NM")),",",2),MPI1NM=$P(MPI1NM," ",1) I MPI1NM'="" S QUERY=QUERY_MPICS_"AND"_MPIRS_"@00108.2"_MPICS_"EQ"_MPICS_MPI1NM ; ^ sending first name
 I $G(MPIVAR("DOB"))>0 D
 .S MPIHDOB=$$HLDATE^HLFNC(MPIVAR("DOB")) ; send date of birth (convert to hl7 date format)
 .S QUEDDOB=MPICS_"AND"_MPIRS_"@00110"_MPICS_"EQ"_MPICS_MPIHDOB,QUERY=QUERY_QUEDDOB ; ^ sending date of birth
 S MPI1NM=$P($G(MPIVAR("NM")),",",2),MPIMID=$P(MPI1NM," ",2) I MPIMID'="" S QUERY=QUERY_MPICS_"AND"_MPIRS_"@00108.3"_MPICS_"EQ"_MPICS_MPIMID ; sending middle name
 S MPISUF=$P(MPI1NM," ",3) I MPISUF'="" S QUERY=QUERY_MPICS_"AND"_MPIRS_"@00108.4"_MPICS_"EQ"_MPICS_MPISUF ; sending suffix
 S MPIPRE=$P(MPI1NM," ",4) I MPIPRE'="" S QUERY=QUERY_MPICS_"AND"_MPIRS_"@00108.5"_MPICS_"EQ"_MPICS_MPIPRE ; sending prefix
 I $G(MPIVAR("SEX"))'="" S QUERY=QUERY_MPICS_"AND"_MPIRS_"@00111"_MPICS_"EQ"_MPICS_$G(MPIVAR("SEX")) ;sending sex
 S SITE=$$SITE^VASITE,SITE=$P(SITE,"^",3) ;**29
 S HEADER="MSH"_HL("FS")_HL("ECH")_HL("FS")_"MPI_LOAD"_HL("FS")_SITE_HL("FS")_"MPI-ICN"_HL("FS")_HL("FS")_HL("FS")_HL("FS")_"VQQ"_MPICS_"Q02"_HL("FS")_MPIMCNT_"-"_MPICNT_HL("FS") ;create msh **38 changed VTQ to VQQ
 S MPIOUT(1)=HEADER K MPIOUT(0) S MPIOUT(2)=QUERY
 ;Attempt to connect to MPI and send message,receive message. Message is returned in MPIDC array
 S TEST=$$EN^HLCSAC("MPIVA DIR","MPIOUT","MPIDC")
 K HLP("ACKTIME") ;Clean up the ack timeout HLP array variable
 I +TEST<0 W !!,"Could not connect to MPI or Time-out occured, try again later." G EXIT
 K ^TMP("MPIFVQQ",$J)
INIPARS ;
 N SEG,INDEX,SKIP,CHECK,AL,TTF2,TFLL,TF,TF2,MPIREP,MPICOMP
 S INDEX=0 K CHECK
LOOP1 ;
 ;process in ADT type messages
 N MPIX S MPIX=0 N REP,SG,MSG,MPIQUIT,MPINODE
 S MPIQUIT=0
 F MPIX=0:1 X "D LOOP2" D  K MPINODE,MSG Q:MPIQUIT'>0
 . I $D(MPINODE(1)) S SG=$E(MPINODE(1),1,3) S MSG(1)=MPINODE(1) D
 ..  S MPIJ=1 F  S MPIJ=$O(MPINODE(MPIJ)) Q:'MPIJ  S MSG(MPIJ)=MPINODE(MPIJ)
 .. D:SG?2A1(1A,1N) @SG
 I '$D(^TMP("MPIFVQQ",$J)) W !!,"Patient was not found in the MPI." G EXIT
DISPLAY ; display data found
 I INDEX>1 W !!,"Found potential matches"
 I INDEX=1 W !!,"Found One Match"
 N CNT1,CNT2,STOP,CNTR2,TTF,CNT3,DIR,X,Y,DATA,PREFIX,ANAME,APRE,ALN,AFN,NAME,SSN,BIRTHDAY,CMOR,TF,ICN,POBC,POBS,PAST,XXX,AMID,ASUF,MNAME,SUFFIX,SEX,IEN,CMOR2,TF2,CLAIM,CASE,NOIS,CUSER,TFN,CMOR3,POW,MBIRTH,TIEN,MIDDLE
 S (CNT1)=0
 F  S CNT1=$O(^TMP("MPIFVQQ",$J,CNT1)) Q:CNT1'>0!($D(STOP))  D
 . S CNTR2=0
 . I CNT1>1 D
 . . K DIR,X,Y S DIR(0)="Y",DIR("B")="YES",DIR("A")="Continue to next Patient? " D ^DIR
 . . I Y'=1 S STOP=""
 . Q:$D(STOP)
 . S CNTR2=CNTR2+1,DATA=$G(^TMP("MPIFVQQ",$J,CNT1,"DATA"))
 . Q:DATA=""
 . K CHECK S NAME=$P(DATA,"^"),SSN=$P(DATA,"^",3),BIRTHDAY=$P(DATA,"^",4),ICN=$P(DATA,"^",6),CMOR=$P(DATA,"^",5)
 . I $G(CMOR)'="" S TIEN=$$LKUP^XUAF4(CMOR) I TIEN'="" S CMOR2=$P($$NS^XUAF4(+TIEN),"^")
 . S SEX=$P(DATA,"^",11),SUFFIX=$P(DATA,"^",15),PREFIX=$P(DATA,"^",14),MIDDLE=$P(DATA,"^",10),POBC=$P(DATA,"^",12),POBS=$P(DATA,"^",13),MNAME=$P(DATA,"^",16)
 . S PAST=$P(DATA,"^",9),CLAIM=$P(DATA,"^",17),CASE=$P(DATA,"^",18),NOIS=$P(CASE,"/",2),CUSER=$P(CASE,"/",3),CASE=$P(CASE,"/")
 . S CMOR3=$P($$NS^XUAF4(CMOR),"^"),MBIRTH=$P(DATA,"^",20),POW=$P(DATA,"^",19)
 . W:$G(CASE)'="" !,"<<THIS ICN IS ACTIVELY BEING WORKED ON - CASE #",CASE
 . W:$G(NOIS)'="" " NOIS/REMEDY TICKET: ",NOIS ;**43 CHANGED DISPLAY TO BE NOIS/REMEDY TICKET
 . W:$G(CASE)'="" ">>"
 . W:$G(CUSER)'="" !,?3,"Case Worker: ",CUSER
 . W !!,"ICN      : ",$P(ICN,"V"),?30,"CMOR: ",CMOR2," (",CMOR,")"
 . W !,"Name     : ",NAME,!,"SSN      : ",SSN
 . W !,"DOB      : ",BIRTHDAY
 . W:$G(PAST)'="" ?30,"Date of Death: ",PAST
 . W:$G(MBIRTH)'=""&(MBIRTH'="N") !,"Multiple Birth Indicator: Yes"
 . W !,"Sex      : ",SEX
 . W:$G(CLAIM)'="" !,"Claim #  : ",CLAIM
 . W:$G(POBC)'="" !,"Place of Birth: ",POBC W:$G(POBS)'="" ", ",POBS
 . W:$G(MNAME)'="" !,"Mother's Maiden Name: ",MNAME
 . W:$G(POW)'="" !,"POW Status: ",POW
 . I $D(^TMP("MPIFVQQ",$J,CNT1,"ALIAS")) D
 . . W !!,"Alias(es): "
 . . S XXX=0 F  S XXX=$O(^TMP("MPIFVQQ",$J,CNT1,"ALIAS",XXX)) Q:XXX=""  D
 . . . W !?5,^TMP("MPIFVQQ",$J,CNT1,"ALIAS",XXX)
 . S CNT2=""
 . W ! N TMP S XXX=0 F  S XXX=$O(^TMP("MPIFVQQ",$J,CNT1,"TF",XXX)) Q:XXX=""  S TMP=$G(^TMP("MPIFVQQ",$J,CNT1,"TF",XXX)) Q:TMP=""  D
 .. S TMP=$P(TMP,MPICOMP,1) I TMP'=CMOR3 W !?10,"Treating Facility: ",$P($$NS^XUAF4($$LKUP^XUAF4(TMP)),"^")," (",TMP,")"
 .W !!
EXIT K DA,X,Y W !! Q
LOOP2 ;
 N MPIDONE,MPII,MPIJ
 S MPII=0,MPIDONE=0
 F  S MPIQUIT=$O(MPIDC(MPIQUIT)) Q:'MPIQUIT  D  Q:MPIDONE
 . I MPIDC(MPIQUIT)="" S MPIDONE=1 Q
 . S MPII=MPII+1,MPINODE(MPII)=$G(MPIDC(MPIQUIT)) Q
 Q
MSH ;
 S MPIREP=$E(HL("ECH"),2),MPICOMP=$E(HL("ECH"),1)
 Q
MSA ;
 Q
RDF ;
 Q
QAK ;
 Q
RDT ;
 S INDEX=$G(INDEX)+1
 D RDT^MPIFSA3(.INDEX,.HL,.MSG)
 Q
BLDRDF(MPIOUT,MPICNT,MPIRS,MPICS) ;
 S MPIOUT(MPICNT)="RDF"_HL("FS")_24_HL("FS") N T,I F I=1:1 S T=$T(FIELD+I) Q:$P(T,";",3)=""  D
 . I I=1 S MPIFLDV=$P(T,";",3)_MPICS_$P(T,";",5)_MPICS_$P(T,";",6)
 . I I'=1 S MPIFLDV=MPIRS_$P(T,";",3)_MPICS_$P(T,";",5)_MPICS_$P(T,";",6)
  .N XLEN,TOTLEN
 . S TOTLEN=$L($G(MPIOUT(MPICNT)))+$L(MPIFLDV)
 . I TOTLEN'>245 S MPIOUT(MPICNT)=$G(MPIOUT(MPICNT))_MPIFLDV Q
 . I TOTLEN>245 D
 .. S XLEN=245-$L($G(MPIOUT(MPICNT)))
 .. S MPIOUT(MPICNT)=$G(MPIOUT(MPICNT))_$E(MPIFLDV,1,XLEN),MPICNT=MPICNT+1
 .. S MPIOUT(MPICNT)=$E(MPIFLDV,XLEN+1,245)
 Q
