select t.rowid, t.id, t.main_id,
               upper(g.name) as name_tr,
       decode(t.obj_level,
               0,
               g.name,
               1,
               g.name,
               2,
               'РЭУ: ' || g.name,
               p.name || ', ' || ltrim(t.nd, '0')) as name, t.trest, t.reu,
       t.kul, t.nd, upper(ltrim(t.nd, '0')) as nd1, t.obj_level, upper(p.name) as street,
       t.state,
       t.sel
  from (select s2.* from scott.tree_objects_temp s2 where 
       (0=0 and s2.state=0 or 0<>0) and s2.fk_user=USERENV('sessionid')) t,
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
                           and u.cd = 'TEPLOENERGO'
                           and u.id = ur.fk_user   
                           and r.id = ur.fk_role
                           and r.id = ra.fk_role
                           and j.id = ra.fk_obj
                           and a.id = ra.fk_act
                           and j.id=226
                           and a.cd = 'Открыть'
                         --  and r.cd='T_BUH_TREST'
   )
 order by t.obj_level, t.reu, decode(t.obj_level,
               0,
               g.name,
               1,
               g.name,
               2,
               'РЭУ: ' || g.name,
               p.name || ', ' || ltrim(t.nd, '0')), p.name, t.nd

scott.reports
oralv.t_obj

oralv.t_org_tp
 select from ORALV.T_USXRL where
 
 GRANT BASE_CONNECT TO CAP_REM_VOD;
 grant select, update on scott.tree_obects_temp to RES_ORG_BASE_CONNECT
scott.l_pay
GRANT SELECT, insert,UPDATE ON SCOTT.TREE_OBJECTS_TEMP TO RES_ORG_BASE_CONNECT;
GRANT SELECT,insert, UPDATE ON SCOTT.TREE_ORG_TEMP TO RES_ORG_BASE_CONNECT;
GRANT SELECT,insert, UPDATE ON SCOTT.TREE_USL_TEMP TO RES_ORG_BASE_CONNECT;
GRANT SELECT ON SCOTT.REPORTS TO RES_ORG_BASE_CONNECT;
GRANT SELECT ON SCOTT.REP_LEVELS TO RES_ORG_BASE_CONNECT;

--представление для выбора организации для фильтра в отчетах
select * from scott.tree_org_temp
where org in (
                          select g.id, g.kod
                          from oralv.t_org g, oralv.t_org_tp tp ,
                               oralv.t_user u, oralv.t_role r, oralv.t_usxrl ur,
                               oralv.t_obj j, oralv.t_act a, oralv.t_rlxac ra
                         where g.id = ur.fk_org
                           and g.fk_orgtp=tp.id
                           and u.cd = USER
                           and u.id = ur.fk_user   
                           and r.id = ur.fk_role
                           and r.id = ra.fk_role
                           and j.id = ra.fk_obj
                           and a.id = ra.fk_act
                           and j.id=190  --вэтой группе отчетов этот юзер будет видеть токо нужную орг-ию.
                           and a.cd = 'Фильтр по организации'
                  --         and tp.cd='Поставщик услуг'
                         --  and G.KOD is not null
                        --   and r.cd='V_PERMISSIONS_ORG'
                       )


SELECT t.kodm, t.kod, t.name, t.dat, t.kod1, t.dat2, t.kod2, t.dat3, t.kod3, t.type, t.for_sch, t.nds_uszn
      FROM oralv.t_org t, oralv.t_orgxtp x, oralv.t_org_tp tp
     WHERE tp.cd = 'Поставщик услуг'
       AND x.fk_orgtp = tp.id
       AND x.fk_org = t.id and t.kod is not null
       
       oralv.t_usxac
       
       select * from oralv.t_obj
       select * from SCOTT.reports