create table scott.log_cap_reguest as select * from scott.cap_reguest where 1=0

insert into scott.log_cap_reguest select * from scott.cap_reguest where flow_id= 283151


select count(*), reu, kul, nd, flow_id, status_id
from scott.cap_reguest
group by reu, kul, nd, flow_id, status_id


select t.*,t.rowid from scott.cap_reguest t
 where flow_id=158450
 
 INSERT INTO CAP_REGUEST select * from KILLME_CAP_REGUEST t where t.flow_id=283104
 INSERT INTO SCOTT.CAP_TRANSACTIONS select * from KILLME_CAP_TRANSACTIONS  where id=283104
 where id>283000 and user_id=235
 
  scott.s_reu_trest
  scott.spul
  select * from KILLME_CAP_REGUEST t where kul='0082' and nd='000077'
  select * from KILLME_CAP_TRANSACTIONS where id>283000 and user_id=235
  order by id
  
   select * from CAP_REGUEST t where t.flow_id=283055
  select t.*,t.rowid from CAP_TRANSACTIONS t where id=283054
 
 
select * from oralv.t_user