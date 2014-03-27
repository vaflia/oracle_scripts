  IF org_ is not null THEN
      str_:=' and t.org='||to_char(org_);
  END IF;
  
   IF var_=1 THEN
     --по ЖЭО
     str_:=str_||' and s.trest=''||trest_||'';
     str2_:=str2_||' and s.trest=''||trest_||'';
  ELSIF var_=2 THEN
  --по РЭУ
    str_:=str_||' and t.reu=''||reu_||'';
    str2_:=str2_||' and s.reu=''||reu_||'';
  ELSIF var_=3 THEN
  --по дому
     str_:=str_||' and t.reu||t.kul||t.nd in (select reu||kul||nd from list_choices where sel=0) ';
  end if;
  
  IF vvod_=0 THEN
    str1_:=' null ';
  ELSE
    str1_:=' 'РЭУ-'||t.reu||' '||u.name||', д.'||ltrim(t.nd,'0')|| ' Ввода № '||t.vvod_gw ';
  END IF;
     
/////////////////////////******************************************************/////////////////////////////////
  
  SELECT sum (kpr_sch) kpr_sch,sum (kpr_n) kpr_n,sum (pl_sg) pl_sg, sum(vol_n) vol_n, 
  sum(vol_sch_n) vol_sch_n, sum(vol_sch_s) vol_sch_s,  
  --sum(pl_no) pl_no, sum(pl_so) pl_so, 
  sum(cr_mop) cr_mop, sum(cr_moptr) cr_moptr, sum(vol_odn) odn_n/*жилые и нежилые*/, sum (cr_n_mop) cr_n_mop,
              sum(cr_n_moptr) cr_n_moptr, 
        --      sum(vol_odn_n) vol_odn_n, sum(vol_odn_s) vol_odn_s, 
              sum(cr_sch_mop) cr_sch_mop, sum(cr_sch_moptr) cr_sch_moptr,
              sum(cr_n_gw) cr_n_gw, sum(cr_n_gwtr) cr_n_gwtr, sum(lg_n_gw) lg_n_gw, sum(lg_n_gwtr) lg_n_gwtr, sum(cr_sch_gw_n) cr_sch_gw_n,
              sum(cr_sch_gw_s) cr_sch_gw_s, sum(cr_sch_gwtr_n) cr_sch_gwtr_n, sum(cr_sch_gwtr_s) cr_sch_gwtr_s, sum(lg_sch_gw_n) lg_sch_gw_n,
              sum(lg_sch_gw_s) lg_sch_gw_s, sum(lg_sch_gwtr_n) lg_sch_gwtr_n, sum(lg_sch_gwtr_s) lg_sch_gwtr_s, sum(cr_no) cr_no,sum(cr_so) cr_so,
              sum(cr_notr) cr_notr, sum(cr_sotr) cr_sotr, sum(lg_no) lg_no, sum(lg_so) lg_so, sum(lg_notr) lg_notr,sum(lg_sotr) lg_sotr,sum(k_gw) k_gw,
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
               sum(CASE WHEN a.status NOT IN ( 8, 9, 10, 11, 12)
                               THEN a.vol_sch_n else 0
                       END)  AS vol_sch_n,
                    -- по счетчику
               sum(CASE WHEN a.status NOT IN ( 8, 9, 10, 11, 12)
                               THEN a.vol_sch_s else 0
                       END)  AS vol_sch_s, 
                -- считаем площади отоплнеия токо по ЖИЛЫМ помещениям
                    --по соц норме
               sum(CASE WHEN a.status NOT IN ( 8, 9, 10, 11, 12)
                               THEN a.pl_no else 0
                       END)  AS PL_NO,
                   --счерх соц нормы
              sum(CASE WHEN a.status NOT IN ( 8, 9, 10, 11, 12)
                               THEN a.pl_so else 0
                       END)  AS PL_SO,
                   --считаем ОДН по ЖИЛЫМ  помещениям объемы    
                       --по нормативу
              sum(CASE WHEN a.status NOT IN ( 8, 9, 10, 11, 12)
                               THEN a.vol_odn_n else 0
                       END)  AS vol_odn_n,
                       --сверх норматива
              sum(CASE WHEN a.status NOT IN (, 8, 9, 10, 11, 12)
                               THEN a.vol_odn_s else 0
                       END)  AS vol_odn_s,
                       
                    -- считаем ОДН по НЕЖИЛЫМ помещениям п.3,3,3   
             sum(CASE WHEN a.status IN ( 8, 9, 10, 11, 12)
                               THEN a.vol_odn else 0
                       END)  AS vol_odn_nejil_pom,
                    -- считаем гор вода по счетчику по НЕЖИЛЫМ объем. П.3,3,2
             sum(CASE WHEN a.status IN (, 8, 9, 10, 11, 12)
                           THEN a.vol_sch_n+vol_sch_s else 0
                    END)  AS vol_sch_nejil_pom    ,
                -- считаем отопление площади по НЕЖИЛЫМ кв.м. П.2,1,3
             sum(CASE WHEN a.status IN ( 8, 9, 10, 11, 12)
                           THEN a.pl_no+pl_so else 0
                   END)  AS pl_npo       
       
  FROM 
  (
  select t.status,
 -- 'РЭУ-'||t.reu||' '||u.name||', д.'||ltrim(t.nd,'0')|| ' Ввода № '||t.vvod_gw vvod_gw,
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
  
  sum( decode(t.usl,'059',nvl(t.charges,0),0)) cr_mop,
  sum( decode(t.usl,'060',nvl(t.charges,0),0)) cr_moptr,
  round(sum( decode(t.usl,'059',nvl(t.volume,0),0)),3) vol_odn,
  
  sum(decode(t.psch,0, decode(t.usl,'059',nvl(t.charges,0),0),0)) cr_n_mop,
  sum(decode(t.psch,0, decode(t.usl,'060',nvl(t.charges,0),0),0)) cr_n_moptr,
  round(sum(decode(t.psch,0, decode(t.usl,'059',nvl(t.volume ,0),0),0)),3) vol_odn_n,
  
  sum(decode(t.psch,1, decode(t.usl,'059',nvl(t.charges,0),0),0)) cr_sch_mop,
  sum(decode(t.psch,1, decode(t.usl,'060',nvl(t.charges,0),0),0)) cr_sch_moptr,
  round(sum(decode(t.psch,1, decode(t.usl,'059',nvl(t.volume ,0),0),0)),3) vol_odn_s,
  
  sum( decode(t.psch,0,decode(t.usl,'015',nvl(t.charges,0)-nvl(t.f,0),'016',nvl(t.charges,0)-nvl(t.f,0),0),0)) cr_n_gw,
  sum( decode(t.psch,0,decode(t.usl,'017',nvl(t.charges,0)-nvl(t.f,0),'018',nvl(t.charges,0)-nvl(t.f,0),0),0)) cr_n_gwtr,
  sum( decode(t.psch,0,decode(t.usl,'015',nvl(t.privs,0)-nvl(t.privs_cn,0),'016',nvl(t.privs,0)-nvl(t.privs_cn,0),0),0)) lg_n_gw,
  sum( decode(t.psch,0,decode(t.usl,'017',nvl(t.privs,0)-nvl(t.privs_cn,0),'018',nvl(t.privs,0)-nvl(t.privs_cn,0),0),0)) lg_n_gwtr,

  sum( decode(t.psch,1,decode(t.usl,'015',nvl(t.charges,0)-nvl(t.f,0),0),0)) cr_sch_gw_n,
  sum( decode(t.psch,1,decode(t.usl,'016',nvl(t.charges,0)-nvl(t.f,0),0),0)) cr_sch_gw_s,
  sum( decode(t.psch,1,decode(t.usl,'017',nvl(t.charges,0)-nvl(t.f,0),0),0)) cr_sch_gwtr_n,
  sum( decode(t.psch,1,decode(t.usl,'018',nvl(t.charges,0)-nvl(t.f,0),0),0)) cr_sch_gwtr_s,

  sum( decode(t.psch,1,decode(t.usl,'015',nvl(t.privs,0)-nvl(t.privs_cn,0),0),0)) lg_sch_gw_n,
  sum( decode(t.psch,1,decode(t.usl,'016',nvl(t.privs,0)-nvl(t.privs_cn,0),0),0)) lg_sch_gw_s,
  sum( decode(t.psch,1,decode(t.usl,'017',nvl(t.privs,0)-nvl(t.privs_cn,0),0),0)) lg_sch_gwtr_n,
  sum( decode(t.psch,1,decode(t.usl,'018',nvl(t.privs,0)-nvl(t.privs_cn,0),0),0)) lg_sch_gwtr_s,

  sum( decode(t.usl,'007',nvl(t.charges,0)-nvl(t.f,0),0)) cr_no, 
  sum( decode(t.usl,'008',nvl(t.charges,0)-nvl(t.f,0),0)) cr_so, 
  sum( decode(t.usl,'009',nvl(t.charges,0)-nvl(t.f,0),0)) cr_notr, 
  sum( decode(t.usl,'010',nvl(t.charges,0)-nvl(t.f,0),0)) cr_sotr, 
  sum( decode(t.usl,'007',nvl(t.privs,0)-nvl(t.privs_cn,0),0)) lg_no, 
  sum( decode(t.usl,'008',nvl(t.privs,0)-nvl(t.privs_cn,0),0)) lg_so, 
  sum( decode(t.usl,'009',nvl(t.privs,0)-nvl(t.privs_cn,0),0)) lg_notr, 
  sum( decode(t.usl,'010',nvl(t.privs,0)-nvl(t.privs_cn,0),0)) lg_sotr,
  
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
  info_usl_lsk t, 
  usl u, s_reu_trest s, spul u
WHERE t.mg between '201210' and '201210'
  and t.kul  = u.id
  and t.reu = s.reu 
  and u.usl = t.usl
  and uslm  in ('004','008')
  and trest='10'
 -- and t.reu||t.kul||t.nd in (select reu||kul||nd from prep.list_choices where sel=0)
  GROUP BY t.status 
  --group by  'РЭУ-'||t.reu||' '||u.name||', д.'||ltrim(t.nd,'0')|| ' Ввода № '||t.vvod_gw 
  --order by  'РЭУ-'||t.reu||' '||u.name||', д.'||ltrim(t.nd,'0')|| ' Ввода № '||t.vvod_gw 
  )  a
 ORDER BY a.status


