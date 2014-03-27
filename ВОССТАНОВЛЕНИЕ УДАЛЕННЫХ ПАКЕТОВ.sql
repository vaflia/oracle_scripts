select * 
from dba_source as of timestamp(sysdate -1/24) -- на час назад
where name='L_LOADREG';



