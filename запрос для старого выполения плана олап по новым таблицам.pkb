запрос для старого выполения плана ДЛЯ ФР по новым таблицам (берем все услуги)
SELECT tp.name_tr, tp.reu, b.ska ska, b.pn pn, b.bn bn, b.ska+b.pn sumall, round(c.plan/1000,2) sumplan, 
                            c.plan-b.ska plan_no,
                            case  when c.plan<>0 then round(((b.ska)/c.plan)*100,2) else 0 end procplan,d.d
                FROM scott.v_trest_plan tp,
                      (SELECT trest,reu,sum(ska) ska,sum(pn) pn,sum(bn) bn
                        FROM   PREP.KWTP_OLAP
                        WHERE dtek BETWEEN :dat_ and :dat1_
                        GROUP BY trest, reu
                       ) b,
                   (SELECT a.trest,a.reu,plan-coalesce(corplan,0) plan
                       FROM
                        (SELECT trest,x.reu,sum(charges)  PLAN
                            FROM scott.xitog2 x
                            WHERE mg=(select to_char(add_months(to_date(period_pl,'yyyy.mm'),-1),'yyyymm') from scott.params)
                            GROUP BY trest,reu
                        ) A,
                        (SELECT reu,sum(sumcorplan) corplan 
                            FROM scott.proc_plan
                          WHERE mg=(select period_pl FROM scott.params)
                          GROUP BY reu
                         ) B
                     WHERE  b.reu (+) = a.reu
                    ) C,
                (SELECT max(r.dt2) d
                   FROM ldo.l_list_reg r, ldo.l_reg t
                 WHERE t.cd = 'L_KWTP' 
                     AND t.id = r.fk_reg
                     AND r.state_cd='LD' 
                 ORDER BY r.id DESC
                ) d
                WHERE b.reu (+) = tp.reu
                     AND c.reu  (+)  = tp.reu
                ORDER BY tp.trest;
                

//запрос для олап под новые таблицы, расчет по старому (все услуги)
        SELECT 
        CASE WHEN k.uch is null THEN a.uch else k.uch end uch,
        CASE WHEN k.reu is null THEN a.reu else k.reu end reu,
        CASE WHEN k.name_tr is null THEN a.name_tr else k.name_tr end predp,
        CASE WHEN k.PREDPR_DET is null THEN a.PREDPR_DET else k.PREDPR_DET end PREDPR_DET,
        sum(a.nach) nach, sum(k.ska) opl, sum(k.pn) pn
        FROM 
            (SELECT x.trest, x.reu, x.uch, x.kul, x.nd, s.trest || '  ' || s.name_tr as NAME_TR, 
                           x.reu||x.kul||x.nd||' '|| SP.NAME || '  ' || ltrim(x.ND,'0') as PREDPR_DET,  
                           sum(x.charges) nach
              FROM scott.xitog2 x, scott.spul SP, 
                    (SELECT  distinct reu, trest, name_tr 
                     FROM    scott.s_stra 
                    ) s
             WHERE
                      x.reu = s.reu 
             AND x.kul = sp.id
              AND x.trest=:trest_
             AND x.mg = (select to_char(add_months(to_date(period_pl,'yyyy.mm'),-1),'yyyymm') from scott.params)
             AND x.charges<>0
             GROUP BY x.trest, x.reu, x.uch, x.kul, x.nd, s.trest || '  ' || s.name_tr,x.reu||x.kul||x.nd||' '|| SP.NAME || '  ' || ltrim(x.ND,'0')
            )  A 
        FULL OUTER JOIN
           (SELECT trest, reu, uch, kul, nd, NAME_TR,
                         k.reu||k.kul||k.nd||' '||name_ul as PREDPR_DET, 
                         sum(ska) ska, sum(pn) pn 
               FROM  PREP.KWTP_OLAP k
             WHERE  k.dtek between :dat_ and :dat1_
             AND       k.trest=:trest_
             GROUP BY  k.trest,k.reu,k.uch,k.kul,k.nd, k.reu||k.kul||k.nd||' '||name_ul,name_tr
             ) K
        ON    k.trest  = a.trest 
        AND   k.reu   = a.reu 
        AND   k.kul   =  a.kul
        AND   k.nd  =  a.nd 
        GROUP BY 
        CASE WHEN k.uch is null THEN a.uch else k.uch end,
        CASE WHEN k.reu is null THEN a.reu else k.reu end,
        CASE WHEN k.name_tr is null THEN a.name_tr else k.name_tr end,
        CASE WHEN k.PREDPR_DET is null THEN a.PREDPR_DET else k.PREDPR_DET end
        ORDER BY predp, reu, uch