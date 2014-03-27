SELECT a.lsk, sum(a.vol_sch_n), sum (a.vol_sch_s), sum (a.vol_n),
            coalesce(sum (b.vol_cub_gw),0), 
            coalesce(sum (a.vol_sch_n)+ sum (a.vol_sch_s)+ coalesce(sum (b.vol_cub_gw),0)+ sum (a.vol_n) ,0) as summa
FROM
 (
 SELECT      lsk,     sum(a.vol_n) as  vol_n,
            -- считаем кубы горячей воды по счетчику по ЖИЛЫМ помещениям
                -- по нормативу
           sum(CASE WHEN a.status NOT IN (8, 9, 10, 11, 12)
                           THEN a.vol_sch_n else 0
                   END)  AS vol_sch_n,
                -- по счетчику
           sum(CASE WHEN a.status NOT IN (8, 9, 10, 11, 12)
                           THEN a.vol_sch_s else 0
                   END)  AS vol_sch_s
            -- считаем площади отоплнеия токо по ЖИЛЫМ помещениям
                --по соц норме
FROM 
          (
          SELECT lsk,status,
            case when  sum( 
                              decode(t.usl,'015', decode(t.psch,0,nvl(t.volume,0),0),'016', decode(t.psch,0,nvl(t.volume,0),0),0)
                                 ) > = sum( 
                             decode(t.usl,'016', decode(t.psch,0,nvl(t.dop_vol,0),0),'017', decode(t.psch,0,nvl(t.dop_vol,0),0),0)
                               )  then   sum( 
                              decode(t.usl,'015', decode(t.psch,0,nvl(t.volume,0),0),'016', decode(t.psch,0,nvl(t.volume,0),0),0)
                                 )   else  sum( 
                             decode(t.usl,'016', decode(t.psch,0,nvl(t.dop_vol,0),0),'017', decode(t.psch,0,nvl(t.dop_vol,0),0),0)
                               )   end vol_n,
            case when
                  sum( decode(uslm,'008',decode(t.psch,1,decode(u.usl_norm,0,nvl(t.volume,0),0),0),0))>=sum( decode(uslm,'008',decode(t.psch,1,decode(u.usl_norm,0,nvl(t.dop_vol,0),0),0),0)) then
                  sum( decode(uslm,'008',decode(t.psch,1,decode(u.usl_norm,0,nvl(t.volume,0),0),0),0))
                  else
                  sum( decode(uslm,'008',decode(t.psch,1,decode(u.usl_norm,0,nvl(t.dop_vol,0),0),0),0))
                  end vol_sch_n,
            case when
                  sum( decode(uslm,'008',decode(t.psch,1,decode(u.usl_norm,1,nvl(t.volume,0),0),0),0))>= sum( decode(uslm,'008',decode(t.psch,1,decode(u.usl_norm,1,nvl(t.dop_vol,0),0),0),0))then 
                  sum( decode(uslm,'008',decode(t.psch,1,decode(u.usl_norm,1,nvl(t.volume,0),0),0),0))
                  else 
                  sum( decode(uslm,'008',decode(t.psch,1,decode(u.usl_norm,1,nvl(t.dop_vol,0),0),0),0))
                  end vol_sch_s
           FROM 
                  prep.info_usl_lsk t, 
                  usl u, s_reu_trest s, spul u
           WHERE t.mg between '201210' and '201210'
                  and t.kul  = u.id
                  and t.reu = s.reu 
                  and u.usl = t.usl
                  and uslm  in ('004','008')   
                  and t.reu='34'
               --   and t.reu||t.kul||t.nd in (select reu||kul||nd from prep.list_choices where sel=0)
                GROUP BY  t.status,t.lsk
                           --     'РЭУ-'||t.reu||' '||u.name||', д.'||ltrim(t.nd,'0')|| ' Ввода № '||t.vvod_gw
                  )  a
GROUP BY  a.lsk
                 ) a,
           (  SELECT lsk, coalesce(sum(t.gw),0) as vol_cub_gw, coalesce(sum(t.gw_dop),0) as vol_mop_cub_gw
                FROM SCOTT.T_VOLUME_USL_IZM t, SCOTT.S_REU_TREST s, scott.spul u
              WHERE 
                    t.kul  = u.id AND 
                    t.reu = s.reu
              and t.reu='34'
           GROUP BY  lsk
            ) b
WHERE a.lsk=b.lsk (+)  
GROUP BY a.LSK
HAVING coalesce(sum (a.vol_sch_n)+ sum (a.vol_sch_s)+ coalesce(sum (b.vol_cub_gw),0) + sum (a.vol_n),0)<>0 
ORDER BY LSK
      


