--начисление
 drop table prep.nabor201402
   create table prep.nabor201403 as select * from scott.nabor
 drop table prep.load_kwni201403
   create table prep.load_kwni201403 as select * from scott.load_kwni
 drop table prep.load_kartw201403
   create table prep.load_kartw201403 as select * from scott.load_kartw
--справочники
 drop table prep.sptar201403
   create table prep.sptar201403 as select * from scott.sptar
 drop table prep.sprorg201403
   create table prep.sprorg201403 as select * from scott.sprorg
 drop table prep.s_stra201403
   create table prep.s_stra201403 as select * from scott.s_stra
--сальдовые  
 drop table prep.t_charges_usl201403
   create table prep.t_charges_usl201403 as select * from scott.t_charges_usl
 drop table prep.t_changes_usl201403
   create table prep.t_changes_usl201403 as select * from scott.t_changes_usl
 drop table prep.t_payment_usl201403
   create table prep.t_payment_usl201403 as select * from scott.t_payment_usl
 drop table prep.t_privs_usl201403      
   create table prep.t_privs_usl201403 as select * from scott.t_privs_usl
 drop table prep.load_koop201403      
   create table prep.load_koop201403 as select * from scott.load_koop
 drop table prep.koop201403      
   create table prep.koop201403 as select * from scott.koop   
 drop table prep.kart201403      
   create table prep.kart201403 as select * from scott.kart  
--общедомовые счетчики   
 drop table prep.load_gw201403      
   create table prep.load_gw201403 as select * from ldo.load_gw   

   

      begin
            core_gen.gen.gen_prep_opl2( null, null,0);
      end;   
      008	059	1	GW        	NDOPGW_   	NDOPGW_ 	IDOPGW  	NDOPGW  	PSDOPGW 		GW      	PDOPGW_ 	PDOPGW_ 					куб.м	Горячая вода ОДН      	Горячая вода          	case when krt.dop_gw = 0 and nvl(g.gw_dop,0) = 0 then
  null
 else
 nvl(krt.dop_gw,0)+nvl(g.gw_dop,0)
end   
/*decode(krt.dop_gw,0,null,krt.dop_gw)+nvl(g.gw_dop,0)*/   	decode(krt.psch,1,1,3,1,0,0,2,0,null)		0				008			0		0	0	0	0			decode
(krt.psch,9,null,
     case when krt.dop_gw=0 then 0 
       else krt.dop_gw 
     end
) 
/*decode(krt.dop_gw,0,0,krt.dop_gw)*/	1		coalesce(ki.gw_dop,0)	0	case when krt.dop_gw = 0 and nvl(g.gw_dop,0) = 0 then
  null
 else
 nvl(krt.dop_gw,0)+nvl(g.gw_dop,0)
end   


select * from scott.usl
      delete from scott.load_koopxpar
      
       update scott.load_kartw k set k.nabor_id = (select t.nabor_id from scott.kart t where t.lsk = k.lsk);