  insert into info_usl_lsk
      (lsk, usl, org, 
       charges, changes, privs,payment, volume, 
       mg, psch, kpr, reu, kul, nd, kw, sch_el, opl, f, dop_kpr, dop_opl, dop_vol, vvod_gw)
/*---------------------------------------------------------------------------------*/
SELECT h.lsk,h.usl,h.org,
           nvl(cr.summa,0)+nvl(cn.summa,0),cn.summa,pr.summa,pm.summa,vl.summa, -- объем оказанных услуг кубы.
           mg_,
           decode(u.s_ras_sch,null,0,h.psch) psch,
           vl.kpr kpr,
           h.reu,h.kul,h.nd,h.kw,sch_el,
           vl.opl opl,
           pr.summa_cn,
           vl.dop_kpr,
           vl.dop_opl,
           vl.dop_vol,
           decode(u.uslm,'006',vvod,vvod_gw) vvod_gw
FROM (select t.*, reu,kul,nd,kw,k.psch,sch_el,vvod_gw, vvod 
         from temp_info_usl t,load_kartw k,status s 
         where t.lsk=k.lsk and s.id=k.status ) h,
         t_charges_usl cr,
         t_changes_usl cn,
         (select lsk,usl,org,sum(summa) summa, sum(decode(type,0,0,null,0,summa)) summa_cn from t_privs_usl group by lsk,usl,org) pr,
         t_volume_usl vl,
         t_payment_usl pm,
         usl u
    where h.lsk=cr.lsk(+)
      and h.usl=cr.usl(+)
      and h.org=cr.org(+)
     and h.lsk=cn.lsk(+)
      and h.usl=cn.usl(+)
      and h.org=cn.org(+)  
     and h.lsk=pr.lsk(+)
      and h.usl=pr.usl(+)
      and h.org=pr.org(+) 
     and h.lsk=vl.lsk(+)
      and h.usl=vl.usl(+)
      and h.org=vl.org(+)
     and h.lsk=pm.lsk(+)
      and h.usl=pm.usl(+)
      and h.org=pm.org(+)      
      and h.usl=u.usl  ;   
      
      load_kwni
      
      scott.v_charges_usl