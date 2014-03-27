SELECT dtek, lk_ska, lk_pn, lk_summa, b_ska, b_pn, b_summa, olap_ska, olap_pn, olap_summa, lk_summa-b_summa as diff,lk_summa-olap_summa as diff1
FROM
(
SELECT dtek, sum(ska) as lk_ska, sum(pn) as lk_pn, sum(ska) + sum(pn) as lk_summa
   FROM  ldo.l_kwtp lk, scott.s_stra s, scott.oper op 
 WHERE  lk.dtek  between '01.11.2012' and '30.11.2012'
       AND  lk.lsk not in ('00009999')
       AND  op.oper=lk.oper and op.tp_cd not in ('ND')
       AND  substr(lk.lsk,1,4) = s.nreu
       AND  not exists
       (SELECT distinct r2.s1 as nkom 
          FROM ldo.l_regxpar r2
        WHERE fk_par=23
        AND r2.s1=lk.nkom)
        GROUP BY dtek
        ORDER BY dtek
        ) FULL OUTER JOIN
        (
         SELECT b.dtek, sum(b.ska) b_ska, sum(pn) b_pn, sum(ska) + sum(pn) b_summa
                FROM prep.kwtp_b  b --, scott.oper op
 WHERE  b.dtek  between '01.11.2012' and '30.11.2012'
         GROUP BY b.dtek
         ORDER BY b.dtek
         ) B USING (dtek) FULL OUTER JOIN
        (
       SELECT dtek, sum(ska) olap_ska, sum(pn) olap_pn, sum(ska) + sum(pn) olap_summa
           FROM prep.kwtp_olap  
 WHERE  dtek  between '01.11.2012' and '30.11.2012'
             and pay = 0
     GROUP BY dtek
     ORDER BY dtek
     ) OLAP USING (dtek) 
--WHERE LK.dtek = b.dtek (+)
  --   and LK.dtek = olap.dtek (+)      
ORDER BY dtek