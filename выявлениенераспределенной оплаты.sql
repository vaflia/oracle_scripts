select a.lsk, b.ska, a.summa
           from
      (
      select lsk, sum(decode(t.priznak, 1, summa, 0 )) as summa,
          sum(decode(t.priznak, 0, summa, 0)) as penya
          from scott.kwtp_day t, scott.oper o
       where t.lsk <>'00009999' and t.dat_ink between '01.12.2012' and '31.12.2012'
       and t.oper=o.oper /*and o.tp_cd not in ('MU')*/
        and not exists
      (select * from ldo.l_regxpar x, ldo.l_par r
        where x.fk_par=r.id and r.cd='NKOM' 
        and x.s1=t.nkom)
        group by lsk
        
       ) a,
      (select lsk, sum(ska) as ska, sum(pn) as pn from scott.load_kwtp t, scott.oper o
             where t.lsk <>'00009999' and t.dat_ink between '01.12.2012' and '31.12.2012'
             and t.oper=o.oper /*and o.tp_cd not in ('MU')*/
                     and not exists
                    (select * from ldo.l_regxpar x, ldo.l_par r
                      where x.fk_par=r.id and r.cd='NKOM' 
                      and x.s1=t.nkom)
                    group by lsk  
             ) b
      where (nvl(b.ska,0) <> nvl(a.summa,0) or nvl(b.pn,0) <> nvl(a.penya,0)) and
      a.lsk=b.lsk
            select * from scott.load_kwtp where lsk= '04221652'
            select * from scott.kwtp_day where lsk= '04221652'
