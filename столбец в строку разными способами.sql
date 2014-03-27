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
/*вар 1*/
   select 
    reu,kul,nd  ,
   listagg (kw,',') within group (order by kw)
      from oralv.kart
    group by reu,kul,nd  
/*вар 2*/   
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
/*вар 3*/
with t as (
 select reu,kul,nd from oralv.kart where rownum<100)
 select reu,kul,
 (xmlelement(list, xmlagg(
 xmlelement(col,nd||',')
 )).extract('LIST/COL')).extract('COL/text()').getStringVal() AS result
 from t
 group by reu,kul
 
 статья
 
-О соединении данных столбца в одну строку с помощью SQL-запроса Поделиться на Google+ Поделиться ВКонтакте Facebook

Постановка задачи: в некоей таблице имеется столбец с данными. Необходимо эти данные склеить в строку с помощью одного SQL-запроса.
Часть I. Аналитика и иерархия.

Простой способ решения задачи подсказал Т.Кайт в статье On Ignoring, Locking, and Parsing. Этот способ 
основывается на использовании аналитических функций и функции SYS_CONNECT_BY_PATH для иерархических запросов
 и применим начиная с Oracle9i Database Release 1. Идея заключается в следующем.
    Выбираемые данные необходимо разделить на подгруппы, для которых будут склеиваться строки и в каждой
     подгруппе пронумеровать элементы в порядке их склеивания.

      select
        deptno,
        ename,
        row_number() over (partition by deptno order by ename) rn
      from emp

    С помощью иерархического запроса все данные подгруппы соединяются в одну ветку дерева.
     Для каждого узла с помощью функции SYS_CONNECT_BY_PATH вычисляется строка со всеми 
     предшествующими значениями поля, разделенными заданным разделителем.

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

    Далее остается сгруппировать полученные данные по идентификатору подгруппы и выбрать для каждой значение строки максимальной длинны.

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

В результате получаем список сотрудников по отделам.

   DEPTNO         SCBP
---------         ----------------------------------
       10         CLARK KING MILLER
       20         ADAMS FORD JONES SCOTT ...
       30         ALLEN BLAKE JAMES MARTIN ...

Этот способ прост и удобен, но имеет один недостаток. Функция SYS_CONNECT_BY_PATH работает с переменными VARCHAR2, 
которые, как известно, ограничиваются размером 4000 символов. При большом объеме склеиваемых данных, 
неизбежно возникает ошибка ORA-01489: result of string concatenation is too long. 
Эту проблему решает второй способ решения задачи.
Часть II. XML и CLOB.

Второй вариант предусматривает использование аггрегатной функции XMLAGG для получения склеенной строки в виде XML-объекта, 
который может быть преобразован в CLOB.

select
  reu,kul,nd,
  XMLAGG(XMLELEMENT(",",kw)).getCLOBVal() scbp
from oralv.kart
group by reu,kul,nd

Для упорядочивания элементов в склеиваемой строке функции XMLAGG можно добавить сортировку.

select
  deptno,
  XMLAGG(XMLELEMENT("node", ename) order by ename).getCLOBVal() scbp
from emp
group by deptno

А если возникнет необходимость отсортировать полученные склеенные строки, можно воспользоваться преобразованием типов cast.

select
  deptno,
  XMLAGG(XMLELEMENT("node", ename) order by ename).getCLOBVal() scbp
from emp
group by deptno
order by cast( substr(scbp, 1, 4000) as varchar2(4000))

В результате получится следующее:

   DEPTNO         SCBP
---------         ----------------------------------
       20         <node>ADAMS</node><node>FORD</node> ...
       30         <node>ALLEN</node><node>BLAKE</node> ...
       10         <node>CLARK</node><node>KING</node>

Недостаток данного способа – наличие тэгов, которые необходимо обрабатывать в зависимости от целей поставленной задачи. 
Хотя для случая, ставшего причиной поиска описанного решения, тэги оказались скорее плюсом.

Этот же метод можно применить и для более коротких строк, где не требуется использование CLOB-данных. XML-объект можно 
преобразовать в varchar2 с помощью функции getStringVal().

select
  deptno,
  XMLAGG(XMLELEMENT("node", ename) order by ename).getStringVal() scbp
from emp
group by deptno
order by scbp