select * 
from dba_source as of timestamp(sysdate -1/24) -- �� ��� �����
where name='L_LOADREG';



