VFDCFM ;DSS/SGM - DRIVER PGM FOR VFDCFM* ; 01/29/2013 18:20
 ;;2011.1.2;DSS,INC VXVISTA OPEN SOURCE;;11 Jun 2013;Build 13
 ;Copyright 1995-2013,Document Storage Systems Inc. All Rights Reserved
 ;
OUT Q:$Q VFDC Q
 ;
 ;--------------------  VFDCFM01  --------------------
DATE(VFDXSD,VFDXED,FUN) ; start/end date prompter
 ; FUN - deprecated 8/6/2012
 N X,VFDC S VFDC=$$DATE^VFDCFM01(.VFDXSD,.VFDXED)
 G OUT
 ;
MSG(FLGS,VFDROUT,WIDTH,LEFT,INPUT) ; process message arrays
 G M^VFDCFM01
 ;
 ;--------------------  VFDCFM05  --------------------
FIND(VFDC,INPUT) ; RPC: VFDC FM FIND
 D FIND^VFDCFM05(.VFDC,.INPUT) Q
 ;
LIST(VFDC,INPUT) ; RPC: VFDC FM LIST
 D LIST^VFDCFM05(.VFDC,.INPUT) Q
 ;
 ;--------------------  VFDCFM06  --------------------
EXTERNAL(VFDC,FILE,FIELD,VALUE,FUN) ; rpc: VFDC FM EXTERNAL
 D EXTERNAL^VFDCFM06(.VFDC,FILE,FIELD,VALUE) G OUT
 ;
FIELD(VFDC,FILE,FIELD,FLAG,ATT,TYPE) ; rpc: VFDC FM GET FIELD ATTRIB
 D FIELD^VFDCFM06(.VFDC,FILE,FIELD,FLAG,.ATT,TYPE) Q
 ;
FIELDLST(VFDC,INPUT) ;
 D FIELDLST^VFDCFM06(.VFDC,.INPUT) Q
 ;
ROOT(VFDC,FILE,IENS,FLAG,FUN) ;
 D ROOT^VFDCFM06(.VFDC,$G(FILE),$G(IENS),$G(FLAG)) G OUT
 ;
VFILE(VFDC,FILE,FUN) ; rpc: VFDC FM VERIFY FILE
 D VFILE^VFDCFM06(.VFDC,FILE) G OUT
 ;
VFIELD(VFDC,FILE,FIELD,FUN) ; rpc: VFDC FM VERIFY FIELD
 D VFIELD^VFDCFM06(.VFDC,FILE,FIELD) G OUT
 ;
VIENS(VFDC,IENS,FUN) ;
 D VIENS^VFDCFM06(.VFDC,IENS) G OUT
 ;
 ;---------------  subroutines  --------------------
INIT(STR) ; list of variable names to initialize
 N I,X
 F I=1:1:$L(STR,U) S X=$P(STR,U,I) I X'="" S @X=$G(@X)
 Q
