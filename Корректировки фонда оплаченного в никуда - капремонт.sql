--корректировки фонда оплаченого в никуда. просто снятие.

declare 
  seq_ number;
  testsum_ number;
begin
for rec in (
select * from (
    SELECT  reu,kul,nd,sum(t.outsal) 
    FROM CAP_FOND_SAL_lsk_pay t where t.reu='L2' and t.kul='0006' and t.nd='000122'
    and t.mg between '201312' and '201312' --and t.nd not in ('000023') 
    group by reu,kul,nd
    having sum(t.outsal) >0 
    order by reu,kul,nd )
    --WHERE rownum<2
 ) 
LOOP

--снятие фонда по капремонту
select flow_id.nextval into seq_ from dual;

SELECT sum(t.outsal) 
    into testsum_
FROM CAP_FOND_SAL_lsk_pay t where t.reu=rec.reu and t.kul=rec.kul and t.nd=rec.nd
and t.mg between '201312' and '201312';

gen_cap.ins_trans(seq_,1,28,testsum_,null,trunc(sysdate),'201312',
                  '201312',null);

insert into cap_flow_lsk
  (lsk, flow_id, oper_id, loan_id, summa, mg, status_id, dopl, dat, reu, kul, nd)
select lsk, seq_, 28 as oper_id, null as loan_id, -1*t.outsal, 
  '201312' as mg, status_id, '201312' as dopl, 
   to_date('20131212','YYYYMMDD') as dat, reu, kul, nd
 from CAP_FOND_SAL_lsk_pay t where t.reu=rec.reu and t.kul=rec.kul and t.nd=rec.nd
and t.mg between '201312' and '201312';

insert into cap_flow_nd
(reu, kul, nd, flow_id, oper_id, status_id, summa, mg, dat, dopl)
select reu, kul, nd, seq_, 28, status_id, sum(summa), '201312' as mg, sysdate, c.dopl
  from cap_flow_lsk c
 where c.flow_id = seq_
 group by reu, kul, nd, status_id, dopl;
--rollback;
commit;
--Raise_application_error(-20000, seq_);
dbms_output.put_line(seq_);
end loop; 
end;

--300446
/*
select t.*,t.rowid from cap_transactions t where id=300447
select t.*,t.rowid from cap_flow_lsk t where flow_id=300447
select t.*,t.rowid from cap_flow_nd t where flow_id=300447*/