SELECT distinct reu, lsk 
from scott.load_kart 
WHERE reu in ('57','55')
and status=1
and psch not in 9
order by lsk
--and psch=0

SELECT ul.name ||' '|| stat.nd ||' '|| stat.kw, lsk, sum(cnt) 
FROM scott.statistics_lsk stat, scott.spul ul 
WHERE  
stat.kul=ul.id
and mg = '201205'
and reu in ('55','57')
--and usl in ('050','026')
and psch=0
and status=1
GROUP BY ul.name ||' '|| stat.nd ||' '|| stat.kw, lsk
ORDER BY ul.name ||' '|| stat.nd ||' '|| stat.kw, lsk


SELECT ul.name ||' '|| stat.nd ||' '|| stat.kw, lsk, sum(cnt) 
from scott.statistics_lsk stat, scott.spul ul 
WHERE 
stat.kul=ul.id
and mg between '201206' and '201206'
and reu in ('55','57')
and usl in ('050','026')
and psch=0
and status=1
GROUP BY rollup (ul.name ||' '|| stat.nd ||' '|| stat.kw, lsk)
ORDER BY lsk, ul.name ||' '|| stat.nd ||' '|| stat.kw


select mg,kul,nd,kw,status,usl,lsk,sum(opl) from scott.statistics_lsk where 
reu='55'
and kul='0005'
and nd='000078'
and kw='0000246'
and mg between '201301' and '201301'
--and status=1
--and usl in ('050','026')
group by kw,status,usl,kul,nd,mg,lsk
order by mg,usl



scott.t_reu_kul_nd_status
scott.spul
scott.status
scott.usl

select lsk,
    decode(krt.nai,0,null,krt.opl) as "ïëàòà íàéì",
    decode(krt.knai,0,null,krt.opl) as "àéì êîììåğ÷"
from scott.load_kartw krt
where reu in ('55','57')
and status=1
order by lsk


select distinct lsk from scott.statistics_lsk 
where reu in ('55','57')
and mg = '201212'
and psch=0
and status=1
order by lsk

select * from scott.statistics_lsk 
where reu in ('55','57')
and mg = '201201'
and psch=0
and status=1
and lsk in ('55168902','55164945')
order by lsk, usl



select nai,knai,psch,reu from scott.load_kart where lsk='55164945'
select * from scott.kart where lsk='55162120'
scott.status

select * from scott.load_kart where lsk='55164945'

scott.params

prep.d_load

ÎÊÒßÁĞÜÑÊÈÉ ÏĞ. 000082 0000338    55167537    747,302

ALTER USER FKV ACCOUNT UNLOCK