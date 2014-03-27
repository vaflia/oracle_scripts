       

select * from info_usl_lsk where-- lsk='10170114'
                   -- and 
                    mg between '201301' and '201301'
                    order by usl
select * from scott.load_kartr where lsk='10146534'
                    and mg between '201212' and '201212'
select * from scott.load_kartw where lsk='10146534'
                    and mg between '201212' and '201212'
                    
select * from scott.statistics_lsk where-- lsk='10170114' and
                     mg between '201301' and '201301'
                    order by usl
                    
                    
                    
select * from scott.t_volume_usl_izm where lsk='10172051'        
                    
select * from load_kwni where lsk='10172051'

load_kartr
select * from load_kartr
where mot<>0 or mot_n<>0
or dop_ot<>0 or ndop_ot<>0 
                    
                  

select distinct status,reu,kul,nd
--select * 
from info_usl_lsk where
    mg between '201207' and '201207'
    and reu='Z2'
GROUP BY MG    

scott.statu

update SCOTT.INFO_USL_LSK set status=3
where mg between '201212' and '201205'
and lsk='10146534'


select * from SCOTT.INFO_USL_LSK 
where mg between '201204' and '201205'
and reu='Z2' 

