TIUXRC2 ; COMPILED XREF FOR FILE #8925 ; 03/19/13
 ; 
 I X'="" I +$P($G(^TIU(8925,+DA,0)),U),+$P($G(^TIU(8925,+DA,12)),U,2),+$P($G(^TIU(8925,+DA,0)),U,5) K ^TIU(8925,"AAU",+$P(^TIU(8925,+DA,12),U,2),+$P(^TIU(8925,+DA,0),U),+$P(^TIU(8925,+DA,0),U,5),(9999999-X),+DA)
 S X=$P(DIKZ(13),U,1)
 I X'="" I +$P($G(^TIU(8925,+DA,0)),U),+$P($G(^TIU(8925,+DA,12)),U,8),+$P($G(^TIU(8925,+DA,0)),U,5) K ^TIU(8925,"ASUP",+$P(^TIU(8925,+DA,12),U,8),+$P(^TIU(8925,+DA,0),U),+$P(^TIU(8925,+DA,0),U,5),(9999999-X),+DA)
 S X=$P(DIKZ(13),U,1)
 I X'="" I +$P($G(^TIU(8925,+DA,0)),U),+$P($G(^TIU(8925,+DA,0)),U,2),+$P($G(^TIU(8925,+DA,0)),U,5) K ^TIU(8925,"APT",+$P(^TIU(8925,+DA,0),U,2),+$P(^TIU(8925,+DA,0),U),+$P(^TIU(8925,+DA,0),U,5),(9999999-X),+DA)
 S X=$P(DIKZ(13),U,1)
 I X'="" I +$P($G(^TIU(8925,+DA,0)),U),+$P($G(^TIU(8925,+DA,14)),U,2),+$P($G(^TIU(8925,+DA,0)),U,5) K ^TIU(8925,"ATS",+$P(^TIU(8925,+DA,14),U,2),+$P(^TIU(8925,+DA,0),U),+$P(^TIU(8925,+DA,0),U,5),(9999999-X),+DA)
 S X=$P(DIKZ(13),U,1)
 I X'="" I +$P($G(^TIU(8925,+DA,0)),U),+$P($G(^TIU(8925,+DA,13)),U,2),+$P($G(^TIU(8925,+DA,0)),U,5) K ^TIU(8925,"ATC",+$P(^TIU(8925,+DA,13),U,2),+$P(^TIU(8925,+DA,0),U),+$P(^TIU(8925,+DA,0),U,5),(9999999-X),+DA)
 S X=$P(DIKZ(13),U,1)
 I X'="" I +$P($G(^TIU(8925,+DA,0)),U),+$P($G(^TIU(8925,+DA,0)),U,5) K ^TIU(8925,"ALL","ANY",+$P(^TIU(8925,+DA,0),U),+$P(^TIU(8925,+DA,0),U,5),(9999999-X),+DA)
 S X=$P(DIKZ(13),U,1)
 I X'="" I +$P($G(^TIU(8925,+DA,0)),U),+$P($G(^TIU(8925,+DA,0)),U,5),$L($P($G(^TIU(8925,+DA,17)),U)) D ASUBK^TIUDD($P($G(^TIU(8925,+DA,17)),U),+$G(^TIU(8925,+DA,0)),+$P($G(^TIU(8925,+DA,0)),U,5),(9999999-+X),DA)
 S X=$P(DIKZ(13),U,1)
 I X'="" I +$P($G(^TIU(8925,+DA,0)),U),+$P($G(^TIU(8925,+DA,14)),U,4),+$P($G(^TIU(8925,+DA,0)),U,5) K ^TIU(8925,"ASVC",+$P(^TIU(8925,+DA,14),U,4),+$P(^TIU(8925,+DA,0),U),+$P(^TIU(8925,+DA,0),U,5),(9999999-X),+DA)
 S X=$P(DIKZ(13),U,1)
 I X'="" I +$P($G(^TIU(8925,+DA,0)),U),+$P($G(^TIU(8925,+DA,0)),U,5),+$O(^TIU(8925.9,"B",+DA,0)) D APRBK^TIUDD(+$G(^TIU(8925,+DA,0)),+$P($G(^TIU(8925,+DA,0)),U,5),(9999999-+X),DA)
 S X=$P(DIKZ(13),U,1)
 I X'="" I +$P($G(^TIU(8925,+DA,0)),U),+$P($G(^TIU(8925,+DA,0)),U,3),+$P($G(^TIU(8925,+DA,0)),U,5) K ^TIU(8925,"AVSIT",+$P(^TIU(8925,+DA,0),U,3),+$P(^TIU(8925,+DA,0),U),+$P(^TIU(8925,+DA,0),U,5),(9999999-X),DA)
 S X=$P(DIKZ(13),U,1)
 I X'="" I +$P($G(^TIU(8925,+DA,0)),U,4),+$P($G(^TIU(8925,+DA,0)),U,2),+$P($G(^TIU(8925,+DA,0)),U,5) K ^TIU(8925,"ADCPT",+$P(^TIU(8925,+DA,0),U,2),+$P(^TIU(8925,+DA,0),U,4),+$P(^TIU(8925,+DA,0),U,5),(9999999-X),DA)
 S X=$P(DIKZ(13),U,1)
 I X'="" K ^TIU(8925,"D",$E(X,1,30),DA)
 S X=$P(DIKZ(13),U,1)
 I X'="" I +$P(^TIU(8925,+DA,0),U),+$P($G(^TIU(8925,+DA,0)),U,2) K ^TIU(8925,"APTCL",+$P(^TIU(8925,+DA,0),U,2),+$$CLINDOC^TIULC1(+$P(^TIU(8925,+DA,0),U),+DA),(9999999-X),DA)
 S X=$P(DIKZ(13),U,1)
 I X'="" I +$P(^TIU(8925,+DA,0),U),+$P($G(^TIU(8925,+DA,0)),U,2) K ^TIU(8925,"APTCL",+$P(^TIU(8925,+DA,0),U,2),38,(9999999-X),DA)
 S X=$P(DIKZ(13),U,1)
 I X'="" I +$P($G(^TIU(8925,+DA,0)),U),+$P($G(^TIU(8925,+DA,12)),U,5),+$P($G(^TIU(8925,+DA,0)),U,5) K ^TIU(8925,"ALOC",+$P(^TIU(8925,+DA,12),U,5),+$P(^TIU(8925,+DA,0),U),+$P(^TIU(8925,+DA,0),U,5),(9999999-X),+DA)
 S X=$P(DIKZ(13),U,1)
 I X'="" D KACLPT^TIUDD01(1301,X)
 S X=$P(DIKZ(13),U,1)
 I X'="" D KACLAU^TIUDD01(1301,X),KACLAU1^TIUDD01(1301,X)
 S X=$P(DIKZ(13),U,1)
 I X'="" D KACLEC^TIUDD01(1301,X)
 S X=$P(DIKZ(13),U,1)
 I X'="" D KACLSB^TIUDD01(1301,X)
 S X=$P(DIKZ(13),U,2)
 I X'="" K ^TIU(8925,"TC",$E(X,1,30),DA)
 S X=$P(DIKZ(13),U,2)
 I X'="" I +$P($G(^TIU(8925,+DA,0)),U),+$P($G(^TIU(8925,+DA,13)),U),+$P($G(^TIU(8925,+DA,0)),U,5) K ^TIU(8925,"ATC",+X,+$P($G(^TIU(8925,+DA,0)),U),+$P(^TIU(8925,+DA,0),U,5),(9999999-$P($G(^TIU(8925,+DA,13)),U)),DA)
 S X=$P(DIKZ(13),U,2)
 I X'="" D KACLAU1^TIUDD01(1302,X)
 S X=$P(DIKZ(13),U,4)
 I X'="" K ^TIU(8925,"E",$E(X,1,30),DA)
 S DIKZ(14)=$G(^TIU(8925,DA,14))
 S X=$P(DIKZ(14),U,2)
 I X'="" K ^TIU(8925,"TS",$E(X,1,30),DA)
 S X=$P(DIKZ(14),U,2)
 I X'="" I +$P($G(^TIU(8925,+DA,0)),U),+$P($G(^TIU(8925,+DA,13)),U),+$P($G(^TIU(8925,+DA,0)),U,5) K ^TIU(8925,"ATS",+X,+$P($G(^TIU(8925,+DA,0)),U),+$P($G(^TIU(8925,+DA,0)),U,5),(9999999-$P($G(^TIU(8925,+DA,13)),U)),DA)
 S X=$P(DIKZ(14),U,4)
 I X'="" I +$P($G(^TIU(8925,+DA,0)),U),+$P($G(^TIU(8925,+DA,13)),U),+$P($G(^TIU(8925,+DA,0)),U,5) K ^TIU(8925,"ASVC",+X,+$P($G(^TIU(8925,+DA,0)),U),+$P($G(^TIU(8925,+DA,0)),U,5),(9999999-$P($G(^TIU(8925,+DA,13)),U)),DA)
 S X=$P(DIKZ(14),U,4)
 I X'="" K ^TIU(8925,"SVC",$E(X,1,30),DA)
 S X=$P(DIKZ(14),U,5)
 I X'="" K ^TIU(8925,"G",$E(X,1,30),DA)
 S DIKZ(15)=$G(^TIU(8925,DA,15))
 S X=$P(DIKZ(15),U,1)
 I X'="" I +$P($G(^TIU(8925,+DA,12)),U,5) K ^TIU(8925,"ALOCP",+$P($G(^TIU(8925,+DA,12)),U,5),+X,+DA)
 S X=$P(DIKZ(15),U,1)
 I X'="" I +$P($G(^TIU(8925,+DA,0)),U,2) K ^TIU(8925,"APTP",+$P($G(^TIU(8925,+DA,0)),U,2),+X,+DA)
 S X=$P(DIKZ(15),U,1)
 I X'="" I +$P($G(^TIU(8925,+DA,12)),U,2) K ^TIU(8925,"AAUP",+$P($G(^TIU(8925,+DA,12)),U,2),+X,+DA)
 S X=$P(DIKZ(15),U,1)
 I X'="" D KACLPT^TIUDD01(1501,X)
 S X=$P(DIKZ(15),U,1)
 I X'="" D KACLEC^TIUDD01(1501,X)
 S X=$P(DIKZ(15),U,1)
 I X'="" D SACLAU^TIUDD0(1501,X),SACLAU1^TIUDD0(1501,X)
 S X=$P(DIKZ(15),U,2)
 I X'="" D KACLSB^TIUDD01(1502,X)
 S X=$P(DIKZ(15),U,7)
 I X'="" D SACLEC^TIUDD0(1507,X)
 S X=$P(DIKZ(15),U,7)
 I X'="" D KACLPT^TIUDD01(1507,X)
 S DIKZ(17)=$G(^TIU(8925,DA,17))
 S X=$P(DIKZ(17),U,1)
 I X'="" I +$P($G(^TIU(8925,+DA,0)),U),+$P($G(^TIU(8925,+DA,0)),U,5),+$P($G(^TIU(8925,+DA,13)),U) D ASUBK^TIUDD($G(X),+$G(^TIU(8925,+DA,0)),+$P(^TIU(8925,+DA,0),U,5),(9999999-+$G(^TIU(8925,+DA,13))),DA)
 S DIKZ(21)=$G(^TIU(8925,DA,21))
 S X=$P(DIKZ(21),U,1)
 I X'="" K ^TIU(8925,"GDAD",$E(X,1,30),DA)
 S DIKZ(150)=$G(^TIU(8925,DA,150))
 S X=$P(DIKZ(150),U,1)
 I X'="" K ^TIU(8925,"VID",$E(X,1,30),DA)
 S X=$P(DIKZ(0),U,1)
 I X'="" K ^TIU(8925,"B",$E(X,1,30),DA)
 S X=$P(DIKZ(0),U,1)
 I X'="" I +$P(^TIU(8925,+DA,0),U,2),+$P($G(^TIU(8925,+DA,13)),U),+$P($G(^TIU(8925,+DA,0)),U,5) K ^TIU(8925,"APT",+$P(^TIU(8925,+DA,0),U,2),+X,+$P(^TIU(8925,+DA,0),U,5),(9999999-$P(^TIU(8925,+DA,13),U)),DA)
 S X=$P(DIKZ(0),U,1)
 I X'="" I +$P($G(^TIU(8925,+DA,12)),U,2),+$P($G(^TIU(8925,+DA,13)),U),+$P($G(^TIU(8925,+DA,0)),U,5) K ^TIU(8925,"AAU",+$P($G(^TIU(8925,+DA,12)),U,2),+X,+$P(^TIU(8925,+DA,0),U,5),(9999999-$P($G(^TIU(8925,+DA,13)),U)),DA)
 S X=$P(DIKZ(0),U,1)
 I X'="" I +$P($G(^TIU(8925,+DA,12)),U,8),+$P($G(^TIU(8925,+DA,13)),U),+$P($G(^TIU(8925,+DA,0)),U,5) K ^TIU(8925,"ASUP",+$P($G(^TIU(8925,+DA,12)),U,8),+X,+$P(^TIU(8925,+DA,0),U,5),(9999999-$P($G(^TIU(8925,+DA,13)),U)),DA)
 S X=$P(DIKZ(0),U,1)
 I X'="" I +$P($G(^TIU(8925,+DA,0)),U,2),+$P($G(^(0)),U,3) K ^TIU(8925,"AV",+$P(^TIU(8925,+DA,0),U,2),+X,+$P(^TIU(8925,+DA,0),U,3),+DA)
 S X=$P(DIKZ(0),U,1)
 I X'="" I +$P($G(^TIU(8925,+DA,14)),U,2),+$P($G(^TIU(8925,+DA,13)),U),+$P($G(^TIU(8925,+DA,0)),U,5) K ^TIU(8925,"ATS",+$P($G(^TIU(8925,+DA,14)),U,2),+X,+$P($G(^TIU(8925,+DA,0)),U,5),(9999999-$P($G(^TIU(8925,+DA,13)),U)),DA)
 S X=$P(DIKZ(0),U,1)
 I X'="" I +$P($G(^TIU(8925,+DA,13)),U,2),+$P($G(^TIU(8925,+DA,13)),U),+$P($G(^TIU(8925,+DA,0)),U,5) K ^TIU(8925,"ATC",+$P($G(^TIU(8925,+DA,13)),U,2),+X,+$P(^TIU(8925,+DA,0),U,5),(9999999-$P($G(^TIU(8925,+DA,13)),U)),DA)
 S X=$P(DIKZ(0),U,1)
 I X'="" I +$P($G(^TIU(8925,+DA,13)),U),+$P($G(^TIU(8925,+DA,0)),U,5) K ^TIU(8925,"ALL","ANY",+X,+$P(^TIU(8925,+DA,0),U,5),(9999999-$P($G(^TIU(8925,+DA,13)),U)),DA)
 S X=$P(DIKZ(0),U,1)
 I X'="" I $L($P(^TIU(8925,+DA,0),U,2)),(+$P(^(0),U,3)>0) K ^TIU(8925,"AA",+$P(^(0),U,2),+X,(9999999-$P(+^AUPNVSIT(+$P(^TIU(8925,+DA,0),U,3),0),".")),DA)
 S X=$P(DIKZ(0),U,1)
 I X'="" I $L($P($G(^TIU(8925,+DA,17)),U)),+$P($G(^TIU(8925,+DA,13)),U),+$P($G(^TIU(8925,+DA,0)),U,5) D ASUBK^TIUDD($P($G(^TIU(8925,+DA,17)),U),+X,+$P(^TIU(8925,+DA,0),U,5),(9999999-+$G(^TIU(8925,+DA,13))),DA)
 S X=$P(DIKZ(0),U,1)
END G ^TIUXRC3
