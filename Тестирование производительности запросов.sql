select * from scott.a_flow where lsk='72193255' and mg='201303' and dt1=to_date('09.03.2013')

select /*+  USE_HASH(pr,k) */ pr.*
 from kart_pr pr,
      (   select /*+ FIRST_ROWS */ distinct k.lsk from prep.kart_pr k 
                group by k.lsk 
                having count(k.lsk)>4 
           order by lsk desc
     )  a
where a.lsk=pr.lsk
order by pr.lsk

select /*+  USE_HASH(aasdasf) */ pr.*
 from kart_pr pr,
      (   select /*+ no_use_hash_aggregation*/ distinct k.lsk from prep.kart_pr k 
                group by k.lsk 
                having count(k.lsk)>4 
      --     order by lsk desc
     )  a
where a.lsk=pr.lsk
order by pr.lsk


select pr.* 
from prep.kart_pr pr where not exists
        (select  /*+ HASH_AJ*/ distinct k.lsk from prep.kart_pr k where k.lsk=pr.lsk group by k.lsk having count(k.lsk)>5)
order by pr.lsk        
        
select  pr.* 
from prep.kart_pr pr where lsk not in
        (select /*+ HASH_AJ*/ distinct k.lsk from prep.kart_pr k  group by k.lsk having count(k.lsk)>5)
order by pr.lsk        
        
select * from table(dbms_xplan.display);

select * from prep.kart_pr where lsk = '54191199'

select * from scott.kart_pr where lsk = '54191199'

create table prep.kart_pr as select * from scott.kart_pr


select /*+ FIRST_ROWS*/ * from scott.log order by timestampm desc

select /*+ INDEX_DESC (t log_timestampm_idx), FIRST_ROWS*/
trunc(t.timestampm),  u.username, t.* 
from scott.log t, all_users u
 where (1=1 and t.event_id is null
 or 1=0)
 and (1=1 and (upper(t.comments) like '%'||upper('')||'%'
  or upper(u.username) like '%'||upper('')||'%')
  or 1=0)
 and u.user_id=t.id
 --order by t.timestampm desc
 
 SELECT /*+ FULL(l) PARALLEL(l, 5) */ *
FROM scott.log l;
 

select degree from dba_tables where table_name=log default=1 

  SELECT *
FROM scott.log l;
 
 
 select /*+ USE_HASH (p,lr)*/* from scott.l_pay p, ldo.l_list_reg lr 
 where  p.fk_list_reg=lr.id
 and lr.fk_reg in ('478','869')
 and p.lsk='66091019'
 and p.dt1 between '16.02.2013' and '20.02.2013'
 
 select /*+ USE_HASH (p,lr)*/* from scott.l_pay p, ldo.l_list_reg lr 
 where  p.fk_list_reg=lr.id
 and lr.fk_reg in ('478','869')
 and p.lsk='55199757'
 and p.dt1 between '16.02.2013' and '20.02.2013'
 

 
 select * from prep.log_parser order by id desc
 usl
 
 
 with rids as(
            select/*+ MATERIALIZE */
               rowid rid
            from scott.log i
            where trunc(timestampm)='29.03.2013'
)
select/*+ use_nl(rids t_big) */ t_big.*
from scott.log t_big, rids
where t_big.rowid=rids.rid

with rids as(
            select/*+ MATERIALIZE */
               rowid rid
            from scott.log i
            where trunc(timestampm)='29.03.2013'
)
select/*+ NO_PARALLEL (t_big)   use_nl(rids t_big)  */ t_big.*
from scott.log t_big, rids
where t_big.rowid=rids.rid

kart 
info_usl_nd

            select trunc(timestampm)
            from scott.log
            where trunc(timestampm)='29.03.2013'
            
            
           alter table scott.log parallel (degree 1);
             
select degree  from user_tables where table_name = 'LOG';

select count(*) from scott.log

alter table scott.log noparallel;

SELECT /*+ PARALLEL(log,4) */ COUNT(*) 
FROM scott.log

