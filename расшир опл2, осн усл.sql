select sum(summa)
from
(
select  
    s.lsk, u.usl, u.for_plan,
    sum (summa) as summa--,u.usl, o.oper
         --LTRIM(k.nd,'0')||'-'||LTRIM(k.kw,'0') as nd1, 
         --s.forreu as forreu, null as lsk, k.kul, e.trest as fromtrest, nvl(r.type,3) as org_tp
         FROM scott.xxito15_lsk s, scott.kart k, scott.oper o, scott.s_reu_trest e, scott.sprorg r,
         scott.usl u 
      /*   ( 
            SELECT U.USL, vu.usl1, u.for_plan
            FROM  
               ( select distinct usl, usl1 from scott.var_usl1) vu , scott.usl u
                 where vu.usl=u.usl
              ) u*/
          where
         k.lsk=s.lsk 
    --     and s.trest='93' 
         and s.reu=e.reu and s.org=r.kod (+)
         and s.dat between '01.11.2012' and '30.11.2012'
         and s.mg='201211'
         and s.oper=o.oper
         --  and o.tp_cd not in ('ND')
         and s.lsk='36012241'
         and substr(o.oigu,1,1)='1' -- добавить убрать если надо видеть оборотные или не оборотные деньги
         and u.for_plan=1
         and u.usl=s.usl
 group by s.lsk, u.usl, u.for_plan
 order by lsk--,u.usl, o.oper
)
 
 
 
 
 scott.period_reports
 
 select U.USL, vu.usl1, u.for_plan
 FROM  
    (select distinct usl,usl1 from scott.var_usl1) vu , scott.usl u
    where vu.usl=u.usl
 
select * from prep.l_kwtp_11 where lsk='04160805'
select * from scott.t_corrects_payments where lsk='14010003'
select * from scott.l_pay where lsk='14010003'
select * from scott.xxito15_lsk where lsk='14010003' and mg='201211'
create table prep.l_kwtp_11 as select * from ldo.l_kwtp
 