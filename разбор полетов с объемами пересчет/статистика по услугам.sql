SELECT s.lsk,
   /* t.trest||' '||t.name_tr as predp, s.reu,
    k.name||', '||NVL(LTRIM(s.nd,'0'),'0') as predpr_det,
    LTRIM(s.kw,'0') as kw, TRIM(u.nm)||DECODE(u.ed_izm,null,'',' ('||TRIM(u.ed_izm)||')') as nm,
    p.kod||' '||p.name as orgname, m.name as status, decode(s.psch,1,'Закрытые Л/С','Открытые Л/С') as psch,
    decode(s.sch,1,'Счетчик','Норматив') as sch, s.val_group,*/
    sum(s.cnt) as cnt
/*    s.opl, s.klsk as klsk, s.kpr as kpr, s.kpr_ot as kpr_ot,
    s.kpr_wr as kpr_wr, s.cnt_lg as cnt_lg, s.cnt_subs as cnt_subs, s.cnt_kw as cnt_kw,
    s.cnt_prop, s.cnt_ub, m.id*/
FROM scott.statistics_lsk s, scott.usl u, scott.s_reu_trest t, scott.sprorg p, scott.status m, scott.spul k
WHERE s.reu=t.reu
    and s.usl=u.usl and s.kul=k.id
    and s.org=p.kod
    and s.status=m.id
    and s.reu='73'
    and u.usl in ('015','059')
    and mg= '201210' 
    group by s.lsk
    order by s.lsk