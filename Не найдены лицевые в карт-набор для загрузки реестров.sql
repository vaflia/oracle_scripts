select  lsk
        from ldo.l_load1 t
       where t.lsk <> '99999999'
         and not exists (select *
                from kart k, nabor d
               where k.lsk = t.lsk
                 and k.nabor_id = d.id)
                 
                 select * from scott.kart where lsk='56010920'
                 
                select * from oralv.u_meter_vol
                
                select * from scott.cap_flow_lsk where flow_id=303073
                select t.*,t.rowid from scott.cap_flow_nd t where flow_id=303073
                select * from scott.cap_transactions where id=303073
                
                select nvl(sum(t.summa),0) 
                   from cap_flow_nd t
                  where t.oper_id = 15
                    and t.mg between substr('2007', 1, 4)||'01' and substr('2007', 1, 4)||'12' --ред. LEV, 23.09.11
                    and t.reu = '27'
                    and t.kul = '0257'
                    and t.nd = '000005'
                    
                       select max(yy), max(reu) 
                        from (select substr(t.mg,1,4) as yy, t.reu
                                 from cap_flow_nd t 
                                where t.status_id = 0
                                  and t.oper_id in (15)
                    and t.kul = '0257'
                    and t.nd = '000005'
                                group by substr(t.mg,1,4), t.reu, t.kul, t.nd
                                having nvl(sum(t.summa),0) <> 0
                                order by substr(mg,1,4) asc
                                ) where rownum=1
                                
                          
                 select k.lsk,  26, k.status_id,sum(k.summa),
                     sum(round(0.01* k.summa / t.summa, 6)) as c, sysdate,
                      k.kul, k.nd
                from cap_flow_lsk k,
                     (select sum(summa) summa
                         from cap_flow_nd t
                        where oper_id = 15
                          and t.mg between substr('2007', 1, 4)||'01' and substr('2007', 1, 4)||'12' --ред. LEV, 23.09.11
                          and reu ='27'
                        and t.kul = '0257'
                        and t.nd = '000005') t
               where k.oper_id = 15
                 and k.mg between substr('2007', 1, 4)||'01' and substr('2007', 1, 4)||'12' --ред. LEV, 23.09.11
                        and k.reu ='27'
                        and k.kul = '0257'
                        and k.nd = '000005'
               group by k.lsk, k.status_id,  k.kul, k.nd;
               
               select t.*,t.rowid from scott.cap_flow_lsk t where flow_id= 303073
               
               select distinct dtek from ldo.l_kwtp_prep
               scott.reports
               
               