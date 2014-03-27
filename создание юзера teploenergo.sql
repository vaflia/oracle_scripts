CREATE USER TEPLOENERGO IDENTIFIED BY fdtk23s5 
grant create session to teploenergo
grant base_connect to teploenergo
grant execute on  SCOTT.X1_ДНЯРСО_Б_ТХМДЕМЭ to teploenergo
grant execute on  scott.logger to teploenergo

grant execute  on  SCOTT.X1_ДНЯРСО_Б_ТХМДЕМЭ to res_org_base_connect
grant execute on  scott.logger to res_org_base_connect
grant execute on SCOTT.N6_оЕВЮРЭ  to res_org_view_button
grant execute on SCOTT.N52_ДКЪ_ЯСАЯХДХПНБЮМХЪ  to res_org_view_button
grant execute on scott.N132_oborotka_olap_lsk to res_org_view_button
grant execute on scott.N18_ЯЮКЭДН to res_org_view_button
grant execute on scott.N109_ЦНПБНДЮ to res_org_view_button
grant execute on core_gen.stat to res_org_base_connect
grant execute on SCOTT.GEN_INFO_USL to res_org_base_connect

CREATE ROLE res_org_base_connect NOT IDENTIFIED;
CREATE ROLE res_org_view_button NOT IDENTIFIED;
grant res_org_base_connect to teploenergo
grant res_org_view_button to teploenergo
grant execute on scott.utils to res_org_base_connect
grant select on scott.v_permissions_main to res_org_base_connect --with grant option
grant select on scott.v_permissions_main to teploenergo

grant execute on scott.N131_exp_saldo to асуц_йбюпрокюрш     
grant execute on scott.N131_exp_saldo to асуц_йбюпрокюрш_рпеяр    
grant execute on scott.N131_exp_saldo to цкюбмши_ноепюрнп

grant execute on scott.N116_Compensation  to base_connect    
grant execute on scott.N117_Compensation_rep  to base_connect


grant execute on scott.N85_finans to TANYA
grant execute on scott.N85_finans to асуц_йбюпрокюрш
grant execute on scott.N85_finans to асуц_йбюпрокюрш_рпеяр
grant execute on scott.N85_finans to щйн_юдлхмхярпюжхх    

grant execute on scott.N19_forma5_1 to асуц_йбюпрокюрш  
grant execute on scott.N19_forma5_1 to асуц_йбюпрокюрш_рпеяр 
grant execute on scott.N19_forma5_1 to цкюбмши_ноепюрнп   
grant execute on scott.N19_forma5_1 to щйн_юдлхмхярпюжхх 

grant execute on scott.N20_forma5_2 to асуц_йбюпрокюрш  
grant execute on scott.N20_forma5_2 to асуц_йбюпрокюрш_рпеяр 
grant execute on scott.N20_forma5_2 to цкюбмши_ноепюрнп   
grant execute on scott.N20_forma5_2 to щйн_юдлхмхярпюжхх 

grant execute on scott.N23_forma5_3 to асуц_йбюпрокюрш  
grant execute on scott.N23_forma5_3 to асуц_йбюпрокюрш_рпеяр  
grant execute on scott.N23_forma5_3 to цкюбмши_ноепюрнп 
grant execute on scott.N23_forma5_3 to щйн_юдлхмхярпюжхх


 GRANT BASE_CONNECT TO CAP_REM_VOD;
 grant select, update on scott.tree_obects_temp to RES_ORG_BASE_CONNECT
scott.l_pay
GRANT SELECT, insert,UPDATE ON SCOTT.TREE_OBJECTS_TEMP TO RES_ORG_BASE_CONNECT;
GRANT SELECT,insert, UPDATE ON SCOTT.TREE_ORG_TEMP TO RES_ORG_BASE_CONNECT;
GRANT SELECT,insert, UPDATE ON SCOTT.TREE_USL_TEMP TO RES_ORG_BASE_CONNECT;
GRANT SELECT ON SCOTT.REPORTS TO RES_ORG_BASE_CONNECT;
GRANT SELECT ON SCOTT.REP_LEVELS TO RES_ORG_BASE_CONNECT;