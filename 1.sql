       INSERT /*+ append */  INTO  KWTP_H 
       SELECT    0, lsk, dat_ink, dtek, s.reu, s.trest, 0, s.var, op.oper, lk.id, lk.ska, lk.pn  
       FROM       ldo.l_kwtp lk, scott.s_stra s, scott.oper op
       WHERE     lk.oper = op.oper      
       AND lk.dtek = :d
       AND lk.lsk not in ('00009999')
       AND substr(lk.lsk,1,4) = s.nreu;

select * from ldo.l_kwtp where dtek=:d

       DELETE FROM KWTP_B WHERE dtek = '01.06.2012';    
       DELETE FROM KWTP_H WHERE dtek =  '01.06.2012';    
       
       select segment_name, partition_name, segment_type
 from user_segments;

truncate table KWTP_B
truncate table KWTP_h

select distinct 0,dtek from KWTP_B 
union all
select distinct 1,dtek from KWTP_H 
select distinct dtek from ldo.l_kwtp order by dtek       

SELECT  lsk,a.ska H_SKA,a.pn H_PN,b.ska B_SKA,b.pn B_PN, a.ska+a.pn as HSUMM, b.ska+b.pn as BSUMM,(a.ska+a.pn)-(b.ska+b.pn) RAZN
FROM
    (  SELECT h.reu,sum(h.ska) ska,sum(h.pn) pn ,
                   sum(case when substr(op.oigu,1,2) = '10' then h.ska else 0 end) AS BN 
        FROM KWTP_H h,scott.oper op
        WHERE h.oper=op.oper
        AND op.tp_cd in ('DS','MU')
        AND h.reu=:reu
        AND dtek BETWEEN :d and :d1
        GROUP BY h.reu
     ) A INNER JOIN 
    (  SELECT h.lsk,SUM(b.ska) ska,sum(coalesce(b.pn,0)) pn
        FROM KWTP_H h, KWTP_B b, SCOTT.OPER op
        WHERE h.id = b.id 
        AND  h.oper = op.oper

        AND  op.tp_cd in ('DS','MU')
        GROUP BY h.lsk
     ) B
USING (lsk)
ORDER BY razn DESC



select * from kwtp_h where lsk='49060146'
select * from kwtp_b where id=2582732
update kwtp_b set pn=0 where pn is null

delete from  kwtp_h where dtek= :d and l_pay=1
delete from kwtp_b where id in ( select id from kwtp_h where dtek= :d and l_pay=1)

SELECT * FROM
(
SELECT lsk
FROM ldo.l_kwtp lk, scott.oper op
WHERE dtek between :D and :D1
       AND lk.oper = op.oper     
       AND op.tp_cd in ('DS')           
       AND lk.lsk not in ('00009999')
) A,
(
SELECT lsk
FROM ldo.l_kwtp lk, scott.oper op, scott.s_stra s
WHERE dtek between :D and :D1
       AND lk.oper = op.oper     
       AND op.tp_cd in ('DS')           
       AND lk.lsk not in ('00009999')
       AND substr(lk.lsk,1,4) = s.nreu 
)
B     
WHERE A.lsk=b.lsk (+)

       
SELECT count (*) 
FROM kwtp_h h, scott.oper op
WHERE dtek between :D and :D1
       AND h.oper = op.oper
       AND op.tp_cd in ('DS')


select * from scott.l_pay t where lsk=7183106 and dt1=to_date('05.06.2012','DD.MM.YYYY')
select * from ldo.l_kwtp where lsk = '90000000'
union all
select * from scott.l_pay t where t.fk_parent_id=3601189
union all
select * from scott.l_pay t where t.fk_parent_id=3605651
union all
select * from scott.l_pay t where t.fk_parent_id=3605652


delete from kwtp_h where l_pay=1


   select a.name, b.value
   from v$statname a, v$mystat b
   where a.statistic# = b.statistic#
   and a.name = 'redo size'
   and b.value > 0
select * from scott.t_corrects_payments
      --для хедера рабочая
INSERT /*+ append */  INTO  KWTP_H 
    SELECT   0, p.lsk, p.dt2, p.dt1, s.reu, s.trest, null, var, p.oper, p.id, 
                 CASE WHEN TP_CD='PAY' THEN summa ELSE 0 end AS SKA,
                 CASE WHEN TP_CD='PEN' THEN summa ELSE 0 end as PN, 1
    FROM    scott.l_pay p, scott.s_stra s
    WHERE  p.dt1 = :d
    AND P.TP_CD in ('PAY','PEN')
    AND P.PAY_CD in ('MN')
    AND p.lsk not in ('99999999')
    AND substr(p.lsk,1,4) = s.nreu
   
    -- для боди рабочая!
INSERT INTO kwtp_b (id, dtek, usl, ska, pn)     
    SELECT b.lsk,b.idkwtp ,b.dt1, 
                CASE WHEN a.fk_usl is null then b.fk_usl else a.fk_usl end as AUSL,
                CASE WHEN b.TP_CD='PAY' and b.pay_cd='PP' THEN a.summa ELSE b.ska end AS ASKA,
                CASE WHEN b.TP_CD='PEN' and b.pay_cd='PP' THEN a.summa ELSE b.pn end as APN
    FROM scott.l_pay a ,
    (SELECT  0, p.lsk, p.dt1, p.oper, p.fk_usl,
                  CASE WHEN TP_CD='PAY' THEN summa ELSE 0 end AS SKA,
                  CASE WHEN TP_CD='PEN' THEN summa ELSE 0 end as PN, tp_cd,PAY_CD,fk_parent_id,p.id,
                  b.id as idkwtp
    FROM     scott.l_pay p,
               ( SELECT FK_ID,ID 
                  FROM kwtp_h kh
                  WHERE
                  kh.l_pay=1  
                  and dtek=:d
               ) b
   WHERE  p.fk_parent_id= b.FK_ID   
   ) b
   WHERE A.fk_parent_id (+) = B.id
    
    select * from kwtp_h where id =2476696



    
    SELECT   level, 0, p.lsk, p.dt2, p.dt1, s.reu, s.trest, null, var, p.oper, p.fk_list_reg,
                  CASE WHEN TP_CD='PAY' THEN summa Else 0 end AS SKA,
                  CASE WHEN TP_CD='PEN' THEN summa ELSE 0 end as PN, tp_cd,PAY_CD,fk_parent_id,p.id
    FROM       scott.l_pay p, scott.s_stra s
    WHERE   p.dt1 = :d
    AND ID=3605646
    AND P.TP_CD IN ('PAY','PEN')
    AND P.PAY_CD in ('MN','PP','PU')
    AND p.lsk not in ('99999999')
    AND substr(p.lsk,1,4) = s.nreu    
START WITH ID=3605646
CONNECT BY PRIOR p.id  =  fk_parent_id

SELECT level, id, pid, title
FROM test_table
START WITH pid is null
CONNECT BY PRIOR id = pid


    
    
select * from scott.l_pay t where t.id=3605646
union al
l
SELECT * 
FROM 
(select 
FROM scott.l_pay p, kwtp_h kh
WHERE kh.l_pay=1
    AND kh.dtek=:d
    AND p. 
            
and id=fk_parent_id

union all
select * from scott.l_pay t where t.fk_parent_id=3605651
union all
select * from scott.l_pay t where t.fk_parent_id=3605652

SELECT a.lsk,a.summa,a.dt1 FROM SCOTT.l_pay A, 
( 
    SELECT    0, p.lsk, p.dt2, p.dt1, s.reu, s.trest, null, var, p.oper, p.id, p.summa as ska, 0 as pn  
    FROM       scott.l_pay p, scott.s_stra s
    WHERE   p.dt1 = :d
    AND P.PAY_CD in ('MN')
    AND p.lsk not in ('99999999')
    AND substr(p.lsk,1,4) = s.nreu
)  B
WHERE a.fk_parent_id=b.id
AND A.PAY_CD in ('PU')


INSERT INTO kwtp_b (id, dtek, usl, ska, pn) 
                              
SELECT  kh.id, p.dt1,fk_usl, case when tp_cd='PAY' then summa end SKA, case when tp_cd='PAY' then summa end PN,0  
FROM    scott.l_pay   p, kwtp_h kh                                    
WHERE   p.fk_list_reg = kh.fk_id
AND       kh.l_pay=1
AND PAY_CD IN ('PU')


   
SELECT a.lsk,a.summa,a.dt1,oper, fk_usl, fk_org FROM SCOTT.l_pay A
WHERE  A.PAY_CD in ('PU')
            AND a.lsk not in ('99999999')
            AND  a.dt1 = :d
3711
SELECT a.lsk,a.summa,a.dt1 FROM SCOTT.l_pay A
WHERE  A.PAY_CD in ('MN')
            AND a.lsk not in ('99999999')
            AND  a.dt1 = :d
213