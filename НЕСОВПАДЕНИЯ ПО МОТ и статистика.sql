select sum(cnt2) from scott.statistics_lsk 
where usl in ('015','007')
and mg = '201301'
--and reu = '73'



scott.usl

select sum(mot), sum(mot_n)
FROM 
 (
        select sum(mot) 
        FROM scott.load_kartw
        where
     
    --    and reu='73'
        
  )
  
  se
  update SCOTT.INFO_USL_LSK i 
    set gkal = (select mot from scott.load_kartw k where i.lsk=k.lsk )
  where i.mg='201301' 
  and usl = '007'
 
 Update t_volume_usl i 
  set gkal = (select mot from scott.load_kartw k where i.lsk=k.lsk )
  where usl='007'
  
  Update t_volume_usl i set gkal =0, gkal_n=0
  
  select * from scott.t_volume_usl where usl='007' 
  
  MERGE INTO  t_volume_usl dest
  USING (SELECT lsk, mot, mot_n  FROM load_kartw) source1
      ON (dest.lsk = source1.lsk and dest.usl='007')
      WHEN MATCHED THEN
          UPDATE SET dest.gkal_n = source1.mot_n,
                             dest.gkal = source1.mot
 
          select sum(gkal), sum(gkal_n) from scott.info_usl_nd where mg='201301' and usl='007'
          
          SELECT  reu, kul, nd, status, vvod_gw, org
          FROM   scott.info_usl_nd 
          WHERE mg='201301' and usl='007'
          
          Update scott.info_usl_nd set gkal =0, gkal_n=0 where mg='201301' and usl='007'
          
  MERGE INTO  info_usl_nd d
  USING (
                 SELECT k.reu, k.kul, k.nd, t.org, k.status, K.VVOD_GW,
                              sum(gkal) gkal, sum(gkal_n) gkal_n FROM t_volume_usl t, scott.load_kartw k
                 WHERE  t.lsk=k.lsk 
                       and usl='007'
                 GROUP BY k.reu, k.kul, k.nd, t.org, k.status, K.VVOD_GW
                 HAVING sum(gkal)<>0 or  sum(gkal_n)<>0
                 order by k.reu, k.kul, k.nd
             ) s
      ON ( d.reu=s.reu and d.kul=s.kul and d.nd=s.nd and d.org=s.org and d.status=s.status and d.org=s.org  and d.VVOD_GW=s.vvod_gw
                and d.mg='201301' and usl='007')
      WHEN MATCHED THEN
          UPDATE SET d.gkal_n = s.gkal_n,
                             d.gkal = s.gkal                                   
  
  
 select psch, sum(mot),sum(mot_n) from scott.load_kartw
 group by psch
 
 union all
 select sum(gkal),sum(gkal_n) from t_volume_usl i
 union all 
 select sum(cnt2), 0 from scott.statistics_lsk 
 where mg='201301'
 
 select sum(mot) from scott.load_kartw
 union all
 select sum(gkal_n) from t_volume_usl i
 

 select sum(gkal) from scott.info_usl_lsk where
 mg='201301'
 and usl = '007'
 and gkal<>0
 and reu='73'
 
select * 
from scott.load_kartw 
--scott.statistics_lsk 
where lsk='05294726'

select * 
from scott.statistics_lsk 
where lsk='05294726'
and  mg='201301'

select * from scott.temp_stat where lsk='05294726'

koop
sptar

select * from scott.info_usl_lsk
where lsk='07236946'
and  mg='201301'
order by usl



SELECT lsk
, a.info_summa-b.stat_summa 
FROM
   (
        select lsk, sum(gkal) info_summa
        from scott.info_usl_lsk
        where  mg='201301'
        group by lsk
        having sum(gkal)<>0
        ) a FULL OUTER JOIN
   (
        select lsk, sum(cnt2) as stat_summa 
        from scott.statistics_lsk 
        where  mg='201301'
        group by lsk
        having sum(cnt2)<>0
    ) b
USING (lsk)
WHERE  a.info_summa-b.stat_summa  <>0



        select sum(gkal) info_summa
        from scott.info_usl_lsk
        where  mg='201301'
  --      and reu='73'
        group by lsk
        having sum(gkal)<>0
        ) a,
   (
        select sum(cnt2) as stat_summa 
        from scott.statistics_lsk 
        where  mg='201301'
     
        having sum(cnt2)<>0



select name_tr, trest, count (lsk) FROM
(
    select lsk, status, Name_tr,trest, coalesce(krtmot,0), coalesce(statmot,0) 
    FROM 
        (
            select lsk,status, sum(mot) krtmot
            FROM scott.load_kartw
            WHERE status IN (8, 9, 10, 11, 12)
            group by lsk, status
        ) krt
    FULL OUTER JOIN
        ( 
           select lsk, sum(cnt2) statmot
           from scott.statistics_lsk
           where  mg='201301'
           group by lsk
        ) stat  
    USING (lsk) left join scott.s_stra s ON substr(lsk,1,4) = s.nreu
    WHERE coalesce(krtmot,0)-coalesce(statmot,0)<>0
)
GROUP BY name_tr,trest

scott.s_stra

scott.s_reu_trest

params