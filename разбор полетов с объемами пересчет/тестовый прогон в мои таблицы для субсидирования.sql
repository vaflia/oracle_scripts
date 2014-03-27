begin
prep.gen_info;
end;

update prep.load_kartw k set k.nabor_id = (select t.nabor_id from scott.kart t where t.lsk = k.lsk);
truncate table prep.info_usl_lsk

    select krt.lsk,
           n.usl,spt.tgw,krt.mgw, krt.mgw*(krt.kpr-krt.kpr_ot),
           CASE 
            WHEN '201210' >= SUBSTR (o.dat3, 3, 4) || SUBSTR (o.dat3, 1, 2)
               THEN o.kod3
            WHEN '201210' >= SUBSTR (o.dat2, 3, 4) || SUBSTR (o.dat2, 1, 2)
               THEN o.kod2
            WHEN '201210' >= SUBSTR (o.dat, 3, 4) || SUBSTR (o.dat, 1, 2)
               THEN o.kod1
            ELSE o.kod
           END org,
           decode (krt.psch,9,null,
                        case
                    --        when
                            when (spt.tgw<>0) AND (krt.mgw<>0) AND  (spt.tgw*krt.mgw*(krt.kpr-krt.kpr_ot)=0)   then krt.mgw 
                            when (krt.psch=1 or krt.psch=3) or (spt.tgw<>0) or  (spt.tgw*krt.mgw*(krt.kpr-krt.kpr_ot)<>0)   then krt.gw_nor
                        else null
                        end) v,
           decode(0,0,kpr-kpr_ot,null) kpr,
           decode(0,0,opl,null) opl   
     from prep.load_kartw krt,
          SCOTT.sptar spt,
          SCOTT.nabor n,
          SCOTT.sprorg o
    where krt.gt=spt.gtr
      and krt.nabor_id=n.id
      and (n.usl='015' or n.usl='016')
      and n.org=o.kod
   --   and krt.nd='000018'
    --  and krt.kul='0067'
      and krt.reu='34'
      order by lsk
      
select * from scott.statistics_lsk where mg='201210' and lsk='10143404'
      

 