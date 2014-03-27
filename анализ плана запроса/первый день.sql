select bh.tch,bh.tim,object_.owner,object_.object_name,object_.object_type
from x$bh bh, v$latch_children l_c, dba_objects object_  
where owner not in ('SYS','SYSMAN') and l_c.name = 'cache buffers chains' and tch<>0 and bh.obj=object_.data_object_id and bh.hladdr = l_c.addr 
order by 1 desc

select tch,owner,object_name,sql_text from v$sqlarea s,
(select * from (select bh.tch,bh.tim,object_.owner,object_.object_name,object_.object_type
from x$bh bh,v$latch_children l_c,dba_objects object_  
where owner not in ('SYS','SYSMAN','SYSTEM') and l_c.name = 'cache buffers chains'and object_.object_type='TABLE'
 and tch>10 and bh.obj=object_.data_object_id and bh.hladdr = l_c.addr order by tch desc) where rownum<10) b
where instr(s.sql_text,object_name)>0



DECLARE
my_task_name VARCHAR2 ( 30 );
my_sqltext   CLOB;

BEGIN
my_sqltext :=
   'SELECT lsk FROM scott.info_usl_lsk i, (select id from scott.spul where rownum<10) sp '
|| 'WHERE i.mg=''201303'' and i.kul=sp.id'
;

my_task_name :=
DBMS_SQLTUNE.CREATE_TUNING_TASK (
  sql_text    => my_sqltext
, user_name   => 'SCOTT'
, task_name   => 'my_sql_tuning_task'
);
END;

SELECT  lsk FROM scott.info_usl_lsk i, (select id from scott.spul where rownum<10) sp 
WHERE i.mg='201302' and i.kul=sp.id;
SELECT /*+ USE_HASH(i,sp) */ lsk FROM scott.info_usl_lsk i, (select id from scott.spul where rownum<10) sp 
WHERE i.mg='201302' and i.kul=sp.id;

SELECT status, execution_start start_time, execution_end end_time 
FROM dba_advisor_log 
WHERE owner = 'SYS' AND task_name = 'my_sql_tuning_task'

EXECUTE DBMS_SQLTUNE.EXECUTE_TUNING_TASK ( 'my_sql_tuning_task' );

SET LONG 10000
SET LONGCHUNKSIZE 1000
SET LINESIZE 200

SELECT
 DBMS_SQLTUNE.REPORT_TUNING_TASK ( 'my_sql_tuning_task' ) 
FROM dual;