select t.rowid, t.id, t.main_id,
               upper(g.name) as name_tr,
       decode(t.obj_level, 0, g.name, 1, g.name,
               2,               'РЭУ: ' || g.name,
               p.name || ', ' || ltrim(t.nd, '0')) as name, t.trest, t.reu,
       t.kul, t.nd, upper(ltrim(t.nd, '0')) as nd1, t.obj_level, upper(p.name) as street,
       t.state,
       t.sel
  from (select s2.* from prep.tree_objects s2 where 
       (0=0 and s2.state=0 or 0<>0) and s2.fk_user=3146) t,
       scott.spul p,
oralv.t_org g
 where 
   t.kul = p.id(+)
   and t.fk_org=g.id(+)
   connect by prior t.id=t.main_id
   start with t.id in (
   select g.id
  from oralv.t_org g, oralv.t_user u, oralv.t_role r, oralv.t_usxrl ur,
       oralv.t_obj j, oralv.t_act a, oralv.t_rlxac ra  
 where g.id = ur.fk_org
   and u.cd = 'BUGH_LTREST5' -- менять токо тут юзаков которых надо проверить! ставим имена из таблицы t_user
   and u.id = ur.fk_user   
   and r.id = ur.fk_role
   and r.id = ra.fk_role
   and j.id = ra.fk_obj
   and a.id = ra.fk_act
   and j.cd = 'ВСЕ_ОТЧЕТЫ'   and a.cd = 'Открыть')
 order by t.obj_level, t.reu, decode(t.obj_level,
               0,  g.name, 1,  g.name, 2, 'РЭУ: ' || g.name,
               p.name || ', ' || ltrim(t.nd, '0')), p.name, t.nd

