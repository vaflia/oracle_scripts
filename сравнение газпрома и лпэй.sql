select t.dtek, t.lsk, t.ska,'' as pay_cd from l_load1@nst t where t.reg_cd='T_GPB'
 AND lsk='35010113'
 UNION ALL
select dt1,lsk, sum(summa),pay_cd from scott.l_pay
where lsk='35010113' 
GROUP BY dt1, lsk,pay_cd



select * from scott.l_pay
where lsk='35010113'

select * from ldo.l_list_reg
where fk_reg=983 
        and dt_kw='11.09.2012'



--два запроса на сравнение
select  lr.id, LR.SUMMA, lr.summap,lr.state_cd, lp.lsk, sum(lp.summa) , to_char(lp.dt1,'dd.mm.yyyy')
FROM ldo.l_list_reg lr, scott.l_pay lp
WHERE
lr.id=lp.fk_list_reg
AND lr.fk_reg=983
and pay_cd='PU'
AND  to_char(lp.dt1,'dd.mm.yyyy')='11.09.2012'
GROUP BY lp.lsk, to_char(lp.dt1,'dd.mm.yyyy'),lr.id , LR.SUMMA, lr.summap,lr.state_cd
ORDER BY to_char(lp.dt1,'dd.mm.yyyy'), lp.lsk


select  t.lsk, sum(t.ska) , to_char(t.dtek,'mm.dd.yyyy') 
FROM l_load1@nst t where t.reg_cd='T_GPB'
GROUP BY  to_char(t.dtek,'dd.mm.yyyy'), t.lsk 
ORDER BY  to_char(t.dtek,'dd.mm.yyyy'), t.lsk


SELECT ora_database_name FROM dual