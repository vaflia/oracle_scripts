select s.lsk, t.trest||' '||t.name_tr as predp, s.reu,
    k.name||', '||NVL(LTRIM(s.nd,'0'),'0') as predpr_det,
    LTRIM(s.kw,'0') as kw, TRIM(u.nm)||DECODE(u.ed_izm,null,'',' ('||TRIM(u.ed_izm)||')') as nm,
    p.kod||' '||p.name as orgname, m.name as status, decode(s.psch,1,'Закрытые Л/С','Открытые Л/С') as psch,
    decode(s.sch,1,'Счетчик','Норматив') as sch, s.val_group,
    s.cnt as cnt, s.opl, s.klsk as klsk, s.kpr as kpr, s.kpr_ot as kpr_ot,
    s.kpr_wr as kpr_wr, s.cnt_lg as cnt_lg, s.cnt_subs as cnt_subs, s.cnt_kw as cnt_kw,
    0 as cnt_houses, s.cnt_prop, s.cnt_ub,
    substr(s.mg, 1, 4)||'-'||substr(s.mg, 5, 2) as mg1
    from scott.statistics_lsk s, scott.usl u, scott.s_reu_trest t, scott.sprorg p, scott.status m, scott.spul k,
    (select reu,kul,nd from scott.tree_objects s2 where 
     s2.fk_user=99024640--USERENV('sessionid') 
     and sel=0
     and reu is not null
     and kul is not null
     and nd is not null) DOM
    where s.reu=t.reu
    and s.usl=u.usl and s.kul=k.id
    and s.org=p.kod
    and s.status=m.id
    and s.reu=dom.reu and s.kul=dom.kul and s.nd=dom.nd
    and s.mg between '201206' and '201207' order by scott.trg.f_order(s.kw,7)
    
    select distinct sel from scott.tree_objects
    
    
    select * from ldo.l_kwtp_crc t
