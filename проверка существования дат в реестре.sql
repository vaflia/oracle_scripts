select t.*, t.rowid from ldo.l_list_reg t where id=610433
select t.*, t.rowid from ldo.l_regxpar t where t.fk_list_reg=610433
select t.*, t.rowid from ldo.l_regxpar t where t.id=60158
select t.*,t.rowid from ldo.l_regxparlst t where t.fk_regxpar=60157
select t.*,t.rowid from ldo.l_regxparlst t where t.fk_regxpar=60158


ldo.l_par
--проверка существования дат в реестре (конкретном, без учета l_pay).
SELECT lrg.* FROM ldo.l_list_reg lr, ldo.l_regxpar lrp, ldo.l_regxparlst lrg
WHERE lr.id=592612
and lrp.fk_list_reg=lr.id
and lrp.id=lrg.fk_regxpar

select * from prep.log_parser order by id desc  
scott.period_reports
scott.params
scott.v_params
