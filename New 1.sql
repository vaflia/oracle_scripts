DROP VIEW LDO.V_OPLATA;

/* Formatted on 05.02.2014 14:10:08 (QP5 v5.163.1008.3004) */
CREATE OR REPLACE FORCE VIEW LDO.V_OPLATA
(
   LSK,
   DOPL,
   OPER,
   DTEK,
   SKA,
   PN,
   NKOM,
   NOMZ,
   WR,
   TEL_SCH,
   TREST
)
AS
   SELECT a.lsk,
          a.dopl,
          a.oper,
          a.dtek,
          a.ska,
          a.pn,
          a.NKOM,
          TO_CHAR (nomz) AS nomz,
          wr,
          tel_sch,
          a.trest
     FROM    (  SELECT p.fk_list_reg,
                       p.lsk,
                       p.dopl,
                       p.oper,
                       p.dt1 AS dtek,
                       SUM (
                          CASE
                             WHEN     p.oper IN (38, 67, 73, 74, 79, 81)
                                  AND p.pay_cd = 'PU'
                                  AND p.TP_CD = 'PAY'
                             THEN
                                p.summa
                             WHEN     p.oper IN (41, 43, 49, 77, 80, 82, 85)
                                  AND p.pay_cd = 'PP'
                                  AND p.TP_CD = 'PAY'
                             THEN
                                p.summa
                             ELSE
                                0
                          END)
                          SKA,
                       SUM (
                          CASE
                             WHEN     p.oper IN (38, 67, 73, 74, 79, 81)
                                  AND p.pay_cd = 'PU'
                                  AND p.TP_CD = 'PEN'
                             THEN
                                p.summa
                             WHEN     p.oper IN (41, 43, 49, 77, 80, 82, 85)
                                  AND p.pay_cd = 'PP'
                                  AND p.TP_CD = 'PEN'
                             THEN
                                p.summa
                             ELSE
                                0
                          END)
                          PN,
                       LPAD (rx.s1, 3, 0) AS NKOM,
                       NULL AS WR,
                       NULL AS TEL_SCH,
                       '00' AS TREST
                  FROM scott.l_pay p,
                       ldo.l_list_reg lr,
                       ldo.l_regxpar rx,
                       fkv.temp_par b
                 WHERE     p.fk_list_reg = lr.id
                       AND lr.fk_reg = rx.fk_reg
                       AND rx.fk_par = 23                       -- номер компа
                       AND P.TP_CD IN ('PAY', 'PEN')
                       AND P.PAY_CD IN ('PU', 'PP')
                       AND p.lsk NOT IN ('99999999')
                       AND lr.state_cd = 'KW'
                       AND p.lsk = b.lsk
                       AND p.dt1 BETWEEN b.dt1 AND b.dt2
              GROUP BY p.fk_list_reg,
                       p.lsk,
                       p.oper,
                       p.dt1,
                       p.dopl,
                       rx.s1,
                       p.fk_extern) a
          LEFT JOIN
             (  SELECT DISTINCT p.fk_list_reg, MIN (p.num_rec) AS nomz
                  FROM scott.l_pay p, fkv.temp_par b
                 WHERE     pay_cd = 'HD'
                       AND p.lsk = b.lsk
                       AND p.dt1 BETWEEN b.dt1 AND b.dt2
              GROUP BY p.fk_list_reg --  and dt1 BETWEEN '01.01.2013' AND '10.06.2013'
                                    ) b
          USING (fk_list_reg)
   UNION ALL
   --оплата из квтп   . в этой оплате нету банков! и не путай меня больше , АНДРЕЙ!
   SELECT h.lsk,
          SUBSTR (dopl, 3, 4) || SUBSTR (dopl, 1, 2) dopl,
          oper,
          dtek,
          ska,
          pn,
          nkom,
          TO_CHAR (nomz) AS nomz,
          wr,
          tel_sch,
          CASE WHEN s.trest = 'SS' THEN '00' ELSE s.trest END AS trest
     FROM prep.kwtp_h h, scott.s_reu_trest s, fkv.temp_par b
    WHERE     SUBSTR (h.nkom, 1, 2) = s.reu
          AND h.lsk = b.lsk
          AND h.dtek BETWEEN b.dt1 AND b.dt2;


GRANT SELECT ON LDO.V_OPLATA TO FKV;

GRANT SELECT ON LDO.V_OPLATA TO LDO;
