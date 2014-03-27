select /*+ ORDERED */
               k.reu,
               s.trest,
               k.kul,
               k.nd,
               st.id_status_gr as status,
               t.org,
               t.uslm,
               sum(summa) as summa
                from scott.kart k, scott.t_changes_for_saldo t, scott.sprorg u, scott.s_reu_trest s, scott.status st
               where t.org = u.kod
                 and u.type in (0, 1)
                 and k.lsk = t.lsk
                 and k.reu = s.reu
                 and k.status=st.id
               group by k.reu,
                        s.trest,
                        k.kul,
                        k.nd,
                        st.id_status_gr,
                        t.org,
                        t.uslm
                        
                        
select /*+ ORDERED */
   k.reu,   s.trest,   k.kul,   k.nd,   st.id_status_gr as status, t.org, t.uslm,
   sum(summa) as summa
    from scott.t_charges_for_saldo t, scott.kart k, scott.sprorg u, scott.s_reu_trest s, scott.status st
   where t.org = u.kod
     and u.type in (0, 1)
     and k.lsk = t.lsk
     and k.reu = s.reu
     and k.status=st.id
   group by k.reu, s.trest, k.kul, k.nd, st.id_status_gr, t.org, t.uslm
   
   charges
   scott.usl
   select * from scott.charges where mg='201209' and usl='039'
   
   select  k.*
   from scott.load_kartr k,scott.s_stra s 
   where substr(lsk,1,4) = s.nreu and s.trest='25'
   
   select * from scott.v_charges_usl where usl='039'
   select * from scott.charges where usl='039'


select * from scott.changes where mg='201109' 

select * from t_corrects_payments where mg='201109'
and usl='039' and org='79'
corr_doc