
   FK_REG,   SUMMA,   LSK,   OPER,   DOPL,   NKOM,   NINK,   DAT_INK,   PRIZNAK,   USL,
   USL_B,   ORG,   OBOROT,   FORREU,   REU,   VAR,   TREST,  DAY,   DTEK

   SELECT g.fk_reg, t.summa, t.lsk, t.oper, t.dopl AS dopl,
          r2.s1 AS nkom, g.num_reg AS nink,  g.dt_kw AS dat_ink, 1 AS priznak,
          SUBSTR (o.oigu, 1, 1) AS oborot,
          s.reu AS forreu,  SUBSTR (r2.s1, 1, 2) AS reu, s.var,
          s.trest as for_trest, TO_CHAR (g.dt_kw, 'DD') AS day,    t.dt1 AS dtek, t.pay_cd, t.tp_cd
     FROM scott.l_pay t, ldo.l_list_reg g, ldo.l_regxpar r2,
          ldo.l_par p2, scott.var_usl1 a, scott.oper o,
          scott.s_stra s, scott.params p
    WHERE     t.pay_cd = 'PU'  AND t.tp_cd = 'PAY'
          AND t.oper = o.oper
          AND t.lsk LIKE s.nreu || '%'
          AND p2.cd = 'NKOM'
          AND p2.id = r2.fk_par
          AND g.state_cd IN ('LD', 'KW')
          AND t.fk_list_reg = g.id
          AND g.fk_reg = r2.fk_reg
          AND t.fk_usl = a.usl1
          AND p.period BETWEEN a.dat AND a.dat1
          AND g.dt_kw BETWEEN TO_DATE (p.period || '01', 'YYYYMMDD')
                          AND LAST_DAY (
                                 TO_DATE (p.period || '01', 'YYYYMMDD'))
                                 ORDER BY REu
  

        select count(distinct t.kwtp_id) as cnt,
               s.trest as trest ,
               r.trest as for_trest,
             to_date('20120704', 'YYYYMMDD') as dat
          from scott.kwtp_day t, scott.s_reu_trest s, scott.s_stra r
         where t.dat_ink between to_date('02.07.2012') and to_date('04.07.2012') 
         and t.reu = s.reu and t.oborot=1 and t.priznak=1
         and t.lsk like r.nreu||'%' and t.kwtp_id is not null
         group by s.trest, r.trest, to_date('20120704', 'YYYYMMDD')
         
         select lp.*, g.state_cd , lr.name
         FROM scott.l_pay lp, ldo.l_list_reg g, scott.params p, ldo.l_reg lr, scott.s_stra s
         WHERE  lp.pay_cd='MN'
         AND lp.fk_list_reg = g.id
         AND G.FK_REG=lr.id
         AND g.state_cd IN ('LD', 'KW')
                   AND g.dt_kw BETWEEN TO_DATE (p.period || '01', 'YYYYMMDD')
                          AND LAST_DAY (
                                 TO_DATE (p.period || '01', 'YYYYMMDD'))
         AND lp.lsk not in ('99999999')            
         AND tp_cd='PAY'        
         AND substr(lp.lsk,1,4) = s.nreu
         ORDER BY LSK
insert into scot.xxito16 (trest,for_trest,mg,cnt) values                   

         SELECT srt.trest, s.trest as for_trest,'201208' as mg,count(*) as cnt
         --lp.lsk, lp.num_reg, lp.pay_cd, to_char(lp.dt1,'yyyymm') dt1, lp.dt2, g.state_cd, g.fk_reg, 
          --           s.reu forreu, s.trest as for_trest, SUBSTR (rx.s1, 1, 2)  reu, rx.fk_par,srt.trest
         FROM    scott.l_pay lp, ldo.l_list_reg g, scott.params p, scott.s_stra s,ldo.l_regxpar rx, ldo.l_par p2, scott.s_reu_trest srt
         WHERE  lp.pay_cd='HD'
         AND lp.fk_list_reg = g.id
         AND g.state_cd IN ('LD', 'KW')
   --      and g.dt_kw=to_date('02.07.2012')
         AND lp.dt1 BETWEEN TO_DATE (p.period || '01', 'YYYYMMDD') AND LAST_DAY (TO_DATE (p.period || '01', 'YYYYMMDD'))
         AND lp.lsk not in ('99999999')
         AND p2.cd = 'NKOM'
         AND p2.id = rx.fk_par
         AND substr(lp.lsk,1,4) = s.nreu
         AND  g.fk_reg = rx.fk_reg
         AND SUBSTR (rx.s1, 1, 2)=srt.reu
         GROUP BY  lsk,srt.trest, s.trest ,SUBSTR (rx.s1, 1, 2),s.reu, g.fk_reg,'201208'
         --lp.lsk, lp.num_reg, lp.pay_cd, lp.dt1, lp.dt2, g.state_cd, s.reu, g.fk_reg, 
          --              SUBSTR (rx.s1, 1, 2), rx.fk_par,s.trest,srt.trest
--         ORDER BY LSK
INSERT INTO scott.xxito16 (trest,for_trest,mg,cnt)   
SELECT  trest, for_trest, '201207' as mg, count(*) as cnt
FROM
       (
        SELECT lp.lsk, lp.num_reg, lp.pay_cd, to_char(lp.dt1,'yyyymm') dt1, lp.dt2, g.state_cd, g.fk_reg, 
                    s.reu forreu, s.trest as for_trest, SUBSTR (rx.s1, 1, 2)  reu, rx.fk_par,srt.trest
          FROM scott.l_pay lp, ldo.l_list_reg g, scott.params p, scott.s_stra s,ldo.l_regxpar rx, ldo.l_par p2, scott.s_reu_trest srt
        WHERE  lp.pay_cd = 'HD'
         AND  g.state_cd IN ('LD', 'KW')
   --      and g.dt_kw=to_date('02.07.2012')
         AND  lp.dt1 BETWEEN TO_DATE (p.period || '01', 'YYYYMMDD') AND LAST_DAY (TO_DATE (p.period || '01', 'YYYYMMDD'))
         AND  lp.lsk not in ('99999999')
         AND  p2.cd = 'NKOM'
         AND  p2.id = rx.fk_par
         AND  lp.fk_list_reg = g.id
         AND  substr(lp.lsk,1,4) = s.nreu
         AND  SUBSTR (rx.s1, 1, 2)=srt.reu
         AND  g.fk_reg = rx.fk_reg
         GROUP BY  lp.lsk, lp.num_reg, lp.pay_cd, lp.dt1, lp.dt2, g.state_cd, s.reu, g.fk_reg, 
                        SUBSTR (rx.s1, 1, 2), rx.fk_par,s.trest,srt.trest
         ORDER BY LSK)
         GROUP BY  trest,for_trest,'201207'


select sum(cnt) from   scott.xxito16 where dat between to_date('01.07.2012') and to_date('02.07.2012') 
union all
select   * from scott.xxito16 where mg='201207'

SELECT count(distinct kwtp_id) from scott.kwtp_day 
where dat_ink between to_date('02.07.2012') and to_date('04.07.2012') 
'проверить в понедельник со львом! что считать платежом.' 
select * from scott.kwtp_day where lsk = '65010943'
select * from ldo.l_kwtp where lsk='65010943'

select sum(cnt) from   scott.xxito16 where dat>=to_date('01.06.2012') and dat<=to_date('30.06.2012')
select * from scott.load_kwtp where err = 11593


select  reu,kul,nd,usl,org,dat,dat1,count(*)
from scott.koop
group by reu,kul,nd,usl,org,dat,dat1
having count(*)>1
order by reu,kul,nd,usl,org
select * from scott.koop where reu='26' and kul='0093' and nd='00021б' and usl=001 and org=72 
select * from scott.load_koop where id in('15333','15331')