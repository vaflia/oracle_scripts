          SELECT
                    ml.id,ch.reu,ch.kul,ch.nd,ml.cd,
                     /*предъявлено*/
                    --1- Гкал из сф по ОТОПЛЕНИЮ
                    --2- рубли из сф по Гкал по ОТОПЛЕНИЮ
                    coalesce(sum(case when par.cd='УСЛ_ОТОП' and doctp.cd='Счет-фактура' then mv.vol2 end),0) as sf_gkal_otopl,
                    coalesce(sum(case when par.cd='УСЛ_ОТОП' and doctp.cd='Счет-фактура' then mv.summ2 end),0) as sf_summ_gkal_otopl,                
                     /*предъявлено*/
                    --1- Гкал из сф по ГВ
                    --2- рубли из сф по Гкал по ГВ
                    --3- кубов из сф по ГВ
                    --4- рубли из сф по метрам куб по ГВ
                    coalesce(sum(case when par.cd='УСЛ_ГВ' and doctp.cd='Счет-фактура' then mv.vol2 end),0) as sf_gkal_gv,
                    coalesce(sum(case when par.cd='УСЛ_ГВ' and doctp.cd='Счет-фактура' then mv.summ2 end),0) as sf_summ_gkal_gv,
                    coalesce(sum(case when par.cd='УСЛ_ГВ' and doctp.cd='Счет-фактура' then mv.vol1 end),0) as sf_metr_gv,
                    coalesce(sum(case when par.cd='УСЛ_ГВ' and doctp.cd='Счет-фактура' then mv.summ1 end),0) as sf_summ_metr_gv,
                    /*ВНЕСЕНО ПО ОДПУ*/
                    --1- Гкал   по ОТОПЛЕНИЮ
                    --2- Гкал   по ГВ             
                    --3- кубы  по ГВ
                    coalesce(sum(case when par.cd='УСЛ_ОТОП' and doctp.cd='Итоговый реестр ОДПУ' then mv.vol2 end),0) as odpu_otopl_gkal,
                    coalesce(sum(case when par.cd='УСЛ_ГВ' and doctp.cd='Итоговый реестр ОДПУ' then mv.vol2 end),0) as odpu_gv_gkal,
                    coalesce(sum(case when par.cd='УСЛ_ГВ' and doctp.cd='Итоговый реестр ОДПУ' then mv.vol1 end),0) as odpu_gv_metr,
                    /*V потребления тепловой энергии*/
                    coalesce(sum(case when par.cd='УСЛ_ОТОП' and doctp.cd='Итоговый реестр ОДПУ' then mv.vol3 end),0) as vol_te
            FROM oralv.u_meter m,
                     oralv.u_meter_log ml     
                     ,oralv.u_meter_vol mv
                     ,oralv.u_hfpar par
               --      ,ORALV.U_LIST i
                     ,oralv.c_houses ch,
                     scott.spul sp,
                     scott.s_reu_trest s,
                     oralv.t_doc doc,
                     oralv.t_doc_tp doctp
            WHERE
                    doc.mg between '201302' and '201302' AND
                    ml.id = M.FK_METER_LOG  AND
                    m.id = mv.fk_meter (+) AND
                    par.id=ml.fk_hfpar AND
                 --   i.id=ml.fk_unit1 AND 
                    (par.cd='УСЛ_ГВ' or par.cd='УСЛ_ОТОП') 
                    and ch.fk_k_lsk = ml.fk_klsk_obj and
                    ch.kul=sp.id  AND 
                    s.reu=ch.reu
                    and doc.id=mv.fk_doc
                    and doc.fk_doctp=doctp.id
            --        and s.trest='65'
            GROUP BY  ml.id,ch.reu,ch.kul,ch.nd,ml.cd
            
select * from oralv.u_meter_vol where fk_meter=8252140
order by dt1

/*глянуть. стоит две записи по 0.24 в meter_vol.*/
select * from oralv.u_meter_vol where fk_meter=8254584
select * 
from ldo.LOAD_GW t 
where kul='0094' and nd='000081' and t.tip=4
/*+ глянуть. предварительно - в dom_vvod уже два ввода, 
       у нас в meter_log ввод один, 
       хотя в meter_vol объема две записи по 0.24.*/
select * from oralv.u_meter_vol where fk_meter=8254088
select * 
from ldo.LOAD_GW t 
where kul='0061' and nd='000007' and t.tip=4

select * from oralv.c_houses
where kul='0061' and nd='000007' and reu='L2'

select * from scott.kart 
where kul='0094' and nd='000081'