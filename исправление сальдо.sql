select * from scott.saldo where lsk='10140072' AND MG='201310'

select * from scott.t_corrects_payments where lsk='10140072'

        select lsk, org, uslm, sum(summa) as summa, '201311' as mg
          from (select lsk, org, uslm, summa
                  from scott.saldo
                 where mg = '201310' 
                union all
                select c.lsk, c.org, c.uslm, c.summa
                  from scott.t_subsidii_for_saldo c where lsk='10140072'
                union all
                select c.lsk, c.org, c.uslm, c.summa
                  from scott.t_charges_for_saldo c where lsk='10140072'
                union all
                select c.lsk, c.org, c.uslm, c.summa
                  from scott.t_changes_for_saldo c where lsk='10140072'
                union all
                select c.lsk, c.org, c.uslm, c.summa * -1
                  from scott.t_payment_for_saldo c where lsk='10140072'
                )
          where lsk='10140072'
         group by lsk, org, uslm;
         
         select * from scott.a_flow where fk_type=61 and lsk='10140072'
         order by dt1 desc 
         select * from scott.load_kwtp where lsk='10140072'
         
         select * from scott.a_flow_tp
         scott.params
         
         t_payment_for_saldo
         
         scott.v_payment_usl
         
         select distinct dtek from scott.kwtp_day 
         
         select * from scott.kart where lsk='10140072'
         
         select * from scott.load_
         
         
         SELECT  t.lsk, t.kw, t.reu, t.kul, t.nd, t.usl, t.org, t.vvod_gw, sum(t.charges) charges, sum(t.changes) changes, sum(t.privs) privs, sum(t.payment) payment, 
                      sum(t.volume) volume, t.mg, t.psch, sum(t.kpr) kpr, sum(t.opl) opl, sum(f) f, sum(t.k_sum), sum(t.dop_opl) dop_opl, sum(t.dop_kpr) dop_kpr, 
                      sum(t.dop_vol) dop_vol, t.status, sum(t.gkal) gkal, sum(t.gkal_n) gkal_n
                      ,sum (case when t.usl<>'007' then izm.vol_izm else 0 end) as  vol_izm
                      ,sum (case when t.usl='007' then izm.gkal_izm else 0 end) as gkal_izm,
                      decode(T.SCH,0,'мер',1,'дю',5,'гюйнкэж',null,'ме нопедекемн') as sch
          FROM   scott.info_usl_lsk t , (  select mg, lsk, org, usl, sum(vol) as vol_izm,sum(gkal) as gkal_izm 
                                                       from scott.t_volume_usl_izm where mg between '201309' and '201309'  group by lsk,org,usl,mg  ) izm
          WHERE     t.mg  between '201309' and '201309'
                and t.reu='73' and t.kul='0129' and t.nd='000009'
                and   t.lsk  = izm.lsk   (+)
                and   t.org = izm.org (+)
                and   t.usl  = izm.usl   (+)
                and   t.mg = izm.mg (+)
          GROUP BY t.lsk, t.kw, t.reu, t.kul, t.nd, t.usl, t.org, t.mg, t.psch, t.vvod_gw, t.status,decode(T.SCH,0,'мер',1,'дю',5,'гюйнкэж',null,'ме нопедекемн')
          
          spul
          
          
          select sum(mot),sum(mot_n) from prep.load_kartw
          where reu in('23','24','R2')
          
          
          select * from ldo.load_gw
          
          
             select null, round(summa, 2), t.lsk, nvl(t.oper,'75') as oper,
          t.dopl, t.nkom, 1 as nink, trunc(t.dat) as dat_ink, trunc(t.dat) as dtek,
          t.priznak, t.usl, t.usl as usl_b, t.org, substr(o.oigu,1,1) as oborot,
          s.reu as forreu, 'SS' as reu, s.var, s.trest, 0 as ink,
             to_char(t.dat,'DD') as day
        from scott.t_corrects_payments t, scott.s_stra s, scott.params p, scott.oper o
       where t.lsk like s.nreu || '%'
         and t.mg = p.period and nvl(t.oper,'83') = o.oper
         and lsk='10140072'
         
         