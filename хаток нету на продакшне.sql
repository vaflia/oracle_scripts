

select distinct kul,nd,kw from oralv.c_kw@hp where reu='C5'
select distinct kul,nd,kw from oralv.c_kw where reu='C5'


select distinct reu,kodul, ndom, nkw
from ldo.l_nanimat@hp

select * from (
             select distinct n.reu,n.kodul,n.ndom,n.nkw,c.id
              from scott.kart@hp n, oralv.c_kw@hp c
             where n.reu=c.reu (+)
               and n.kodul=c.kul (+)
               and n.ndom=c.nd (+)
               and n.nkw=c.kw (+)
         ) where id is null order by reu,kodul,ndom,nkw ;
         
         select * from oralv.c_kw@hp where reu='C5' and kul='0006' and nd='000034'
         
select distinct reu,kul,nd,kw from (
             select distinct n.reu,n.kul,n.nd,n.kw,c.id
              from scott.kart@hp n, oralv.c_kw@hp c
             where n.reu=c.reu (+)
               and n.kul=c.kul (+)
               and n.nd=c.nd (+)
               and n.kw=c.kw (+)
         ) where id is null order by reu,kul,nd,kw ; 
         
         