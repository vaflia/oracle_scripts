select k.k_lsk_id, k.lsk, k.kul, k.nd, k.kw, k.fio, k.kpr,
    kpr_wr, k.kpr_ot, k.kpr_cem,
    kpr_s, k.opl, k.ppl, k.pldop, k.lp, k.lpdt, k.ki, k.ant, k.psch, k.psch_dt,
    psch_nac, k.gt, k.status, k.kwt, k.kwt_lg, k.kwt_karm, k.lodpl, k.bekpl,
    balpl, k.kladovka, k.komn, k.lift, k.m_prov, k.musor, k.et, k.kfg, k.kfot,
    nai, k.kfps, k.sumpens, k.phw, k.mhw, k.id_hw, k.pgw, k.mgw, k.id_gw, k.pel,
    mel, k.doxod, k.sub_nach, k.subsidii, k.sub_data, k.sub_priz, k.sob,
    rsob, k.nsob, k.sotk, k.ges_lsk, k.tel, k.tel_nach, k.tel_data, k.org_dolg,
    polis, k.stra_kre, k.stra_dat, k.nalog, k.sch_el, k.reu, k.vvod, k.vvod_el,
    kodsc, k.schel_dt, k.id_kwt, k.text, k.mel_lg, k.dolg_ges, k.comtel, k.avn_el,
    err, k.kod_org, k.eksub1, k.eksub2, k.kran, k.kran1, k.el, k.el1, k.subs_cor,
    dgw, k.pech_dog, k.gr_el, k.gr_hv, k.gr_gv, k.podezd, k.gr_tr, k.dop_mel,
    dop_gw, k.dop_hw, k.bank_id, k.house_id, k.c_lsk_id, k.dop_pl, k.vvod_gw,
    k.vvod_ot, c.id as house_id2 from kart@hotora k,
    oralv.c_houses c where
    k.reu=c.reu and k.kul=c.kul and k.nd=c.nd and
    c.entry is null --дом
    and  exists
   (select * from oralv.kart t where t.lsk=k.lsk)
   
   
   select t.reu, t.kul, t.nd, t.lsk, s.trest from oralv.kart t,scott.s_stra s
   where t.k_lsk_id is null
   and s.nreu=substr(t.lsk,1,4)
   
    select t.reu, t.kul, t.nd, s.trest from oralv.kart t,scott.s_stra s
   where t.k_lsk_id is not null
   and s.nreu=substr(t.lsk,1,4)
    order by trest,reu,kul,nd 
   
   select t.reu, t.kul, t.nd, s.trest from oralv.kart t,scott.s_stra s
   where t.k_lsk_id is null
   and s.nreu=substr(t.lsk,1,4)
   group by t.reu, t.kul, t.nd, s.trest
   order by trest,reu,kul,nd
   
   select sk.reu,sk.kul,sk.nd 
   from scott.kart sk 
   where not exists(select reu,kul,nd from oralv.kart ok where sk.reu=ok.reu and sk.kul=ok.kul and sk.nd=ok.nd)
   and psch not in (9)
   group by sk.reu,sk.kul,sk.nd
   
   select sk.lsk,sk.reu,sk.kul,sk.nd 
   from scott.kart sk
   where reu='F1' and kul ='1039' and sk.nd='000005'
   
   select sk.reu,sk.kul,sk.nd 
   from oralv.c_houses sk
   where reu='F1' and kul ='1039' and sk.nd='000005'
   
   select * from scott.kart where psch=9
   
   select * from oralv.kart where psch=9
   
   
   select distinct t.reu, t.kul, t.nd from kart@hotora t where not exists
    (select * from oralv.c_houses c where c.reu=t.reu and c.kul=t.kul and c.nd=t.nd
       and c.entry is null)
       
       select count (*) from kart@hotora
       select count (*) from scott.kart
       
              select 1 from dual@hotora
              
              
       select distinct t.reu, t.kul, t.nd from kart@hotora t where not exists
    (select * from oralv.c_houses c where c.reu=t.reu and c.kul=t.kul and c.nd=t.nd
       and c.entry is null)
       
       
       
       select distinct t.reu, t.kul, t.nd from kart@hotora t where not exists
    (select * from oralv.c_houses c where c.reu=t.reu and c.kul=t.kul and c.nd=t.nd
       and c.entry is null)



select distinct t.reu, t.kul, t.nd from scott.kart t where not exists
    (select * from oralv.c_houses c where c.reu=t.reu and c.kul=t.kul and c.nd=t.nd
       and c.entry is null)