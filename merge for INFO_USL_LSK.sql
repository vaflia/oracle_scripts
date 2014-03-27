 SELECT 
                o.uch,  o.reu, k.name||', '||NVL(LTRIM(o.nd,'0'),'0')  as predpr_det, o.kw, o.lsk,   
                      x.mg, substr(x.mg, 1, 4)||'-'||substr(x.mg, 5, 2) as mg1, 
                      t.trest||' '||t.name_tr as predpr,
                      decode(d.type,0,'Прочие','Основные') as type,
                      st.name as status, TO_CHAR(d.kod)||' '||d.name as org, m.nm1,
                      o.sch,           
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
                 SELECT /*+ index(t  XITOG2_S_LSK_REU_KUL_ND_IDX)*/ 
                            lsk,t.kw,t.reu,t.kul,t.nd,status,t.org,t.uslm,uch,mg, sum(indebet) as indebet, sum(inkredit) as inkredit,sum(charges) as charges,
                            sum(changes) as changes, sum(subsid) as subsid, sum(privs) as privs, sum(privs_city) as privs_city,
                            sum(payment) as payment, sum(pn) as pn,sum(outdebet) as outdebet, sum(outkredit) as outkredit,
                            decode(t.sch,1,'Счетчик','Норматив') as sch
                FROM   scott.xitog2_s_lsk t, scott.tree_usl_temp u
                           , scott.tree_org_temp o
                           , scott.tree_objects_temp obj
                WHERE 
                           t.mg between '201309' and '201309'
                     and obj.trest=t.trest
                     and u.uslm=t.uslm
                     and t.org=o.org 
                     and u.sel=0
                     and o.sel=0
                     and obj.sel=0
                GROUP BY lsk,t.kw,t.reu,t.kul,t.nd,status,t.org,t.uslm,uch,mg,decode(t.sch,1,'Счетчик','Норматив')
            ) o,
           (select * from scott.period_reports t where id='68') x,
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
                    TO_CHAR(d.kod)||' '||d.name, m.nm1, o.kw, o.sch
          order by x.mg
          
          
          update scott.info_usl_nd i, ldo.load_gw lg 
                    set  sch=0 
          where mg='201309'
          and  exists (
                          SELECT reu,kul,nd,vvod,coalesce(sch,0) as sch, 
                            case when tip=2 then '011' 
                                   when tip=3 then '015'
                                   when tip=4 then '007'
                            else null
                            end as usl       
                  FROM ldo.load_gw t1
                WHERE '201309' between dat_nach and dat_end
                and t.reu=t1.reu and t.kul=t1.kul and t.nd=t1.nd 
                and t.vvod_gw=T1.VVOD and t.usl=case when tip=2 then '011' 
                                                              when tip=3 then '015'
                                                              when tip=4 then '007'
                                                              else null  end
                
                )
                       
                merge into  scott.info_usl_lsk i
                using ( select lg.*,u.usl from
                                 (SELECT reu,kul,nd,vvod,coalesce(sch,0) as sch, 
                                            case when tip=2 then '006' 
                                                   when tip=3 then '008'
                                                   when tip=4 then '004'
                                            else null
                                            end as uslm     
                                  FROM ldo.load_gw t1
                                WHERE '201309' between dat_nach and dat_end) lg , scott.usl u
                                where lg.uslm=u.uslm ) lg
                 ON  
                (
                 i.reu=lg.reu and i.kul=lg.kul and i.nd=lg.nd 
                and i.vvod_gw=lg.VVOD and i.usl=lg.usl and i.mg='201309')
                WHEN MATCHED THEN UPDATE
                      set  i.sch=LG.SCH
                      
          update scott.info_usl_nd set sch=null where mg='201309'
          select * from scott.info_usl_lsk where lsk='30077215' and mg='201309'
          select * from ldo.load_gw where reu='L1' and kul='0040' and nd='000024'
          select lsk,reu,kul,nd,kw,FIO,psch,vvod,vvod_gw,vvod_ot from scott.prepload_kartw where reu='11' and kul='0003' and nd='000111'
          select vvod,vvod_gw,vvod_ot,k.* from scott.prepload_kartw k where lsk='30077215'           
                
          select distinct lsk,usl from scott.info_usl_lsk where mg='201309' and sch is null
          

          where i.mg='201309'
          where 
          and  exists (
                          SELECT reu,kul,nd,vvod,coalesce(sch,0) as sch, 
                            case when tip=2 then '011' 
                                   when tip=3 then '015'
                                   when tip=4 then '007'
                            else null
                            end as usl       
                  FROM ldo.load_gw t1
                WHERE '201309' between dat_nach and dat_end
                and t.reu=t1.reu and t.kul=t1.kul and t.nd=t1.nd 
                and t.vvod_gw=T1.VVOD and t.usl=case when tip=2 then '011' 
                                                              when tip=3 then '015'
                                                              when tip=4 then '007'
                                                              else null  end
                
                )
                
                
                
                select *from scott.info_usl_nd 
                where sch is null
                
                ldo.load_gw
                select * from scott.load_kartw where reu='34' and kul='0068' and nd='000029'
                
                usl
                
                select distinct usl,vvod_gw from scott.info_usl_lsk
                where mg = '201309' 
                and vvod_gw is null
                
                select reu,kul,nd,vvod_gw,usl
                 from scott.info_usl_nd
                where mg = '201309'  and sch=5
                order by reu,kul,nd,usl
                
             услм  усл 
             004   007-ОТ
             006   011-ХВ
             008   015-ГВ
--              
             select * from (  
            select   reu,kul,nd,usl,
                        max(case when usl='007' then to_number(vvod_gw) else 0 end) as a,
                        max(case when usl='015' then to_number(vvod_gw) else 0 end) as b
                 from scott.info_usl_lsk
                where mg = '201309'
                group by reu,kul,nd,usl     
                  order by reu,kul,nd,usl
                  ) where a<>b
                  
                  create table prep.info_usl_lsk201309 as select * from scott.info_usl_lsk where mg='201309' 
                  create table prep.info_usl_nd201309 as select * from scott.info_usl_nd where mg='201309'

       
                             
       merge into scott.info_usl_lsk  b
        using ( select a.lsk, a.vvod,u.usl from
         (         
                select lsk,vvod as vvod, '006' as uslm from scott.prepload_kartw
                union all
                select lsk,vvod_gw, '008' from scott.prepload_kartw
                union all
                select lsk,vvod_ot, '004' from scott.prepload_kartw
             ) a , scott.usl u 
             where a.uslm=u.uslm) a
         on (a.lsk=b. lsk
         and a.usl=b.usl
         and b.mg='201309')   
         when matched then update
          set b.vvod_gw=a.vvod
                  
select * from scott.info_usl_nd 
where reu='87' and nd='000121' and kul='0082' and mg='201309'                  
          
          select distinct u.uslm
          FROM 
          (
           select a.lsk, a.vvod,u.usl from
         (         
                select lsk,vvod as vvod, '006' as uslm from scott.prepload_kartw
                union all
                select lsk,vvod_gw, '008' from scott.prepload_kartw
                union all
                select lsk,vvod_ot, '004' from scott.prepload_kartw
             ) a , scott.usl u 
             where a.uslm=u.uslm) a , scott.usl u 
             where a.usl=u.usl
                  
22    0118    000019    1    0
25    0111    00001а    0    1
73    0133    00013а    0    1
73    0133    00023б    1    0
83    0006    00055б    8    3

select lsk,vvod, vvod_gw, vvod_ot from scott.prepload_kartw where 
reu='73' and kul='0133' and nd='00013а'

select lsk,usl, vvod_gw from scott.info_usl_lsk
where reu='73' and kul='0133' and nd='00013а'
and mg='201309'
07180201    0    0    2
select * from scott.info_usl_lsk
where reu='22' and kul='0118' and nd='000019'
and mg='201309'

spul

select lsk, reu,kul,nd, vvod_gw,vvod_ot
from scott.load_kartw
where-- vvod_gw<>vvod_ot
reu='22' and kul='0118' and nd='000019'
scott.s_reu_trest




 DELETE FROM scott.info_usl_nd where mg=mg_; 
 INSERT INTO scott.info_usl_nd ( reu,kul,nd,usl,org,vvod_gw,charges,changes,privs,payment,volume,mg,
                                        psch,kpr,opl, f, f1, dop_opl, dop_kpr, dop_vol,  status, gkal, gkal_n, vol_izm, gkal_izm,sch
                                       )
 SELECT  t.reu, t.kul, t.nd, t.usl, t.org, t.vvod_gw, sum(t.charges), sum(t.changes), sum(t.privs) , sum(t.payment), sum(t.volume), t.mg,
              t.psch, sum(t.kpr) , sum(t.opl), sum(f), sum(t.k_sum), sum(t.dop_opl), sum(t.dop_kpr), sum(t.dop_vol), t.status, sum(t.gkal), sum(t.gkal_n)
              ,sum (case when t.usl<>'007' then izm.vol_izm else 0 end) as  vol_izm
              ,sum (case when t.usl='007' then izm.gkal_izm else 0 end) as gkal_izm,
              t.sch
  FROM   scott.info_usl_lsk t, 
          ( select lsk, org, usl, sum(vol) as vol_izm,sum(gkal) as gkal_izm from scott.t_volume_usl_izm where mg='201309'  group by lsk, org, usl ) izm
  WHERE     t.mg = '201309'
         and   t.lsk  = izm.lsk   (+)
         and   t.org = izm.org (+)
         and   t.usl  = izm.usl   (+)
  GROUP BY t.reu, t.kul, t.nd, t.usl, t.org, t.mg, t.psch, t.vvod_gw, t.status,t.sch;

 DELETE FROM scott.info_usl_nd where mg='201309'; 
 INSERT INTO scott.info_usl_nd ( reu,kul,nd,usl,org,vvod_gw,charges,changes,privs,payment,volume,mg,
                                        psch,kpr,opl, f, f1, dop_opl, dop_kpr, dop_vol,  status, gkal, gkal_n, vol_izm, gkal_izm
                                       )
 SELECT  t.reu, t.kul, t.nd, t.usl, t.org, t.vvod_gw, sum(t.charges), sum(t.changes), sum(t.privs) , sum(t.payment), sum(t.volume), t.mg,
              t.psch, sum(t.kpr) , sum(t.opl), sum(f), sum(t.k_sum), sum(t.dop_opl), sum(t.dop_kpr), sum(t.dop_vol), t.status, sum(t.gkal), sum(t.gkal_n)
              ,sum (case when t.usl<>'007' then izm.vol_izm else 0 end) as  vol_izm
              ,sum (case when t.usl='007' then izm.gkal_izm else 0 end) as gkal_izm
  FROM   scott.info_usl_lsk t, 
          ( select lsk, org, usl, sum(vol) as vol_izm,sum(gkal) as gkal_izm from scott.t_volume_usl_izm where mg='201309'  group by lsk, org, usl ) izm
  WHERE     t.mg = '201309'
         and   t.lsk  = izm.lsk   (+)
         and   t.org = izm.org (+)
         and   t.usl  = izm.usl   (+)
  GROUP BY t.reu, t.kul, t.nd, t.usl, t.org, t.mg, t.psch, t.vvod_gw, t.status;
  