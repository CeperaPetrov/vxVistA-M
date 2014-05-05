APCDFCT1 ; IHS/CMI/TUCSON - FORMS COUNT (FILE) report process ; [ 01/04/00  10:58 AM ]
 ;;2.0;IHS RPMS/PCC Data Entry;**2**;MAR 09, 1999
 S APCDJOB=$J,APCDBT=$H
 S ^XTMP("APCDFCT",0)=$$FMADD^XLFDT(DT,14)_"^"_DT_"^"_"PCC DE TRANS CODE REPORT"
P ; Run by posting date
 S APCDODAT=APCDSD_".9999" F  S APCDODAT=$O(^APCDTCT("B",APCDODAT)) Q:APCDODAT=""!((APCDODAT\1)>APCDED)  S APCDDFN=$O(^APCDTCT("B",APCDODAT,"")) D V1
 Q
V1 ;
 S APCDC=0 F  S APCDC=$O(^APCDTCT(APCDDFN,11,APCDC)) Q:APCDC'=+APCDC  S APCDVDFN=$P(^APCDTCT(APCDDFN,11,APCDC,0),U) I APCDVDFN]"",$D(^AUPNVSIT(APCDVDFN,0)) D PROC
 Q
PROC ;
 I APCDDEC'="ALL",APCDDEC'=$P(^APCDTCT(APCDDFN,11,APCDC,0),U,2) Q
 Q:$P(^APCDTCT(APCDDFN,11,APCDC,0),U,2)=""
 Q:'$D(^VA(200,$P(^APCDTCT(APCDDFN,11,APCDC,0),U,2),0))
 S APCDAP=$P(^VA(200,$P(^APCDTCT(APCDDFN,11,APCDC,0),U,2),0),U),APCDTC=$P(^APCDTCT(APCDDFN,11,APCDC,0),U,3)
 S APCDVREC=^AUPNVSIT(APCDVDFN,0)
 Q:'$P(APCDVREC,U,9)
 Q:$P(APCDVREC,U,11)
 D @APCDPROC
 S APCDDATE=$P(APCDODAT,".")
SET S ^(APCDDATE)=$S($D(^XTMP("APCDFCT",APCDJOB,APCDBT,APCDAP,APCDSORT,APCDDATE)):^(APCDDATE)+1,1:1)
 S ^(APCDDATE)=$S($D(^XTMP("APCDFCT",APCDJOB,APCDBT,APCDAP,APCDSORT,"DEP COUNT",APCDDATE)):^(APCDDATE)+APCDTC,1:APCDTC)
 Q
EOJ ; clean up and exit
 K APCDVREC,APCDCLIN,APCDSKIP,APCD1,APCD2,APCDAP,APCDX,APCDY,APCDTC,APCDDATE,APCDPROV,APCDSEC,APCDZ
 Q
 ;
1 ;
 S APCDCLIN=$P(APCDVREC,U,8) I APCDCLIN="" S APCDSORT="NO CLINIC ENTERED" Q
 S APCDSORT=$P(^DIC(40.7,APCDCLIN,0),U)
 Q
 ;
2 ;
 K ^UTILITY("DIQ1",$J)
 K DIQ,DIC,DA,DR
 S DIC="^AUPNVSIT(",DR=".07",DA=APCDVDFN,DIQ(0)="E" D EN^DIQ1 K DIC,DA,DR,DIQ
 S APCDSORT=^UTILITY("DIQ1",$J,9000010,APCDVDFN,.07,"E")
 K ^UTILITY("DIQ1",$J)
 Q
 ;
4 ;
 S APCDSORT="NONE"
 Q
3 ;TYPE
 K ^UTILITY("DIQ1",$J)
 K DIQ,DIC,DA,DR
 S DIC="^AUPNVSIT(",DR=".03",DA=APCDVDFN,DIQ(0)="E" D EN^DIQ1 K DIC,DA,DR,DIQ
 S APCDSORT=^UTILITY("DIQ1",$J,9000010,APCDVDFN,.03,"E")
 K ^UTILITY("DIQ1",$J)
 Q
 ;
 ;