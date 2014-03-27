--посомтреть все партиции в базе
SELECT count(*)
  FROM DBA_TAB_PARTITIONS
 WHERE partition_name='DTEK1112013' 
   and table_name='KWTP_B'
   and table_owner='PREP'