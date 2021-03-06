DECLARE 
l_parametr number;
BEGIN
   kwtp_parser.kwtp_pars(l_parametr);
 --  kwtp_parser.ADD_LOG (l_parametr);
   IF l_parametr in ('1','2') THEN 
    ROLLBACK;  
   END IF;
   COMMIT;  
END;

log_parser
        DELETE FROM KWTP_OLAP WHERE pay=1 and dtek=:d;
            
        --����� ������ ������� ����� �������������� � ������ ��� ����� 7.1
                SELECT tp.name_tr, tp.reu, sum(b.ska) ska, sum(b.pn) pn, sum(b.bn) bn, sum(b.ska)+sum(b.pn) sumall, round(c.plan/1000,1) sumplan, 
                            c.plan-sum(b.ska)+sum(b.pn) plan_no,
                            case  when c.plan<>0 then round(((sum(b.ska)+sum(b.pn))/c.plan)*100,2) else 0 end procplan,d.d
                FROM scott.v_trest_plan tp,
                      (SELECT  trest,reu,sum(ska) ska ,sum(pn) pn, sum(bn) bn
                          FROM   PREP.KWTP_OLAP
                        WHERE dtek BETWEEN :dat_ and :dat1_
                    GROUP BY trest,reu
                       ) b,
                   (SELECT a.trest,a.reu,plan-coalesce(corplan,0) plan
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
                    ) C,
                (SELECT max(r.dt2) d
                   FROM ldo.l_list_reg r, ldo.l_reg t
                 WHERE t.cd = 'L_KWTP' 
                     AND t.id = r.fk_reg
                     AND r.state_cd='LD' 
                 ORDER BY r.id DESC
                ) d
                WHERE b.reu (+) = tp.reu
                     AND c.reu  = tp.reu
                GROUP BY tp.name_tr,tp.reu,c.plan,d.d
                ORDER BY tp.REU
