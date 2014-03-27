select * from scott.load_koop
select * from scott.koop
select * from scott.nabor

select * from 
select distinct fk_koop from scott.koop

select distinct reu,kul,nd,usl from scott.koop

select * from prep.log_parser order by id desc

select table_name,constraint_name from sys.user_constraints t
    where (constraint_type='P' or constraint_type='U'  or constraint_type='C') 
    and table_name in (select tname from scott.tablelist where var=0) order by constraint_type desc
    
select table_name,constraint_name from sys.user_constraints t
where constraint_type='R' and table_name in (select tname from scott.tablelist where var  IN (0)) order by constraint_type desc
      --За период
select table_name,constraint_name from sys.user_constraints t
where constraint_type='R' and table_name in (select tname from scott.tablelist where var IN (0,1)) order by constraint_type desc



insert into scott.koop
(fk_koop, reu, kul, nd, org, usl, uch, dat, dat1, assen)
select t.id, t.reu, t.kul, t.nd, 'wod','011', t.uch, t.dat_nach, t.dat_end, t.assen
from scott.load_koop t
where t.dat_nach is not null and t.dat_end is not null

scott.usl

select t.id, t.reu, t.kul, t.nd, 'wod' as org,'011' as usl, t.uch, t.dat_nach, t.dat_end, t.assen
from scott.load_koop t
where reu is not null 
and kul is not null
and nd is not null
and uch is not null  

insert into prep.koop select * from scott.koop

select  * from scott.load_koop t
where reu is null 
and kul is null
and nd is null
and uch is null  


create table kill_kwtp_b1 tablespace test
as select * from kwtp_b



1) reu,  kul, nd, uch на нулл  
Можно проверить одним запросом и все, без констрэнта
2) usl is not null - явно не будет нуллом так как курсором, по которому 
идет парсер выбираются уже не нулл услуги.
3) составной индекс reu kul nd usl org dat dat1 -
будет тоже уникальным так как в load_koop 
уже проверяется reu kul nd dat dat1, scott.usl, 
а при парсинге не будет двух одинаковых домов
с одинаковыми услугами, так как дома уже в констрэнте
4) referential на usl конечно он будет. так как курсор сам по усл! и берутся эти же услуги
5) org <> 0 не отследишь, тока включением,
    referential на org тоже никак не уследишь..тока включать!


select * from prep.log_parser order by id desc

ldo.l_par
ldo.l_regxpar
ldo.l_reg

select rx.s1,o.name, r.name
FROM LDO.L_REGXPAR rx, ldo.l_reg r,scott.t_org o
where r.id=rx.fk_reg
and rx.fk_par=23
and o.id=fk_org
and s1 is not null

scott.l_pay
scott.a_flow

select lsk,oper,sum(summa),mg 
FROM scott.xxito15_lsk
WHERE dat='24.07.2012'
--and lsk='45157009'
GROUP BY lsk,oper,mg

select * from ldo.l_kwtp
where dtek='31.07.2012'
and lsk='24030725'

select * from scott.l_pay
where lsk=24030725


scott.sprorgПоставщик реестров

oralv.t_org
scott.koop
scott.koop_uch
scott.sprorg

select t.*, tp.name as tp_name
 from scott.t_org t, scott.t_org_tp tpSELECT SUM (t.sit_)
FROM   scott.load_kartw t
UNION ALL
SELECT SUM (summa)
  FROM (SELECT SUM (summa) AS summa
            FROM   scott.charges 
            WHERE usl <> '037'
        UNION ALL
            SELECT SUM (summa)
            FROM   scott.changes 
            WHERE usl <> '037')
UNION ALL                               --показать корректировки по начислению
SELECT SUM (summa)
FROM scott.t_corrects_for_saldo t
WHERE mg = '201208'
where t.fk_orgtp=tp.id-- and 
order by decode(tp.cd, 'Поставщики реестров', 0,1), t.name
 