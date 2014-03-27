--вначале делаем изменения
declare
 mg_ params.period%type;
cursor r is 
select usl, f_ras_v, f_ras_izmvol_subsid, f_ras_izmgkal_subsid
from scott.usl u
where f_ras_v  is not null
    and usl in ('011','012','056')--,'015','016','007','059','056')
    order by usl;
begin
 update scott.load_kartw k set k.nabor_id = (select t.nabor_id from scott.kart t where t.lsk = k.lsk);
  select period into mg_  from scott.params;
    --select to_char(add_months(sysdate,-1),'yyyymm') into mg_ from dual;
  -- update scott..load_kartw k set k.nabor_id = (select t.nabor_id from kart t where t.lsk = k.lsk); 
 FOR REC IN R
  loop    
  delete from scott.t_volume_usl_izm where mg=mg_ and usl=rec.usl;
  execute immediate
  '
    INSERT INTO scott.t_volume_usl_izm (lsk, org, usl, vol, gkal, reu, kul, nd, vvod_gw, mg)
    SELECT ki.lsk,   
           CASE 
            WHEN :mg_ >= SUBSTR (o.dat3, 3, 4) || SUBSTR (o.dat3, 1, 2)
               THEN o.kod3
            WHEN :mg_ >= SUBSTR (o.dat2, 3, 4) || SUBSTR (o.dat2, 1, 2)
               THEN o.kod2
            WHEN :mg_ >= SUBSTR (o.dat, 3, 4) || SUBSTR (o.dat, 1, 2)
               THEN o.kod1
            ELSE o.kod
           END org,
               n.usl, ki.vol, ki.gkal, ki.reu, ki.kul, ki.nd, decode(u.uslm,''006'',ki.vvod,''008'', ki.vvod_gw,''004'', ki.vvod_ot, null), :mg_
    FROM  (
                  SELECT   ki.lsk, krt.nabor_id, krt.reu, krt.kul, krt.nd, krt.vvod, krt.vvod_gw, krt.vvod_ot,
                           sum(case when '||rec.f_ras_izmvol_subsid||'<>0 then '||rec.f_ras_izmvol_subsid||' else 0 end) as vol,
                           sum(case when '||rec.f_ras_izmgkal_subsid||'<>0 then '||rec.f_ras_izmgkal_subsid||' else 0 end) as gkal                       
                    FROM   (select lsk, gw, gw_dop, ot, ot_dop, hw, hw_dop from scott.load_kwni ki
                                where ki.gw<>0 or ki.gw_dop <>0 or ki.ot<>0 or ki.ot_dop <>0 or ki.hw<>0 or ki.hw_dop<>0
                                ) ki, 
                                scott.load_kartw krt, scott.sptar spt
                  WHERE  ki.lsk=krt.lsk and krt.gt=spt.gtr
                  GROUP BY  ki.lsk, krt.nabor_id, krt.reu, krt.kul, krt.nd, krt.vvod, krt.vvod_gw, krt.vvod_ot
                  HAVING sum(case when '||rec.f_ras_izmvol_subsid||'<>0 then '||rec.f_ras_izmvol_subsid||' else 0 end) <>0 or 
                           sum(case when '||rec.f_ras_izmgkal_subsid||'<>0 then '||rec.f_ras_izmgkal_subsid||' else 0 end) <>0 
              ) ki, 
       scott.nabor n, scott.sprorg o, scott.usl u 
    WHERE 
     ki.nabor_id=n.id
          and n.usl=:usl_ 
          and n.org=o.kod
          and u.usl=n.usl'  
    using mg_,mg_,mg_,mg_,rec.usl;
    commit;
     end loop;
end;



insert into scott.t_volume_usl_izm  
select * from scott.t_volume_usl_izm 
AS OF TIMESTAMP
TO_TIMESTAMP('24.01.2014 08:01:45','DD-MM-YY HH24: MI: SS')
where mg='201301'

delete  from scott.t_volume_usl_izm where mg='201301'

select * from scott.t_volume_usl_izm 
where mg='201305'  and usl='011'
usl
delete from scott.load_koopxpar

select lsk, gw, gw_dop, ot, ot_dop, hw, hw_dop from scott.load_kwni ki
                                where ki.gw<>0 or ki.gw_dop <>0 or ki.ot<>0 or ki.ot_dop <>0 or ki.hw<>0 or ki.hw_dop<>0
                                
                                select * from scott.nabor