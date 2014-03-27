--олап       
       select t.lsk as lsk,
                u.usl,
              sum(t.volume) vl
       FROM prep.info_usl_lsk t,            scott.s_reu_trest r,            scott.usl u,            scott.sprorg o,            scott.spul ul
       where t.reu=r.reu
       and t.usl=u.usl         and t.org=o.kod         and t.kul=ul.id         and t.reu='73'         and mg='201210'         and u.usl in ('015','016','059','060','017','018')
      --  and t.kul='0067'
      --  and t.nd='000018'
   --  and  lsk='10143404' 
       group by  t.lsk,
            u.usl
       having sum(t.charges)<>0 or sum(t.changes) <>0 or
              sum(t.privs) <>0 or sum(t.volume)<>0
              or sum(t.payment)<>0 or sum(t.opl)<>0 or sum(t.kpr)<>0
       order by t.lsk,
                u.usl 



       select * from scott.kart where lsk='10143404'
       select * from scott.load_kwni where lsk='07181687'
       select * from prep.load_kartw where lsk='07181570'
       

       scott.usl
       select * from prep.t_volume_usl where lsk='07181570'
       scott.sptar
       select  * from scott.nabor where id=1576930
       
       SELECT 
       CASE
          WHEN (krt.psch=1 or krt.psch=3) then 
                CASE when abs(krt.mgw)>abs(krt.gw_nor) 
                                                          then krt.mgw-krt.gw_nor
                ELSE 0 end 
       END
       from prep.load_kartw krt
       where  lsk='07181570'