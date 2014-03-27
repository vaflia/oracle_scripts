SELECT a.*, b.* 
FROM
 (SELECT ROW_NUMBER () over (order by a.vvod_gw)  rown,  
           a.vvod_gw, 
          sum(kpr_sch) kpr_sch,sum (kpr_n) kpr_n,sum (pl_sg) pl_sg, 
          sum(vol_n) vol_n, 
         -- sum(vol_sch_n) vol_sch_n, sum(vol_sch_s) vol_sch_s,
          --sum(pl_no) pl_no, sum(pl_so) pl_so,   убрал так как считается отдельно по жилым и по нежилым
          sum(cr_mop) cr_mop, sum(cr_moptr) cr_moptr, 
          sum(vol_odn) vol_odn/*жилые и нежилые*/, 
        --  sum(vol_odn_n) vol_odn_n, sum(vol_odn_s) vol_odn_s, 
          sum (cr_n_mop) cr_n_mop,
          sum(cr_n_moptr) cr_n_moptr, 
          sum(cr_sch_mop) cr_sch_mop, sum(cr_sch_moptr) cr_sch_moptr,
          sum(cr_n_gw) cr_n_gw, sum(cr_n_gwtr) cr_n_gwtr, sum(lg_n_gw) lg_n_gw, sum(lg_n_gwtr) lg_n_gwtr, sum(cr_sch_gw_n) cr_sch_gw_n,
          sum(cr_sch_gw_s) cr_sch_gw_s, sum(cr_sch_gwtr_n) cr_sch_gwtr_n, sum(cr_sch_gwtr_s) cr_sch_gwtr_s, sum(lg_sch_gw_n) lg_sch_gw_n,
          sum(lg_sch_gw_s) lg_sch_gw_s, sum(lg_sch_gwtr_n) lg_sch_gwtr_n, sum(lg_sch_gwtr_s) lg_sch_gwtr_s, sum(cr_no) cr_no,sum(cr_so) cr_so,
          sum(cr_notr) cr_notr, sum(cr_sotr) cr_sotr, sum(lg_no) lg_no, sum(lg_so) lg_so, sum(lg_notr) lg_notr, sum(lg_sotr) lg_sotr, 
          sum(cn_gw) cn_gw, sum(cn_gwtr) cn_gwtr, sum(cn_ot) cn_ot, sum(cn_ottr) cn_ottr, sum(cn_sgw) cn_sgw, sum(cn_sgwtr) cn_sgwtr, 
          sum(cn_sot) cn_sot, sum(cn_sottr) cn_sottr, sum(cn_sch_gw) cn_sch_gw, sum (cn_sch_gwtr) cn_sch_gwtr, sum(cn_sch_sgw) cn_sch_sgw,
          sum(cn_sch_sgwtr)  cn_sch_sgwtr, sum(cn_n_gw) cn_n_gw, sum(cn_n_gwtr)  cn_n_gwtr, sum(cn_n_mop) cn_n_mop, 
          sum(cn_n_moptr) cn_n_moptr, sum(cn_sch_mop) cn_sch_mop, sum ( cn_sch_moptr)  cn_sch_moptr, 
          sum(pn_gw) pn_gw, sum(pn_gwtr) pn_gwtr, sum(pn_ot) pn_ot, sum(pn_ottr) pn_ottr,
          sum(pn_sgw) pn_sgw, sum(pn_sgwtr) pn_sgwtr, sum(pn_sot) pn_sot, sum(pn_sottr) pn_sottr,
          sum(pn_sch_gw) pn_sch_gw, sum(pn_sch_gwtr) pn_sch_gwtr, sum(pn_sch_sgw) pn_sch_sgw, sum(pn_sch_sgwtr) pn_sch_sgwtr,
          sum(pn_n_gw) pn_n_gw, sum(pn_n_gwtr) pn_n_gwtr,
          sum(k_gw) k_gw,
          sum(k_gwtr) k_gwtr, sum(k_ot) k_ot, sum(k_ottr) k_ottr, sum(k_sgw) k_sgw, sum(k_sgwtr) k_sgwtr, sum(k_sot) k_sot, sum(k_sottr) k_sottr,
          sum(k_sch_gw), sum(k_sch_gwtr), sum(k_sch_sgw) k_sch_sgw, sum(k_sch_sgwtr) k_sch_sgwtr, sum(k_n_gw) k_n_gw, sum(k_n_gwtr) k_n_gwtr,
          sum(kl_gw) kl_gw, sum(kl_gwtr) kl_gwtr, sum(kl_ot) kl_ot, sum(kl_ottr) kl_ottr, sum(kl_sgw) kl_sgw, sum(kl_sgwtr) kl_sgwtr,
          sum(kl_sot) kl_sot, sum(kl_sottr) kl_sottr, sum(kl_sch_gw) kl_sch_gw, sum(kl_sch_gwtr) kl_sch_gwtr, sum(kl_n_gw) kl_n_gw, sum(v_gw) v_gw,
          sum(v_gwtr) v_gwtr, sum(v_ot) v_ot, sum(v_ottr) v_ottr, sum(v_sgw) v_sgw, sum(v_sgwtr) v_sgwtr, sum(v_sot) v_sot, sum(v_sottr) v_sottr,
          sum(v_sch_gw) v_sch_gw, sum(v_sch_gwtr) v_sch_gwtr, sum(v_sch_sgw) v_sch_sgw, sum(v_sch_sgwtr) v_sch_sgwtr, sum(v_n_gw) v_n_gw,
          sum(v_n_gwtr) v_n_gwtr, sum(vl_gw) vl_gw, sum(vl_gwtr) vl_gwtr, sum(vl_ot) vl_ot, sum (vl_ottr) vl_ottr, sum(vl_sgw) vl_sgw,
          sum(vl_sgwtr) vl_sgwtr, sum(vl_sot) vl_sot, sum(vl_sottr) vl_sottr, sum(vl_sch_gw) vl_sch_gw, sum(vl_sch_gwtr) vl_sch_gwtr,
          sum(vl_sch_sgw) vl_sch_sgw,sum(vl_sch_sgwtr) vl_sch_sgwtr, sum(vl_n_gw) vl_n_gw, sum(vl_n_gwtr) vl_n_gwtr,
          
              
            -- считаем кубы горячей воды по счетчику по ЖИЛЫМ помещениям
                -- по нормативу
           sum(CASE WHEN a.status NOT IN (8, 9, 10, 11, 12)
                           THEN a.vol_sch_n else 0
                   END)  AS vol_sch_n,
                -- по счетчику
           sum(CASE WHEN a.status NOT IN (8, 9, 10, 11, 12)
                           THEN a.vol_sch_s else 0
                   END)  AS vol_sch_s, 
            -- считаем площади отоплнеия токо по ЖИЛЫМ помещениям
                --по соц норме
           sum(CASE WHEN a.status NOT IN (8, 9, 10, 11, 12)
                           THEN a.pl_no else 0
                   END)  AS PL_NO,
               --счерх соц нормы
          sum(CASE WHEN a.status NOT IN (8, 9, 10, 11, 12)
                           THEN a.pl_so else 0
                   END)  AS PL_SO,
               --считаем ОДН по ЖИЛЫМ  помещениям объемы    
                   --по нормативу
          sum(CASE WHEN a.status NOT IN (8, 9, 10, 11, 12)
                           THEN a.vol_odn_n else 0
                   END)  AS vol_odn_n,
                   --сверх норматива
          sum(CASE WHEN a.status NOT IN (8, 9, 10, 11, 12)
                           THEN a.vol_odn_s else 0
                   END)  AS vol_odn_s,
                       
                -- считаем ОДН по НЕЖИЛЫМ помещениям п.3,3,3   
         sum(CASE WHEN a.status IN ( 8, 9, 10, 11, 12)
                           THEN a.vol_odn else 0
                   END)  AS vol_odn_nejil_pom,
                -- считаем гор вода по счетчику по НЕЖИЛЫМ объем. П.3,3,2
         sum(CASE WHEN a.status IN (8, 9, 10, 11, 12)
                       THEN a.vol_sch_n+vol_sch_s else 0
                END)  AS vol_sch_nejil_pom    ,
            -- считаем отопление площади по НЕЖИЛЫМ кв.м. П.2,1,3
         sum(CASE WHEN a.status IN (8, 9, 10, 11, 12)
                       THEN a.pl_no+pl_so else 0
               END)  AS pl_npo       
       
FROM 
  (
     SELECT  1 as vvod_gw,
     t.status,
 case when
  sum(decode(uslm,'008',decode(t.psch,1,nvl(t.kpr,0),0),0))>=sum( decode(uslm,'008',decode(t.psch,1,nvl(t.dop_kpr,0),0),0)) then
     sum( decode(uslm,'008',decode(t.psch,1,nvl(t.kpr,0),0),0))
  else sum( decode(uslm,'008',decode(t.psch,1,nvl(t.dop_kpr,0),0),0)) end kpr_sch,
  
  case when
  sum( decode(uslm,'008',decode(t.psch,0,nvl(t.kpr,0),0),0))>=sum( decode(uslm,'008',decode(t.psch,0,nvl(t.dop_kpr,0),0),0)) then
     sum( decode(uslm,'008',decode(t.psch,0,nvl(t.kpr,0),0),0))
  else sum( decode(uslm,'008',decode(t.psch,0,nvl(t.dop_kpr,0),0),0)) end  kpr_n,

 case when
  sum(decode(uslm,'008',decode(t.psch,1,nvl(t.opl,0),0),0))>=sum( decode(uslm,'008',decode(t.psch,1,nvl(t.dop_opl,0),0),0)) then
     sum( decode(uslm,'008',decode(t.psch,1,nvl(t.opl,0),0),0))
  else sum( decode(uslm,'008',decode(t.psch,1,nvl(t.dop_opl,0),0),0)) end pl_sg,
  
  case when
  sum( decode(uslm,'008',decode(t.psch,0,nvl(t.opl,0),0),0))>=sum( decode(uslm,'008',decode(t.psch,0,nvl(t.dop_opl,0),0),0)) then
     sum( decode(uslm,'008',decode(t.psch,0,nvl(t.opl,0),0),0))
  else sum( decode(uslm,'008',decode(t.psch,0,nvl(t.dop_opl,0),0),0)) end  pl_ng,

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
  end vol_sch_s,

  case when 
  sum( decode(uslm,'004',decode(u.usl_norm,0,nvl(t.volume,0),0,0)))>=sum( decode(uslm,'004',decode(u.usl_norm,0,nvl(t.dop_vol,0),0,0))) then
  sum( decode(uslm,'004',decode(u.usl_norm,0,nvl(t.volume,0),0,0)))
  else
  sum( decode(uslm,'004',decode(u.usl_norm,0,nvl(t.dop_vol,0),0,0)))
  end  pl_no,
  
  case when
  sum( decode(uslm,'004',decode(u.usl_norm,1,nvl(t.volume,0),0),0))>= sum( decode(uslm,'004',decode(u.usl_norm,1,nvl(t.dop_vol,0),0),0)) then 
   sum( decode(uslm,'004',decode(u.usl_norm,1,nvl(t.volume,0),0),0))
   else
    sum( decode(uslm,'004',decode(u.usl_norm,1,nvl(t.dop_vol,0),0),0))
  end pl_so,
  
  sum( decode(t.usl,'059',nvl(t.charges,0)-nvl(t.changes,0)+nvl(t.privs,0)-nvl(t.f,0),0)) cr_mop,
  sum( decode(t.usl,'060',nvl(t.charges,0)-nvl(t.changes,0)+nvl(t.privs,0)-nvl(t.f,0),0)) cr_moptr,
  round(sum( decode(t.usl,'059',nvl(t.volume,0),0)),3) vol_odn,
  
  sum(decode(t.psch,0, decode(t.usl,'059',nvl(t.charges,0)-nvl(t.changes,0)+nvl(t.privs,0)-nvl(t.f,0),0),0)) cr_n_mop,
  sum(decode(t.psch,0, decode(t.usl,'060',nvl(t.charges,0)-nvl(t.changes,0)+nvl(t.privs,0)-nvl(t.f,0),0),0)) cr_n_moptr,
  round(sum(decode(t.psch,0, decode(t.usl,'059',nvl(t.volume ,0),0),0)),3) vol_odn_n,
  
  sum(decode(t.psch,1, decode(t.usl,'059',nvl(t.charges,0)-nvl(t.changes,0)+nvl(t.privs,0)-nvl(t.f,0),0),0)) cr_sch_mop,
  sum(decode(t.psch,1, decode(t.usl,'060',nvl(t.charges,0)-nvl(t.changes,0)+nvl(t.privs,0)-nvl(t.f,0),0),0)) cr_sch_moptr,
  round(sum(decode(t.psch,1, decode(t.usl,'059',nvl(t.volume ,0),0),0)),3) vol_odn_s,
  
  sum( decode(t.psch,0,decode(t.usl,'015',nvl(t.charges,0)-nvl(t.changes,0)+nvl(t.privs,0)-nvl(t.f,0),'016',nvl(t.charges,0)-nvl(t.changes,0)+nvl(t.privs,0)-nvl(t.f,0),0),0)) cr_n_gw,
  sum( decode(t.psch,0,decode(t.usl,'017',nvl(t.charges,0)-nvl(t.changes,0)+nvl(t.privs,0)-nvl(t.f,0),'018',nvl(t.charges,0)-nvl(t.changes,0)+nvl(t.privs,0)-nvl(t.f,0),0),0)) cr_n_gwtr,
  sum( decode(t.psch,0,decode(t.usl,'015',nvl(t.privs,0)-nvl(t.f,0),'016',nvl(t.privs,0)-nvl(t.privs_cn,0),0),0)) lg_n_gw,
  sum( decode(t.psch,0,decode(t.usl,'017',nvl(t.privs,0)-nvl(t.f,0),'018',nvl(t.privs,0)-nvl(t.privs_cn,0),0),0)) lg_n_gwtr,

  sum( decode(t.psch,1,decode(t.usl,'015',nvl(t.charges,0)-nvl(t.changes,0)+nvl(t.privs,0)-nvl(t.f,0),0),0)) cr_sch_gw_n,
  sum( decode(t.psch,1,decode(t.usl,'016',nvl(t.charges,0)-nvl(t.changes,0)+nvl(t.privs,0)-nvl(t.f,0),0),0)) cr_sch_gw_s,
  sum( decode(t.psch,1,decode(t.usl,'017',nvl(t.charges,0)-nvl(t.changes,0)+nvl(t.privs,0)-nvl(t.f,0),0),0)) cr_sch_gwtr_n,
  sum( decode(t.psch,1,decode(t.usl,'018',nvl(t.charges,0)-nvl(t.changes,0)+nvl(t.privs,0)-nvl(t.f,0),0),0)) cr_sch_gwtr_s,

  sum( decode(t.psch,1,decode(t.usl,'015',nvl(t.privs,0)-nvl(t.f,0),0),0)) lg_sch_gw_n,
  sum( decode(t.psch,1,decode(t.usl,'016',nvl(t.privs,0)-nvl(t.f,0),0),0)) lg_sch_gw_s,
  sum( decode(t.psch,1,decode(t.usl,'017',nvl(t.privs,0)-nvl(t.f,0),0),0)) lg_sch_gwtr_n,
  sum( decode(t.psch,1,decode(t.usl,'018',nvl(t.privs,0)-nvl(t.f,0),0),0)) lg_sch_gwtr_s,

  sum( decode(t.usl,'007',nvl(t.charges,0)-nvl(t.changes,0)+nvl(t.privs,0)-nvl(t.f,0),0)) cr_no, 
  sum( decode(t.usl,'008',nvl(t.charges,0)-nvl(t.changes,0)+nvl(t.privs,0)-nvl(t.f,0),0)) cr_so, 
  sum( decode(t.usl,'009',nvl(t.charges,0)-nvl(t.changes,0)+nvl(t.privs,0)-nvl(t.f,0),0)) cr_notr, 
  sum( decode(t.usl,'010',nvl(t.charges,0)-nvl(t.changes,0)+nvl(t.privs,0)-nvl(t.f,0),0)) cr_sotr, 
  sum( decode(t.usl,'007',nvl(t.privs,0)-nvl(t.f,0),0)) lg_no, 
  sum( decode(t.usl,'008',nvl(t.privs,0)-nvl(t.f,0),0)) lg_so, 
  sum( decode(t.usl,'009',nvl(t.privs,0)-nvl(t.f,0),0)) lg_notr, 
  sum( decode(t.usl,'010',nvl(t.privs,0)-nvl(t.f,0),0)) lg_sotr,
 
  /*перерасчет прошлого периода*/
  sum( decode(t.usl,'015',nvl(t.changes,0)-nvl(t.f,0)+nvl(t.f,0)-nvl(t.privs_cn,0),0)) cn_gw,
  sum( decode(t.usl,'017',nvl(t.changes,0)-nvl(t.f,0)+nvl(t.f,0)-nvl(t.privs_cn,0),0)) cn_gwtr,
  sum( decode(t.usl,'007',nvl(t.changes,0)-nvl(t.f,0)+nvl(t.f,0)-nvl(t.privs_cn,0),0)) cn_ot,
  sum( decode(t.usl,'009',nvl(t.changes,0)-nvl(t.f,0)+nvl(t.f,0)-nvl(t.privs_cn,0),0)) cn_ottr,
  
  sum( decode(t.usl,'016',nvl(t.changes,0)-nvl(t.f,0)+nvl(t.f,0)-nvl(t.privs_cn,0),0)) cn_sgw,
  sum( decode(t.usl,'018',nvl(t.changes,0)-nvl(t.f,0)+nvl(t.f,0)-nvl(t.privs_cn,0),0)) cn_sgwtr,
  sum( decode(t.usl,'008',nvl(t.changes,0)-nvl(t.f,0)+nvl(t.f,0)-nvl(t.privs_cn,0),0)) cn_sot,
  sum( decode(t.usl,'010',nvl(t.changes,0)-nvl(t.f,0)+nvl(t.f,0)-nvl(t.privs_cn,0),0)) cn_sottr,
  
  sum( decode(t.usl,'015',decode(psch,1,nvl(t.changes,0)-nvl(t.f,0)+nvl(t.f,0)-nvl(t.privs_cn,0),0),0)) cn_sch_gw,
  sum( decode(t.usl,'017',decode(psch,1,nvl(t.changes,0)-nvl(t.f,0)+nvl(t.f,0)-nvl(t.privs_cn,0),0),0)) cn_sch_gwtr,

  sum( decode(t.usl,'016',decode(psch,1,nvl(t.changes,0)-nvl(t.f,0)+nvl(t.f,0)-nvl(t.privs_cn,0),0),0)) cn_sch_sgw,
  sum( decode(t.usl,'018',decode(psch,1,nvl(t.changes,0)-nvl(t.f,0)+nvl(t.f,0)-nvl(t.privs_cn,0),0),0)) cn_sch_sgwtr,
  
  sum( decode(t.usl,'015',decode(psch,0,nvl(t.changes,0)-nvl(t.f,0)+nvl(t.f,0)-nvl(t.privs_cn,0),0),'016',decode(psch,0,nvl(t.changes,0)-nvl(t.f,0)+nvl(t.f,0)-nvl(t.privs_cn,0),0),0)) cn_n_gw,
  sum( decode(t.usl,'017',decode(psch,0,nvl(t.changes,0)-nvl(t.f,0)+nvl(t.f,0)-nvl(t.privs_cn,0),0),'018',decode(psch,0,nvl(t.changes,0)-nvl(t.f,0)+nvl(t.f,0)-nvl(t.privs_cn,0),0),0)) cn_n_gwtr,
   
  sum(decode(t.psch,0, decode(t.usl,'059',nvl(t.changes,0)-nvl(t.f,0)+nvl(t.f,0)-nvl(t.privs_cn,0),0),0)) cn_n_mop,
  sum(decode(t.psch,0, decode(t.usl,'060',nvl(t.changes,0)-nvl(t.f,0)+nvl(t.f,0)-nvl(t.privs_cn,0),0),0)) cn_n_moptr,
  
  sum(decode(t.psch,1, decode(t.usl,'059',nvl(t.changes,0)-nvl(t.f,0)+nvl(t.f,0)-nvl(t.privs_cn,0),0),0)) cn_sch_mop,
  sum(decode(t.psch,1, decode(t.usl,'060',nvl(t.changes,0)-nvl(t.f,0)+nvl(t.f,0)-nvl(t.privs_cn,0),0),0)) cn_sch_moptr,
 
 /*перерасчет льгот прошлого периода*/
  sum( decode(t.usl,'015',nvl(t.f,0)-nvl(t.privs_cn,0),0)) pn_gw,
  sum( decode(t.usl,'017',nvl(t.f,0)-nvl(t.privs_cn,0),0)) pn_gwtr,
  sum( decode(t.usl,'007',nvl(t.f,0)-nvl(t.privs_cn,0),0)) pn_ot,
  sum( decode(t.usl,'009',nvl(t.f,0)-nvl(t.privs_cn,0),0)) pn_ottr,
  
  sum( decode(t.usl,'016',nvl(t.f,0)-nvl(t.privs_cn,0),0)) pn_sgw,
  sum( decode(t.usl,'018',nvl(t.f,0)-nvl(t.privs_cn,0),0)) pn_sgwtr,
  sum( decode(t.usl,'008',nvl(t.f,0)-nvl(t.privs_cn,0),0)) pn_sot,
  sum( decode(t.usl,'010',nvl(t.f,0)-nvl(t.privs_cn,0),0)) pn_sottr,
  
  
  sum( decode(t.usl,'015',decode(psch,1,nvl(t.f,0)-nvl(t.privs_cn,0),0),0)) pn_sch_gw,
  sum( decode(t.usl,'017',decode(psch,1,nvl(t.f,0)-nvl(t.privs_cn,0),0),0)) pn_sch_gwtr,

  sum( decode(t.usl,'016',decode(psch,1,nvl(t.f,0)-nvl(t.privs_cn,0),0),0)) pn_sch_sgw,
  sum( decode(t.usl,'018',decode(psch,1,nvl(t.f,0)-nvl(t.privs_cn,0),0),0)) pn_sch_sgwtr,
  
  sum( decode(t.usl,'015',decode(psch,0,nvl(t.f,0)-nvl(t.privs_cn,0),0),'016',decode(psch,0,nvl(t.f,0)-nvl(t.privs_cn,0),0),0)) pn_n_gw,
  sum( decode(t.usl,'017',decode(psch,0,nvl(t.f,0)-nvl(t.privs_cn,0),0),'018',decode(psch,0,nvl(t.f,0)-nvl(t.privs_cn,0),0),0)) pn_n_gwtr,
 
     /*перерасчет кузбасэнерго*/
  sum( decode(t.usl,'015',nvl(t.f,0)+nvl(t.privs_cn,0),0)) k_gw,
  sum( decode(t.usl,'017',nvl(t.f,0)+nvl(t.privs_cn,0),0)) k_gwtr,
  sum( decode(t.usl,'007',nvl(t.f,0)+nvl(t.privs_cn,0),0)) k_ot,
  sum( decode(t.usl,'009',nvl(t.f,0)+nvl(t.privs_cn,0),0)) k_ottr,
  
  sum( decode(t.usl,'016',nvl(t.f,0)+nvl(t.privs_cn,0),0)) k_sgw,
  sum( decode(t.usl,'018',nvl(t.f,0)+nvl(t.privs_cn,0),0)) k_sgwtr,
  sum( decode(t.usl,'008',nvl(t.f,0)+nvl(t.privs_cn,0),0)) k_sot,
  sum( decode(t.usl,'010',nvl(t.f,0)+nvl(t.privs_cn,0),0)) k_sottr,
  
  
  sum( decode(t.usl,'015',decode(psch,1,nvl(t.f,0)+nvl(t.privs_cn,0),0),0)) k_sch_gw,
  sum( decode(t.usl,'017',decode(psch,1,nvl(t.f,0)+nvl(t.privs_cn,0),0),0)) k_sch_gwtr,

  sum( decode(t.usl,'016',decode(psch,1,nvl(t.f,0)+nvl(t.privs_cn,0),0),0)) k_sch_sgw,
  sum( decode(t.usl,'018',decode(psch,1,nvl(t.f,0)+nvl(t.privs_cn,0),0),0)) k_sch_sgwtr,
  
  sum( decode(t.usl,'015',decode(psch,0,nvl(t.f,0)+nvl(t.privs_cn,0),0),'016',decode(psch,0,nvl(t.f,0)+nvl(t.privs_cn,0),0),0)) k_n_gw,
  sum( decode(t.usl,'017',decode(psch,0,nvl(t.f,0)+nvl(t.privs_cn,0),0),'018',decode(psch,0,nvl(t.f,0)+nvl(t.privs_cn,0),0),0)) k_n_gwtr,

 /*перерасчет льгот кузбасэнерго*/
  sum( decode(t.usl,'015',t.privs_cn,0)) kl_gw,
  sum( decode(t.usl,'017',t.privs_cn,0)) kl_gwtr,
  sum( decode(t.usl,'007',t.privs_cn,0)) kl_ot,
  sum( decode(t.usl,'009',t.privs_cn,0)) kl_ottr,
  
  sum( decode(t.usl,'016',t.privs_cn,0)) kl_sgw,
  sum( decode(t.usl,'018',t.privs_cn,0)) kl_sgwtr,
  sum( decode(t.usl,'008',t.privs_cn,0)) kl_sot,
  sum( decode(t.usl,'010',t.privs_cn,0)) kl_sottr,
  
  sum( decode(t.usl,'015',decode(psch,1,t.privs_cn,0),0)) kl_sch_gw,
  sum( decode(t.usl,'017',decode(psch,1,t.privs_cn,0),0)) kl_sch_gwtr,

  sum( decode(t.usl,'016',decode(psch,1,t.privs_cn,0),0)) kl_sch_sgw,
  sum( decode(t.usl,'018',decode(psch,1,t.privs_cn,0),0)) kl_sch_sgwtr,
  
  sum( decode(t.usl,'015',decode(psch,0,t.privs_cn,0),'016',decode(psch,0,t.privs_cn,0),0)) kl_n_gw,
  sum( decode(t.usl,'017',decode(psch,0,t.privs_cn,0),'018',decode(psch,0,t.privs_cn,0),0)) kl_n_gwtr,

     /*всего*/
  sum( decode(t.usl,'015',nvl(t.charges,0)+nvl(t.privs,0),0)) v_gw,
  sum( decode(t.usl,'017',nvl(t.charges,0)+nvl(t.privs,0),0)) v_gwtr,
  sum( decode(t.usl,'007',nvl(t.charges,0)+nvl(t.privs,0),0)) v_ot,
  sum( decode(t.usl,'009',nvl(t.charges,0)+nvl(t.privs,0),0)) v_ottr,
  
  sum( decode(t.usl,'016',nvl(t.charges,0)+nvl(t.privs,0),0)) v_sgw,
  sum( decode(t.usl,'018',nvl(t.charges,0)+nvl(t.privs,0),0)) v_sgwtr,
  sum( decode(t.usl,'008',nvl(t.charges,0)+nvl(t.privs,0),0)) v_sot,
  sum( decode(t.usl,'010',nvl(t.charges,0)+nvl(t.privs,0),0)) v_sottr,
  
  sum( decode(t.usl,'015',decode(psch,1,nvl(t.charges,0)+nvl(t.privs,0),0),0)) v_sch_gw,
  sum( decode(t.usl,'017',decode(psch,1,nvl(t.charges,0)+nvl(t.privs,0),0),0)) v_sch_gwtr,

  sum( decode(t.usl,'016',decode(psch,1,nvl(t.charges,0)+nvl(t.privs,0),0),0)) v_sch_sgw,
  sum( decode(t.usl,'018',decode(psch,1,nvl(t.charges,0)+nvl(t.privs,0),0),0)) v_sch_sgwtr,
  
  sum( decode(t.usl,'015',decode(psch,0,nvl(t.charges,0)+nvl(t.privs,0),0),'016',decode(psch,0,nvl(t.charges,0)+nvl(t.privs,0),0),0)) v_n_gw,
  sum( decode(t.usl,'017',decode(psch,0,nvl(t.charges,0)+nvl(t.privs,0),0),'018',decode(psch,0,nvl(t.charges,0)+nvl(t.privs,0),0),0)) v_n_gwtr,
 
  
 /*всего льгот*/
  sum( decode(t.usl,'015',t.privs,0)) vl_gw,
  sum( decode(t.usl,'017',t.privs,0)) vl_gwtr,
  sum( decode(t.usl,'007',t.privs,0)) vl_ot,
  sum( decode(t.usl,'009',t.privs,0)) vl_ottr,
  
  sum( decode(t.usl,'016',t.privs,0)) vl_sgw,
  sum( decode(t.usl,'018',t.privs,0)) vl_sgwtr,
  sum( decode(t.usl,'008',t.privs,0)) vl_sot,
  sum( decode(t.usl,'010',t.privs,0)) vl_sottr,
 
  sum( decode(t.usl,'015',decode(psch,1,t.privs,0),0)) vl_sch_gw,
  sum( decode(t.usl,'017',decode(psch,1,t.privs,0),0)) vl_sch_gwtr,

  sum( decode(t.usl,'016',decode(psch,1,t.privs,0),0)) vl_sch_sgw,
  sum( decode(t.usl,'018',decode(psch,1,t.privs,0),0)) vl_sch_sgwtr,
  
  sum( decode(t.usl,'015',decode(psch,0,t.privs,0),'016',decode(psch,0,t.privs,0),0)) vl_n_gw,
  sum( decode(t.usl,'017',decode(psch,0,t.privs,0),'018',decode(psch,0,t.privs,0),0)) vl_n_gwtr
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
        GROUP BY  t.status,1
                   --     'РЭУ-'||t.reu||' '||u.name||', д.'||ltrim(t.nd,'0')|| ' Ввода № '||t.vvod_gw
          )  a
GROUP BY  a.VVOD_GW
                 ) a,
           (  SELECT coalesce(sum(t.gw),0) as vol_cub_gw, coalesce(sum(t.gw_dop),0) as vol_mop_cub_gw, ROW_NUMBER () over (order by '1')  rown,  
              '1' as vvod_gw
                FROM SCOTT.T_VOLUME_USL_IZM t, SCOTT.S_REU_TREST s, scott.spul u
              WHERE 
                    t.kul  = u.id AND 
                    t.reu = s.reu
                    and t.reu='34' 
           GROUP BY  '1', s.trest, s.reu
            -- str_:=str_||' and t.reu='''||reu_||'''';
            -- str_:=str_||' and s.trest='''||trest_||'''';
            -- str1 = ''РЭУ-''||t.reu||'' ''||u.name||'', д.''||ltrim(t.nd,''0'')|| '' Ввода № ''||t.vvod_gw

            ) b
WHERE a.vvod_GW = b.vvod_gw  (+)  
     and
     a.rown=b.rown (+)  
     
 /*    --запрос для вставки объемов
INSERT INTO SCOTT.T_VOLUME_USL_IZM
SELECT ki.lsk, null, null, ki.gw, ki.gw_dop, ka.reu, ka.kul, ka.nd, ka.vvod 
FROM (
          SELECT  ki.lsk, sum(ki.gw) as gw, sum(ki.gw_dop) as gw_dop 
            FROM  scott.load_kwni ki
          WHERE ki.gw<>0 or ki.gw_dop <>0
          GROUP BY  ki.lsk  ) ki, 
scott.load_kart ka
WHERE 
 ki.lsk=ka.lsk (+)


     create table scott.t_volume_usl_izm as select * from scott.t_volume_usl where 1=0
     scott.status
     scott.load_kartw
     scott.params
     

  (  SELECT coalesce(sum(gw),0) as vol_cub_gw, coalesce(sum(gw_dop),0) as vol_mop_cub_gw, ROW_NUMBER () over (order by '||str1_||')  rown,  
      '||str1_||' as vvod_gw
       FROM load_kartw t, load_kwni ki, spul u, SCOTT.S_REU_TREST s
     WHERE  
        (ki.gw<>0 or ki.gw_dop <>0) AND 
        t.lsk=ki.lsk AND
        t.kul  = u.id AND 
        t.reu = s.reu
        '||str_||' 
    GROUP BY  '||str1_||', s.trest, s.reu
    ) b
    
    
    select sysdate - to_date('15.09.2010','dd.mm.yyyy') from dual*/
