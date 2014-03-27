           
            create or replace force view v_d_serv 
            as select * from oralv.d_serv@"HOT_TEST.REGRESS.RDBMS.DEV.US.ORACLE.COM"
            
            create table prep.d_serv2 as select * from prep.d_serv where 1=0
            insert into prep.d_serv2 
            select d.*,u.* from v_d_serv d, scott.usl u 
            where case when length(d.cd_usl)=4 then substr(d.cd_usl,2,3) else d.cd_usl end like u.usl 
            union all
            select b.*,a.* from 
            (select * from scott.usl u where not exists 
            (select * from oralv.d_serv@"HOT_TEST.REGRESS.RDBMS.DEV.US.ORACLE.COM" d 
               where u.usl=d.cd_usl)) a,
            (select * from oralv.d_serv@"HOT_TEST.REGRESS.RDBMS.DEV.US.ORACLE.COM" where 1=0) b
            where a.usl = b.cd_usl (+)  
            union all
            select * from 
            (select * from oralv.d_serv@"HOT_TEST.REGRESS.RDBMS.DEV.US.ORACLE.COM" d where not exists 
                (select * from scott.usl u 
                   where u.usl=d.cd_usl)) a,
            (select * from scott.usl u where 1=0) b
            where a.cd_usl=b.usl (+)
                      
                   
            select * from prep.d_serv2 where usl is not null
            scott.params