with d(t,q) as 
(
select 'SGA' as t, sum (value)  q from v$sga
union all
select 'PGA' as t,sum(value)over() q from v$pgastat
where name='aggregate PGA target parameter'
)
SELECT t, sum(q) FROM d
GROUP BY ROLLUP (t)

