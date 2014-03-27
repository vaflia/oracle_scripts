select * from scott.l_pay
ldo.l_par

select r.name, max(num_reg) from ldo.l_list_reg lr, ldo.l_reg r
where lr.fk_reg=r.id
group by r.name

ldo.l_reg

scott.kwtp

ldo.l_regxpar

update ldo.l_regxpar set n1=1
where  exists (
SELECT fk_reg 
  FROM ldo.l_regxpar rx,ldo.l_par p 
WHERE p.cd='USE_DAY_AS_NINK' 
          and p.id=rx.fk_par
          and n1=1
) 
and 
fk_par=24 --параметр отвечающий за номер загружаемого реестра (l_par.cd='NUM_REG'),id=24

update prep.p_contr_var set isexport=
where  exists (
SELECT fk_reg 
  FROM ldo.l_regxpar rx,ldo.l_par p 
WHERE p.cd='USE_DAY_AS_NINK' 
          and p.id=rx.fk_par
          and n1=1
) 
prep.log_parser

scott.p_contr_var

merge into prep.p_contr_var cv
using (select * from scott.p_contr_nabor where type=1) cn on (cv.contr_id=cn.contr_id and cv.org_id=cn.org_id and  cv.num_rep_ag=cn.num_rep_ag and cv.mg ='201210')
when matched then update set cv.isexport=cn.isexport

select * from prep.p_contr_var cv
where cv.contr_id=129 and cv.org_id=4 and  cv.num_rep_ag like '%19%' and cv.mg ='201210' 


insert into prep.p_contr_var select * from scott.P_contr_var where mg>'201205'

select * from prep.p_contr_var where mg='201210' and isexport=1

grant select , update , delete, insert on prep.p_contr_var to miha