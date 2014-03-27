select * from oralv.u_meter_vol t



select count (*) from oralv.u_meter
select count (*) from oralv.u_meter_log
select count (*) from oralv.u_meter_vol


select fk_meter_log from oralv.u_meter
group by fk_meter_log
having count(fk_meter_log)>1

oralv.c_houses


select --par.cd, i.name, --ml.*, mv.vol1
        reu,kul,nd,
        sum(case when par.cd='УСЛ_ГВ' and i.cd='м3' then mv.vol1 end) as metr_gv,
        sum(case when par.cd='УСЛ_ГВ' and i.cd='гигакалория'  then mv.vol1 end) as gkal_gv,
        sum(case when par.cd='УСЛ_ОТОП' and i.cd='м3' then mv.vol1 end) as metr_otopl,
        sum(case when par.cd='УСЛ_ОТОП' and i.cd='гигакалория' then mv.vol1 end) as gkal_otopl      
FROM oralv.u_meter m,
         prep.u_meter_log ml
         ,oralv.u_meter_vol mv
         ,oralv.u_hfpar par
         ,ORALV.U_LIST i
         ,oralv.c_houses ch
WHERE
      --  ML.ID=3070360 AND
        ml.id = M.FK_METER_LOG  AND
        m.id = mv.fk_meter (+) AND
        par.id=ml.fk_hfpar AND
        i.id=ml.fk_unit1 AND 
        (par.cd='УСЛ_ГВ' or par.cd='УСЛ_ОТОП') AND
        (i.cd='м3' or i.cd='гигакалория')
        and ch.fk_k_lsk = ml.fk_klsk_obj
GROUP BY reu, kul, nd
ORDER BY REU, KUL, nd
        



select sum (vol1)  from oralv.u_meter_vol mv
 
oralv.u_hfpar
oralv.u_list


create table prep.u_meter_log as select 
* from oralv.u_meter_log

insert into prep.u_meter_log select * from  
oralv.u_meter_log

update prep.u_meter_log set fk_hfpar=1702


scott.params