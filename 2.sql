--курсор если есть трест
SELECT tp.name_tr,tp.trest,tp.reu,h.ska ska,h.pn pn,h.bn_summa bn, h.ska+h.pn summa,  
            p.sumplan,
            CASE WHEN p.sumplan<>0 then ROUND((coalesce(h.ska,0))/10/p.sumplan,2) ELSE 0 END as procplan,
            coalesce(p.sumplan,0)*1000-coalesce(h.ska,0) as plan_no
FROM   
    scott.v_trest_plan tp, scott.proc_plan p, scott.params m,
    (
    SELECT trest,reu,SUM(ska) ska, sum(pn) pn,sum(bn_summa) bn_summa
    FROM prep.mv_exec_plan
    WHERE dtek BETWEEN :d1 and :d2
    GROUP BY trest, reu
    )  H
WHERE h.reu (+)=tp.reu
    AND tp.reu=p.reu
    AND m.period_pl=p.mg and tp.trest=:p_trest order by tp.trest, tp.reu
    
--курсор если есть рэу  - проверял примерно на 7 руэ. цифры идут.
SELECT tp.name_tr,tp.trest,tp.reu,h.ska,h.pn,h.bn_ska, h.bn_pn, h.ska+h.bn_ska S_ALL,  
            p.sumplan,
            case when p.sumplan<>0 then ROUND((nvl(h.ska,0))/10/p.sumplan,2) else 0 end as procplan,
            nvl(p.sumplan,0)*1000-nvl(h.ska,0) as plan_no
FROM   
    scott.v_trest_plan tp, scott.proc_plan p, scott.params m,
    (SELECT h.reu,sum(h.ska) ska,sum(h.pn) pn,
                sum(case when substr(op.oigu,1,2) = '10' then h.ska else 0 end) AS BN_SKA,
                sum(case when substr(op.oigu,1,1) = '1' then h.pn else 0 end) AS BN_PN 
    FROM KWTP_H h,scott.oper op
    WHERE h.oper=op.oper
    AND op.tp_cd in ('DS','MU')
    AND dtek BETWEEN :d and :d1
    GROUP BY h.reu) H
WHERE h.reu (+)=tp.reu
    AND tp.reu=p.reu
    AND m.period_pl=p.mg and tp.reu=:p_reu order by tp.trest,tp.reu
    


--выполнение плана  и платежи сгруппированные по рэу и трестам 
SELECT dtek,tp.name_tr,tp.trest,tp.reu,h.name,h.ska,h.pn,h.bn_ska,h.ska+h.bn_ska S_ALL,  
            p.sumplan,
            coalesce(p.sumplan,0)*1000-coalesce(h.ska,0) as plan_no,
            CASE WHEN p.sumplan<>0 THEN ROUND((coalesce(h.ska,0))/10/p.sumplan,2) ELSE 0 END as procplan
FROM   
    scott.v_trest_plan tp, scott.proc_plan p, scott.params m,
    (SELECT dtek,h.reu,s.name ||', '|| LTRIM(k.nd,'0') as NAME,sum(h.ska) ska,sum(h.pn) pn,
                sum(case when substr(op.oigu,1,2) = '10' then h.ska else 0 end) AS BN_SKA,
                sum(case when substr(op.oigu,1,1) = '1' then h.ska else 0 end) AS BN_PN 
    FROM KWTP_H H,scott.oper OP, scott.kart K, scott.spul S
    WHERE  k.kul = s.id
    AND    k.lsk=h.lsk 
    AND    h.oper = op.oper
    AND    op.tp_cd in ('DS','MU')
   -- AND    dtek BETWEEN :d and :d1
    GROUP BY h.reu,h.lsk,dtek,s.name,k.nd) H
WHERE h.reu (+)=tp.reu
    AND tp.reu=p.reu
    AND m.period_pl=p.mg order by tp.trest,tp.reu
        

load_koop scott.kart
    

SELECT sum (ska),sum(pn),s.trest,s.reu
FROM ldo.l_kwtp p ,scott.s_stra s,scott.oper op
WHERE p.oper=op.oper
AND op.tp_cd in ('DS','MU')
AND p.lsk not in ('99999999')
AND s.reu='26'
AND substr(p.lsk,1,4) = s.nreu
AND p.dtek BETWEEN :d and :d1
group by s.reu,s.trest
               

SELECT count (*) 
FROM ldo.l_kwtp p,
         scott.s_stra s      
WHERE 
substr(p.lsk,1,4) = s.nreu 