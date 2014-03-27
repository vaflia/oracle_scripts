    --запрос для вставки в олап всех услуг по l_pay
    SELECT a.name_tr, a.name_ul, b.kul, b.nd, a.dtek, a.reu, a.trest, b.uch, a.ska, a.pn, a.pay, for_plan
    FROM
    (SELECT   s.trest || '  ' || s.name_tr as name_tr, SP.NAME || '  ' || ltrim(k.ND,'0') as name_ul, p.dat as dtek, s.reu, s.trest,
                   sum(case when p.priznak=1 then p.summa else 0 end) SKA,
                   sum(case when p.priznak=0 then p.summa else 0 end)  PN,
                   2 as pay, sp.id as kul,k.nd as nd, u.for_plan
         FROM scott.t_corrects_payments p, scott.s_stra s, scott.kart K, scott.spul SP, scott.usl u
       WHERE  p.mg=(select period_pl from scott.params)
       AND      substr(p.lsk,1,4) = s.nreu
       AND      k.kul = sp.id     
       AND      k.lsk=p.lsk      
       AND      p.usl = u.usl   
 --    AND      u.for_plan = 1   
       GROUP BY s.trest || '  ' || s.name_tr, SP.NAME || '  ' || ltrim(k.ND,'0'),p.dat,s.trest,s.reu, sp.id ,k.nd, u.for_plan
       ) A,
    (SELECT distinct ku.reu,ku.kul,ku.nd,ku.uch 
    FROM scott.koop_uch ku,scott.kart k
    WHERE k.kul = ku.kul
    AND   k.nd = ku.nd
    ) b 
    WHERE 
           a.reu = b.reu (+)
    AND  a.kul = b.kul (+)
    AND a.nd  = b.nd  (+);