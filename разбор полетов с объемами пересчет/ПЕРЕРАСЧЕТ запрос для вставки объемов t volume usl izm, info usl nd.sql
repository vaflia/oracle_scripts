update SCOTT.T_VOLUME_USL_IZM set usl='015'
where mg='201301'

select lsk, sum (gw), sum (gw_dop) from scott.t_volume_usl_izm v, scott.s_reu_trest s
where s.reu=v.reu
and s.trest='04'
and mg='201212'
group by lsk

select * from scott.t_volume_usl_izm
where mg='201301'

delete  from prep.t_volume_usl_izm
where mg='201302'

     --запрос для вставки объемов перерасчет прошлых периодов
INSERT INTO prep.T_VOLUME_USL_IZM (lsk,org,usl,gw,reu,kul,nd,vvod_gw,mg)
SELECT ki.lsk,   
         CASE 
                WHEN '201301' >= SUBSTR (o.dat3, 3, 4) || SUBSTR (o.dat3, 1, 2)
                   THEN o.kod3
                WHEN '201301' >= SUBSTR (o.dat2, 3, 4) || SUBSTR (o.dat2, 1, 2)
                   THEN o.kod2
                WHEN '201301' >= SUBSTR (o.dat, 3, 4) || SUBSTR (o.dat, 1, 2)
                   THEN o.kod1
                ELSE o.kod
           END org, 
           n.usl, ki.gw, ki.reu, ki.kul, ki.nd, ki.vvod, '201301'
FROM  (
                  SELECT   ki.lsk, krt.nabor_id, krt.reu, krt.kul, krt.nd, krt.vvod,
                     --        decode(krt.psch,9,null,decode(spt.tot,0,null,krt.pl_no))
                               sum(case when decode(krt.psch,9,null,decode(spt.tot,0,null,krt.pl_no)) is not null 
                                      or  decode(krt.psch,9,null,decode(spt.tot,0,null,krt.pl_no)) <>0 then coalesce(ki.ot,0) else 0 end) as vol,
                              sum(case when decode(krt.psch,9,null,decode(spt.tot,0,null,krt.pl_no)) is not null 
                                      or  decode(krt.psch,9,null,decode(spt.tot,0,null,krt.pl_no)) <>0 then coalesce(ki.ot,0) else 0 end) as gkal
                    FROM   (select lsk, gw, gw_dop, ot, ot_dop from scott.load_kwni ki
                                where ki.gw<>0 or ki.gw_dop <>0 or ki.ot<>0 or ki.ot_dop <>0
                                ) ki, 
                                prep.load_kartw krt, prep.sptar spt--, scott.s_stra ss
                  WHERE  ki.lsk=krt.lsk and krt.gt=spt.gtr
                  --and ss.nreu=substr(ki.lsk,1,4)
                  --and ss.trest=''65''
                  GROUP BY  ki.lsk, krt.nabor_id, krt.reu, krt.kul, krt.nd, krt.vvod
                  HAVING sum(case when krt.psch=0 and spt.tgw=0 then 0 else ki.gw end)<>0
          ) ki, 
   scott.nabor n, scott.sprorg o
WHERE 
 ki.nabor_id=n.id
      and n.usl='015' 
      and n.org=o.kod

    
select lsk,sum(ot) from scott.load_kwni group by lsk
select pl_no from prep.load_kartw where lsk='07234757'
select * from scott.load_kwni where lsk='07234757'
select spt.tot from prep.sptar spt where gtr='1646'
usl

select sum(gw)+sum(gw_dop)  from scott.load_kwni

select sum(gw_dop) from scott.load_kwni


update prep.load_kartw k set k.nabor_id = (select t.nabor_id from kart t where t.lsk = k.lsk);


insert into scott.t_volume_usl_izm 
select * from SCOTT.T_VOLUME_USL_IZM  AS OF TIMESTAMP
TO_TIMESTAMP('11.02.2013 15:01:45','DD-MM-YY HH24: MI: SS')
where mg='201301' and lsk='65040580'


 SELECT sum (gw),sum(gw_dop)  FROM  scott.load_kwni
 SELECT sum (gw),sum(gw_dop)  FROM  scott.t_volume_usl_izm where mg='201301'
 
 SELECT sum (vol_izm) FROM  scott.info_usl_nd where mg='201301'
  
 FROM
 (
 SELECT ki.lsk, null, null, ki.gw, ki.gw_dop, ka.reu, ka.kul, ka.nd, ka.vvod 
 FROM (
          SELECT  ki.lsk, sum(ki.gw) as gw, sum(ki.gw_dop) as gw_dop 
            FROM  scott.load_kwni ki
          WHERE ki.gw<>0 or ki.gw_dop <>0
          GROUP BY  ki.lsk  ) ki, 
scott.load_kart ka
WHERE 
 ki.lsk=ka.lsk (+))
 
 

 delete  FROM scott.info_usl_nd where mg='201301'

 INSERT INTO scott.info_usl_nd (reu,kul,nd,usl,org,vvod_gw,charges,changes,privs,payment,volume,mg,
                                       psch, kpr, opl, f, f1, dop_opl, dop_kpr, dop_vol, status, vol_izm)
                                       
 SELECT t.reu, t.kul, t.nd, t.usl, t.org, t.vvod_gw, sum(t.charges), sum(t.changes), sum(t.privs) , sum(t.payment), sum(t.volume), t.mg,
              t.psch, sum(t.kpr) , sum(t.opl), sum(f), sum(t.k_sum), sum(t.dop_opl), sum(t.dop_kpr), sum(t.dop_vol), t.status, 
              sum (izm.vol_izm)  as vol_izm
 FROM scott.info_usl_lsk t, (  select lsk, org, usl, sum(gw)+sum(gw_dop) as vol_izm from scott.t_volume_usl_izm where mg='201301'  group by lsk,org,usl  ) izm
 WHERE t.mg = '201301' 
         and t.lsk=izm.lsk    (+)
         and t.org=izm.org  (+)
         and t.usl=izm.usl    (+)
 GROUP BY t.reu, t.kul, t.nd, t.usl, t.org, t.mg, t.psch, t.vvod_gw, t.status
 order by vol_izm asc
  
 SELECT t.reu, t.kul, t.nd, t.usl, t.org, t.vvod_gw, sum(t.charges), sum(t.changes), sum(t.privs) , sum(t.payment), sum(t.volume), t.mg,
              t.psch, sum(t.kpr) , sum(t.opl), sum(f), sum(t.k_sum), sum(t.dop_opl), sum(t.dop_kpr), sum(t.dop_vol), t.status, 
              sum (izm.vol_izm)  as vol_izm
 FROM scott.info_usl_lsk t, (  select lsk, org, usl, sum(gw)+sum(gw_dop) as vol_izm from scott.t_volume_usl_izm where mg='201301'  group by lsk, org, usl  ) izm
 WHERE t.mg = '201301'
         and t.lsk=izm.lsk   (+)
         and t.org=izm.org (+)
         and t.usl=izm.usl   (+)
 GROUP BY t.reu, t.kul, t.nd, t.usl, t.org, t.mg, t.psch, t.vvod_gw, t.status;
 
 
 
 
            
               select  sum(gkal),sum(vol)
               from scott.t_volume_usl_izm where mg='201212'  
               and reu = '73'
               group by lsk,org,usl 
               
              select  sum(gkal_izm),sum(vol_izm) 
               from scott.info_usl_nd where mg='201212'  
               and reu = '73'
               group by lsk,org,usl 

delete from scott.info_usl_nd where mg='201210'
insert into prep.info_usl_nd select * from scott.info_usl_nd where mg='201210'
delete from prep.info_usl_nd where mg='201210'
select * from scott.info_usl_nd where mg='201210'

select sum(vol_izm), sum(gkal_izm)
FROM
(       
 INSERT INTO info_usl_nd ( reu,kul,nd,usl,org,vvod_gw,charges,changes,privs,payment,volume,mg,
                                        psch,kpr,opl, f, f1, dop_opl, dop_kpr, dop_vol,  status, gkal, gkal_n, vol_izm, gkal_izm
                                       )
  SELECT  t.reu, t.kul, t.nd, t.usl, t.org, t.vvod_gw, sum(t.charges), sum(t.changes), sum(t.privs) , sum(t.payment), sum(t.volume), t.mg,
              t.psch, sum(t.kpr) , sum(t.opl), sum(f), sum(t.k_sum), sum(t.dop_opl), sum(t.dop_kpr), sum(t.dop_vol), t.status, sum(t.gkal), sum(t.gkal_n)
              ,sum (case when t.usl<>'007' then izm.vol_izm else 0 end) as  vol_izm
              ,sum (case when t.usl='007' then izm.gkal_izm else 0 end) as gkal_izm
  FROM   scott.info_usl_lsk t , (  select lsk, org, usl, sum(vol) as vol_izm,sum(gkal) as gkal_izm from scott.t_volume_usl_izm where mg='201210'  group by lsk,org,usl  ) izm
  WHERE     t.mg = '201210'
        and   t.lsk  = izm.lsk   (+)
        and   t.org = izm.org (+)
         and   t.usl  = izm.usl   (+)
  GROUP BY t.reu, t.kul, t.nd, t.usl, t.org, t.mg, t.psch, t.vvod_gw, t.status
 ) 
 
 Select sum(vol_izm), sum(gkal_izm) from scott.info_usl_nd 
 where mg = '201212'
                 
 SELECT  t.reu, t.kul, t.nd, t.usl, t.org, t.vvod_gw, sum(t.charges), sum(t.changes), sum(t.privs) , sum(t.payment), sum(t.volume), t.mg,
              t.psch, sum(t.kpr) , sum(t.opl), sum(f), sum(t.k_sum), sum(t.dop_opl), sum(t.dop_kpr), sum(t.dop_vol), t.status, sum(t.gkal), sum(t.gkal_n)
   FROM   prep.info_usl_lsk t 
 WHERE     t.mg = '201302'
 GROUP BY t.reu, t.kul, t.nd, t.usl, t.org, t.mg, t.psch, t.vvod_gw, t.status;
  

select a.rown,a.lsk, a.usl,a.org,b.lsk, b.usl,b.org
from (
        select b.lsk, b.usl,b.org from scott.statistics_lsk b where mg='201211' and lsk='55161412' group by b.lsk, b.usl,b.org
        ) b,
        (select a.*,a.rown from scott.t_volume_usl_izm a where mg='201211' ) a
where a.lsk=b.lsk
and a.usl=b.usl


MERGE INTO scott.t_volume_usl_izm  d
USING (select b.lsk, b.usl, b.org from scott.info_usl_lsk b where mg='201210' group by b.lsk, b.usl,b.org) s
  ON (d.lsk = s.lsk and d.lsk=s.lsk and d.usl=s.usl  and d.mg='201210' )
  WHEN MATCHED THEN
      UPDATE SET d.org = s.org
      
      update scott.t_volume_usl_izm set org=null where mg='201212'
      
      nabor
      
      select t.rowid, t.lsk,t.usl,t.org ,a.org
      from scott.t_volume_usl_izm t , (select lsk,usl,org from scott.info_usl_lsk i where i.mg ='201209') a 
      WHERE a.usl=t.usl and t.lsk=a.lsk
      and  t.mg='201209'
     and t.org is null
  
  
  select * from scott.kart where lsk='24034441'
  select * from scott.load_kwtp where lsk='24034441'
  select * from scott.kart_pr where lsk='24034441'