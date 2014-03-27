      select t.reu,
             s.trest,
             t.kul,
             t.nd,
             t.status,
             t.org,
             t.uslm,
             t.uch, 
             sum(a.summa) indebet,
             sum(b.summa) inkredit,
             sum(nvl(e.summa, 0) + nvl(f.summa, 0)) charges,
             sum(f.summa) changes,
             sum(g.summa) subsid,
             sum(o.summa) privs,
             sum(o1.summa) privs_city,
             sum(h.summa) payment,
             sum(j.summa) pn,
             sum(k.summa) outdebet,
             sum(l.summa) outkredit,
             mg_ as mg
        from scott.t_reu_kul_nd_status t,
             scott.s_reu_trest s,
            (select /*+ ORDERED */
            t.lsk, k.reu,  s.trest, k.kul,  k.nd,  st.id_status_gr as status,
            t.org,  t.uslm,  sum(summa) as summa
            FROM scott.saldo t, scott.kart k, scott.sprorg u, scott.s_reu_trest s, scott.status st
            WHERE summa >= 0
                 and t.mg = '201208'
                 and t.org = u.kod
                 and u.type in (0, 1)
                 and k.lsk = t.lsk
                 and k.reu = s.reu
                 and k.status=st.id
                 and s.trest='26'
                 and u.kod='015'
               group by t.lsk, k.reu, s.trest, k.kul, k.nd, st.id_status_gr,
                        t.org, t.uslm) a,
             (select /*+ ORDERED */
               k.reu,
               s.trest,
               k.kul,
               k.nd,
               st.id_status_gr as status,
               t.org,
               t.uslm,
               sum(summa) as summa
                from scott.saldo t, scott.kart k, scott.sprorg u, scott.s_reu_trest s, scott.status st
               where summa < 0
                 and mg = mg_
                 and t.org = u.kod
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
                        t.uslm) b,
             (select /*+ ORDERED */
               k.reu,
               s.trest,
               k.kul,
               k.nd,
               st.id_status_gr as status,
               t.org,
               t.uslm,
               sum(summa) as summa
                from scott.saldo t, scott.kart k, scott.sprorg u, scott.s_reu_trest s, scott.status st
               where summa >= 0
                 and mg = mg1_
                 and t.org = u.kod
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
                        t.uslm) k,
             (select /*+ ORDERED */
               k.reu,
               s.trest,
               k.kul,
               k.nd,
               st.id_status_gr as status,
               t.org,
               t.uslm,
               sum(summa) as summa
                from scott.saldo t, scott.kart k, scott.sprorg u, scott.s_reu_trest s, scott.status st
               where summa < 0
                 and mg = mg1_
                 and t.org = u.kod
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
                        t.uslm) l,
             (select /*+ ORDERED */
               k.reu,
               s.trest,
               k.kul,
               k.nd,
               st.id_status_gr as status,
               t.org,
               t.uslm,
               sum(summa) as summa
                from scott.t_charges_for_saldo t, scott.kart k, scott.sprorg u, scott.s_reu_trest s, scott.status st
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
                        t.uslm) e,
             (select /*+ ORDERED */
               k.reu,
               s.trest,
               k.kul,
               k.nd,
               st.id_status_gr as status,
               t.org,
               t.uslm,
               sum(summa) as summa
                from scott.t_privs_for_saldo t, scott.kart k, scott.sprorg u, scott.s_reu_trest s, scott.status st
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
                        t.uslm) o,
          (SELECT /*+ ORDERED */
               k.reu,
               s.trest,
               k.kul,
               k.nd,
               st.id_status_gr AS STATUS,
               t.ORG,
               t.USLM,
               SUM(summa) AS summa
                FROM scott.T_PRIVS_FOR_SALDO t, scott.KART k, scott.SPRORG u, scott.S_REU_TREST s, scott.status st
               WHERE t.ORG = u.kod
                 AND u.TYPE IN (0, 1)
                 AND k.lsk = t.lsk
                 and k.status=st.id
                 AND k.reu = s.reu and t.id_region in (3) --городские льготы в т.ч.
               GROUP BY k.reu,
                        s.trest,
                        k.kul,
                        k.nd,
                        st.id_status_gr,
                        t.ORG,
                        t.USLM) o1,
             (select /*+ ORDERED */
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
                        t.uslm) f,
             (select /*+ ORDERED */
               k.reu,
               s.trest,
               k.kul,
               k.nd,
               st.id_status_gr as status,
               t.org,
               t.uslm,
               sum(summa) as summa
                from scott.kart k, scott.t_subsidii_for_saldo t, scott.sprorg u, scott.s_reu_trest s, scott.status st
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
                        t.uslm) g,
             (select /*+ ORDERED */
               k.reu,
               s.trest,
               k.kul,
               k.nd,
               st.id_status_gr as status,
               t.org,
               t.uslm,
               sum(summa) as summa
                from scott.kart k, scott.t_payment_for_saldo t, scott.sprorg u, scott.s_reu_trest s, scott.status st
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
                        t.uslm) h,
             (select /*+ ORDERED */
               k.reu,
               s.trest,
               k.kul,
               k.nd,
               st.id_status_gr as status,
               t.org,
               t.uslm,
               sum(summa) as summa
                from scott.kart k, scott.t_penya_for_saldo t, scott.sprorg u, scott.s_reu_trest s, scott.status st
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
                        t.uslm) j
       where t.reu = s.reu
         and t.reu = a.reu(+)
         and t.kul = a.kul(+)
         and t.nd = a.nd(+)
         and t.status = a.status(+)
         and t.org = a.org(+)
         and t.uslm = a.uslm(+)

         and t.reu = b.reu(+)
         and t.kul = b.kul(+)
         and t.nd = b.nd(+)
         and t.status = b.status(+)
         and t.org = b.org(+)
         and t.uslm = b.uslm(+)

         and t.reu = k.reu(+)
         and t.kul = k.kul(+)
         and t.nd = k.nd(+)
         and t.status = k.status(+)
         and t.org = k.org(+)
         and t.uslm = k.uslm(+)

         and t.reu = l.reu(+)
         and t.kul = l.kul(+)
         and t.nd = l.nd(+)
         and t.status = l.status(+)
         and t.org = l.org(+)
         and t.uslm = l.uslm(+)

         and t.reu = e.reu(+)
         and t.kul = e.kul(+)
         and t.nd = e.nd(+)
         and t.status = e.status(+)
         and t.org = e.org(+)
         and t.uslm = e.uslm(+)

         and t.reu = o.reu(+)
         and t.kul = o.kul(+)
         and t.nd = o.nd(+)
         and t.status = o.status(+)
         and t.org = o.org(+)
         and t.uslm = o.uslm(+)

         and t.reu = o1.reu(+)
         and t.kul = o1.kul(+)
         and t.nd = o1.nd(+)
         and t.status = o1.status(+)
         and t.org = o1.org(+)
         and t.uslm = o1.uslm(+)

         and t.reu = f.reu(+)
         and t.kul = f.kul(+)
         and t.nd = f.nd(+)
         and t.status = f.status(+)
         and t.org = f.org(+)
         and t.uslm = f.uslm(+)

         and t.reu = g.reu(+)
         and t.kul = g.kul(+)
         and t.nd = g.nd(+)
         and t.status = g.status(+)
         and t.org = g.org(+)
         and t.uslm = g.uslm(+)

         and t.reu = h.reu(+)
         and t.kul = h.kul(+)
         and t.nd = h.nd(+)
         and t.status = h.status(+)
         and t.org = h.org(+)
         and t.uslm = h.uslm(+)

         and t.reu = j.reu(+)
         and t.kul = j.kul(+)
         and t.nd = j.nd(+)
         and t.status = j.status(+)
         and t.org = j.org(+)
         and t.uslm = j.uslm(+)

       group by t.reu, s.trest, t.kul, t.nd, t.status, t.org, t.uslm, t.uch;