begin
 select dbms_metadata.get_ddl(OBJECT_TYPE => 'USER',NAME => a.username)
     from dba_users a where username='VAFLIA';
end;
--------------------------------------------------------------------------------

   CREATE USER FKV IDENTIFIED BY  CJCBCRF;
   
   select * from sys.user$
   select * from oralv.users
   
   
  CREATE USER PREP identified by values 'DFDDE23BF3DF217C';
  
  SELECT * FROM dba_users
  @OLD_HOTORA
  
  HOTORA_OLD.GKH-KEMEROVO.ru
  ENERG
  
  GRANT SELECT ON SCOTT.V_CUR_RLXFUNCT TO BASE_CONNECT
  
  select * from dba_tables 
  where owner='SCOTT' 
  order by table_name 
  
  select * from scott.l_pay where lsk ='65011012'
  
  CREATE SYNONYM SYS.DBMS_ALERT FOR SYS.DBMS_ALERT
  select * from scott.v_permissions_main t
  
  CREATE SYNONYM SYS.DEF$_DEFAULTDEST FOR SYSTEM.DEF$_DEFAULTDEST;
  
  select * from l_load1@nst
  
begin
  execute immediate 'GRANT BASE_CONNECT TO BUGH_ALTER_2';
  execute immediate 'GRANT BASE_CONNECT TO BUGH_ALTER_1';
end;

select * from oralv.t_user

scott.usl
scott.uslm

select * from SCOTT.LOAD_S_STRA

select * from scott.s_reu_trest


Select p.* from   sys.DBA_sys_privs p, dba_roles r Where  p.

select * from all_sys_privs

Select  drg.granted_group, drg.grant_option, drg.initial_group, drg.grantee
  FROM dba_rsrc_consumer_group_privs drg
 WHERE drg.grantee IN ('ADMIN_FINDAY', 'PUBLIC')
 
 select DBMS_METADATA.get_ddl('ROLE','ADMIN_FINDAY') source from dual

begin
delete from scott.t_corrects_payments where fk_corr_doc=1341;
delete from scott.t_corr_doc where id=1341;
end;

create table prep.scott_log as select timestampm, comments from scott.log where comments like '%¬ıÓ‰ ‚ ÙËÌ‡ÌÒÓ‚˚È ‰ÂÌ¸%' order by timestampm

 select distinct substr( 
                                 substr(comments,instr(comments,':')+2,20),
                                 1, instr(substr(comments,instr(comments,':')+2,20),' ')-1
                                ) as login,
   
   substr( substr(comments,instr(comments,':',1,2)+1,instr(comments,':',1,3)-3),1,
        instr(substr(comments,instr(comments,':',1,2)+1,instr(comments,':',1,3)-3),' '))
     as pass                       
  --,comments
  FROM prep.scott_log where trunc(timestampm,'dd')>'01.01.2010'  
 /*  order by substr( 
                                 substr(comments,instr(comments,':')+2,20),
                                 1, instr(substr(comments,instr(comments,':')+2,20),' ')-1
                                ) */
                                union
                                select cd,licp from oralv.t_user
                                where cd is not null
                                and licp is not null

 select cd,licp from oralv.t_user
 select rpad('123456789f',20) from dual
 select substr('123456789f',5,2) from dual
    
 
 
 
  select * from
  (select username,password from dba_users) a
  full outer join 
  (select cd as username,licp from oralv.t_user)b
  using(username)
  
  
  create directory dpdump as 'F:\dump\dpdump'
  
  GRANT EXECUTE ON CORE_GEN.GEN TO "√À¿¬Õ€…_Œœ≈–¿“Œ–";
  
  create table l_load2 as select       *    from l_load1@NST
  
  select       *    from scott.l_load2
  
  SELECT owner, table_name, select_priv, insert_priv, delete_priv, update_priv, references_priv, alter_priv, index_priv 
  FROM table_privileges
 WHERE grantee = 'SCOTT'
 ORDER BY owner, table_name;
 
 SELECT DISTINCT owner, table_name, PRIVILEGE 
  FROM dba_role_privs rp JOIN role_tab_privs rtp ON (rp.granted_role = rtp.role)
 WHERE rp.grantee = 'SCOTT'
 ORDER BY owner, table_name;
 
 select * from scott.l_pay where lsk='65011012'
 
 
 
 create table scott.l_load1 as 
select * from l_load1@NST.REGRESS.RDBMS.DEV.US.ORACLE.COM


  select * from params@NST 
  where owner='SCOTT' 
  order by table_name 
  
  DROP PUBLIC DATABASE LINK "NST.GKH-KEMEROVO.RU";

CREATE PUBLIC DATABASE LINK "NST.REGRESS.RDBMS.DEV.US.ORACLE.COM"
 CONNECT TO SCOTT
 IDENTIFIED BY LIFESTYLE
 USING 'HOTORA_OLD';
 
 CREATE DATABASE LINK "NST.REGRESS.RDBMS.DEV.US.ORACLE.COM"
 CONNECT TO LDO
 IDENTIFIED BY LIFESTYLE
 USING 'HOTORA_OLD';
 
 select * from scott.l_pay where lsk='66089728'
 
  select * from a_flow  where lsk in ('66089728') and dt1 between '27.07.2013' and '10.08.2013'
  order by lsk,dt1
  
  
  select       *    from dba_tables@NST
select       *    from l_load1@NST.REGRESS.RDBMS.DEV.US.ORACLE.COM
create table ldo.l_load2 as select * from  l_load1@NST
DROP DATABASE LINK NST;

CREATE DATABASE LINK NST
 CONNECT TO SCOTT
 IDENTIFIED BY lifestyle
 USING 'HOTORA_OLD';
 
 DROP DATABASE LINK NST
 
 

SELECT path
FROM (
  SELECT grantee,
    sys_connect_by_path(privilege, ':')||':'||grantee path
  FROM (
    SELECT grantee, privilege, 0 role
    FROM dba_sys_privs
    UNION ALL
    SELECT grantee, granted_role, 1 role
    FROM dba_role_privs)
  CONNECT BY privilege=prior grantee
  START WITH role = 0)
WHERE grantee IN (
  SELECT username
  FROM dba_users
  WHERE lock_date IS NULL
  AND password != 'EXTERNAL'
  AND username != 'SYS')
OR grantee='PUBLIC'


select  * from all_tab_privs@NST.REGRESS.RDBMS.DEV.US.ORACLE.COM
select  * from dba_users@NST.REGRESS.RDBMS.DEV.US.ORACLE.COM --where account_status='OPEN'
select  * from all_tab_privs@NST.REGRESS.RDBMS.DEV.US.ORACLE.COM where account_status='OPEN'
select  * from dba_users

grantee -  ÔÓÎÛ˜‡ÚÂÎ¸


ALTER TABLE SCOTT.OPER ADD CONSTRAINT OPER_F_FK_ORG FOREIGN KEY (FK_ORG) REFERENCES ORALV.T_ORG (ID) ENABLE

ALTER SYSTEM SET pga_aggregate_target=4000M ;



CREATE TABLE prep.s_reu_trest  
(  
REU         CHAR(2 BYTE)   ,
  TREST       CHAR(2 BYTE),
  NAME_TR     CHAR(35 BYTE),
  TR_FORPLAN  CHAR(2 BYTE),
  FOR_DEBITS  NUMBER,
  FOR_SCHET   NUMBER,
  INK         NUMBER    ,
  FOR_PLAT    NUMBER,
  MG1         CHAR(6 BYTE),
  MG2         CHAR(6 BYTE)
  )
    ORGANIZATION EXTERNAL
    (
      TYPE ORACLE_DATAPUMP
      DEFAULT DIRECTORY DATA_PUMP_DIR
      LOCATION ('SCOTT_FULL_DP.DP')
    )
    
as SELECT * FROM scott.s_reu_trest;
    

drop table prep.s_reu_trest
