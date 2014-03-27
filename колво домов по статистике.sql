  --Кол-во домов по статистике
  for c in
   (select distinct reu from statistics_trest t where t.mg='201208')
  loop
  
  update prep.statistics_trest t set t.cnt_houses=(select count(*) from 
   (    select distinct reu, kul ,nd from kart where psch <> 9    ) a where a.reu=t.reu)
  where t.mg='201208' and rownum=1 
  and reu='72';
  end loop; доработать ебаный запрос!
  
  select sum(cnt_houses) from prep.statistics_trest where reu='72' and mg='201208'
  1767
  
  update prep.statistics_trest set cnt_houses=0 where mg='201208' and reu='72'
  select * from prep.statistics_trest where mg='201208' and reu='72'

drop table prep.statistics_trest

create table prep.statistics_trest as select * from scott.statistics_trest
