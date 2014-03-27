    SELECT 
       sum(opl), for_plan, usl
    FROM (
  
  (
         SELECT sum(a.ska)+ sum(a.pn) as opl, for_plan, usl
            FROM
                  (  SELECT    h.lsk, u.usl, op.oper, op.oigu,
                                    h.dtek, s.reu, s.trest,
                                    sum(b.ska) ska, sum(b.pn) pn,    
                                    sum(case when substr(op.oigu,1,1) = '1' then b.ska+b.pn else 0 end) bn, 
                                    0 as pay, sp.id as kul,k.nd as nd, u.for_plan
                      FROM     prep.kwtp_h h, prep.kwtp_b b, scott.s_stra s, scott.oper op, scott.kart K, scott.spul SP,
                                    scott.usl u
                    WHERE      h.id = b.id
                       AND      k.kul = sp.id                    
                       AND      k.lsk = h.lsk                      
                       AND      op.tp_cd not in ('ND')        -- не берет платежи банка             
                       AND      substr(h.lsk,1,4) = s.nreu                     
                       AND      h.oper = op.oper
                       AND      u.usl = b.usl (+)
                       AND      b.dtek between '01.12.2012' and '30.12.2012'
                       AND      h.dtek between '01.12.2012' and '30.12.2012'
                    GROUP BY    h.lsk, s.trest, s.reu, h.dtek, sp.id, k.nd, u.for_plan , u.usl, op.oper, op.oigu
                    ORDER BY       h.lsk, u.usl, op.oper
                  ) A,
                  (   SELECT distinct ku.reu,ku.kul,ku.nd,ku.uch 
                           FROM scott.koop_uch ku
                  ) b 
            WHERE 
                   a.reu = b.reu (+)
            AND  a.kul = b.kul (+)
            AND a.nd  = b.nd (+)
            GROUP BY for_plan, usl
    ) 
        UNION ALL
                --запрос для вставки в олап всех услуг по l_pay
    (   SELECT sum(a.ska)+ sum(a.pn) as opl, a.for_plan, usl
            FROM
             (SELECT   p.lsk, s.reu, sp.id as kul, k.nd as nd, u.for_plan,
                                sum(CASE WHEN p.TP_CD='PAY' THEN p.summa ELSE 0 end)  SKA,
                                sum(CASE WHEN p.TP_CD='PEN' THEN p.summa ELSE 0 end)  PN,
                                u.usl
                      FROM  scott.l_pay p, scott.s_stra s, scott.oper op,
                                (
                                   select U.USL, vu.usl1, u.for_plan
                                        FROM  
                                        (select distinct usl,usl1 from scott.var_usl1) vu , scott.usl u
                                        where vu.usl=u.usl
                                  ) u,
                         scott.kart K, scott.spul SP, ldo.l_list_reg lr
                    WHERE       p.dt1 between '01.11.2012' and '30.11.2012'
                            AND p.oper = op.oper 
                            AND p.fk_usl = u.usl1
                            AND substr(p.lsk,1,4) = s.nreu 
                            AND k.kul = sp.id     
                            AND k.lsk=p.lsk         
                            AND P.TP_CD   in ('PAY','PEN')
                            AND P.PAY_CD in ('PU')
                         --   AND op.tp_cd  in ('MU')     
                            AND p.lsk not  in ('99999999')      
                            AND  lr.state_cd in ('KW')  -- берет токо реестры выгруженные в квартплату
                            AND  lr.id=p.fk_list_reg
                      --       AND s.trest='04'
                      --          and  p.lsk='14010003'
                      --   AND  u.for_plan=1
                    GROUP BY  p.lsk, s.trest, s.reu, sp.id, k.nd, u.for_plan, u.usl
                    )
                    A,
            (SELECT distinct ku.reu,ku.kul,ku.nd,ku.uch 
               FROM  scott.koop_uch ku
            ) b
            WHERE 
                   a.reu = b.reu (+)
            AND a.kul = b.kul  (+)
            AND a.nd  = b.nd  (+) 
            GROUP BY a.for_plan, usl
)  
UNION ALL
   (  
          SELECT sum(ska)+sum(pn) as opl, for_plan,usl
            FROM
            (SELECT   s.trest || '  ' || s.name_tr as name_tr, SP.NAME || '  ' || ltrim(k.ND,'0') as name_ul, p.dat as dtek, s.reu, s.trest,
                           sum(case when p.priznak=1 then p.summa else 0 end) SKA,
                           sum(case when p.priznak=0 then p.summa else 0 end)  PN,
                           2 as pay, sp.id as kul,k.nd as nd, u.for_plan, u.usl
                 FROM scott.t_corrects_payments p, scott.s_stra s, scott.kart K, scott.spul SP, scott.usl u
               WHERE  p.mg='201211'
               AND      substr(p.lsk,1,4) = s.nreu
               AND      k.kul = sp.id     
               AND      k.lsk=p.lsk      
               AND      p.usl = u.usl   
               GROUP BY s.trest || '  ' || s.name_tr, SP.NAME || '  ' || ltrim(k.ND,'0'),p.dat,s.trest,s.reu, sp.id ,k.nd, u.for_plan, u.usl
               ) A,
            (SELECT distinct ku.reu,ku.kul,ku.nd,ku.uch 
            FROM scott.koop_uch ku

            ) b 
            WHERE 
                   a.reu = b.reu (+)
            AND  a.kul = b.kul (+)
            AND a.nd  = b.nd  (+)
            GROUP BY for_plan,usl
    ) 
)
GROUP BY for_plan, usl