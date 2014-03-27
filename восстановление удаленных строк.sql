update prep.load_kartw201301 set nabor_id=null
update prep.load_kartw201301 a set nabor_id=( 
 select /*+ Cardinality (326000)*/nabor_id from prep.load_kartw201301   
   AS OF TIMESTAMP
TO_TIMESTAMP('28.01.2014 08:01:45','DD-MM-YY HH24: MI: SS') b
where a.lsk=b.lsk
)

merge into prep.load_kartw201301 a
using (select /*+ Cardinality (326000)*/lsk,nabor_id from prep.load_kartw201301   
   AS OF TIMESTAMP
TO_TIMESTAMP('28.01.2014 08:01:45','DD-MM-YY HH24: MI: SS')
)   b
on (a.lsk=b.lsk)
when matched then update set a.nabor_id=b.nabor_id  

select * from  scott.cap_transactions   
WHERE dat_ts='10.12.2013'
scott.t_charges_usl cr,
         scott.t_changes_usl

insert into scott.cap_transactions


select *  FROM scott.t_reu_kul_nd_status AS OF TIMESTAMP
TO_TIMESTAMP('02.03.2014 9:40:02','DD-MM-YY HH24: MI: SS')

 
 create table prep.kwtp_olap24022014900 as 
select *  FROM prep.KWTP_OLAP AS OF TIMESTAMP
TO_TIMESTAMP('26.02.2014 9:00:02','DD-MM-YY HH24: MI: SS')
 WHERE pay=0 AND dtek='24.02.2014'
 
  create table prep.kwtp_olap24022014845 as 
select *  FROM prep.KWTP_OLAP AS OF TIMESTAMP
TO_TIMESTAMP('26.02.2014 8:45:00','DD-MM-YY HH24: MI: SS')
 WHERE pay=0 AND dtek='24.02.2014'
 
 
create table prep.kwtp_h24022014940
as 
select * from  prep.kwtp_h
AS OF TIMESTAMP
TO_TIMESTAMP('26.02.2014 9:40:02','DD-MM-YY HH24: MI: SS')
where dtek>='01.02.2014'

select * from ldo.l_kwtp_crc
AS OF TIMESTAMP
TO_TIMESTAMP('26.02.2014 9:50:02','DD-MM-YY HH24: MI: SS')

create table prep.info_usl_nd_73 as
select * from  scott.info_usl_nd
AS OF TIMESTAMP
TO_TIMESTAMP('09.01.2014 08:20:45','DD-MM-YY HH24: MI: SS')
WHERE reu in ('73','52') 




WHERE dat_ts='10.12.2013'
and id=300440

insert into scott.cap_reguest
select * from scott.cap_reguest
where flow_id=300440 and kul='0005' and nd='00020а'
AS OF TIMESTAMP
TO_TIMESTAMP('19.12.2013 13:45:45','DD-MM-YY HH24: MI: SS') 
where flow_id=300440 and kul='0005' and nd='00020а'
select * from scott.cap_reguest


insert into scott.t_volume_usl_izm select * from prep.t_volume_usl_izm where mg='201301' or mg='201302'

insert into oralv.s_area
select * from (select  * from oralv.s_area AS OF TIMESTAMP
TO_TIMESTAMP('15.05.2013 08:01:45','DD-MM-YY HH24: MI: SS') ) s
where not exists (
select * from oralv.s_area sa where sa.id=s.id)



select sum(ska),sum(pn) 
    from prep.ldolkwtp l, scott.s_stra s
where 
    substr(l.lsk,1,4)=s.nreu 
    and s.reu='73'
    and dtek='06.01.2013'


SELECT       s.trest || ' ' || s.name_tr as name_tr, SP.NAME || '  ' || ltrim(k.ND,'0') as name_ul, p.dt1 as dtek, s.reu,s.trest,
                                    sum(CASE WHEN p.TP_CD='PAY' THEN p.summa ELSE 0 end)  SKA,
                                    sum(CASE WHEN p.TP_CD='PEN' THEN p.summa ELSE 0 end)  PN,
                                    sum(CASE WHEN substr(op.oigu,1,2)='10' then p.summa else 0 end) BN,
                                    1 as pay, sp.id as kul, k.nd as nd, u.for_plan
                          FROM  scott.l_pay AS OF TIMESTAMP
TO_TIMESTAMP('12.03.2013 08:35:45','DD-MM-YY HH24: MI: SS') 
                           p, scott.s_stra s, scott.oper op,
                                 (  SELECT U.USL, vu.usl1, u.for_plan
                                     FROM  
                                       (select distinct usl,usl1 from scott.var_usl1) vu , scott.usl u
                                        where vu.usl=u.usl
                                  ) u,
                                      scott.kart K, scott.spul SP, ldo.l_list_reg lr
                        WHERE       p.dt1 ='11.03.2013'
                                AND p.oper = op.oper 
                                AND p.fk_usl = u.usl1
                                AND substr(p.lsk,1,4) = s.nreu 
                                AND k.kul = sp.id     
                                AND k.lsk=p.lsk         
                                AND P.TP_CD   in ('PAY','PEN')
                                AND P.PAY_CD in ('PU')
                                             and trest='07'
                              --  AND op.tp_cd  in ('MU')     
                                AND  lr.state_cd in ('KW')  -- берет токо реестры выгруженные в квартплату
                                AND p.lsk not  in ('99999999')      
                                AND  lr.id=p.fk_list_reg
                        GROUP BY  s.trest || ' ' || s.name_tr, SP.NAME || '  ' || ltrim(k.ND,'0'),s.trest, s.reu, p.dt1, sp.id ,k.nd, u.for_plan
                        
                        
               
