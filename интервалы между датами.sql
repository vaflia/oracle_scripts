select 
EXTRACT(minute FROM (to_date('201307021545','YYYYMMDDHH24MI')  -
to_date('201307021555','YYYYMMDDHH24MI')) day to second) as sdd
from dual

select * from prep.usl where usl='059'