     ELSIF var_ = 1 THEN
            --Ïî ÆÝÎ
          OPEN prep_refcursor FOR 'SELECT 
                     coalesce(k.uch,0) uch, coalesce(k.reu,a.reu) reu, coalesce(k.name_tr,a.name_tr) predp,coalesce(k.PREDPR_DET, a.PREDPR_DET ) predpr_det,
                     sum(a.nach) nach, sum(k.ska) opl, sum(k.pn) pn
        FROM 
              (SELECT x.trest, x.reu,  x.kul, x.nd, s.trest || ''  '' || s.name_tr as NAME_TR, 
                           x.reu||x.kul||x.nd||'' ''|| SP.NAME || ''  '' || ltrim(x.ND,''0'') as PREDPR_DET,  
                           sum(x.charges) nach
                FROM scott.xitog2 x, scott.spul SP, 
                    (SELECT  distinct reu,trest, name_tr 
                     FROM scott.s_stra 
                    ) s,
                   (SELECT DISTINCT USLM FROM
                      (SELECT max (for_plan) for_plan, usl, uslm
                       FROM  scott.usl
                       GROUP BY usl,uslm 
                       HAVING max (for_plan)<>0
                      )      
                   )U
             WHERE X.uslm=U.uslm
             AND x.reu=s.reu 
             AND x.kul=sp.id
             AND x.trest=:trest_
             AND x.mg=(select to_char(add_months(to_date(period_pl,''yyyy.mm''),-1),''yyyymm'') from scott.params)
             GROUP BY x.trest, x.reu,  x.kul, x.nd, s.trest || ''  '' || s.name_tr,x.reu||x.kul||x.nd||'' ''|| SP.NAME || ''  '' || ltrim(x.ND,''0'')
            )  A 
        FULL OUTER JOIN
           (SELECT trest, reu, uch, kul, nd, NAME_TR,
                         k.reu||k.kul||k.nd||'' ''||name_ul as PREDPR_DET, 
                         sum(ska) ska, sum(pn) pn 
               FROM  PREP.KWTP_OLAP k
             WHERE  k.dtek between :dat_ and :dat1_     
                 AND   k.trest=:trest1_  
             GROUP BY  k.trest,k.reu,k.uch,k.kul,k.nd, k.reu||k.kul||k.nd||'' ''||name_ul,name_tr
             ) K
        ON    k.trest  = a.trest 
        AND   k.reu   = a.reu 
        AND   k.kul   =  a.kul
        AND   k.nd  =  a.nd 
        GROUP BY k.reu,coalesce(k.uch,0), coalesce(k.reu,a.reu), coalesce(k.name_tr,a.name_tr),coalesce(k.PREDPR_DET, a.PREDPR_DET ) 
        ORDER BY k.reu'
        USING trest_,dat_, dat1_, trest_; 
       ELSIF var_ = 0 THEN
            --Ïî ÌÏ ÓÅÇÆÊÓ (âñå òðåñòû)
            OPEN prep_refcursor FOR 'SELECT 
                     coalesce(k.uch,k.uch) uch, coalesce(k.reu,a.reu) reu, coalesce(k.name_tr,a.name_tr) predp,coalesce(k.PREDPR_DET, a.PREDPR_DET ) predpr_det,
                     sum(a.nach) nach, sum(k.ska) opl, sum(k.pn) pn
        FROM 
              (SELECT x.trest, x.reu,  x.kul, x.nd, s.trest || ''  '' || s.name_tr as NAME_TR, 
                           x.reu||x.kul||x.nd||'' ''|| SP.NAME || ''  '' || ltrim(x.ND,''0'') as PREDPR_DET,  
                           sum(x.charges) nach
                FROM scott.xitog2 x, scott.spul SP, 
                    (SELECT  distinct reu,trest, name_tr 
                     FROM scott.s_stra 
                    ) s,
                   (SELECT DISTINCT USLM FROM
                      (SELECT max (for_plan) for_plan, usl, uslm
                       FROM  scott.usl
                       GROUP BY usl,uslm 
                       HAVING max (for_plan)<>0
                      )      
                   )U
             WHERE X.uslm=U.uslm
             AND x.reu=s.reu 
             AND x.kul=sp.id
             AND x.mg=(select to_char(add_months(to_date(period_pl,''yyyy.mm''),-1),''yyyymm'') from scott.params)
             GROUP BY x.trest, x.reu,  x.kul, x.nd, s.trest || ''  '' || s.name_tr,x.reu||x.kul||x.nd||'' ''|| SP.NAME || ''  '' || ltrim(x.ND,''0'')
            )  A 
        FULL OUTER JOIN
           (SELECT trest, reu, uch, kul, nd, NAME_TR,
                         k.reu||k.kul||k.nd||'' ''||name_ul as PREDPR_DET, 
                         sum(ska) ska, sum(pn) pn 
               FROM  PREP.KWTP_OLAP k
             WHERE  k.dtek between :dat_ and :dat1_     
             GROUP BY  k.trest,k.reu,k.uch,k.kul,k.nd, k.reu||k.kul||k.nd||'' ''||name_ul,name_tr
             ) K
        ON    k.trest  = a.trest 
        AND   k.reu   = a.reu 
        AND   k.kul   =  a.kul
        AND   k.nd  =  a.nd 
        GROUP BY coalesce(k.uch,k.uch), coalesce(k.reu,a.reu), coalesce(k.name_tr,a.name_tr),coalesce(k.PREDPR_DET, a.PREDPR_DET ) 
        ORDER BY predp'
        USING dat_,dat1_;