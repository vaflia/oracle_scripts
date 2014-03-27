select * from scott.spul
инициативная - код - 0094
шахтеров - 0082
select * from scott.kart where kul='0094'
scott.s_reu_trest


update scott.info_usl_lsk i set status=(select status from scott.kart k where k.lsk=i.lsk)
where 
    i.reu in (select reu from scott.s_reu_trest where trest='04')
    and mg between '201201' and '201205'
    
kul='0082'   
and nd='000034'
and mg='201205'


select u.* from 
scott.info_usl_lsk u, scott.s_reu_trest s
where u.reu=s.reu
    and s.trest='04'
    and mg between '201205' and '201205'
     
 kul='0082'   
and nd='000034'
and mg='201204'


select * from prep.log_parser order by id desc

prep.d_load

oralv.t_org

PREP.KWTP_ERR

select * from scott.l_pay where lsk='55199699'



select * from 
scott.info_usl_lsk
where status>0
and mg='201201'

select * from oralv.t_doc


select 
  sum( decode(t.psch,0,decode(t.usl,'017',nvl(t.charges,0)-nvl(t.f,0),'018',nvl(t.charges,0)-nvl(t.f,0),0),0)) cr_n_gwtr,
  sum( decode(t.psch,0,decode(t.usl,'017',nvl(t.charges,0),0),0)) cr_n_gwtr,
  sum( decode(t.usl,'017',decode(psch,0,nvl(t.changes,0)-nvl(t.f,0)+nvl(t.f,0)-nvl(t.privs_cn,0),0),'018',decode(psch,0,nvl(t.changes,0)-nvl(t.f,0)+nvl(t.f,0)-nvl(t.privs_cn,0),0),0)) cn_n_gwtr,
  sum(t.f) f          
from scott.info_usl_lsk t
where t.reu='K2' 
and t.mg='201211'

select 
  sum(coalesce(t.charges,0)) cr_n_gwtr,
  sum(coalesce(t.changes,0)) cn_n_gwtr
from scott.info_usl_lsk t
where t.reu='K2' 
and t.mg='201211'
and psch=0
and t.usl='017'

select sum(summa),lsk
FROM scott.changes ch, scott.s_stra s
where s.nreu=substr(ch.lsk,1,4)
and ch.usl='017'
and ch.mg='201212'
and s.reu='L8'
group by lsk
--and reu='K2'
scott.params
49071318
49070117
select * from scott.info_usl_lsk
where lsk='49070117'
and mg='201212'