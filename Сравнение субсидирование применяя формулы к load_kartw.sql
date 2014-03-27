
/*--------------------------------------*/
select sum (hw_nor), sum (hw_sv_n), sum(gw_nor) , sum (gw_sv_n)   from
(      select krt.lsk,  n.usl,
         case when usl='015' then 
                    decode 
                    (krt.psch,9,null,krt.gw_nor ) 
                end as gw_nor,
             case when usl='016' then 
              (case
                when psch=9 then null 
                when (krt.psch=1 or krt.psch=3) then 
                    case when abs(krt.mgw)>abs(krt.gw_nor) 
                             then krt.mgw-krt.gw_nor
                             else 0 end
                         when spt.tgw <> 0 and krt.mgw <> 0 and krt.mgw*(krt.kpr-krt.kpr_ot) = 0 then krt.mgw
                else null
                end)  
             else null
             end as gw_sv_n,
               case when usl='011' then   
                decode (krt.psch,9,null, krt.hw_nor)
               end hw_nor,
             case when usl='012' then 
               (case
                  when psch=9 then null 
                  when (krt.psch=1 or krt.psch=2) then 
                        case when abs(krt.mhw)>abs(krt.hw_nor) 
                                 then krt.mhw-krt.hw_nor
                                 else 0 end  
                --  when (spt.twod<>0) and (abs(mhw)*(kpr-kpr_ot)>abs(hw_nor)) then mhw*(kpr-kpr_ot)-hw_nor
                 when spt.twod <> 0 and krt.mhw <> 0 and krt.mhw*(krt.kpr-krt.kpr_ot) = 0 then krt.mhw                
                  else null
                end)  
               end as hw_sv_n
             from scott.prepload_kartw krt, prep.sptar spt, prep.nabor n, sprorg o
            where krt.gt=spt.gtr
              and krt.nabor_id=n.id
              and n.usl in ('011','012','015','016') and n.org=o.kod
 )    
 UNION ALL
 select sum(case when usl='011' then volume end), 
        sum(case when usl='012' then volume end),
        sum(case when usl='015' then volume end), 
        sum(case when usl='016' then volume end)
 from scott.info_usl_lsk where mg='201301' 
 and usl in ('011','012','015','016')
 UNION ALL
 select sum (hw_nor), sum (hw_sv_n), sum(gw_nor) , sum (gw_sv_n)   from
(      select krt.lsk,  n.usl,
         case when usl='015' then 
                    decode 
                    ( 
                       krt.psch,9,null,
                       case 
                             when spt.tgw<>0  then krt.gw_nor
                             when spt.tgw=0 and krt.mgw<>0 and (krt.psch=1 or krt.psch=3) then krt.mgw 
                       else null
                       end
                    )
                end as gw_nor,
             case when usl='016' then 
              (case
                  when psch=9 then null 
                  when (krt.psch=1 or krt.psch=3) then 
                        case when abs(krt.mgw)>abs(krt.gw_nor) and spt.tgw<>0 --доб-но spt.tgw 15072013 и проверено
                                 then krt.mgw-krt.gw_nor
                                 else 0 end 
                  when (spt.tgw<>0) and (abs(mgw)*(kpr-kpr_ot)>abs(gw_nor)) then mgw*(kpr-kpr_ot)-gw_nor
                  when spt.tgw <> 0 and krt.mgw <> 0 and krt.mgw*(krt.kpr-krt.kpr_ot) = 0 then krt.mgw     
                  else null
                end  )  
             else null
             end as gw_sv_n,
               case when usl='011' then   
                decode 
                    ( 
                       krt.psch,9,null,
                       case 
                             when spt.twod<>0 then krt.hw_nor
                             when spt.twod=0 and krt.mhw<>0 and (krt.psch=1 or krt.psch=2) then krt.mhw
                       else null
                       end
                    )
               end hw_nor,
             case when usl='012' then 
               (case
                  when psch=9 then null 
                  when (krt.psch=1 or krt.psch=2) then 
                        case when abs(krt.mhw)>abs(krt.hw_nor) and spt.twod<>0 --доб-но spt.twod 15072013 и проверено
                                 then krt.mhw-krt.hw_nor
                                 else 0 end 
                  when (spt.twod<>0) and (abs(mhw)*(kpr-kpr_ot)>abs(hw_nor)) then mhw*(kpr-kpr_ot)-hw_nor
                  when spt.twod <> 0 and krt.mhw <> 0 and krt.mhw*(krt.kpr-krt.kpr_ot) = 0 then krt.mhw     
                  else null
                end  )  
               end as hw_sv_n
             from scott.prepload_kartw krt, prep.sptar spt, prep.nabor n, sprorg o
            where krt.gt=spt.gtr
              and krt.nabor_id=n.id
              and n.usl in ('011','012','015','016') and n.org=o.kod
 )    
 
 
 select lsk, sum(krt.mhw) ,sum(hw_nor)
 from scott.prepload_kartw krt, prep.sptar spt
 where krt.mhw*(krt.kpr-krt.kpr_ot)=0 and krt.mhw<>0 and spt.twod<>0
   and krt.gt=spt.gtr
   and krt.psch not in (1,2)
   group by lsk
   
   select gw_nor,hw_nor from scott.prepload_kartw where lsk in ('66184329','04086722')
   select gw_nor,hw_nor from scott.load_kartr where lsk in ('66184329','04086722')
   
   select * from scott.prepload_kartw where lsk='66184329'
   
   select * from scott.t_volume_usl_izm where lsk='04086722' and 
   
   