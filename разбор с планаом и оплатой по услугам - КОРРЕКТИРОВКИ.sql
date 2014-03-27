        SELECT sum(ska)+sum(pn),for_plan
        FROM
        (SELECT   s.trest || '  ' || s.name_tr as name_tr, SP.NAME || '  ' || ltrim(k.ND,'0') as name_ul, p.dat as dtek, s.reu, s.trest,
                       sum(case when p.priznak=1 then p.summa else 0 end) SKA,
                       sum(case when p.priznak=0 then p.summa else 0 end)  PN,
                       2 as pay, sp.id as kul,k.nd as nd, u.for_plan
             FROM scott.t_corrects_payments p, scott.s_stra s, scott.kart K, scott.spul SP, scott.usl u
           WHERE  p.mg='201212'
           AND      substr(p.lsk,1,4) = s.nreu
           AND      k.kul = sp.id     
           AND      k.lsk=p.lsk      
           AND      p.usl = u.usl   
           GROUP BY s.trest || '  ' || s.name_tr, SP.NAME || '  ' || ltrim(k.ND,'0'),p.dat,s.trest,s.reu, sp.id ,k.nd, u.for_plan
           ) A,
        (SELECT distinct ku.reu,ku.kul,ku.nd,ku.uch 
        FROM scott.koop_uch ku

        ) b 
        WHERE 
               a.reu = b.reu (+)
        AND  a.kul = b.kul (+)
        AND a.nd  = b.nd  (+)
        GROUP BY for_plan
        
        
        scott.period_reports