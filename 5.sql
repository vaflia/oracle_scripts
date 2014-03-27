--суммы корректировок плана ( забиваются текущим месяцем)
SELECT a.trest,a.reu,plan-coalesce(corplan,0) plan
FROM
                (SELECT trest,x.reu,sum(charges)  PLAN
                     FROM scott.xitog2 x,
                      (SELECT DISTINCT USLM FROM
                         (SELECT max (for_plan) for_plan, usl,uslm
                            FROM  scott.usl
                          GROUP BY usl,uslm 
                          HAVING max (for_plan)<>0
                         )      
                      )U
                    WHERE X.uslm=U.uslm
                    AND mg=(select to_char(add_months(to_date(period_pl,'yyyy.mm'),-1),'yyyymm') from scott.params)
                    GROUP BY trest,x.reu
                   ) A,
                    (SELECT reu,sum(sumcorplan) corplan 
                         FROM scott.proc_plan
                       WHERE mg=(select period_pl From scott.params)
                       GROUP BY reu
                      ) B
                   WHERE  b.reu (+) = a.reu
/*-------------------------------------------------------------------------------*/
/*-------------------------------------------------------------------------------*/
/*-------------------------------------------------------------------------------*/              
/*-------------------------------------------------------------------------------*/                   
-- для olap выполнение плана по l_kwtp
INSERT /*+ APPEND*/ INTO PREP.KWTP_OLAP (name_tr, name_ul, KUL, ND, DTEK, REU, TREST, UCH,
  SKA,  PN ,  PAY) 
SELECT a.name_tr, a.name_ul, b.kul, b.nd, a.dtek, a.reu, a.trest, b.uch, a.ska, a.pn, a.pay
FROM
(SELECT    s.trest || '  ' || s.name_tr as name_tr, SP.NAME || '  ' || ltrim(k.ND,'0') as name_ul, 
                h.dtek, s.reu, s.trest,
                sum(b.ska) ska, sum(b.pn) pn,    
                sum(case when substr(op.oigu,1,2) = '10' then b.ska+b.pn else 0 end) bn, 
                0 as pay, sp.id as kul,k.nd as nd
  FROM     kwtp_h h, kwtp_b b, scott.s_stra s, scott.oper op, scott.usl u,scott.kart K, scott.spul SP
WHERE    h.id = b.id
   AND      b.usl = u.usl         
   AND      k.kul = sp.id                    
   AND      k.lsk=h.lsk                      
   AND      u.for_plan = 1          
   AND      op.oper not in ('ND')                     
   AND      substr(h.lsk,1,4) = s.nreu                     
   AND      h.oper = op.oper
   AND      h.dtek=:d   
GROUP BY    s.trest || '  ' || s.name_tr, SP.NAME || '  ' || ltrim(k.ND,'0'),s.trest, s.reu, h.dtek, sp.id, k.nd 
)A,
(SELECT distinct ku.reu,ku.kul,ku.nd,ku.uch 
FROM scott.koop_uch ku,scott.kart k
WHERE k.kul = ku.kul
AND   k.nd = ku.nd
) b 
WHERE 
       a.reu = b.reu (+)
AND a.kul = b.kul (+)
AND a.nd  = b.nd (+)

--lдля выполнения плана по олап для l_pay
INSERT /*+ APPEND*/ INTO PREP.KWTP_OLAP (name_tr, name_ul, KUL, ND, DTEK, REU, TREST, UCH,
  SKA,  PN ,  PAY) 
SELECT a.name_tr, a.name_ul, b.kul, b.nd, a.dtek, a.reu, a.trest, b.uch, a.ska, a.pn, a.pay
FROM
 (SELECT       s.trest || '  ' || s.name_tr as name_tr, SP.NAME || '  ' || ltrim(k.ND,'0') as name_ul, p.dt1 as dtek, s.reu,s.trest,
                    sum(CASE WHEN p.TP_CD='PAY' THEN summa ELSE 0 end)  SKA,
                    sum(CASE WHEN p.TP_CD='PEN' THEN summa ELSE 0 end)  PN,
                    1 as pay,sp.id as kul,k.nd as nd
          FROM  scott.l_pay p, scott.s_stra s, scott.oper op, scott.usl u,scott.kart K, scott.spul SP
        WHERE       p.dt1 between :d and :d1
                AND p.oper = op.oper 
                AND p.fk_usl = u.usl
                AND u.for_plan = 1
                AND substr(p.lsk,1,4) = s.nreu 
                AND k.kul = sp.id     
                AND k.lsk=p.lsk         
                AND P.TP_CD   in ('PAY','PEN')
                AND P.PAY_CD in ('PU')
                AND op.tp_cd  in ('MU')     
                AND p.lsk not  in ('99999999')      
        GROUP BY  s.trest || '  ' || s.name_tr, SP.NAME || '  ' || ltrim(k.ND,'0'),s.trest, s.reu, p.dt1, sp.id ,k.nd
        )
        A,
(SELECT distinct ku.reu,ku.kul,ku.nd,ku.uch 
FROM scott.koop_uch ku,scott.kart k
WHERE k.kul = ku.kul
AND   k.nd = ku.nd
) b 
WHERE 
       a.reu = b.reu (+)
AND a.kul = b.kul (+)
AND a.nd  = b.nd (+)
/*-------------------------------------------------------------------------------*/
/*-------------------------------------------------------------------------------*/
/*-------------------------------------------------------------------------------*/
/*-------------------------------------------------------------------------------*/
--для выполнения плана по олап для corrects payments
INSERT /*+ APPEND*/ INTO PREP.KWTP_OLAP (name_tr, name_ul, KUL, ND, DTEK, REU, TREST, UCH,
  SKA,  PN ,  PAY) 
SELECT a.name_tr, a.name_ul, b.kul, b.nd, a.dtek, a.reu, a.trest, b.uch, a.ska, a.pn, a.pay
FROM
(SELECT   s.trest || '  ' || s.name_tr as name_tr, SP.NAME || '  ' || ltrim(k.ND,'0') as name_ul, p.dat as dtek, s.reu, s.trest,
               sum(case when p.priznak=1 then p.summa else 0 end) SKA,
               sum(case when p.priznak=0 then p.summa else 0 end)  PN,
               2 as pay, sp.id as kul,k.nd as nd
     FROM scott.t_corrects_payments p, scott.s_stra s, scott.kart K, scott.spul SP, scott.usl u
   WHERE  p.mg=(select period_pl from scott.params)
   AND      substr(p.lsk,1,4) = s.nreu
   AND      k.kul = sp.id     
   AND      k.lsk=p.lsk      
   AND      p.usl = u.usl   
   AND      u.for_plan = 1   
   GROUP BY s.trest || '  ' || s.name_tr, SP.NAME || '  ' || ltrim(k.ND,'0'),p.dat,s.trest,s.reu, sp.id ,k.nd  
   ) A,
(SELECT distinct ku.reu,ku.kul,ku.nd,ku.uch 
FROM scott.koop_uch ku,scott.kart k
WHERE k.kul = ku.kul
AND   k.nd = ku.nd
) b 
WHERE 
       a.reu = b.reu (+)
AND  a.kul = b.kul (+)
AND a.nd  = b.nd  (+)

--проверочный запрос
SELECT  tab,
    case when tab=1 then summa else 0 end,
    case when tab=0 then summa else 0 end
FROM
(SELECt 1 as tab,reu,sum(ska+pn) summa,sum(pn) pn
FROM kwtp_olap
WHERE dtek between :d and :d1
and pay=1
GROUP BY REU
union all
SELECT 0 as tab,reu,sum (ska+pn) summa,sum(pn) pn
FROM kwtp_itog
WHERE dtek between :d and :d1
and pay=1
GROUP BY REU
)
ORDER BY 2,1
log_parser

        DELETE FROM KWTP_ITOG WHERE pay=1 and dtek=:d;
        INSERT INTO  KWTP_ITOG
        SELECT p.dt1,s.trest, s.reu,
                    sum(CASE WHEN p.TP_CD='PAY' THEN summa ELSE 0 end)  SKA,
                    sum(CASE WHEN p.TP_CD='PEN' THEN summa ELSE 0 end)  PN,
                    sum(CASE WHEN substr(op.oigu,1,2)='10' then summa else 0 end) BN,
                    1
          FROM  scott.l_pay p, scott.s_stra s, scott.oper op, scott.usl u
        WHERE       p.dt1 = :d
                AND p.oper = op.oper 
                AND p.fk_usl = u.usl
                AND u.for_plan = 1
                AND substr(p.lsk,1,4) = s.nreu 
                AND P.TP_CD   in ('PAY','PEN')
                AND P.PAY_CD in ('PU')
                AND op.tp_cd  in ('MU')     
                AND p.lsk not  in ('99999999')      
        GROUP BY p.dt1,s.trest,s.reu;








    -- сверка счетов у которых просрочены реу  ,участки
SELECT ka.lsk ,ku.uch,ku.reu,ku.kul,ku.nd
FROM      scott.kart ka,scott.koop_uch ku
WHERE
 not exists (SELECT k.lsk --,ku.uch,ku.reu,ku.kul,ku.nd 
FROM    scott.koop_uch ku, scott.kart k,scott.params p
WHERE
    p.period between ku.dat and ku.dat1
    AND ku.kul (+) =k.kul 
    AND ku.nd (+) =k.nd 
    AND ka.lsk=k.lsk )  
AND ka.kul= ku.kul
AND   ka.nd=ku.nd
GROUP BY ka.lsk ,ku.uch,ku.reu,ku.kul,ku.nd
        

SELECT  s.trest || '  ' || s.name_tr, SP.NAME || '  ' || ltrim(k.ND,'0'), p.dt1, s.reu, 
             sum(CASE WHEN p.TP_CD='PAY' THEN summa ELSE 0 end)  SKA,
             sum(CASE WHEN p.TP_CD='PEN' THEN summa ELSE 0 end)  PN,
             sum(CASE WHEN substr(op.oigu,1,2)='10' then summa else 0 end) BN,     
             1           
FROM       scott.l_pay p, scott.s_stra s, scott.oper op, scott.usl u,scott.kart K, scott.spul SP            
WHERE    
               p.fk_usl = u.usl
   AND      k.kul = sP.id                    
   AND      k.lsk=p.lsk                      
   AND      u.for_plan = 1          
   AND      op.oper not in ('ND')                     
   AND      substr(p.lsk,1,4) = s.nreu                     
   AND      p.oper = op.oper
   AND      p.dt1 = :d       
   AND      P.TP_CD   in ('PAY','PEN')
   AND      P.PAY_CD in ('PU')
   AND      op.tp_cd  in ('MU')     
   AND      p.lsk not  in ('99999999')         
GROUP BY  s.trest || '  ' || s.name_tr, SP.NAME || '  ' || ltrim(k.ND,'0'),s.trest, s.reu, p.dt1


 SELECT p.dt1,s.trest, s.reu,
                    sum(CASE WHEN p.TP_CD='PAY' THEN summa ELSE 0 end)  SKA,
                    sum(CASE WHEN p.TP_CD='PEN' THEN summa ELSE 0 end)  PN,
                    sum(CASE WHEN substr(op.oigu,1,2)='10' then summa else 0 end) BN,
                    1
          FROM  scott.l_pay p, scott.s_stra s, scott.oper op, scott.usl u
        WHERE      
                AND P.TP_CD   in ('PAY','PEN')
                AND P.PAY_CD in ('PU')
                AND op.tp_cd  in ('MU')     
                AND p.lsk not  in ('99999999')      
        GROUP BY p.dt1,s.trest,s.reu;
        
        
select k.uch, tr.trest||' '||tr.name_tr as predp, k.reu reu,
        k.reu||k.kul||n.nd||' '||ul.name||', '||NVL(LTRIM(k.nd,'0'),'0') as predpr_det,
        n.nach nach, opl.ska opl,opl.pn pn
        FROM  (SELECT x.reu reu,x.kul kul,x.uch uch,x.nd nd,sum(x.charges) nach
                      FROM scott.xitog2 x 
                    WHERE  mg between :mg_ and :mg1_ 
                    GROUP BY x.reu,x.kul,x.uch ,x.nd
                    ORDER BY x.KUL,x.nd,x.uch) n,
             (SELECT x.reu reu,x.kul kul,x.uch uch,x.nd nd,sum(x.payment) ska,sum(x.pn) pn
                FROM scott.xitog2 x, scott.uslm m 
              WHERE x.uslm=m.uslm and m.type in (1) 
                 AND  mg BETWEEN :mg_ and :mg1_  
              GROUP BY x.reu,x.kul,x.uch ,x.nd) opl,
             scott.v_koop_uch k,
             scott.spul ul,
             scott.s_reu_trest tr
        where k.reu=n.reu(+) and
              k.kul=n.kul(+) and
              k.nd=n.nd(+) and
              k.reu=opl.reu(+) and
              k.kul=opl.kul(+) and
              k.nd=opl.nd(+) and
              k.kul=ul.id and
              k.reu=tr.reu