--ÑÎÇÄÀÍÈÅ ÄÅĞÅÂÀ ÎÁÚÅÊÒÎÂ ÄËß ÒÅÑÒÀ
declare
 fk_user_ number;
 maxid_ number; 
 begin
 select USERENV('sessionid') into fk_user_ from dual;
 --ïîäãîòîâêà äîìîâ äëÿ âûáîğà ïîëüçîâàòåëÿìè
 --000
 insert into scott.tree_objects_temp (main_id, id, obj_level, fk_user, sel, fk_org, state)
 select t.parent_id, t.id, 0, fk_user_ , 1, t.id, 0 as state
  from oralv.t_org t, oralv.t_org_tp p
  where t.fk_orgtp=p.id and p.cd='000'
   connect by t.parent_id=t.id;

--ÌÏ ÓÅÇÆÊÓ
 insert into scott.tree_objects_temp (main_id, id, obj_level, fk_user, sel, fk_org, state)
 select t.parent_id, t.id, 0, fk_user_ , 1, t.id, 0 as state
  from oralv.t_org t, oralv.t_org_tp p
  where t.fk_orgtp=p.id and t.cd='ÌÏ "ĞÈÖ"'
   connect by t.parent_id=t.id;

--òğåñò
 insert into scott.tree_objects_temp (main_id, id, obj_level, trest, fk_user, sel, fk_org, state)
 select t.parent_id, t.id, 1, t.trest, fk_user_ , 1, t.id as fk_org,
  0 as state
  from oralv.t_org t, oralv.t_org_tp g
  where t.fk_orgtp=g.id and g.cd='ÆİÎ'
  and exists
  (select * from scott.s_reu_trest r, scott.params p where 
     p.period between r.mg1 and r.mg2
     and r.trest=t.trest)
   connect by t.parent_id=t.id
  union all
 select t.parent_id, t.id, 1, t.trest, fk_user_ , 1, t.id as fk_org,
  1 as state
  from oralv.t_org t, oralv.t_org_tp g
  where t.fk_orgtp=g.id and g.cd='ÆİÎ'
  and not exists
  (select * from scott.s_reu_trest r, scott.params p where 
     p.period between r.mg1 and r.mg2
     and r.trest=t.trest)
   connect by t.parent_id=t.id;

--ğıó
 insert into scott.tree_objects_temp (main_id, id, obj_level, reu, trest, fk_user, sel, fk_org, state)
 select t.parent_id, t.id, 2, t.reu, d.trest, fk_user_ , 1 as sel, t.id,
  case when p.period between s.mg1 and s.mg2 then 0 
    else 1 end as state
  from oralv.t_org t, oralv.t_org_tp g, oralv.t_org d, scott.s_reu_trest s, scott.params p
  where t.fk_orgtp=g.id and g.cd='ĞİÓ' and t.parent_id=d.id
  and t.reu=s.reu(+)
   connect by t.parent_id=t.id;

 select max(id) into maxid_ 
   from scott.tree_objects_temp t where t.fk_user=fk_user_ ;
   
--äîìà
 insert into scott.tree_objects_temp (main_id, id, obj_level, reu, kul, nd, trest, fk_user, sel, state)
   select a.main_id, maxid_ +rownum as rn, 3, a.reu, a.kul, a.nd, d1.trest, fk_user_, 1 as sel,
    case when p.period between a.dat_nach and a.dat_end then 0 
    else 1 end as state
    from (select distinct k.reu, k.kul, k.nd, t.id as main_id, k.dat_nach, k.dat_end
     from scott.load_koop k, scott.tree_objects_temp t
      where k.reu=t.reu and t.obj_level=2
      and t.fk_user=fk_user_) a, oralv.t_org d, oralv.t_org_tp g, oralv.t_org d1, scott.params p
      where a.reu=d.reu and g.cd='ĞİÓ' and d.fk_orgtp=g.id and d.parent_id=d1.id;
      
     -- ÓÑËÓÃÈ
    /* Formatted on 02.10.2013 13:57:44 (QP5 v5.139.911.3011) */
    INSERT INTO scott.tree_usl_temp (fk_user, uslm, nm1, sel,v)
         SELECT fk_user_, 
                     uslm, 
                     to_char(uslm) || ' ' || nm1 as nm1, 1, 1
           FROM SCOTT.USL
          WHERE TYPE IN (0, 1)
       GROUP BY uslm, nm1
       ORDER BY nm1;
      INSERT INTO scott.tree_usl_temp (fk_user, uslm, nm1, sel,v)
         SELECT fk_user_, 
                     uslm, 
                     to_char(uslm) || ' ' || nm1 as nm1, 1, 0
           FROM SCOTT.USL
          WHERE uslm in ('100','108')
       GROUP BY uslm, nm1
       ORDER BY nm1;
     --ÎĞÃÀÍÈÇÀÖÈÈ
    /* Formatted on 03.10.2013 9:17:49 (QP5 v5.139.911.3011) */
    INSERT INTO SCOTT.TREE_ORG_TEMP (fk_user, org, name, sel)
         SELECT  fk_user_, t.kod,
               TO_CHAR (t.kod) || ' ' || t.name AS name, 0
            FROM scott.sprorg t
          WHERE kod <> 0 AND TO_CHAR (kod) <> name AND name IS NOT NULL
       ORDER BY t.kod;
end;