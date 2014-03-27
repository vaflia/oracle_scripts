declare 
fk_user_ integer;
maxid_ integer;
begin
fk_user_:=11;
 --подготовка домов для выбора пользователями
 delete from prep.tree_objects t
 where t.fk_user=fk_user_;

--000
 insert into prep.tree_objects (main_id, id, obj_level, fk_user, sel, fk_org, state)
 select t.parent_id, t.id, 0, fk_user_, 1, t.id, 0 as state
  from oralv.t_org t, oralv.t_org_tp p
  where t.fk_orgtp=p.id and p.cd='000'
   connect by t.parent_id=t.id;

--МП УЕЗЖКУ
 insert into prep.tree_objects (main_id, id, obj_level, fk_user, sel, fk_org, state)
 select t.parent_id, t.id, 0, fk_user_, 1, t.id, 0 as state
  from oralv.t_org t, oralv.t_org_tp p
  where t.fk_orgtp=p.id and t.cd='МП "РИЦ"'
--  where t.fk_orgtp=p.id and t.cd='МП УЕЗЖКУ'
   connect by t.parent_id=t.id;

--трест
 insert into prep.tree_objects (main_id, id, obj_level, trest, fk_user, sel, fk_org, state)
 select t.parent_id, t.id, 1, t.trest, fk_user_, 1, t.id as fk_org,
  0 as state
  from oralv.t_org t, oralv.t_org_tp g
  where t.fk_orgtp=g.id and g.cd='ЖЭО'
  and exists
  (select * from s_reu_trest r, params p where 
     p.period between r.mg1 and r.mg2
     and r.trest=t.trest)
   connect by t.parent_id=t.id
  union all
 select t.parent_id, t.id, 1, t.trest, fk_user_, 1, t.id as fk_org,
  1 as state
  from oralv.t_org t, oralv.t_org_tp g
  where t.fk_orgtp=g.id and g.cd='ЖЭО'
  and not exists
  (select * from s_reu_trest r, params p where 
     p.period between r.mg1 and r.mg2
     and r.trest=t.trest)
   connect by t.parent_id=t.id;

--рэу
 insert into prep.tree_objects (main_id, id, obj_level, reu, trest, fk_user, sel, fk_org, state)
 select t.parent_id, t.id, 2, t.reu, d.trest, fk_user_, 1 as sel, t.id,
  case when p.period between s.mg1 and s.mg2 then 0 
    else 1 end as state
  from oralv.t_org t, oralv.t_org_tp g, oralv.t_org d, s_reu_trest s, params p
  where t.fk_orgtp=g.id and g.cd='РЭУ' and t.parent_id=d.id
  and t.reu=s.reu(+)
   connect by t.parent_id=t.id;

 select max(id) into maxid_ 
   from prep.tree_objects t where t.fk_user=fk_user_;
   
--дома
 insert into prep.tree_objects (main_id, id, obj_level, reu, kul, nd, trest, fk_user, sel, state)
   select a.main_id, maxid_+rownum as rn, 3, a.reu, a.kul, a.nd, d1.trest, fk_user_, 1 as sel,
    case when p.period between a.dat_nach and a.dat_end then 0 
    else 1 end as state
    from (select distinct k.reu, k.kul, k.nd, t.id as main_id, k.dat_nach, k.dat_end
     from load_koop k, prep.tree_objects t
      where k.reu=t.reu and t.obj_level=2
      and t.fk_user=fk_user_) a, oralv.t_org d, oralv.t_org_tp g, oralv.t_org d1, params p
      where a.reu=d.reu and g.cd='РЭУ' and d.fk_orgtp=g.id and d.parent_id=d1.id;
      
end;