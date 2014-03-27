select -- coalesce(lag(sobr_plat-ink+ost) over (order by dat),0) vh_ost,
 coalesce(sum(sobr_plat-ink) OVER (ORDER BY dat rows between unbounded PRECEDING and 1 PRECEDING ),0) as n_ost ,
a.dat,  a.sobr_plat,  a.ink,
 sum(sobr_plat-ink) OVER (ORDER BY dat) as ish_ost 
FROM
       (
       select '01.09.2013' as dat, 500 as sobr_plat, 450 as ink from dual
union select '02.09.2013' as dat, 400 as sobr_plat, 400 as ink from dual
union select '03.09.2013' as dat, 0 as sobr_plat, 50 as ink from dual
union select '04.09.2013' as dat, 500 as sobr_plat, 300 as ink from dual
union select '05.09.2013' as dat, 450 as sobr_plat, 200 as ink from dual
union select '06.09.2013' as dat, 150 as sobr_plat, 100 as inkt from dual
union select '07.09.2013' as dat, 300 as sobr_plat, 700 as inkt from dual
union select '08.09.2013' as dat, 230 as sobr_plat, 50 as ink from dual
) a

select name, applied from v$archived_log;


select mg,ost,rn,
 sum(rn) over (order by mg rows between 1 PRECEDING and 0 following) as b,
 dense_rank()
      over (partition by rn order by mg)
 -- ,row_number () over (partition by lsk order by aa desc)
FROM
prep.andrey 





create table prep.andrey 
as 
select mg, ost,
-- row_number () over (partition by lsk order by mg desc) as rn,--, 
 --case when (sum(ost) OVER (ORDER BY MG))>0 then 1 else 0 end as asd,
 case when ost<0 then row_number () over (partition by lsk order by mg asc) else 0 end as rn
 /*
 case when ost<0 then ROWNUM-rownum else rownum end as AA1,
 ROWNUM,
  sum(ost) OVER (ORDER BY MG) as sum,
 case when (case when ost<0 then 0 else 1 end)=0 then  
    coalesce(sum(ost) OVER (ORDER BY mg rows between 0 PRECEDING and 3 following ),0) else 0 
 end as ad*/
FROM
       (
SELECT o.lsk, o.mg, o.dt2, o.ost_s ost
  FROM fkv.sum_ost_client o
 WHERE o.typop_id=-1 
   AND o.lsk='04088822'
) a