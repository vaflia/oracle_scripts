SELECT trest,reu,sum(ska) ska,sum(pn) pn,sum(bn) bn
                        FROM   PREP.KWTP_OLAP
                        WHERE dtek BETWEEN :dat_ and :dat1_
                    --    AND FOR_PLAN=1
                        GROUP BY trest, reu


log_parser
kwtp_olap


select index_name, monitoring, used, start_monitoring, end_monitoring
    from v$object_usage
    
    
    ALTER INDEX kwtp_olap_idx_l_pay MONITORING USAGE
    
    
    SELECT a.owner "Схема",
       a.table_name "Таблица",
       b.bytes "Размер (Мб)",
       TRUNC((a.blocks * 100) / b.blocks) "Занято(%)",
       b.extents "Экстентов"
FROM dba_tables a,
     (
        SELECT owner, segment_name, sum(bytes)/1024/1024 bytes,
               sum(blocks) blocks, count(*) extents
          FROM dba_extents
        -- WHERE segment_type = '%'
      GROUP BY owner, segment_name
     ) b
WHERE a.owner = 'PREP'  AND
      a.owner = b.owner AND a.table_name = b.segment_name
      ORDER BY a.table_name
