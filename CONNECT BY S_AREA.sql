--вниз по иерархии
SELECT lpad(' ',2*(level-1)) || name s ,level
FROM oralv.s_area
 -- connect by prior parent_id  = id
  connect by prior id  = parent_id
  --start with id=9
  start with parent_id=3
  
--вверх по иерархииLink Name    HOT_TEST.REGRESS.RDBMS.DEV.US.ORACLE.COM
SELECT lpad(' ',2*(level-1)) || name s, level, 
        SYS_CONNECT_BY_PATH ( name, ', ' ) as all_name, CONNECT_BY_ISLEAF
FROM oralv.s_area@HOT_TEST.REGRESS.RDBMS.DEV.US.ORACLE.COM
start with id in(9,10)
  connect by prior parent_id  = id
  and id not in (1)

select * from ldo.l_registr@hotora where otn=24
  
  
WITH
numbers ( n ) AS (
   SELECT 1 AS n FROM dual -- исходное множество -- одна строка
   UNION ALL                      -- символическое «объединение» строк
   SELECT n + 1 AS n              -- рекурсия: добавок к предыдущему результату
   FROM   numbers                 -- предыдущий результат в качестве источника данных
   WHERE  n < 10                   -- если не ограничить, будет бесконечная рекурсия
)
SELECT n FROM numbers  
