SELECT dtek,    pay, bank_summa, pay -bank_summa
FROM
  ( SELECT  --id,num_reg, 
     --lsk,
                  a.dtek,  sum(a.ska)+ sum(a.pn) pay
                FROM
                 (
                 SELECT  lr.id, lr.num_reg, k.lsk, p.dt1 as dtek,
                                    sum(CASE WHEN p.TP_CD='PAY' THEN p.summa ELSE 0 end)  SKA,
                                    sum(CASE WHEN p.TP_CD='PEN' THEN p.summa ELSE 0 end)  PN
                          FROM  scott.l_pay p, scott.s_stra s, scott.oper op,
                                 (  SELECT U.USL, vu.usl1, u.for_plan
                                     FROM  
                                       (select distinct usl,usl1 from scott.var_usl1) vu , scott.usl u
                                        where vu.usl=u.usl
                                  ) u,
                                      scott.kart K, scott.spul SP, ldo.l_list_reg lr
                        WHERE       p.dt1 between '01.06.2013' and '30.06.2013'
                                AND p.oper = op.oper 
                                AND p.fk_usl = u.usl1
                                AND substr(p.lsk,1,4) = s.nreu 
                                AND k.kul = sp.id     
                                AND k.lsk=p.lsk         
                                AND P.TP_CD in ('PAY','PEN')
                                AND P.PAY_CD in ('PU')
                              --  AND op.tp_cd  in ('MU')     
                                AND  lr.state_cd in ('KW')  -- берет токо реестры выгруженные в квартплату
                                AND p.lsk not  in ('99999999')      
                                AND  lr.id=p.fk_list_reg
                       --         and lr.num_reg=64
                        GROUP BY  k.lsk, p.dt1,lr.id, lr.num_reg
                        ) a
     group by  --id,num_reg,
     -- lsk, 
               a.dtek   
   )  a                 
FULL OUTER JOIN           
    (
        SELECT --nink, 
        --lk.lsk, 
                lk.dtek, sum(ska) + sum(pn) as bank_summa
            FROM  scott.load_kwtp  lk, scott.s_stra s, scott.oper op 
        WHERE  lk.dtek  between '01.03.2013' and '31.03.2013'
           AND  lk.lsk not in ('00009999')
           AND  op.oper=lk.oper and op.tp_cd not in ('ND')
           AND  substr(lk.lsk,1,4) = s.nreu
         --  and nink=64
           AND  exists
        (SELECT distinct r2.s1 as nkom 
             FROM ldo.l_regxpar r2
         WHERE fk_par=23 AND r2.s1=lk.nkom)
         GROUP BY --nink, 
         -- lk.lsk, 
                        lk.dtek
         ORDER BY lk.dtek
     ) b
USING (dtek)
where dtek='29.03.2013'


  select * from ldo.l_list_reg where id=727141 or id=727140
  select sum(p.summa) from ldo.l_list_reg l,scott.l_pay p
  where --dt_kw='04.03.2013' 
      --and 
      p.num_reg=64 
      and L.ID=P.FK_LIST_REG and pay_cd='PP' and l.FK_REG = 983
UNION ALL
    select sum(lk.ska)+sum(lk.pn) 
     from ldo.l_kwtp lk, scott.oper op 
      where nink='64' and nkom='B64'
     AND  op.oper=lk.oper and op.tp_cd not in ('ND')
     ldo.l_reg                        */
     
     select * from scott.kart
     scott.load_kartw
     
     prep.d_load1