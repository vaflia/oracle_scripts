       select /*r.trest||' '||r.name_tr as predp,
              r.reu reu,
              ul.name||', '||ltrim(t.nd,'0') as predpr_det,
              scott.utils.f_order(ltrim(t.kw,'0'),7) as kw,*/
               t.lsk as lsk,
               
             /* scott.utils.month_name(substr(t.mg, 5, 2))||' '||substr(t.mg, 1, 4) mg,
              u.nm||','||u.ed_izm nm,
              decode(u.usl_norm,0,'норм.',1,'сверх.норм.') as usl_norm,
              u.nm1||','||u.ed_izm nm1,
              o.name,
              decode(psch,1,'счетчик',0,'норматив.',null) psch,*/
            /*  sum(t.kpr) kpr,
              sum(opl) opl,
              sum(t.charges) cr,
              sum(t.changes) cn,
              sum(t.privs) pr,
              sum(t.payment) pm,*/
              sum(t.volume) vl
       from prep.info_usl_lsk t,            scott.s_reu_trest r,            scott.usl u,            scott.sprorg o,            scott.spul ul
       where t.reu=r.reu
         and t.usl=u.usl         and t.org=o.kod         and t.kul=ul.id         and r.trest='04'         and mg='201212'
         and u.usl in ('015','059','060','017','016','018')
       group by /*r.trest,r.name_tr,
                r.reu,
                scott.utils.month_name(substr(t.mg, 5, 2))||' '||substr(t.mg, 1, 4),
                u.nm,u.nm1,
                o.name, decode(psch,1,'счетчик',0,'норматив.',null),
               u.usl_norm,u.ed_izm,
                ul.name,t.nd,t.kw,*/t.lsk
       having sum(t.charges)<>0 or sum(t.changes) <>0 or
              sum(t.privs) <>0 or sum(t.volume)<>0
              or sum(t.payment)<>0 or sum(t.opl)<>0 or sum(t.kpr)<>0
       order by t.lsk;
