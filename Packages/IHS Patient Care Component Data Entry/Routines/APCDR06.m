APCDR06 ; IHS/CMI/TUCSON - V PROVIDER REVIEW ; [ 01/04/00  11:02 AM ]
 ;;2.0;IHS RPMS/PCC Data Entry;**2**;MAR 09, 1999
 ;
 ;IHS/CMI/LAB patch 1 for file 200 converted sites
PRIPRV ; 
 I $P(^DD(9000010.06,.01,0),U,2)[200 D PRI200 G XIT
 S APCDEREC=^AUPNVPRV(APCDEDFN,0),APCDPRV=$P(APCDEREC,U),APCDY=""
 I '$D(^DIC(6,APCDPRV)) S APCDE="E002" D ERR G XIT
 I '$D(^DIC(6,APCDPRV,9999999)) S APCDE="E002" D ERR G XIT
 I $P(^DIC(6,APCDPRV,9999999),U)="" S APCDE="E028" D ERR G XIT
 S APCDY=$P(^DIC(6,APCDPRV,0),U,4)
 I APCDY="" S APCDE="E027" D ERR G XIT
 I '$D(^DIC(7,APCDY,9999999)) S APCDE="E027" D ERR G XIT
 I $P(^DIC(7,APCDY,9999999),U)="" S APCDE="E027" D ERR G XIT
 I $P(^DIC(6,APCDPRV,9999999),U,2)="" S APCDE="E002" D ERR G XIT
 ;
XIT ; Clean up and exit
 K APCDY,APCDEREC,APCDPRV,APCDE
 Q
ERR ;
 S APCDE("FILE")=9000010.06,APCDE("ENTRY")=APCDEDFN
 D ERR^APCDRV
 Q
PRI200 ;IHS/CMI/LAB - patch 1 for file 200 converted sites
 S APCDEREC=^AUPNVPRV(APCDEDFN,0),APCDPRV=$P(APCDEREC,U),APCDY=""
 I '$D(^VA(200,APCDPRV)) S APCDE="E002" D ERR G XIT
 I '$D(^VA(200,APCDPRV,9999999)) S APCDE="E002" D ERR G XIT
 I $$PROVAFFL^XBFUNC1(APCDPRV,"I")="" S APCDE="E028" D ERR G XIT
 I $$PROVCLS^XBFUNC1(APCDPRV,"I")="UNKNOWN" S APCDE="E027" D ERR G XIT
 I $$PROVCODE^XBFUNC1(APCDPRV)="" S APCDE="E002" D ERR G XIT
 ;
 Q
