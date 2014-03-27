select case
            when o3.cd = 'Создать' and nvl(d.dt3, sysdate) >= sysdate then
             0
            when o3.cd = 'Создать' and nvl(d.dt3, sysdate) < sysdate then
             1
            when o3.cd = 'Выполнить' then
             2
            when o3.cd = 'Создать смету' then
             3
            when o3.cd = 'Закрыть' then
             4
            else
             -1
          end as ord, d.rowid, d.lsk, d.id, d.name, o1.name as user_fio,
    decode(atp.cd, 'ЛС', s.name || ', д.' || ltrim(k.nd, '0') || ', кв.' || ltrim(k.kw, '0'),
     'Дом', s1.name || ', д.' || ltrim(h.nd, '0')) as adr,

       d.dt1, d.dt3, d.dt4, decode(d.s1, null, '', d.s1|| ' (т. '||k.tel||')' ) as s1, d.s2, d.s3, d.fk_doctp, d.fk_k_lsk,
       d.fk_cat, d.fk_time, d.fk_log, d.fk_org, d.fk_result, d.fault || ' (' || log.nm || ') ' as fault,
       d.place, d.reu, d.kul, d.nd, d.kw, d.trest, d.fk_ext1 as ext, d.ext1_count as count,
       case
         when o3.cd = 'Создать' and nvl(d.dt3, sysdate) >= sysdate then
          1
         when o3.cd = 'Создать' and nvl(d.dt3, sysdate) < sysdate then
          2
         when o3.cd = 'Создать смету' then
          5
         when o3.cd = 'Выполнить' then
          3
         when o3.cd = 'Закрыть' then
          4
         else
          -1
       end as act_cd, p1.act_cd2 as path_seq, o3.cd as doc_state, 
       log.nm as log_nm, d.parent_id d_parent_id, log.cd as log_cd, tp.cd tp_cd
     , d.uch, d.sm_n, d.dt2, d.mg
  from oralv.t_doc d, 
oralv.t_doc_tp tp, 
     oralv.u_list log, 

oralv.kart k, oralv.c_houses h, oralv.k_lsk k1, oralv.t_addr_tp atp, oralv.spul s, oralv.spul s1,
       oralv.v_cu_acc_doc_tp v, 
       oralv.t_doct_path p, 
        --путь документа, следующее ожидаемое действие над ним данной ролью
       (select max(x.id) as id, x.fk_doc   from oralv.t_docxa x, oralv.t_act a   
        where x.fk_act = a.id --кто создал документ
                  and a.cd = 'Создать'
        group by x.fk_doc) o,
       (select max(x.id) as id, x.fk_doc
           from oralv.t_docxa x
          group by x.fk_doc) o2,
        --последнее выполненное действие по документу
       (select x.id, u.name
           from oralv.t_docxa x, oralv.t_user u
          where x.fk_user = u.id    and   ((:var7 = 1 and u.id = :fk_user )   or  :var7 = 0)  ) o1,
        --кто создал документ
       (select x.id, x.fk_act, u.cd
           from oralv.t_docxa x, oralv.t_act u
          where x.fk_act = u.id) o3, --последнее выполненное действие по документу
       (select a.fk_doctp, a.nstep, c.cd as act_cd, v.act_cd as act_cd2
           from oralv.t_doct_path a, oralv.v_cu_acc_doc_tp v, oralv.t_act c
          where a.fk_org = :org_
            and a.fk_act = c.id
            and a.fk_org = v.fk_org(+)
            and a.fk_doctp = v.fk_doctp(+)
            and a.fk_act = v.fk_act(+)) p1
 where k1.id=k.k_lsk_id(+) and k1.id=h.fk_k_lsk(+)
  and k1.fk_addrtp=atp.id(+) 
   and d.fk_doctp = tp.id

   and tp.id = v.fk_doctp

   and p.fk_doctp = d.fk_doctp
   and p.fk_act = o3.fk_act
   and p.fk_org = :org_
      
   and p1.fk_doctp(+) = p.fk_doctp
   and p1.nstep(+) = p.nstep + 1
      
   and v.fk_org = :org_
   and v.act_cd = 'Открыть'
   and d.fk_k_lsk = k1.id(+)
   and k.kul = s.id(+)
   and h.kul = s1.id(+)
   and (tp.cd = 'Заявка' or tp.cd = 'Плановая работа'    or tp.cd = 'Типовая работа' or tp.cd='Счет-фактура')
   and d.id = o.fk_doc
   and d.id = o2.fk_doc
   and o.id = o1.id
   and o2.id = o3.id
   and ((:var = 1 and d.kul = :kul) or
       (:var = 2 and d.kul = :kul and d.nd = :nd) or
       (:var = 3 and d.kul = :kul and d.nd = :nd and d.kw = :kw) or
       (:var = 4 and d.kul = :kul and d.nd = :nd and  ((d.kw >= :kw_1) AND (d.kw <= :kw_2))) or
       (:var = 5 and d.lsk = :lsk) or
       (:var = 0))
   and  (  (:var2 = 1   and  trunc(d.dt1) between  trunc(:dt1)  AND  trunc(:dt2) )
              or  :var2 = 0)
   and  (  (:var31 = 1   and  trunc(d.dt3) between  trunc(:dt3)  AND  trunc(:dt31) )
              or  :var31 = 0)
   and  (  (:var3 = 1  and  EXISTS ( SELECT 1 FROM oralv.u_list l  WHERE l.fk_listtp = 1 AND l.id=d.fk_log  CONNECT BY l.parent_id = PRIOR l.id START WITH l.id = :fk_log ))
              OR  :var3 = 0)
   and  (  (:var41 = 1 and  EXISTS  (select 1  FROM oralv.t_doc_tp l  WHERE  l.id=d.fk_doctp  CONNECT BY l.parent_id = PRIOR l.id  START WITH l.id=:FK_DOCTP))
              OR  :var41 = 0)
   and  (  (:var5 = 1 and  (   ( trunc(d.dt4) between trunc(:dt4) and trunc(:dt5)  )   OR   ( (:var6) = 'НЕТ' and  (d.dt4 is null)    )   )  )
              or  :var5 = 0)
    and ((:reu = '00') or ((:reu <>'00') and (d.reu = :reu)))
   AND ((:uch = 0) or ((:uch <> 0) and (d.uch = :uch)))
   and ((:trest = '00') or ((:trest <>'00') and (d.trest = :trest))) 
   AND d.fk_log = log.id AND log.fk_listtp = 1
  AND (  (:res <> '0'  AND EXISTS (   (SELECT 1 FROM oralv.u_docxtmpl zt, oralv.u_docxop zo, oralv.u_docopxres zx, oralv.u_res zr
                                                            WHERE zt.id=zo.fk_docxtmpl AND zo.id=zx.fk_docxop AND zr.id=zx.fk_res  
                                                                        AND  (Upper(zr.name) LIKE '%'|| Upper(:res) ||'%'    OR  Upper(zr.cd)=Upper(:res))
                                                                       AND zt.fk_doc=d.id  )))
            OR :res = '0' )
  AND (  (:V_FKWRKR=1  AND   EXISTS (   (SELECT 1 FROM oralv.u_docxtmpl yt, oralv.u_docxop yo, oralv.u_docopxres yx
                                                                     WHERE yt.id=yo.fk_docxtmpl AND yo.id=yx.fk_docxop AND yx.fk_wrkr= :FK_WRKR
                                                                                  AND yt.fk_doc=d.id    ) ) )
            OR :V_FKWRKR = 0 )
  AND (  (:note <> '0' AND Instr(Upper(d.s3), Upper(:note)) > 0 )  OR :note='0'  )

     AND D.REU IN ('23') order by ord, dt3
