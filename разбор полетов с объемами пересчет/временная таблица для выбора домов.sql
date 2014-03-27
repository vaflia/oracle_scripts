    --Временная таблица для выбора домов
  begin
    if clr_ = 1 then
      delete from list_choices;
      insert into prep.list_choices t
        (reu, kul, nd, uch, sel, state)
        select distinct h.reu, h.kul, h.nd, k.uch, 1, case when p.period between
         k.dat and k.dat1 then 0 else 1 end as state
          from houses h, koop_uch k, v_permissions_reu s, params p
         where h.reu = s.reu
           and h.reu = k.reu
           and h.kul = k.kul
           and h.nd = k.nd;
    end if;

  end;