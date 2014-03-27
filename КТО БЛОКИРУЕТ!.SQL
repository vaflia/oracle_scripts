select    'lock type = ' || lk.TYPE || ' table name = ' || OB.OBJECT_NAME || ' SID = ' || se.sid || 
                                   ' username = '  ||  se.username ||
                                   ' OS user = ' || se.osuser || 
                                   ' machine = ' ||  se.machine ||
                                   ' program = ' || se.program ||
                                   ' pid = ' || PS.SPID || 
                                   ' module = ' || se.module  data 
                        from v$lock lk
                        join dba_objects ob on ob.object_id = lk.id1
                                and OB.OBJECT_TYPE = 'TABLE'
                                and ob.owner = 'SCOTT'
                        join v$session se on se.sid = lk.sid
                        join v$process ps on PS.ADDR = se.paddr
                        where lk.TYPE IN  ('TM','UL');
        