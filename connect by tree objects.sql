--��� �������. ������ ������� ���!!! 
select * from 
(  -- ��������� ������� ���� �� �������-������ ����. ����� ����� �������� ������.
SELECT distinct b.id, b.main_id, b.trest, b.reu, b.kul, b.nd,
--lpad(' ',2*(level-1)) || b.kul s, level, 
        SYS_CONNECT_BY_PATH ( b.kul, ', ' ) as all_name---, CONNECT_BY_ISLEAF
FROM  prep.tree_objects_temp b
start with b.id in(
             --������ ��� ������! �������� ������ id - ������ ����, ����� ����� ��������� �� ������� �����.
             select
             t.id from prep.tree_objects_temp t, scott.spul s 
             where t.kul=s.id and  upper(s.name) like'%�����%' and t.nd like '%1%' and sel=1  --�������� ���� =1
             --start with t.id in (35785)
          --   connect by prior t.main_id = t.id
           --  and t.id in(31)
             )
  connect by prior b.main_id  =  b.id
  --and id not in (1)
)  a 
--�������� ����� � ������... ��� ��� ����� ���� ���-�� �� ������. ����� - ������. 
--���� ���� �� �����, ������� �� ����� ������� ��������� ID, ������� � ������ ���-��- 35785
start with id in  (35785,35786)  -- ���7, ��� 9
connect by prior id= main_id
  
  
select g.id
  from oralv.t_org g, oralv.t_user u, oralv.t_role r, oralv.t_usxrl ur,
       oralv.t_obj j, oralv.t_act a, oralv.t_rlxac ra  
 where g.id = ur.fk_org
   and u.cd = user
   and u.id = ur.fk_user   
   and r.id = ur.fk_role
   and r.id = ra.fk_role
   and j.id = ra.fk_obj
   and a.id = ra.fk_act
   and j.id=190
   and a.cd = '�������'
   
   
  create table prep.x1 as select * from ( select /*+ qb_name(subq1) no_unnest*/ 
             t.id from scott.tree_objects_temp t, scott.spul s 
             where t.kul=s.id and  s.name like'%��������%' )
             
  create table prep.tree_objects_temp as select * from scott.tree_objects_temp
  
  --������� ������!
    with --������������ ���� ��� ������ ��������. ��������!!(
      s as
        (select t.*,s.name as street
           from prep.tree_objects_temp t, scott.spul s 
           where t.kul=s.id
        ), 
      w as
        (
           select id from s where lower(street) like '%�����%'
        )
   select * 
     from s
    where id = 1
       or id in (select id from w)
       or main_id in (select id from w)
    connect by main_id = prior id
    start with id =2 
    
    
    
    
    select * from scott.spul where id=0059
    
    select reu from scott.kart where kul='0040' and nd='00028�' and kw='0000002'
    select * from scott.kart  where lsk='30171001'