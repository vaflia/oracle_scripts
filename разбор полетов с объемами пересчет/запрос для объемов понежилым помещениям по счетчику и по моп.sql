--запрос для объемов понежилым помещениям по счетчику и по моп
SELECT CASE
          WHEN SUM (DECODE (uslm, '008', DECODE (t.psch, 1, DECODE (u.usl_norm, 0, NVL (t.volume, 0),0),0), 0)) >=
                  SUM ( DECODE ( uslm, '008', DECODE (  t.psch, 1, DECODE (u.usl_norm, 0, NVL (t.dop_vol, 0),   0), 0),0))
          THEN
             SUM ( DECODE (uslm, '008', DECODE (t.psch, 1, DECODE (u.usl_norm, 0, NVL (t.volume, 0), 0), 0), 0))
          ELSE
             SUM ( DECODE (uslm, '008', DECODE (t.psch, 1, DECODE (u.usl_norm, 0, NVL (t.dop_vol, 0), 0), 0), 0))
       END
       + 
       CASE
          WHEN SUM ( DECODE (uslm, '008', DECODE ( t.psch, 1, DECODE (u.usl_norm, 1, NVL (t.volume, 0),0),0), 0)) >=
                    SUM (DECODE ( uslm, '008', DECODE (t.psch, 1, DECODE (u.usl_norm, 1, NVL (t.dop_vol, 0),0),0),0))
          THEN
               SUM (DECODE (uslm, '008', DECODE (t.psch,1, DECODE (u.usl_norm, 1, NVL (t.volume, 0), 0),0),0))
           ELSE
               SUM (DECODE (uslm, '008', DECODE ( t.psch,1, DECODE (u.usl_norm,1, NVL (t.dop_vol, 0), 0), 0), 0))
         END
          vol_sch_nejil_pom,
       SUM (DECODE (u.usl, '059', NVL (t.volume, 0), 0)) vol_mop_nejil_pom
  FROM prep.info_usl_lsk t, scott.s_stra s, scott.usl u
 WHERE     t.status IN (6, 7, 8, 9, 10, 11, 12) AND
        SUBSTR (t.lsk, 1, 4) = s.nreu
       AND u.usl = t.usl
       AND u.uslm = '008'                                  
        and s.trest='07'
       AND t.mg = '201208'
       
       
create table prep.info_usl_lsk as  
 select * from scott.info_usl_lsk where mg='201208' and reu='73' and usl='008'
 select * from prep.info_usl_lsk where mg='201208' and reu='73' and usl='008'
       
       update scott.info_usl_lsk l set status = (select status from scott.load_kart k  where k.lsk=l.lsk)
       where  mg='201208' and reu='73' and usl='018'
       
       l, scott.load_kart k 
                 set l.status =k.status where l.lsk=k.lsk
                 and l.mg='201208' and l.reu='73'
       
       select * from scott.koop_uch where rownum=1
       
       
       select * from scott.load_kart where lsk='24010161'