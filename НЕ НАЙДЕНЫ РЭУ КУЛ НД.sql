select reu,kul,nd,lsk,kw,fio from scott.kart k where not exists
(select * from scott.koop t where t.reu=k.reu and t.kul=k.kul and t.nd=k.nd)
select * from scott.koop where org=0

delete from scott.load_koopxpar
create table prep.load_koopxpar27012014 as select * from SCOTT.LOAD_KOOPXPAR

select * from scott.load_koop where 
(reu='87' and kul='1043' and nd='000021') or
(reu='K6' and kul='0123' and nd='000014')

delete from SCOTT.KART where reu='87' and kul='1043' and nd='000021'
delete from SCOTT.KART where reu='K6' and kul='0123' and nd='000014'
  
select t.*,t.rowid  from SCOTT.KART t where reu='K6'and  kul='0123' and nd='000014'

select * from scott.load_koop where reu='K6'and  kul='0123' and nd='000014'
select * from scott.params

select * from scott.load_koopxpar where kul='0151'

select * from scott.koop where org=0
select * from scott.spul where id='1043'

select * from scott.kart where lsk in('65014280','65014837')
select * from scott.spul where id='0094'

select * from scott.sptar where gtr in ('0652','0023') 


scott.usl_excl