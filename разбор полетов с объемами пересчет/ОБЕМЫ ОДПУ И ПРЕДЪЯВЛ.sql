select 
                 'РЭУ-'||ch.reu||' '||u.name||', д.'||ltrim(ch.nd,'0')|| ' Ввода № '||ml.cd as vvod_gw,
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
                
              --  coalesce(sum(case when par.cd='УСЛ_ОТОП' and doctp.cd='Итоговый реестр ОДПУ' then mv.vol1 end),0) as odpu_otopl_gkal,
ch.reu,ch.kul,ch.nd
        FROM oralv.u_meter m,
                 oralv.u_meter_log ml     
                 ,oralv.u_meter_vol mv
                 ,oralv.u_hfpar par
                 ,ORALV.U_LIST i
                 ,oralv.c_houses ch,
                 scott.params p,
                 scott.spul u,
                 scott.s_reu_trest s,
                 oralv.t_doc doc,
                 oralv.t_doc_tp doctp
        WHERE
                --doc.mg between '201301' and '201301' AND
                mv.dtf between '01.01.2013' and '31.01.2013' and
                ml.id = M.FK_METER_LOG  AND
                m.id = mv.fk_meter (+) AND
                par.id=ml.fk_hfpar AND
                i.id=ml.fk_unit1 AND 
                (par.cd='УСЛ_ГВ' or par.cd='УСЛ_ОТОП') 
                and ch.fk_k_lsk = ml.fk_klsk_obj and
                ch.kul=u.id  AND 
                s.reu=ch.reu
                and doc.id=mv.fk_doc
                and doc.fk_doctp=doctp.id
                and s.reu='73'
         --       and ch.reu='K2'
          --      and ch.kul='0118'
          --      and ch.nd='000020'
        GROUP BY   'РЭУ-'||ch.reu||' '||u.name||', д.'||ltrim(ch.nd,'0')|| ' Ввода № '||ml.cd, ch.reu,ch.kul,ch.nd,u.name||', д.'||ltrim(ch.nd,'0')
        order by u.name||', д.'||ltrim(ch.nd,'0')
        
        


        select  *from oralv.t_doc where id=203138
        oralv.t_org
        oralv.u_hfpar
        select * from oralv.u_meter_vol where summ2='17504,23' 
        id=8252688
        select * from oralv.u_meter where id=8252687
        select * from oralv.k_lsk where id=1044003
        select * from oralv.u_meter_log where id=8252686
        
        select * from oralv.u_meter where id=8252687
        select * from oralv.u_meter_log where id=8252686
        select * from oralv.t_doc where id in (202977,203138)
        oralv.t_doc_tp
        select * from oralv.u_meter where id=8254275
        select * from oralv.u_meter_log where id=8254274
        oralv.c_houses
        
 fk_doc  vol2 summ1 summ2     
202967    0            0           0
203138    16,789    0    17504,23
202977    16,789    0    17504,23
201867    3    2    4
202978    3    2    4
201867    3    2    4

select * from oralv.t_doc where fk_doctp=9