--сравнение cap_flow_lsk фонд оплаченный,     и оборотка     
       SELECT lsk, uslm, pay_cap,xito_pay, pay_cap-xito_pay, sum(pay_cap-xito_pay) over (PARTITION BY uslm) as ALL_SUM
       FROM
         (
         SELECT lsk, '001' as uslm, sum(summa) as pay_cap
            FROM scott.cap_flow_lsk 
         WHERE mg between '201311' and '201311' and oper_id = 3 --Оплата насел.
                 and reu in ('C5')
          group by lsk,  '001'
       ) FULL OUTER JOIN
       (
            SELECT /*+ FULL(s)*/   lsk, '001' as uslm, sum(coalesce(payment,0)) as xito_pay 
            from scott.xitog2_s_lsk  s
             WHERE reu='C5'
          and uslm in ('001','031','107','108','109')
                 and mg='201311'
        group by lsk, uslm
        having sum(coalesce(payment,0))<>0
      )   Using (lsk, uslm)
        WHERE pay_cap-xito_pay<>0

 --ГЛАВНЫЙ ЗАПРОС РАСХОЖДЕНИЯ ОПЛАТЫ ФОНДА ОПЛАЧЕННОГО И ОБОРОТКИ         
           SELECT srt.name_tr,s.trest,s.reu,cp.lsk,cp.usl,cp.org,cp.summa, sum(summa) over (PARTITION BY s.trest ORDER BY s.trest ) as ALL_SUM
              FROM scott.t_corrects_payments cp,scott.s_stra s, scott.s_reu_trest srt
           WHERE cp.usl='108'
                 AND cp.mg='201311'
                 AND s.nreu=substr(cp.lsk,1,4)
                 AND srt.reu=s.reu

select f.*,tp.name 
from scott. a_flow f, scott.a_flow_tp tp
where lsk='36010339'
and mg='201402'
and f.fk_type=tp.id
order by dt1,dopl

select dtek,sum(summa)
from scott.kwtp_day
group by dtek