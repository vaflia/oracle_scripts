begin
 prep.oracle2dbf.export_dbf('DPDUMP','gen1.dbf','select * from scott.kart order by lsk');
end;
