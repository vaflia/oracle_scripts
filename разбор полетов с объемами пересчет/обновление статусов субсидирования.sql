select count(*) from info_usl_lsk where mg='201206' and status>1
select count(*) from scott.statistics_lsk where mg='201209'

update scott.info_usl_lsk l set status=(select status from prep.stat s where s.lsk = l.lsk and s.mg='201206')
where mg='201206'

insert into prep.stat select distinct status, lsk, '201206' from scott.statistics_lsk where mg='201206'

select  lsk, status  from prep.stat where mg='201206'

delete  from prep.stat where mg='201206' and lsk is null
delete  from prep.stat where mg='201206' and status is null

select * from scott.kart where status is null

truncate table prep.stat