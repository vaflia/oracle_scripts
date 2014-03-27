                select 
          sum(indebet) as indebet, sum(inkredit) as inkredit,sum(charges) as charges,
                            sum(changes) as changes, sum(subsid) as subsid, sum(privs) as privs, sum(privs_city) as privs_city,
                            sum(payment) as payment, sum(pn) as pn,sum(outdebet) as outdebet, sum(outkredit) as outkredit
                            from
                            (
      select o.lsk,x.mg, substr(x.mg, 1, 4)||'-'||substr(x.mg, 5, 2) as mg1, 
          t.trest||' '||t.name_tr as predpr, 
          o.reu, o.uch, k.name||', '||NVL(LTRIM(o.nd,'0'),'0')  as predpr_det, 
          decode(d.type,0,'Прочие','Основные') as type,
          st.name/*decode(h.status,1,'Частные','Муницип.')*/ as status, TO_CHAR(d.kod)||' '||d.name as org, m.nm1,
          sum(o.indebet) as indebet, sum(o.inkredit) as inkredit,
          sum(o.charges) as charges, sum(o.changes) as changes, sum(o.subsid) as subsid, sum(o.privs) as privs, sum(o.privs_city) as privs_city, sum(o.payment) as payment,
          sum(o.pn) as pn, sum(o.outdebet) as outdebet, sum(o.outkredit) as outkredit 
          FROM
          /*(
              SELECT e.*, org.type, s.trest 
                FROM scott.t_reu_kul_nd_lsk_status e, 
                         scott.sprorg org,
                         scott.s_reu_trest s 
              WHERE e.org=org.kod 
                   and e.reu=s.reu 
           ) h,  --я бы убрал этот запрос. итак все на основе его построено*/
          ( 
                SELECT lsk,reu,kul,nd,status,org,uslm,uch,mg, sum(indebet) as indebet, sum(inkredit) as inkredit,sum(charges) as charges,
                            sum(changes) as changes, sum(subsid) as subsid, sum(privs) as privs, sum(privs_city) as privs_city,
                            sum(payment) as payment, sum(pn) as pn,sum(outdebet) as outdebet, sum(outkredit) as outkredit
                FROM   scott.xitog2_s_lsk t
                WHERE t.mg between '201309' and '201309'
                GROUP BY lsk,reu,kul,nd,status,org,uslm,uch,mg
            ) o,
           (select * from scott.period_reports t where id=1006) x,
           scott.sprorg d, scott.uslm m, scott.org l, scott.s_reu_trest t, scott.spul k, 
           scott.status st
WHERE 
          o.status=st.id and
         -- h.lsk=o.lsk(+) and h.reu=o.reu(+) and h.kul=o.kul(+) and h.nd=o.nd(+) and h.org=o.org(+) and h.uslm=o.uslm(+) and h.status=o.status(+) and
         -- h.uch=o.uch(+) and
          l.id=1 and 
          o.org=d.kod (+) and 
          o.uslm=m.uslm(+)
          and o.reu=t.reu (+)
          and o.kul=k.id
          and x.mg=o.mg 
          and x.mg between '201308' and '201309' 
          group by o.lsk,x.mg, substr(x.mg, 1, 4)||'-'||substr(x.mg, 5, 2), t.trest||' '||t.name_tr, o.reu, k.name||', '||NVL(LTRIM(o.nd,'0'),'0'), st.name, d.type, o.uch, 
                    TO_CHAR(d.kod)||' '||d.name, m.nm1
          order by x.mg
          )
          UNION all
          select 
          sum(indebet) as indebet, sum(inkredit) as inkredit,sum(charges) as charges,
                            sum(changes) as changes, sum(subsid) as subsid, sum(privs) as privs, sum(privs_city) as privs_city,
                            sum(payment) as payment, sum(pn) as pn,sum(outdebet) as outdebet, sum(outkredit) as outkredit
                            from
               ( select o.lsk,x.mg, substr(x.mg, 1, 4)||'-'||substr(x.mg, 5, 2) as mg1, 
          t.trest||' '||t.name_tr as predpr, 
          o.reu, o.uch, k.name||', '||NVL(LTRIM(o.nd,'0'),'0')  as predpr_det, 
          decode(d.type,0,'Прочие','Основные') as type,
          st.name/*decode(h.status,1,'Частные','Муницип.')*/ as status, TO_CHAR(d.kod)||' '||d.name as org, m.nm1,
          sum(o.indebet) as indebet, sum(o.inkredit) as inkredit,
          sum(o.charges) as charges, sum(o.changes) as changes, sum(o.subsid) as subsid, sum(o.privs) as privs, sum(o.privs_city) as privs_city, sum(o.payment) as payment,
          sum(o.pn) as pn, sum(o.outdebet) as outdebet, sum(o.outkredit) as outkredit 
          FROM
          /*(
              SELECT e.*, org.type, s.trest 
                FROM scott.t_reu_kul_nd_lsk_status e, 
                         scott.sprorg org,
                         scott.s_reu_trest s 
              WHERE e.org=org.kod 
                   and e.reu=s.reu 
           ) h,  --я бы убрал этот запрос. итак все на основе его построено*/
          ( 
                SELECT lsk,reu,kul,nd,status,org,uslm,uch,mg, sum(indebet) as indebet, sum(inkredit) as inkredit,sum(charges) as charges,
                            sum(changes) as changes, sum(subsid) as subsid, sum(privs) as privs, sum(privs_city) as privs_city,
                            sum(payment) as payment, sum(pn) as pn,sum(outdebet) as outdebet, sum(outkredit) as outkredit
                FROM   scott.xitog2_s_lsk t
                WHERE t.mg between '201308' and '201309'
                GROUP BY lsk,reu,kul,nd,status,org,uslm,uch,mg
            ) o,
           (select * from scott.period_reports t where id=1006) x,
           scott.sprorg d, scott.uslm m, scott.org l, scott.s_reu_trest t, scott.spul k, 
           scott.status st
WHERE 
          o.status=st.id and
         -- h.lsk=o.lsk(+) and h.reu=o.reu(+) and h.kul=o.kul(+) and h.nd=o.nd(+) and h.org=o.org(+) and h.uslm=o.uslm(+) and h.status=o.status(+) and
         -- h.uch=o.uch(+) and
          l.id=1 and 
          o.org=d.kod (+) and 
          o.uslm=m.uslm(+)
          and o.reu=t.reu (+)
          and o.kul=k.id
          and x.mg=o.mg 
          and x.mg between '201308' and '201309' 
          group by o.lsk,x.mg, substr(x.mg, 1, 4)||'-'||substr(x.mg, 5, 2), t.trest||' '||t.name_tr, o.reu, k.name||', '||NVL(LTRIM(o.nd,'0'),'0'), st.name, d.type, o.uch, 
                    TO_CHAR(d.kod)||' '||d.name, m.nm1
          order by x.mg)
          
          
          
          
          select count(*) from 
          
          (    select o.lsk,x.mg, substr(x.mg, 1, 4)||'-'||substr(x.mg, 5, 2) as mg1, 
          t.trest||' '||t.name_tr as predpr, 
          o.reu, o.uch, k.name||', '||NVL(LTRIM(o.nd,'0'),'0')  as predpr_det, 
          decode(d.type,0,'Прочие','Основные') as type,
          st.name/*decode(h.status,1,'Частные','Муницип.')*/ as status, TO_CHAR(d.kod)||' '||d.name as org, m.nm1,
          sum(o.indebet) as indebet, sum(o.inkredit) as inkredit,
          sum(o.charges) as charges, sum(o.changes) as changes, sum(o.subsid) as subsid, sum(o.privs) as privs, sum(o.privs_city) as privs_city, sum(o.payment) as payment,
          sum(o.pn) as pn, sum(o.outdebet) as outdebet, sum(o.outkredit) as outkredit 
          FROM
          /*(
              SELECT e.*, org.type, s.trest 
                FROM scott.t_reu_kul_nd_lsk_status e, 
                         scott.sprorg org,
                         scott.s_reu_trest s 
              WHERE e.org=org.kod 
                   and e.reu=s.reu 
           ) h,  --я бы убрал этот запрос. итак все на основе его построено*/
          ( 
                SELECT /*+ index(t XITOG2_S_LSK_TREST_IDX )*/
                lsk,reu,kul,nd,status,org,uslm,uch,mg, sum(indebet) as indebet, sum(inkredit) as inkredit,sum(charges) as charges,
                            sum(changes) as changes, sum(subsid) as subsid, sum(privs) as privs, sum(privs_city) as privs_city,
                            sum(payment) as payment, sum(pn) as pn,sum(outdebet) as outdebet, sum(outkredit) as outkredit
                FROM   scott.xitog2_s_lsk t
                WHERE t.mg between '201309' and '201309' and trest='07'
                GROUP BY lsk,reu,kul,nd,status,org,uslm,uch,mg
            ) o,
           (select * from scott.period_reports t where id=1006) x,
           scott.sprorg d, scott.uslm m, scott.org l, scott.s_reu_trest t, scott.spul k, 
           scott.status st
WHERE 
          o.status=st.id and
         -- h.lsk=o.lsk(+) and h.reu=o.reu(+) and h.kul=o.kul(+) and h.nd=o.nd(+) and h.org=o.org(+) and h.uslm=o.uslm(+) and h.status=o.status(+) and
         -- h.uch=o.uch(+) and
          l.id=1 and 
          o.org=d.kod (+) and 
          o.uslm=m.uslm(+)
          and o.reu=t.reu (+)
          and o.kul=k.id
          and x.mg=o.mg 
          and x.mg between '201309' and '201309' 
          group by o.lsk,x.mg, substr(x.mg, 1, 4)||'-'||substr(x.mg, 5, 2), t.trest||' '||t.name_tr, o.reu, k.name||', '||NVL(LTRIM(o.nd,'0'),'0'), st.name, d.type, o.uch, 
                    TO_CHAR(d.kod)||' '||d.name, m.nm1
          order by x.mg
          )
          
          select count(*) from XITOG2_S_lsk t where t.reu='73'
          
          prep.kwtp_olap
          
          
          scott.a_flow_tp
          scott.xito_fin_reu
          
          select s.tot,k.* from scott.load_kartw k, scott.sptar s
          where status=8 and s.gtr=k.gt
          
           lsk='72244757'
          select * from sptar where tot=0322
          select * from scott.status
          
          
         выводы  lsk='72244757'
         так как sp tot=0 то и нету площади по отоплению в стате
         
          scott.usl
          
          
          scott.reports
          scott.period_reports
          
          
          select distinct mg from scott.xitog2_s_lsk
          
select *from ldo.load_gw where sch=0
 -- запросы на обновление
          
      MERGE INTO scott.xitog2_s_lsk l
      USING (
                    SELECT distinct lsk,reu,kul,nd,kw FROM SCOTT.KART
                ) o
 ON (  
                 l.lsk = o.lsk
           and l.reu=o.reu and l.nd=o.nd
           and l.kul=o.kul
       )
       when matched then update
           set l.kw=o.kw
           
        MERGE INTO scott.xitog2_s_lsk l
      USING (
                    SELECT distinct lsk,reu,kul,nd,kw,psch,sch_el FROM SCOTT.KART
                ) o
 ON (  
                 l.lsk = o.lsk
           and l.reu=o.reu 
           and l.kul=o.kul
           and l.nd=o.nd
       )
       when matched then update
           set l.sch = case when l.uslm='006' then decode(o.psch,1,1,2,1,0,0,3,0,0) 
                                  when l.uslm='008' then decode(o.psch,1,1,3,1,0,0,2,0,0) 
                                  when l.uslm='015' then decode(o.sch_el,1,1,0,0,0) else 0
                           end   
           
           
           select * from scott.xitog2_s_lsk where kw is null
         
       scott.statistics_lsk

       select distinct uslm, s_ras_sch from scott.usl order by s_ras_sch

       //данные
       decode(s.sch,1,'Счетчик','Норматив') as sch, 
       006    decode(krt.psch,1,1,2,1,0,0,3,0,0)
       008    decode(krt.psch,1,1,3,1,0,0,2,0,0)
       015    decode(krt.sch_el,1,1,0,0,0)

 
           
           
           
           
                SELECT lsk,t.kw,t.reu,t.kul,t.nd,status,t.org,t.uslm,uch,mg, sum(indebet) as indebet, sum(inkredit) as inkredit,sum(charges) as charges,
                            sum(changes) as changes, sum(subsid) as subsid, sum(privs) as privs, sum(privs_city) as privs_city,
                            sum(payment) as payment, sum(pn) as pn,sum(outdebet) as outdebet, sum(outkredit) as outkredit,
                            decode(t.sch,1,''Счетчик'',''Норматив'') as sch
                FROM   scott.xitog2_s_lsk t, scott.tree_usl_temp u
                           , scott.tree_org_temp o
                           --, scott.tree_objects_temp obj
                WHERE 
                        t.trest=:trest_ and 
                    --- and obj.reu=:reu_ and    
                          t.mg between :mg_ and :mg1_
                     and u.uslm=t.uslm
                     and t.org=o.org 
                     and u.sel=0
                     and o.sel=0
                 --    and obj.sel=0
                GROUP BY lsk,t.kw,t.reu,t.kul,t.nd,status,t.org,t.uslm,uch,mg,decode(t.sch,1,''Счетчик'',''Норматив'')
                
                
SELECT uslm,--lsk,t.kw,t.reu,t.kul,t.nd,status,t.org,t.uslm,uch,mg, 
            sum(indebet) as indebet, sum(inkredit) as inkredit,sum(charges) as charges,
            sum(changes) as changes, sum(subsid) as subsid, sum(privs) as privs, sum(privs_city) as privs_city,
            sum(payment) as payment, sum(pn) as pn,sum(outdebet) as outdebet, sum(outkredit) as outkredit
         --   decode(t.sch,1,'Счетчик','Норматив') as sch
FROM   scott.xitog2_s_lsk t
           --  , scott.tree_usl_temp u
           --  , scott.tree_org_temp o
           --, scott.tree_objects_temp obj
WHERE 
      --  t.trest=:trest_ and 
         t.reu='70' and    
         t.mg between '201309' and '201309'
group by uslm
     and u.uslm=t.uslm
     and t.org=o.org 
     and u.sel=0
     and o.sel=0
 --    and obj.sel=0
GROUP BY lsk,t.kw,t.reu,t.kul,t.nd,status,t.org,t.uslm,uch,mg,decode(t.sch,1,'Счетчик','Норматив')
                

SELECT t.uslm, t.trest,
  --lsk,t.kw,t.reu,t.kul,t.nd,status,t.org,t.uslm,uch,mg, 
            sum(indebet) as indebet, sum(inkredit) as inkredit,sum(charges) as charges,
            sum(changes) as changes, sum(subsid) as subsid, sum(privs) as privs, sum(privs_city) as privs_city,
            sum(payment) as payment, sum(pn) as pn,sum(outdebet) as outdebet, sum(outkredit) as outkredit
         --   decode(t.sch,1,'Счетчик','Норматив') as sch
FROM   scott.xitog2_s_lsk t
             , scott.tree_usl_temp u
           --  , scott.tree_org_temp o
           --, scott.tree_objects_temp obj
WHERE 
      --  t.trest=:trest_ and 
  ---       t.reu='70' and
         t.mg between '201309' AND  '201309'  and 
         u.sel=0 and T.USLM=U.USLM
         --and  (T.USLM=U.USLM    and  t.uslm='100' OR t.uslm='108')
         --and uslm in ('200','105','104','107','108','106','100','109')
         group by t.uslm,t.trest
         
         scott.s_reu_trest
         
         uslm
         scott.tree_objects_temp
     
         select distinct uslm from scott.swx_out
         
         
         var_usl1
         
         
         
         
     
      declare 
         l_cnt number;
         l_cnt2 number;
      begin
              SELECT  
                        max(case when uslm='001' and sel=0 then 1 else 0 end) as caprem
                       ,max(case when uslm='002' and sel=0 then 1 else 0 end) as teksod
                  INTO l_cnt, l_cnt2
                FROM scott.tree_usl_temp
              WHERE uslm in ('001','002');
       end;    
       
       
       
MERGE [hint] INTO [schema .] table [t_alias] USING [schema .] 

{ table | view | subquery } [t_alias] ON ( condition ) 

WHEN MATCHED THEN merge_update_clause 

WHEN NOT MATCHED THEN merge_insert_clause;
 MERGE INTO dept d
     USING (SELECT deptno, dname, loc
            FROM dept_online) o
     ON (d.deptno = o.deptno)
     WHEN MATCHED THEN
         UPDATE SET d.dname = o.dname, d.loc = o.loc
     WHEN NOT MATCHED THEN
         INSERT (d.deptno, d.dname, d.loc)
         VALUES (o.deptno, o.dname, o.loc);

    merge   into scott.tree_usl_temp u
            using (SELECT case when uslm='001' then '108' 
                                         when uslm='002' then '100' end uslm,sel 
--                                  max(case when uslm='001' and sel=0 then 1 else 0 end) as caprem,
  --                                max(case when uslm='002' and sel=0 then 1 else 0 end) as teksod
                       FROM scott.tree_usl_temp
                     WHERE uslm in ('001','002')
                     and sel=0
                     ) t
                     ON (u.uslm=t.uslm)
           when matched then update   set u.sel=0         
                     
               --001 кап ремонт-108 кап ремонт.с.н.
               --002 тек содерж - 100 тек содерж.с.н.
         IF l_cnt=1 then
                update scott.tree_usl_temp set sel=0 where uslm='108';
         END IF;
         IF l_cnt2=1 then
                update scott.tree_usl_temp set sel=0 where uslm='100';
         END IF;
         
         
         
         
         
begin
  -- Call the procedure
  ldo.l_loadreg.load_reg_list(NULL);
end;
scott.spul
ldo.
0133
 /*рабочий вариант создания общей таблицы*/
 truncate table   scott.t_reu_kul_nd_lsk_status
 
 
 INSERT INTO /*+ APPEND*/ 
  scott.t_reu_kul_nd_lsk_status

      (lsk,reu, kul, nd, status, org, uslm, uch)
      select distinct k.lsk, k.reu,
                      k.kul,
                      k.nd,
                      nvl(s.id, 0) as status,  --если статус - null то = 0
                      org,
                      uslm, 
                      nvl(f.uch,0) as uch --если участок - null то = 0
        from (select a.lsk, a.org, a.uslm
                from scott.saldo a, scott.sprorg u, scott.v_params v
               where a.org = u.kod
                 and u.type in (0, 1)
                 and a.mg = v.period-1
              union all
              select e.lsk, e.org, uslm
                from scott.t_charges_for_saldo e
              union all
              select e.lsk, e.org, uslm
                from scott.t_changes_for_saldo e
              union all
              select e.lsk, e.org, uslm
                from scott.t_subsidii_for_saldo e
              union all
              select e.lsk, e.org, uslm
                from scott.t_payment_for_saldo e
              union all
              select e.lsk, e.org, uslm
                from scott.t_privs_for_saldo e
              union all
              select e.lsk, e.org, uslm from scott.t_penya_for_saldo e) a,
             scott.kart k, scott.status s, scott.koop_uch f
       where a.lsk = k.lsk and k.status=s.id and k.fk_koop=f.fk_koop(+);
       
       select * FROM SCOTT.KART WHERE FK_KOOP=16074
        select count (*) from  scott.t_reu_kul_nd_lsk_status
       select * from  scott.t_reu_kul_nd_lsk_status a
       where exists
       (
           select lsk,count(*) from  scott.t_reu_kul_nd_lsk_status b
           where a.lsk=b.lsk
           group by lsk
           having count(*)>1        
       )