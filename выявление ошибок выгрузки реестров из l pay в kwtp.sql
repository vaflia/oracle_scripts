SELECT a.name, a.*, a.itg as l_pay_summa, b.summa as kwtp_sum, coalesce(a.itg,0)-coalesce(b.summa,0) as diff/*, nvl(a.itg,0)/nvl(b.summa,0) as diff2*/ 
FROM 
    (
    SELECT max(t.fk_list_reg) as max_fk_list_reg, r.fk_reg, x.s1 as nkom, r.num_reg as nink, sum(t.summa) as itg, sum(decode(t.tp_cd,'PAY',t.summa,0)) as summa, 
             sum(decode(t.tp_cd,'PEN',t.summa,0)) as pn, g.name
     FROM scott.l_pay t, ldo.l_list_reg r, ldo.l_regxpar x, ldo.l_par p,
                params pr, oper o, ldo.l_reg g
     WHERE t.fk_list_reg=r.id
                and x.fk_reg=r.fk_reg 
                and x.fk_par=p.id and p.cd='NKOM' 
                and r.dt1 between to_date(pr.period||'01', 'YYYYMMDD') and last_day(to_date(pr.period||'01', 'YYYYMMDD'))
                and t.oper=o.oper
                and t.pay_cd=case when o.tp_cd='ND' then 'PP' else 'PU' end--контроль платежей газпром-онлайн 
                and r.state_cd in ('LD','KW')
                and t.dt1 between to_date(pr.period||'01', 'YYYYMMDD') and last_day(to_date(pr.period||'01', 'YYYYMMDD'))
                and g.id=r.fk_reg
                group by r.fk_reg, x.s1, r.num_reg, g.name
    ) a,
    (
        SELECT t.nkom, t.nink, coalesce(sum(t.ska),0)+coalesce(sum(t.pn),0) as summa from ldo.l_kwtp t, params p
        WHERE to_char(t.dat_ink,'YYYYMM')=p.period
            and exists
        (SELECT * from ldo.l_regxpar x, ldo.l_par p 
         WHERE x.fk_par=p.id 
                    and p.cd='NKOM'
                    and x.s1=t.nkom)
        group by t.nkom, t.nink
    ) b
where a.nkom=b.nkom(+) and a.nink=b.nink(+) 
and coalesce(a.itg,0)-coalesce(b.summa,0)<> 0
order by a.nkom, a.nink

ldo.l_kwtp

select * from scott.l_pay where lsk='38042748' and trunc(dt1,'MM')='01.01.2013' and summa<1

select  * from scott.l_pay where id in('5691229','5691230','5691240')          

update scott.l_pay set summa = round(summa,2) 
where id in('5691229','5691230','5691240')          


select * from ldo.l_kwtp where lsk='38042748'

select * from saldo where lsk='93218445'
