CREATE OR REPLACE DIRECTORY external_tables_xls AS 'F:\dump\external_tables_xls';

CREATE TABLE prep.user1
 (
     USERNAME        VARCHAR2(1000),
     PS     VARCHAR2(1000)
) 
ORGANIZATION EXTERNAL
   (
         TYPE oracle_loader
         DEFAULT DIRECTORY external_tables_xls
         ACCESS PARAMETERS 
         (
               RECORDS DELIMITED BY NEWLINE
               FIELDS TERMINATED BY ';'
             MISSING FIELD VALUES ARE NULL
            REJECT ROWS WITH ALL NULL FIELDS
         )
             LOCATION ('user1.csv')
   )
REJECT LIMIT UNLIMITED;

drop table prep.user1
select * from prep.user1

select * from dba_users;


--Создает юзеров
begin
for rec in (select * from (select * from dba_users@NST.REGRESS.RDBMS.DEV.US.ORACLE.COM u where not exists (select * from dba_users d where u.username=d.username) )
                                        order by username)
loop  
          execute immediate 'create user '|| rec.username||' identified by values ''' ||rec.password ||'''';
end loop;
end;


--ПРОГНАТЬ ПОСЛЕ СОЗДАНИЯ ТАБЛИЦ И ЮЗЕРОВ, дает привелегии на объекты отд-ым юзера 
declare
l_privilege varchar2(4000);
l_table_name varchar2(4000);
l_grantee varchar2(4000);
l_str varchar2(4000);
begin
for rec in (select * from all_tab_privs@NST.REGRESS.RDBMS.DEV.US.ORACLE.COM priv 
                         where exists (select * from dba_users u 
                                             where u.username=priv.grantee 
                                                and  default_tablespace='DATA')
                                                and grantor not like '%SYS%'
                                                and table_schema not in ('SYS')
                 ) loop
     l_privilege:=rec.privilege;
     l_table_name:= rec.table_name;
     l_grantee:=  rec.grantee;
    l_str:= ' grant ' || rec.privilege || ' on ' || rec.table_schema||'.'||rec.table_name || ' to ' || rec.grantee ||'';
    execute immediate  l_str;
end loop;    
   EXCEPTION
   WHEN OTHERS THEN
    begin
        DBMS_OUTPUT.PUT_LINE (sysdate||' Ошибка - '|| SQLERRM ||'.   привилегия - ' || l_privilege ||' table name -'|| l_table_name||' - ' ||l_str);
    end;
end;
