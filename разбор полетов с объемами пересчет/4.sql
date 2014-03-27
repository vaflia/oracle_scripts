DROP VIEW SCOTT.V_CHARGES_USL;

/* Formatted on 13.09.2012 13:22:13 (QP5 v5.139.911.3011) */
CREATE OR REPLACE FORCE VIEW SCOTT.V_CHARGES_USL
(
   LSK,
   SUMMA,
   USL,
   ORG
)
AS
     SELECT                                                     /*+ ORDERED */
           p.lsk,
            SUM (p.summa) AS summa,
            p.usl,
            CASE
               WHEN p.mg >= SUBSTR (t.dat3, 3, 4) || SUBSTR (t.dat3, 1, 2)
               THEN
                  t.kod3
               WHEN p.mg >= SUBSTR (t.dat2, 3, 4) || SUBSTR (t.dat2, 1, 2)
               THEN
                  t.kod2
               WHEN p.mg >= SUBSTR (t.dat, 3, 4) || SUBSTR (t.dat, 1, 2)
               THEN
                  t.kod1
               ELSE
                  t.kod
            END
               org
       FROM charges p,
            kart r,
            nabor k,
            sprorg t
      WHERE     r.lsk = p.lsk
            AND r.nabor_id = k.id
            AND k.usl = p.usl
            AND t.kod = k.org
            AND t.TYPE IN (0, 1)
            AND NOT EXISTS
                       (SELECT e.usl_id
                          FROM usl_excl e
                         WHERE e.usl_id = p.usl)
   GROUP BY p.lsk,
            p.usl,
            CASE
               WHEN p.mg >= SUBSTR (t.dat3, 3, 4) || SUBSTR (t.dat3, 1, 2)
               THEN
                  t.kod3
               WHEN p.mg >= SUBSTR (t.dat2, 3, 4) || SUBSTR (t.dat2, 1, 2)
               THEN
                  t.kod2
               WHEN p.mg >= SUBSTR (t.dat, 3, 4) || SUBSTR (t.dat, 1, 2)
               THEN
                  t.kod1
               ELSE
                  t.kod
            END;
