select sum(summa)
from 
(
select 
         s.lsk, s.summa, substr(o.oigu,2,1) as nal, substr(o.oigu,1,1) as ob, 
         e.trest as fromtrest, nvl(r.type,3) as org_tp
  FROM scott.xxito15_lsk s, scott.kart k, scott.oper o, scott.s_reu_trest e, scott.sprorg r,
           ( select U.USL, vu.usl1, u.for_plan
            FROM  
            (select distinct usl, usl1 from scott.var_usl1) vu , scott.usl u
            where vu.usl=u.usl
            ) u
WHERE
         k.lsk=s.lsk
        -- and e.trest = '04'
       -- and s.lsk='14010003'
         and s.forreu=e.reu 
         and s.org=r.kod(+)
         and s.dat between '01.11.2012' and '30.11.2012' 
         and s.oper=o.oper
         and s.mg='201211'
         and substr(o.oigu,1,1)=1
         and u.for_plan=1
         and u.usl1=s.usl
) d
group by d.lsk
order by d.lsk


