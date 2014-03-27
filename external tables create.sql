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


begin
for rec in (select * from (select * from dba_users@NST.REGRESS.RDBMS.DEV.US.ORACLE.COM u where not exists (select * from dba_users d where u.username=d.username) )
                                        order by username)
     loop  
          execute immediate 'create user '|| rec.username||' identified by values ''' ||rec.password ||'''';
end loop; 
end;