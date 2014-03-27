--статитстика
SELECT s.lsk,
     u.usl,
    sum(s.cnt) as cnt
FROM scott.statistics_lsk s, scott.usl u, scott.s_reu_trest t, scott.sprorg p, scott.status m, scott.spul k
WHERE s.reu=t.reu
    and s.usl=u.usl and s.kul=k.id
    and s.org=p.kod
    and s.status=m.id
    and t.trest='04'
    and status NOT IN (8, 9, 10, 11, 12)
    --and kul='0067'
    --and s.nd='000018'
    and lsk='04050032' 
   -- and u.usl in ('015','016','059')
    and mg= '201212' 
    group by s.lsk,  u.usl
 --  having     sum(cnt)<>0
    order by s.lsk,   u.usl
       
    
select --sum(dop_gw)
    kw.mgw, kw.kpr, kw.kpr_ot, kw.gw_nor, kw.* from scott.load_kartw kw, scott.s_reu_trest s
where lsk='04050032' 
and s.reu=kw.reu 
and s.trest='04'

select * from scott.kart where lsk='04050004'

select sum(gw), sum(gw_dop) from scott.load_kwni k, scott.s_stra s
where substr(k.lsk,1,4)=s.nreu 
          and s.trest='04' and  lsk='04050004'
          
select t.lsk, sum(t.hw) as hw, sum(t.hw_dop) as hw_dop, sum(t.gw) as gw, 
       sum(t.gw_dop) as gw_dop,
       sum(t.kwt) as kwt, sum(t.kwt_dop) as kwt_dop
       from load_kwni t, params p
       where to_char(t.dtek,'YYYYMM')='201212'
       group by t.lsk

scott.usl

prep.usl
scott.usl


--статитстика
SELECT s.lsk,
     u.usl,
    sum(s.cnt) as cnt
FROM scott.statistics_lsk s, scott.usl u, scott.s_reu_trest t, scott.sprorg p, scott.status m, scott.spul k
WHERE s.reu=t.reu
    and s.usl=u.usl and s.kul=k.id
    and s.org=p.kod
    and s.status=m.id
    and status NOT IN (8, 9, 10, 11, 12)
    and s.reu='04'
 --   and u.usl in ('015','059')
    and mg= '201212' 
     and lsk='04050032' 
    group by s.lsk,   u.usl
    order by s.lsk,  u.usl
    
