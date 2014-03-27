SELECT * from
                  (SELECT rn,   max(sys_connect_by_path (d1, ' ... ' )) dates
                    FROM (SELECT fk_regxpar, lrg.d1, rownum  as rn
                               FROM ldo.l_list_reg lr, ldo.l_regxpar lrp, ldo.l_regxparlst lrg
                               WHERE lr.id=767341   and
                                
                               lrp.fk_list_reg=lr.id
                               AND lrp.id=lrg.fk_regxpar
                               )
                    START with rn = 1
                    CONNECT BY prior rn = rn-1
                    GROUP BY rn order by rn desc 
                    ) where rownum = 1 
                    
                    

with s as
(select 'abc,cde,ef,gh,mn,test,ss, df,fw,ewe,wwe' str from dual
)
select * from s
select 
listagg(s      , ',') within group (order by       s) str_1,
listagg(trim(s), ',') within group (order by trim(s)) str_2
from
   (select substr(str,
                  decode(level, 1, 1, instr(str, ',', 1, level - 1) + 1),
                  decode(connect_by_isleaf, 1, length(str), instr(str, ',', 1, level) - decode(level, 1, 1, instr(str, ',', 1, level - 1) + 1))
                 ) s
    from s
    connect by level <= regexp_count(str, ',') + 1
   );
   
   select 
    reu,kul,nd  ,
   listagg (kw,',') within group (order by kw)
   
   from oralv.kart
    group by reu,kul,nd  
/*��� 1*/
   select 
    reu,kul,nd  ,
   listagg (kw,',') within group (order by kw)
      from oralv.kart
    group by reu,kul,nd  
/*��� 2*/   
SELECT reu,kul,nd,
 --wm_concat(ltrim(kw,0)) over (order by kw) 
 listagg(ltrim(kw,0),',') within group (order by kw)
FROM (
    select reu,kul,nd,kw from oralv.kart-- where rownum<100
   -- order by kw
  )
GROUP BY reu,kul,nd



select regexp_replace('0000700','[0]','') from dual
select ltrim('0000700',0) from dual  
/*��� 3*/
with t as (
 select reu,kul,nd from oralv.kart where rownum<100)
 select reu,kul,
 (xmlelement(list, xmlagg(
 xmlelement(col,nd||',')
 )).extract('LIST/COL')).extract('COL/text()').getStringVal() AS result
 from t
 group by reu,kul
 
 ������
 
-� ���������� ������ ������� � ���� ������ � ������� SQL-������� ���������� �� Google+ ���������� ��������� Facebook

���������� ������: � ������ ������� ������� ������� � �������. ���������� ��� ������ ������� � ������ � ������� ������ SQL-�������.
����� I. ��������� � ��������.

������� ������ ������� ������ ��������� �.���� � ������ On Ignoring, Locking, and Parsing. ���� ������ 
������������ �� ������������� ������������� ������� � ������� SYS_CONNECT_BY_PATH ��� ������������� ��������
 � �������� ������� � Oracle9i Database Release 1. ���� ����������� � ���������.
    ���������� ������ ���������� ��������� �� ���������, ��� ������� ����� ����������� ������ � � ������
     ��������� ������������� �������� � ������� �� ����������.

      select
        deptno,
        ename,
        row_number() over (partition by deptno order by ename) rn
      from emp

    � ������� �������������� ������� ��� ������ ��������� ����������� � ���� ����� ������.
     ��� ������� ���� � ������� ������� SYS_CONNECT_BY_PATH ����������� ������ �� ����� 
     ��������������� ���������� ����, ������������ �������� ������������.

    select
      deptno,
      sys_connect_by_path(ename, ' ' ) scbp
    from
      (select
         deptno,
         ename,
         row_number() over (partition by deptno order by ename) rn
       from emp
      )
    start with rn = 1
    connect by prior rn = rn-1
    and prior deptno = deptno

    ����� �������� ������������� ���������� ������ �� �������������� ��������� � ������� ��� ������ �������� ������ ������������ ������.

    select
      deptno,
      max(sys_connect_by_path(ename, ' ' )) scbp
    from
      (select
         deptno,
         ename,
         row_number() over (partition by deptno order by ename) rn
       from emp
      )
    start with rn = 1
    connect by prior rn = rn-1
    and prior deptno = deptno
    group by deptno
    order by deptno

� ���������� �������� ������ ����������� �� �������.

   DEPTNO         SCBP
---------         ----------------------------------
       10         CLARK KING MILLER
       20         ADAMS FORD JONES SCOTT ...
       30         ALLEN BLAKE JAMES MARTIN ...

���� ������ ����� � ������, �� ����� ���� ����������. ������� SYS_CONNECT_BY_PATH �������� � ����������� VARCHAR2, 
�������, ��� ��������, �������������� �������� 4000 ��������. ��� ������� ������ ����������� ������, 
��������� ��������� ������ ORA-01489: result of string concatenation is too long. 
��� �������� ������ ������ ������ ������� ������.
����� II. XML � CLOB.

������ ������� ��������������� ������������� ����������� ������� XMLAGG ��� ��������� ��������� ������ � ���� XML-�������, 
������� ����� ���� ������������ � CLOB.

select
  reu,kul,nd,
  XMLAGG(XMLELEMENT(",",kw)).getCLOBVal() scbp
from oralv.kart
group by reu,kul,nd

��� �������������� ��������� � ����������� ������ ������� XMLAGG ����� �������� ����������.

select
  deptno,
  XMLAGG(XMLELEMENT("node", ename) order by ename).getCLOBVal() scbp
from emp
group by deptno

� ���� ��������� ������������� ������������� ���������� ��������� ������, ����� ��������������� ��������������� ����� cast.

select
  deptno,
  XMLAGG(XMLELEMENT("node", ename) order by ename).getCLOBVal() scbp
from emp
group by deptno
order by cast( substr(scbp, 1, 4000) as varchar2(4000))

� ���������� ��������� ���������:

   DEPTNO         SCBP
---------         ----------------------------------
       20         <node>ADAMS</node><node>FORD</node> ...
       30         <node>ALLEN</node><node>BLAKE</node> ...
       10         <node>CLARK</node><node>KING</node>

���������� ������� ������� � ������� �����, ������� ���������� ������������ � ����������� �� ����� ������������ ������. 
���� ��� ������, �������� �������� ������ ���������� �������, ���� ��������� ������ ������.

���� �� ����� ����� ��������� � ��� ����� �������� �����, ��� �� ��������� ������������� CLOB-������. XML-������ ����� 
������������� � varchar2 � ������� ������� getStringVal().

select
  deptno,
  XMLAGG(XMLELEMENT("node", ename) order by ename).getStringVal() scbp
from emp
group by deptno
order by scbp