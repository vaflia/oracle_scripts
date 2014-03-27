     --v_changes_usl
     
     SELECT lsk,
            SUM (summa) AS summa,
            usl,
            org
       FROM (SELECT                                             /*+ ORDERED */
                   p.lsk,
                    p.summa,
                    p.usl,
                    CASE
                       WHEN SUBSTR (p.dtizm, 3, 4) || SUBSTR (p.dtizm, 1, 2) >=
                               SUBSTR (t.dat3, 3, 4) || SUBSTR (t.dat3, 1, 2)
                       THEN
                          t.kod3
                       WHEN SUBSTR (p.dtizm, 3, 4) || SUBSTR (p.dtizm, 1, 2) >=
                               SUBSTR (t.dat2, 3, 4) || SUBSTR (t.dat2, 1, 2)
                       THEN
                          t.kod2
                       WHEN SUBSTR (p.dtizm, 3, 4) || SUBSTR (p.dtizm, 1, 2) >=
                               SUBSTR (t.dat, 3, 4) || SUBSTR (t.dat, 1, 2)
                       THEN
                          t.kod1
                       ELSE
                          t.kod
                    END
                       org
               FROM kart r,
                    nabor k,
                    changes p,
                    sprorg t
              WHERE     r.lsk = p.lsk
                    AND r.nabor_id = k.id
                    AND k.usl = p.usl
                    AND t.kod = k.org
                    AND t.TYPE IN (0, 1)
                    AND NVL (p.org, 0) = 0
                    AND NOT EXISTS
                               (SELECT e.usl_id
                                  FROM usl_excl e
                                 WHERE e.usl_id = p.usl)
             UNION ALL
             SELECT c.lsk,
                    c.summa,
                    c.usl,
                    c.org
               FROM t_corrects_for_saldo c, params p
              WHERE c.mg = period
             UNION ALL
             SELECT                                             /*+ ORDERED */
                   p.lsk,
                    p.summa,
                    p.usl,
                    CASE
                       WHEN SUBSTR (p.dtizm, 3, 4) || SUBSTR (p.dtizm, 1, 2) >=
                               SUBSTR (t.dat3, 3, 4) || SUBSTR (t.dat3, 1, 2)
                       THEN
                          t.kod3
                       WHEN SUBSTR (p.dtizm, 3, 4) || SUBSTR (p.dtizm, 1, 2) >=
                               SUBSTR (t.dat2, 3, 4) || SUBSTR (t.dat2, 1, 2)
                       THEN
                          t.kod2
                       WHEN SUBSTR (p.dtizm, 3, 4) || SUBSTR (p.dtizm, 1, 2) >=
                               SUBSTR (t.dat, 3, 4) || SUBSTR (t.dat, 1, 2)
                       THEN
                          t.kod1
                       ELSE
                          t.kod
                    END
                       org
               FROM changes p, usl u, sprorg t
              WHERE    
                           t.kod = p.org
                --    AND t.TYPE IN (0, 1)
                    AND NVL (p.org, 0) <> 0
                    AND NOT EXISTS
                               (SELECT e.usl_id
                                  FROM usl_excl e
                                 WHERE e.usl_id = p.usl)
                                 
                          )
   GROUP BY lsk, usl, org;