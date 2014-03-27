select * from scott.cap_flow_nd where flow_id=283162

select * from scott.cap_flow_lsk where mg= '201207' and  flow_id=283162  
select * from scott.cap_flow_nd where flow_id=283162


scott.log

select * from scott.cap_transactions where id=283162

scott.cap_opers
select * from ldo.l_kwtp where lsk='54166106'

select kul,ltrim(nd,'0') from scott.cap_flow_nd where flow_id=283162

select * from scott.log 
where id=278
order by timestampm desc 

UPDATE scott.cap_transactions 
   SET summa=(SELECT sum(summa) FROM scott.cap_flow_nd    
                         WHERE flow_id = 283162)
WHERE id=283162      

 select * from dba_users           

prep.kwtp_h

select name, value, description 
from   v$parameter p 
where lower(p.NAME) = 'undo_retention'
 
select * from prep.log_parser order by id desc
select count(*) ,dtek from prep.kwtp_h group by dtek

 SELECT   TABLESPACE_NAME,
         STATUS, 
         SUM (BLOCKS) * 8192 / 1024 / 1024 / 1024 GB
FROM     DBA_UNDO_EXTENTS
GROUP BY TABLESPACE_NAME, STATUS;

---------------------------
SELECT D.UNDO_SIZE/(1024*1024) "ACTUAL UNDO SIZE [MByte]",
       SUBSTR(E.VALUE,1,25) "UNDO RETENTION [Sec]",
       ROUND((D.UNDO_SIZE / (TO_NUMBER(F.VALUE) *
       G.UNDO_BLOCK_PER_SEC))) "OPTIMAL UNDO RETENTION [Sec]"
FROM (
       SELECT SUM(A.BYTES) UNDO_SIZE
          FROM V$DATAFILE A,
               V$TABLESPACE B,
               DBA_TABLESPACES C
         WHERE C.CONTENTS = 'UNDO'
           AND C.STATUS = 'ONLINE'
           AND B.NAME = C.TABLESPACE_NAME
           AND A.TS# = B.TS#
       ) D,
       V$PARAMETER E,
       V$PARAMETER F,
       (
       SELECT MAX(UNDOBLKS/((END_TIME-BEGIN_TIME)*3600*24))
              UNDO_BLOCK_PER_SEC
         FROM V$UNDOSTAT
       ) G
WHERE  E.NAME = 'undo_retention'
       AND F.NAME = 'db_block_size';







------------------------
select au.user_id,u.* from scott.t_user u , all_users au 
where au.user_id=215
and au.username=u.cd


select n.rowid,n.* from scott.cap_transactions n where id=283162       
select n.rowid,n.* from scott.cap_flow_nd n where flow_id=283162
insert into scott.cap_flow_nd
select * from scott.cap_flow_nd as of timestamp (sysdate -1000/1440)
where flow_id=283162




select * from prep.log_parser where MSG like '%01-JUL-12%'
select * from ldo.l_kwtp where lsk = '80084723'
select * from kwtp_h where lsk=07233323
select * from scott.l_pay where lsk=80084723


select * from scott.l_pay where lsk = '07233323'
SELECT distinct r2.s1 as nkom 
              FROM ldo.l_regxpar r2
            WHERE fk_par=23
            AND r2.s1=lk.nkom


   SELECT a.name_tr, a.name_ul, b.kul, b.nd, a.dtek, a.reu, a.trest, b.uch, a.ska, a.pn, a.pay, a.bn, a.for_plan
        FROM
         (SELECT       s.trest || '  ' || s.name_tr as name_tr, SP.NAME || '  ' || ltrim(k.ND,'0') as name_ul, p.dt1 as dtek, s.reu,s.trest,
                            sum(CASE WHEN p.TP_CD='PAY' THEN summa ELSE 0 end)  SKA,
                            sum(CASE WHEN p.TP_CD='PEN' THEN summa ELSE 0 end)  PN,
                            sum(CASE WHEN substr(op.oigu,1,2)='10' then summa else 0 end) BN,
                            1 as pay, sp.id as kul, k.nd as nd, u.for_plan
                  FROM  scott.l_pay p, scott.s_stra s, scott.oper op, scott.usl u,scott.kart K, scott.spul SP
                WHERE       p.dt1 = :d
                        AND p.oper = op.oper 
                        AND p.fk_usl = u.usl
                        AND substr(p.lsk,1,4) = s.nreu 
                        AND k.kul = sp.id     
                        AND k.lsk=p.lsk         
                        AND P.TP_CD   in ('PAY','PEN')
                        AND P.PAY_CD in ('PU')
                        AND op.tp_cd  in ('MU')     
                        AND p.lsk not  in ('99999999')      
                GROUP BY  s.trest || '  ' || s.name_tr, SP.NAME || '  ' || ltrim(k.ND,'0'),s.trest, s.reu, p.dt1, sp.id ,k.nd, u.for_plan
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
        AND a.nd  = b.nd (+);



select name_tr,name_ul,nd,pay,sum(ska) from kwtp_olap
where dtek='01.07.2012'
and for_plan=1 and nd='000005'
Group by name_tr,name_ul,nd,pay










scott.t_user
select dtek,count(*) from prep.kwtp_h
group by dtek

kwtp_h
INSERT /*+ APPEND*/ INTO KWTP_H 
SELECT 0, LSK, DAT_INK, DTEK, S.REU, S.TREST, 0, S.VAR, LK.OPER, LK.ID, LK.SKA, LK.PN ,0 
FROM LDO.L_KWTP LK, SCOTT.S_STRA S WHERE LK.DTEK = '' || :B1 ||'' AND LK.LSK NOT IN ('00009999') AND SUBSTR(LK.LSK,1,4) = S.NREU 
AND NOT EXISTS (SELECT DISTINCT R2.S1 AS NKOM FROM LDO.L_REGXPAR R2 WHERE FK_PAR=23 AND R2.S1=LK.NKOM)

select * from ldo.l_kwtp where nkom is null
create table

  DELETE FROM scott.cap_flow_nd
   WHERE mg=201207
       AND   flow_id = 283162 
       AND kul  = 0006
       AND ltrim(nd,'0')  = 125
       AND reu =59
scott.spul
GRANT ALTER, DELETE, INDEX, INSERT, REFERENCES, SELECT, UPDATE, ON COMMIT REFRESH, QUERY REWRITE, DEBUG, FLASHBACK ON SCOTT.CAP_flow_lsk TO MIHA;

GRANT ALTER, DELETE, INDEX, INSERT, REFERENCES, SELECT, UPDATE, ON COMMIT REFRESH, QUERY REWRITE, DEBUG, FLASHBACK ON SCOTT.CAP_reguest TO PREP;



declare
l_comments  varchar2(1000);
begin
select 'id: ' || id || ', cd: ' || cd  into l_comments from scott.t_user where cd= (select user from dual);
end;


scott.log

select * from prep.log_parser order by id desc
scott.log

select * from scott.t_user where cd like '%REU09%'
select * from all_users
select * from dba_users