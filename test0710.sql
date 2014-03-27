/*проверки*/
select trest,org,reu,kul,nd,uslm,uch, a.indebet, b.indebet
FROM
(SElECT s.trest,o.org,o.reu,o.kul,o.nd,o.uslm,o.uch,
sum(o.indebet) as indebet, sum(o.inkredit) as inkredit,
          sum(o.charges) as charges, sum(o.changes) as changes, sum(o.subsid) as subsid, sum(o.privs) as privs, sum(o.privs_city) as privs_city, sum(o.payment) as payment,
          sum(o.pn) as pn, sum(o.outdebet) as outdebet, sum(o.outkredit) as outkredit
FROM scott.xitog2_s_lsk o
, scott.s_stra s
WHERE
 --s.trest='49 'and
o.mg='201309' and 
s.nreu=substr(o.lsk,1,4)      
group by s.trest,o.org,o.reu,o.kul,o.nd,o.uslm,o.uch
) a
FULL OUTER JOIN
(
SElECT s.trest,o.org,o.reu,o.kul,o.nd,o.uslm,o.uch,
sum(o.indebet) as indebet, sum(o.inkredit) as inkredit,
          sum(o.charges) as charges, sum(o.changes) as changes, sum(o.subsid) as subsid, sum(o.privs) as privs, sum(o.privs_city) as privs_city, sum(o.payment) as payment,
          sum(o.pn) as pn, sum(o.outdebet) as outdebet, sum(o.outkredit) as outkredit
FROM scott.xitog2_s o
, scott.s_reu_trest s
WHERE
  --s.trest='49 'and
o.mg='201309' and 
s.reu=o.reu    
group by s.trest,o.org,o.reu,o.kul,o.nd,o.uslm,o.uch
)b 
USING  (trest,org,reu,kul,nd,uslm,uch)
WHERE 
    coalesce(a.indebet,0)<>coalesce(b.indebet,0) or 
    coalesce(b.charges,0)<>coalesce(b.charges,0) or 
    coalesce(a.changes,0)<>coalesce(b.changes,0) or 
    coalesce(a.subsid,0)<>coalesce(b.subsid,0) or 
    coalesce(a.privs,0)<>coalesce(b. privs,0) or 
    coalesce(b.privs_city,0)<>coalesce(b.privs_city,0) or 
    coalesce(a.payment,0)<>coalesce(b.payment,0) or 
    coalesce(a.pn,0)<> coalesce(b.pn,0) or  
    coalesce(a.outdebet,0)<>coalesce(b.outdebet,0) or  
    coalesce(a.outkredit,0)<>coalesce(b.outkredit,0)

SELECT 
 sum(i.indebet) as indebet, sum(i.inkredit) as inkredit,
          sum(o.charges) as charges, sum(o.changes) as changes, sum(o.subsid) as subsid,
          sum(o.privs) as privs, sum(o.privs_city) as privs_city, sum(o.payment) as payment,
          sum(o.pn) as pn, sum(u.outdebet) as outdebet, sum(u.outkredit) as outkredit
FROM
          (select e.*, u.type, s.trest from scott.t_reu_kul_nd_status e, scott.sprorg u,
           scott.s_reu_trest s where e.org=u.kod and e.reu=s.reu --and e.reu='73'
           ) h,
           
           scott.xitog2_s i,
           
          ( SELECT reu,kul,nd,status,org,uslm,uch,mg,sum(charges) as charges,
                        sum(changes) as changes, sum(subsid) as subsid, sum(privs) as privs, sum(privs_city) as privs_city,
                        sum(payment) as payment, sum(pn) as pn 
            FROM   scott.xitog2_s t
            WHERE t.reu='L1' and  
                        t.mg between '201308' and '201308'
            GROUP BY reu,kul,nd,status,org,uslm,uch,mg) o,
            
           scott.xitog2_s u,
           
          (select * from scott.period_reports t where id=14) x,
          
          scott.sprorg d, scott.uslm m, scott.org l, scott.s_reu_trest t, scott.spul k, scott.status_gr st
WHERE 
          h.status=st.id and
          h.reu=i.reu(+) and h.kul=i.kul(+) and h.nd=i.nd(+) and h.org=i.org(+) and h.uslm=i.uslm(+) and h.status=i.status(+) and
          h.uch=i.uch and
          h.reu=o.reu(+) and h.kul=o.kul(+) and h.nd=o.nd(+) and h.org=o.org(+) and h.uslm=o.uslm(+) and h.status=o.status(+) and
          h.uch=o.uch and
          h.reu=u.reu(+) and h.kul=u.kul(+) and h.nd=u.nd(+) and h.org=u.org(+) and h.uslm=u.uslm(+) and h.status=u.status(+) and
          h.uch=u.uch and
          l.id=1 and h.org=d.kod and h.uslm=m.uslm and h.reu=t.reu and h.kul=k.id
          and x.mg=i.mg and x.mg=o.mg and x.mg=u.mg
          and x.mg between '201308' and '201308' 
          
          
--GROUP BY x.mg, substr(x.mg, 1, 4)||'-'||substr(x.mg, 5, 2), t.trest||' '||t.name_tr, h.reu, k.name||', '||NVL(LTRIM(h.nd,'0'),'0'), st.name, h.type, h.uch, TO_CHAR(d.kod)||' '||d.name, m.nm1
--ORDER BY x.mg
          
UNION ALL

SELECT 
 sum(o.indebet) as indebet, sum(o.inkredit) as inkredit,
          sum(o.charges) as charges, sum(o.changes) as changes, sum(o.subsid) as subsid,
          sum(o.privs) as privs, sum(o.privs_city) as privs_city, sum(o.payment) as payment,
          sum(o.pn) as pn, sum(o.outdebet) as outdebet, sum(o.outkredit) as outkredit
FROM
          select count (*) from (
            select e.*, u.type, s.trest from scott.t_reu_kul_nd_status e, scott.sprorg u,
             scott.s_reu_trest s where e.org=u.kod(+) and e.reu=s.reu (+)--and e.reu='73'
           ) h,
          ( SELECT reu,kul,nd,status,org,uslm,uch,mg, sum(indebet) as indebet, sum(inkredit) as inkredit,sum(charges) as charges,
                        sum(changes) as changes, sum(subsid) as subsid, sum(privs) as privs, sum(privs_city) as privs_city,
                        sum(payment) as payment, sum(pn) as pn,sum(outdebet) as outdebet, sum(outkredit) as outkredit
            FROM   scott.xitog2_s_lsk t
            WHERE t.reu='L1' and  
                        t.mg between '201308' and '201308'
            GROUP BY reu,kul,nd,status,org,uslm,uch,mg
            ) o--,
          --(select * from scott.period_reports t where id=14) x--,
         --  scott.sprorg d, scott.uslm m, scott.org l--, scott.s_reu_trest t--, scott.spul k--, scott.status st
WHERE 
      --   h.status=st.id and
          h.reu=o.reu(+) and h.kul=o.kul(+) and h.nd=o.nd(+) and h.org=o.org(+) and h.uslm=o.uslm(+) and h.status=o.status(+) 
          and h.uch=o.uch(+) and
          h.uslm=o.uslm (+)-- and 
  --        l.id=1 and 
        --  x.mg=o.mg 
        --  and x.mg between '201308' and '201308' 
        --  h.org=d.kod and 
        ---  h.uslm=m.uslm and 
          
      --    and o.uslm='015'
       --   and t.trest='07' 
     --     and h.reu=t.reu and
       --         h.kul=k.id

          --   h.reu=u.reu(+) and h.kul=u.kul(+) and h.nd=u.nd(+) and h.org=u.org(+) and h.uslm=u.uslm(+) and h.status=u.status(+) and
          --   and x.mg=i.mg
          --   and x.mg=u.mg 
                    --h.reu=i.reu(+) and 
          --h.kul=i.kul(+) and h.nd=i.nd(+) 
          --and h.org=i.org(+) and 
          --h.uslm=i.uslm(+) and h.status=i.status(+) and
        --  h.uch=i.uch and          
          
--GROUP BY x.mg, substr(x.mg, 1, 4)||'-'||substr(x.mg, 5, 2), t.trest||' '||t.name_tr, h.reu, k.name||', '||NVL(LTRIM(h.nd,'0'),'0'), st.name, h.type, h.uch, TO_CHAR(d.kod)||' '||d.name, m.nm1
--ORDER BY x.mg
          


select 1,uslm, sum(indebet) as indebet, sum(inkredit) as inkredit,sum(charges) as charges,
                        sum(changes) as changes, sum(subsid) as subsid, sum(privs) as privs, sum(privs_city) as privs_city,
                        sum(payment) as payment, sum(pn) as pn,sum(outdebet) as outdebet, sum(outkredit) as outkredit
from scott.xitog2_s where mg='201309' and reu='70'
group by uslm
order by uslm
union all
select 2,uslm,sum(indebet) as indebet, sum(inkredit) as inkredit,sum(charges) as charges,
                        sum(changes) as changes, sum(subsid) as subsid, sum(privs) as privs, sum(privs_city) as privs_city,
                        sum(payment) as payment, sum(pn) as pn,sum(outdebet) as outdebet, sum(outkredit) as outkredit                   
from scott.xitog2_s_lsk where mg='201309' and reu='70'
group by uslm
order by uslm
 

select count (*) from scott.t_reu_kul_nd_status

    insert into scott.t_reu_kul_nd_lsk_status
      (lsk, reu, kul, nd, org, uslm, status, uch)
      select distinct t.lsk, t.reu, t.kul, t.nd, t.org, t.uslm, t.status, uch
        from scott.xitog2_s_lsk t