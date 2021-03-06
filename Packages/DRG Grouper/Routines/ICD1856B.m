ICD1856B ;ALB/MJB - YEARLY DRG UPDATE;8/9/2010
 ;;18.0;DRG Grouper;**56**;Oct 13, 2000;Build 18
 Q
 ;
DIAG ; - update diagnosis codes
 ; from Table 6A in Fed Reg - assumes new codes already added by Lexicon
 D BMES^XPDUTL(">>>Modifying new diagnosis codes - file 80")
 N LINE,X,ICDDIAG,ENTRY,DA,DIE,DR,IDENT,MDC,MDC25,FDA
 F LINE=1:1 S X=$T(REVD+LINE) S ICDDIAG=$P(X,";;",2) Q:ICDDIAG="EXIT"  D
 .S ENTRY=+$O(^ICD9("BA",$P(ICDDIAG,U)_" ",0))
 .I ENTRY D
 ..;check for possible inactive dupe
 ..I $P($G(^ICD9(ENTRY,0)),U,9)=1 S ENTRY=+$O(^ICD9("BA",$P(ICDDIAG,U)_" ",ENTRY)) I 'ENTRY Q 
 ..S DA=ENTRY,DIE="^ICD9("
 ..S IDENT=$P(ICDDIAG,U,2)
 ..S MDC=$P(ICDDIAG,U,3)
 ..;this would only apply to diagnoses who have no other MDC than a pre-MDC
 ..I MDC="PRE" S MDC=98
 ..S MDC25=$P(ICDDIAG,U,4)
 ..S DR="2///^S X=IDENT;5///^S X=MDC;5.9///^S X=MDC25"
 ..D ^DIE
 ..;check if already created in case patch being re-installed
 ..Q:$D(^ICD9(ENTRY,3,"B",3111001))
 ..; add 80.071 and 80.711 and 80.072 records
 ..N FDA
 ..S FDA(1820,80,"?1,",.01)="`"_ENTRY
 ..S FDA(1820,80.071,"+2,?1,",.01)=3111001
 ..S FDA(1820,80.072,"+3,?1,",.01)=3111001
 ..S FDA(1820,80.072,"+3,?1,",1)=$P(ICDDIAG,U,3)
 ..D UPDATE^DIE("","FDA(1820)") K FDA(1820)
 ..S FDA(1820,80,"?1,",.01)="`"_ENTRY
 ..S FDA(1820,80.071,"?2,?1,",.01)=3111001
 ..S FDA(1820,80.711,"+3,?2,?1,",.01)=$P(ICDDIAG,U,5)
 ..I $P(ICDDIAG,U,6) S FDA(1820,80.711,"+4,?2,?1,",.01)=$P(ICDDIAG,U,6)
 ..I $P(ICDDIAG,U,7) S FDA(1820,80.711,"+5,?2,?1,",.01)=$P(ICDDIAG,U,7)
 ..I $P(ICDDIAG,U,8) S FDA(1820,80.711,"+6,?2,?1,",.01)=$P(ICDDIAG,U,8)
 ..I $P(ICDDIAG,U,9) S FDA(1820,80.711,"+7,?2,?1,",.01)=$P(ICDDIAG,U,9)
 ..I $P(ICDDIAG,U,10) S FDA(1820,80.711,"+8,?2,?1,",.01)=$P(ICDDIAG,U,10)
 ..I $P(ICDDIAG,U,11) S FDA(1820,80.711,"+9,?2,?1,",.01)=$P(ICDDIAG,U,11)
 ..I $P(ICDDIAG,U,12) S FDA(1820,80.711,"+10,?2,?1,",.01)=$P(ICDDIAG,U,12)
 ..I $P(ICDDIAG,U,13) S FDA(1820,80.711,"+11,?2,?1,",.01)=$P(ICDDIAG,U,13)
 ..D UPDATE^DIE("","FDA(1820)") K FDA(1820)
 Q
 ;
REVD ; DIAG^IDEN^MDC^MDC25^MDC24^MS-DRG
 ;;041.41^^18^^867^868^869
 ;;041.42^^18^^867^868^869
 ;;041.43^^18^^867^868^869
 ;;041.49^^18^^867^868^869
 ;;173.00^M^9^^606^607
 ;;173.01^^9^^606^607
 ;;173.02^^9^^606^607
 ;;173.09^M^9^^606^607
 ;;173.10^M^2^^124^125
 ;;173.11^^2^^124^125
 ;;173.12^^2^^124^125
 ;;173.19^M^2^^124^125
 ;;173.20^M^9^^606^607
 ;;173.21^^9^^606^607
 ;;173.22^^9^^606^607
 ;;173.29^M^9^^606^607
 ;;173.30^M^9^^606^607
 ;;173.31^^9^^606^607
 ;;173.32^^9^^606^607
 ;;173.39^M^9^^606^607
 ;;173.40^M^9^^606^607
 ;;173.41^^9^^606^607
 ;;173.42^^9^^606^607
 ;;173.49^M^9^^606^607
 ;;173.50^M^9^^606^607
 ;;173.51^^9^^606^607
 ;;173.52^^9^^606^607
 ;;173.59^M^9^^606^607
 ;;173.60^M^9^^606^607
 ;;173.61^^9^^606^607
 ;;173.62^^9^^606^607
 ;;173.69^M^9^^606^607
 ;;173.70^M^9^^606^607
 ;;173.71^^9^^606^607
 ;;173.72^^9^^606^607
 ;;173.79^M^9^^606^607
 ;;173.80^M^9^^606^607
 ;;173.81^^9^^606^607
 ;;173.82^^9^^606^607
 ;;173.89^M^9^^606^607
 ;;173.90^M^9^^606^607
 ;;173.91^^9^^606^607
 ;;173.92^^9^^606^607
 ;;173.99^M^9^^606^607
 ;;282.40^HJ^16^^811^812
 ;;282.43^HJ^16^^811^812
 ;;282.44^HJ^16^^811^812
 ;;282.45^HJ^16^^811^812
 ;;282.46^HJ^16^^811^812
 ;;282.47^HJ^16^^811^812
 ;;284.11^^16^^808^809^810
 ;;284.12^^16^^808^809^810
 ;;284.19^^16^^808^809^810
 ;;286.52^^16^^813
 ;;286.53^^16^^814^815^816
 ;;286.59^^16^^813
 ;;294.20^^19^^884
 ;;294.21^^19^^884
 ;;310.81^^1^^56^57
 ;;310.89^^1^^56^57
 ;;331.6^^1^^56^57
 ;;348.82^^1^^80^81
 ;;358.30^^1^^56^57
 ;;358.31^^1^^56^57
 ;;358.39^^1^^56^57
 ;;365.05^^2^^124^125
 ;;365.06^^2^^124^125
 ;;365.70^^2^^124^125
 ;;365.71^^2^^124^125
 ;;365.72^^2^^124^125
 ;;365.73^^2^^124^125
 ;;365.74^^2^^124^125
 ;;379.27^^2^^124^125
 ;;414.4^^5^^302^303
 ;;415.13^^4^^175^176
 ;;425.11^^5^^314^315^316
 ;;425.18^^5^^314^315^316
 ;;444.01^^5^^299^300^301
 ;;444.09^^5^^299^300^301
 ;;488.81^^4^^193^194^195
 ;;488.82^^4^^193^194^195
 ;;488.89^^18^^865^866
 ;;508.2^^4^^205^206
 ;;512.2^^4^^199^200^201
 ;;512.81^^4^^199^200^201
 ;;512.82^^4^^199^200^201
 ;;512.83^^4^^199^200^201
 ;;512.84^^4^^199^200^201
 ;;512.89^^4^^199^200^201
 ;;516.30^^4^^196^197^198
 ;;516.31^^4^^196^197^198
 ;;516.32^^4^^196^197^198
 ;;516.33^^4^^196^197^198
 ;;516.34^^4^^196^197^198
 ;;516.35^^4^^196^197^198
 ;;516.36^^4^^196^197^198
 ;;516.37^^4^^196^197^198
 ;;516.4^^4^^196^197^198
 ;;516.5^^4^^196^197^198
 ;;516.61^^4^^196^197^198
 ;;516.62^^4^^196^197^198
 ;;516.63^^4^^196^197^198
 ;;516.64^^4^^196^197^198
 ;;516.69^^4^^196^197^198
 ;;518.51^^4^^189
 ;;518.52^^4^^189
 ;;518.53^^4^^189
 ;;539.01^^6^^393^394^395
 ;;539.09^^6^^393^394^395
 ;;539.81^^6^^393^394^395
 ;;539.89^^6^^393^394^395
 ;;573.5^^4^^205^206
 ;;596.81^^11^^698^699^700
 ;;596.82^^11^^698^699^700
 ;;596.83^^11^^698^699^700
 ;;596.89^^11^^698^699^700
 ;;629.31^F^13^^742^743^760^761
 ;;629.32^F^13^^742^743^760^761
 ;;631.0^F^14^^781^782
 ;;631.8^F^14^^781^782
 ;;649.81^DF^14^^765^766^767^768^774^775
 ;;649.82^DF^14^^765^766^767^768^774^775
 ;;704.41^^9^^606^607
 ;;704.42^^9^^606^607
 ;;726.13^^8^^557^558
 ;;747.31^^5^^306^307
 ;;747.32^^5^^306^307
 ;;747.39^^5^^306^307
 ;;793.11^^4^^205^206
 ;;793.19^^4^^204
 ;;795.51^^4^^177^178^179
 ;;795.52^^4^^177^178^179
 ;;808.44^^8^^535^536
 ;;808.54^^8^^535^536
 ;;996.88^^21^^919^920^921
 ;;997.32^^4^^205^206
 ;;997.41^HJ^6^^393^394^395
 ;;997.49^HJ^6^^393^394^395
 ;;998.00^HJ^21^^919^920^921
 ;;998.01^HJ^21^^919^920^921
 ;;998.02^HJ^21^^919^920^921
 ;;998.09^HJ^21^^919^920^921
 ;;999.32^HJ^5^^314^315^316
 ;;999.33^HJ^5^^314^315^316
 ;;999.34^HJ^18^^856^857^858^867^868^869
 ;;999.41^HJ^21^^915^916
 ;;999.42^HJ^21^^915^916
 ;;999.49^HJ^21^^915^916
 ;;999.51^HJ^21^^915^916
 ;;999.52^HJ^21^^915^916
 ;;999.59^HJ^21^^915^916
 ;;V12.21^F^23^^951
 ;;V12.29^^23^^951
 ;;V12.55^^23^^951
 ;;V13.81^^23^^951
 ;;V13.89^^23^^951
 ;;V19.11^^23^^951
 ;;V19.19^^23^^951
 ;;V23.42^F^14^^998
 ;;V23.87^F^14^^998
 ;;V40.31^^23^^951
 ;;V40.39^^23^^951
 ;;V54.82^^8^^559^560^561
 ;;V58.68^^23^^949^950
 ;;V87.02^^23^^951
 ;;V88.21^^23^^951
 ;;V88.22^^23^^951
 ;;V88.29^^23^^951
 ;;EXIT
