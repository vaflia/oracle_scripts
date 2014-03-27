select k.lsk, t.fk_serv, o.vol1, u.name
  from oralv.kart k, oralv.c_kw c, oralv.u_meter_log t, oralv.u_meter m, oralv.u_meter_vol o, oralv.u_list u
 where c.fk_k_lsk = t.fk_klsk_obj
   and k.reu = c.reu
   and k.nd = c.nd
   and k.kw = c.kw
   and k.lsk = '07234421'
   and t.id = m.fk_meter_log
   and m.id = o.fk_meter
   and o.fk_type=u.id
--   and u.cd='Фактический объем'
union all
select k.lsk, t.fk_serv, o.vol1, u.name
  from kart k, u_meter_log t, u_meter m, u_meter_vol o, u_list u
 where k.k_lsk_id = t.fk_klsk_obj
   and k.lsk = '07234421'
   and t.id = m.fk_meter_log
   and m.id = o.fk_meter
   and o.fk_type=u.id
--   and u.cd='Фактический объем'

select  *from scott.load_kart@hp where lsk='07234421'