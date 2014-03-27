create or replace procedure clear_tables 
AS
  -- курсор тех дат, которые надо транкейт
  CURSOR c_part IS SELECT partition_name pn,subpartition_name spn
               FROM ALL_TAB_SUBPARTITIONS WHERE table_name='A_FLOW' and table_owner='PREP'
               AND  subpartition_name like '%SP14%' ORDER BY 2 asc;
  L_USE number;
  L_D varchar2(100);                
  l_mg scott.params.period%type;
BEGIN
  dbms_output.put_line(to_char(sysdate,'hh24:mm:ss'));
  SELECT p.period into l_mg from scott.params p;  --  начинаем пример! - дата l_mg = 201207 (партиция 201208)
  SELECT to_char(add_months(to_date(l_mg||'01','YYYYMMDD'),-2), 'YYYYMM') into L_D from dual; -- надо 2 месяца отнимать! так как в 8-ой партиции у нас 7-ой месяц.
                                                                                                                              -- а так как чистить мы будем по имени партиции то и брать надо на месяц меньше (-2)
  --после запроса получаем L_D=201205 - это часть имени партиции!                                                                                                                                
  dbms_output.put_line(L_D);
  FOR rec IN c_part
  LOOP  
      IF  substr(rec.spn,3,6)<=L_D then   --очищаем партиции, которые меньше либо равны L_D=201205-ой партиции, 
                                                          --как раз получается очистим -3 месяца от mg=201207. (mg<= 201204) (для партиций <=201205)
         dbms_output.put_line('truncate - '||rec.spn);
     EXECUTE IMMEDIATE 'ALTER TABLE prep.A_FLOW TRUNCATE SUBPARTITION '|| rec.spn ||'';
     END IF; 
  END LOOP ;
  dbms_output.put_line(to_char(sysdate,'hh24:mm:ss'));
EXCEPTION
 when others then
     raise;
END;




declare 
  l_mg scott.params.period%type;
  L_D varchar2(100);             
begin
  SELECT p.period into l_mg from scott.params p;
  SELECT to_char(add_months(to_date(l_mg||'01','YYYYMMDD'),-3), 'YYYYMM') into l_d from dual;

  dbms_output.put_line(l_mg ||'    |     '||l_d);
end;


select partition_name,subpartition_name, showlong (high_value)
from ALL_TAB_SUBPARTITIONS where table_name='A_FLOW' and table_owner='SCOTT'
and subpartition_name like'%SP14%' 


select count(lsk) from prep.a_flow subpartition(MG201209_SP14)

select * from scott.a_flow subpartition(MG201209_SP1)

insert /*+ APPEND*/  into prep.a_flow select * 
from scott.a_flow subpartition(MG201209_SP14)

select count(lsk) from prep.a_flow where mg='201208' and fk_type=61

delete from prep.a_flow where mg='201208' and fk_type=61


  select t.id from scott.a_flow_tp t where    t.cd='DEBITS';