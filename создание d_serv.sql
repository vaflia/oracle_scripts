           
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
            drop table prep.d_serv
            

create or replace force view SCOTT.v_usl 
as 
select USLM,USL,TYPE,RASZ,KARTW,KWTP,KWNI,PRNK,PRNKSU,SALD_USL,KOOP,PN,
SUBSIDII,LPW,SPK,SPTAR,F_RAS,ED_IZM,NM_USL as nm, NM1_USL as nm1,S_RAS,S_RAS_SCH,USL_P,SPTARN,USL_TYPE,USL_PLR,USL_NORM,USLM_DET,USL_SUM,
KRT_R_SCH,TYP_USL,KART_P,ID_P_KF_R,ID_P_R,ID_K_KF_R,ID_K_R,FOR_SCH,USL_SV,F_RAS_V,FOR_PLAN,S_RAS2,F_RAS_IZMVOL_SUBSID,
F_RAS_IZMGKAL_SUBSID,S_RAS_DAILY,DOPL_PLAN
FROM prep.d_serv2 where usl is not null

scott.usl
select * from prep.d_serv2

select * from (
select * from scott.usl
union all
select * from scott.v_usl) order by usl            

--проверка исп-ия индексов
select i.*,v.nm1 from scott.info_usl_lsk i, scott.v_usl v 
where i.usl=v.usl and i.mg='201402'  and v.usl='012'

select i.*,v.nm1 from scott.info_usl_lsk i, scott.usl v 
where i.usl=v.usl and i.mg='201402'