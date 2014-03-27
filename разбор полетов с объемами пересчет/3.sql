SELECT  k.lsk, sum(k.HW), sum(k.GW), sum(k.KWT_DOP) ,  sum(k.HW_DOP), sum(k.GW_DOP)
FROM    scott.load_kwni k, scott.s_stra s
WHERE    s.trest='07'
     and  substr(k.lsk,1,4)=s.nreu
GROUP BY k.LSK

select s.trest, sum(NGW_)  
from load_kartw k, scott.s_stra s
where substr(k.lsk,1,4)=s.nreu
and s.trest='07'
GROUP BY s.trest

select sum(summa),sum(kpr),sum(opl),sum(dop_opl),sum(dop_kpr),sum(dop_vol) 
from
scott.t_volume_usl k, scott.s_stra s
where substr(k.lsk,1,4)=s.nreu
and s.trest='07'



SELECT t.*,   case when  sum( 
  decode(t.usl,'015', decode(t.psch,0,nvl(t.volume,0),0),'016', decode(t.psch,0,nvl(t.volume,0),0),0)
     ) > = sum( 
 decode(t.usl,'016', decode(t.psch,0,nvl(t.dop_vol,0),0),'017', decode(t.psch,0,nvl(t.dop_vol,0),0),0)
   )  then   sum( 
  decode(t.usl,'015', decode(t.psch,0,nvl(t.volume,0),0),'016', decode(t.psch,0,nvl(t.volume,0),0),0)
     )   else  sum( 
 decode(t.usl,'016', decode(t.psch,0,nvl(t.dop_vol,0),0),'017', decode(t.psch,0,nvl(t.dop_vol,0),0),0)
   )   end vol_n
   
SELECT *  
FROM scott.t_volume_usl t
WHERE t.lsk='80084759'
and t.usl='015'
union all
SELECT *  
FROM scott.t_volume_usl t
WHERE t.lsk='80084760'
and t.usl='059'
union all
SELECT *  
FROM scott.t_volume_usl t
WHERE t.lsk='80084760'
and t.usl='059'
union all
SELECT *  
FROM scott.t_volume_usl t
WHERE t.lsk='80084760'
and t.usl='059'

scott.usl

select lsk, sum(igw),sum(gw),sum(GW_DOP)
from scott.load_kwni k, scott.s_stra s
where substr(k.lsk,1,4)=S.NREU
and s.trest='07'
where
group by lsk