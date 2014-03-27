 SELECT a.*,b.*,c.* FROM 
  
(  select 
 null vvod_gw,

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
  sum( decode(t.usl,'059',nvl(t.volume,0),0)) vol_mop,
  
  sum(decode(t.psch,0, decode(t.usl,'059',nvl(t.charges,0)-nvl(t.changes,0)+nvl(t.privs,0)-nvl(t.f,0),0),0)) cr_n_mop,
  sum(decode(t.psch,0, decode(t.usl,'060',nvl(t.charges,0)-nvl(t.changes,0)+nvl(t.privs,0)-nvl(t.f,0),0),0)) cr_n_moptr,
  sum(decode(t.psch,0, decode(t.usl,'059',nvl(t.volume ,0),0),0)) vol_n_mop,
  
  sum(decode(t.psch,1, decode(t.usl,'059',nvl(t.charges,0)-nvl(t.changes,0)+nvl(t.privs,0)-nvl(t.f,0),0),0)) cr_sch_mop,
  sum(decode(t.psch,1, decode(t.usl,'060',nvl(t.charges,0)-nvl(t.changes,0)+nvl(t.privs,0)-nvl(t.f,0),0),0)) cr_sch_moptr,
  sum(decode(t.psch,1, decode(t.usl,'059',nvl(t.volume ,0),0),0)) vol_sch_mop,
  
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
  sum( decode(t.usl,'015',nvl(t.changes,0)-nvl(t.f1,0)+nvl(t.f,0)-nvl(t.privs_cn,0),0)) cn_gw,  
  sum( decode(t.usl,'017',nvl(t.changes,0)-nvl(t.f1,0)+nvl(t.f,0)-nvl(t.privs_cn,0),0)) cn_gwtr,
  sum( decode(t.usl,'007',nvl(t.changes,0)-nvl(t.f1,0)+nvl(t.f,0)-nvl(t.privs_cn,0),0)) cn_ot,
  sum( decode(t.usl,'009',nvl(t.changes,0)-nvl(t.f1,0)+nvl(t.f,0)-nvl(t.privs_cn,0),0)) cn_ottr,
  
  sum( decode(t.usl,'016',nvl(t.changes,0)-nvl(t.f1,0)+nvl(t.f,0)-nvl(t.privs_cn,0),0)) cn_sgw,
  sum( decode(t.usl,'018',nvl(t.changes,0)-nvl(t.f1,0)+nvl(t.f,0)-nvl(t.privs_cn,0),0)) cn_sgwtr,
  sum( decode(t.usl,'008',nvl(t.changes,0)-nvl(t.f1,0)+nvl(t.f,0)-nvl(t.privs_cn,0),0)) cn_sot,
  sum( decode(t.usl,'010',nvl(t.changes,0)-nvl(t.f1,0)+nvl(t.f,0)-nvl(t.privs_cn,0),0)) cn_sottr,
  
    -- по СЧЕТЧИКУ начислено всего горячей воды + транспортировка
  sum( decode(t.usl,'015',decode(psch,1,nvl(t.changes,0)-nvl(t.f1,0)+nvl(t.f,0)-nvl(t.privs_cn,0),0),0)) cn_sch_gw,  --+ ПО СОЦ НОРМЕ
  sum( decode(t.usl,'017',decode(psch,1,nvl(t.changes,0)-nvl(t.f1,0)+nvl(t.f,0)-nvl(t.privs_cn,0),0),0)) cn_sch_gwtr,

  sum( decode(t.usl,'016',decode(psch,1,nvl(t.changes,0)-nvl(t.f1,0)+nvl(t.f,0)-nvl(t.privs_cn,0),0),0)) cn_sch_sgw, -- + СВЕРХ СОЦ НОРМЫ
  sum( decode(t.usl,'018',decode(psch,1,nvl(t.changes,0)-nvl(t.f1,0)+nvl(t.f,0)-nvl(t.privs_cn,0),0),0)) cn_sch_sgwtr,
  
  -- по НОРМАТИВУ начислено всего горячей воды + транспортировка
  sum( decode(t.usl,'015',decode(psch,0,nvl(t.changes,0)-nvl(t.f1,0)+nvl(t.f,0)-nvl(t.privs_cn,0),0),'016',
          decode(psch,0,nvl(t.changes,0)-nvl(t.f1,0)+nvl(t.f,0)-nvl(t.privs_cn,0),0),0)) CN_N_GW,
  sum( decode(t.usl,'017',decode(psch,0,nvl(t.changes,0)-nvl(t.f1,0)+nvl(t.f,0)-nvl(t.privs_cn,0),0),'018',
          decode(psch,0,nvl(t.changes,0)-nvl(t.f1,0)+nvl(t.f,0)-nvl(t.privs_cn,0),0),0)) CN_N_GWTR,
          
            -- по НОРМАТИВУ начислено всего горячей воды + транспортировка КУБЫ
  sum( decode(t.usl,'015',decode(psch,0,nvl(t.changes,0)-nvl(t.f1,0)+nvl(t.f,0)-nvl(t.privs_cn,0),0),'016',
          decode(psch,0,nvl(t.changes,0)-nvl(t.f1,0)+nvl(t.f,0)-nvl(t.privs_cn,0),0),0)) CN_N_GW_CUB,
  sum( decode(t.usl,'017',decode(psch,0,nvl(t.changes,0)-nvl(t.f1,0)+nvl(t.f,0)-nvl(t.privs_cn,0),0),'018',
          decode(psch,0,nvl(t.changes,0)-nvl(t.f1,0)+nvl(t.f,0)-nvl(t.privs_cn,0),0),0)) CN_N_GWTR_CUB,
   
  sum(decode(t.psch,0, decode(t.usl,'059',nvl(t.changes,0)-nvl(t.f1,0)+nvl(t.f,0)-nvl(t.privs_cn,0),0),0)) cn_n_mop,
  sum(decode(t.psch,0, decode(t.usl,'060',nvl(t.changes,0)-nvl(t.f1,0)+nvl(t.f,0)-nvl(t.privs_cn,0),0),0)) cn_n_moptr,
  
  sum(decode(t.psch,1, decode(t.usl,'059',nvl(t.changes,0)-nvl(t.f1,0)+nvl(t.f,0)-nvl(t.privs_cn,0),0),0)) cn_sch_mop,
  sum(decode(t.psch,1, decode(t.usl,'060',nvl(t.changes,0)-nvl(t.f1,0)+nvl(t.f,0)-nvl(t.privs_cn,0),0),0)) cn_sch_moptr,
 
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
  sum( decode(t.usl,'015',nvl(t.f1,0)+nvl(t.privs_cn,0),0)) k_gw,
  sum( decode(t.usl,'017',nvl(t.f1,0)+nvl(t.privs_cn,0),0)) k_gwtr,
  sum( decode(t.usl,'007',nvl(t.f1,0)+nvl(t.privs_cn,0),0)) k_ot,
  sum( decode(t.usl,'009',nvl(t.f1,0)+nvl(t.privs_cn,0),0)) k_ottr,
  
  sum( decode(t.usl,'016',nvl(t.f1,0)+nvl(t.privs_cn,0),0)) k_sgw,
  sum( decode(t.usl,'018',nvl(t.f1,0)+nvl(t.privs_cn,0),0)) k_sgwtr,
  sum( decode(t.usl,'008',nvl(t.f1,0)+nvl(t.privs_cn,0),0)) k_sot,
  sum( decode(t.usl,'010',nvl(t.f1,0)+nvl(t.privs_cn,0),0)) k_sottr,
  
  
  sum( decode(t.usl,'015',decode(psch,1,nvl(t.f1,0)+nvl(t.privs_cn,0),0),0)) k_sch_gw,
  sum( decode(t.usl,'017',decode(psch,1,nvl(t.f1,0)+nvl(t.privs_cn,0),0),0)) k_sch_gwtr,

  sum( decode(t.usl,'016',decode(psch,1,nvl(t.f1,0)+nvl(t.privs_cn,0),0),0)) k_sch_sgw,
  sum( decode(t.usl,'018',decode(psch,1,nvl(t.f1,0)+nvl(t.privs_cn,0),0),0)) k_sch_sgwtr,
  
  sum( decode(t.usl,'015',decode(psch,0,nvl(t.f1,0)+nvl(t.privs_cn,0),0),'016',decode(psch,0,nvl(t.f1,0)+nvl(t.privs_cn,0),0),0)) k_n_gw,
  sum( decode(t.usl,'017',decode(psch,0,nvl(t.f1,0)+nvl(t.privs_cn,0),0),'018',decode(psch,0,nvl(t.f1,0)+nvl(t.privs_cn,0),0),0)) k_n_gwtr,

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
  info_usl_nd t,usl u,s_reu_trest s, spul u
WHERE   t.mg between '201208' and '201208'
  and t.reu=s.reu 
  and t.kul=u.id
  and u.usl=t.usl
  and uslm  in ('004','008') and s.trest='10' ) a,
 (    SELECT  sum(gw) + sum(gw_dop) as vol_cub_gw, sum(gw_dop) as vol_mop_cub_gw
         FROM  scott.load_kwni kw, scott.s_stra s
       WHERE  (gw<>0 or gw_dop<>0 )
        and substr(kw.lsk,1,4)=s.nreu --and
         and trest='07'
  ) b  
  ,
  --запрос для объемов понежилым помещениям по счетчику и по моп
 (SELECT CASE
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
     --  AND u.uslm = '008'                                  
        and s.trest='07'
       AND t.mg between '201208' and '201208') c
       
