SELECT       s.trest || '  ' || s.name_tr as name_tr, SP.NAME || '  ' || ltrim(k.ND,'0') as name_ul, p.dt1 as dtek, s.reu,s.trest,
                      --      sum(CASE WHEN p.TP_CD='PAY' THEN summa ELSE 0 end)  SKA,
                       --     sum(CASE WHEN p.TP_CD='PEN' THEN summa ELSE 0 end)  PN,
                        --    sum(CASE WHEN substr(op.oigu,1,2)='10' then summa else 0 end) BN,
                         --   1 as pay, sp.id as kul
                  FROM  scott.l_pay p, scott.s_stra s, scott.oper op, scott.usl u,scott.kart K, scott.spul SP
                WHERE       p.dt1 =:d
                        AND p.oper = op.oper 
                        AND p.fk_usl = u.usl
                        AND substr(p.lsk,1,4) = s.nreu 
                        AND k.kul = sp.id     
                        AND k.lsk=p.lsk         
            --            AND P.TP_CD   in ('PAY','PEN')
                        AND P.PAY_CD in ('MN')
          --              AND op.tp_cd  in ('MU')     
                        AND p.lsk not  in ('99999999')      
                GROUP BY  s.trest || '  ' || s.name_tr, SP.NAME || '  ' || ltrim(k.ND,'0'),s.trest, s.reu, p.dt1, sp.id 
                
                select * from scott.l_pay p where p.pay_cd='HD'
                scott.s_stra
                scott.v_l_pay
                
select * from scott.l_pay p where lsk=87011627
and pay_cd='MN'
union all
select * from scott.l_pay p where id=3842879


 select * from ldo.l_list_reg where id=559124