--олап       
       select t.lsk as lsk,
                u.usl,
              sum(t.volume) vl
       from prep.info_usl_lsk t,            scott.s_reu_trest r,            scott.usl u,            scott.sprorg o,            scott.spul ul
       where t.reu= r.reu
         and t.usl= u.usl         and t.org= o.kod         and t.kul= ul.id         and t.reu= '34'         and mg='201210'         and u.usl in ('015','059','060','017','018')
         and  lsk='10174068'
       group by t.lsk,u.usl
       having sum(t.charges)<>0 or sum(t.changes) <>0 or
              sum(t.privs) <>0 or sum(t.volume)<>0
              or sum(t.payment)<>0 or sum(t.opl)<>0 or sum(t.kpr)<>0
       order by t.lsk,u.usl 
       
       select * from scott.load_kartw where abs(mgw)>abs(gw_nor)  
       lsk='10146962'
       sptar
       
       --статитстика
SELECT s.lsk,
     u.usl,
    sum(s.cnt) as cnt
FROM scott.statistics_lsk s, scott.usl u, scott.s_reu_trest t, scott.sprorg p, scott.status m, scott.spul k
WHERE s.reu=t.reu
    and s.usl=u.usl and s.kul=k.id
    and s.org=p.kod
    and s.status=m.id
    and s.reu='34'
    and u.usl in ('015','059')
    and mg= '201210' 
     and  lsk='10174068'
    group by s.lsk,     u.usl
    order by s.lsk,     u.usl