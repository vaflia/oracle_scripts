SELECT distinct a.lsk, a.kodul, a.ndom, a.nkw, initcap(a.fam) as  fam,initcap(a.im) as im, initcap(a.ot) as ot, a.nac, a.pol,
                          a.grazd, a.viddok1, a.serdok1, a.ndok1, a.bfam, a.dpasp1, a.kodpo1, a.dr, a.status, a.otpkd,a.otpad,a.datapr,a.datavip,
                          a.faktprop, a.faktvip
                 FROM LDO.L_REGISTR@HP  a
              WHERE a.lsk='07234421' order by dr

SELECT k.lsk, k.kul, k.nd, k.kw, P.NM_FIRST, p.nm_last, p.nm_patr, 
  FROM oralv.s_pers p , oralv.s_doc d, oralv.s_reg r, oralv.kart k, 
       select * from  
 WHERE r.fk_pers=p.id AND d.fk_pers=P.ID                 
              
select * from oralv.


select * from oralv.v_nation
drop view v_nation
CREATE OR REPLACE FORCE VIEW oralv.v_nation
( id ,name,cd,nm,t_id,t_cd)
as 
SELECT u.id,u.name,u.cd,u.nm, t.id, t.cd
FROM oralv.u_list u, oralv.u_listtp t 
WHERE u.fk_listtp=t.id
  and t.cd='NATION_TP'
order by u.id

select * from oralv.v_citizen
drop view v_citizen
CREATE OR REPLACE FORCE VIEW oralv.v_citizen
( id ,name,cd,nm,t_id,t_cd)
as 
SELECT u.id,u.name,u.cd,u.nm, t.id, t.cd
FROM oralv.u_list u, oralv.u_listtp t 
WHERE u.fk_listtp=t.id
  and t.cd='CITIZEN_TP'
order by u.id


SELECT * FROM oralv.v_milit_org
DROP VIEW v_milit_org
CREATE OR REPLACE FORCE VIEW oralv.v_milit_org
( id ,name,cd,nm,t_id,t_cd)
as 
SELECT u.id,u.name,u.cd,u.name_in_fox nm, t.id, t.cd
FROM oralv.t_org u, oralv.t_org_tp t 
WHERE u.fk_orgtp=t.id
  and t.cd='Военкоматы'
order by u.id

SELECT * FROM oralv.v_ps_org
DROP VIEW v_ps_org
CREATE OR REPLACE FORCE VIEW oralv.v_ps_org
( id ,name,cd,nm,t_id,t_cd)
as 
SELECT u.id,u.name,u.cd,u.name_in_fox nm, t.id, t.cd
FROM oralv.t_org u, oralv.t_org_tp t 
WHERE u.fk_orgtp=t.id
  and t.cd='Паспортный стол'
order by u.id


select * from oralv.v_sex
drop view v_sex
CREATE OR REPLACE FORCE VIEW oralv.v_sex
( id ,name,cd,nm,t_id,t_cd)
as 
SELECT u.id,u.name,u.cd,u.nm, t.id, t.cd
FROM oralv.u_list u, oralv.u_listtp t 
WHERE u.fk_listtp=t.id
  and t.cd='SEX_TP'
order by u.id

select * from oralv.v_reg_tp
drop view oralv.v_reg_tp
CREATE OR REPLACE FORCE VIEW oralv.v_reg_tp
( id ,name,cd,nm,t_id,t_cd)
as 
SELECT u.id,u.name,u.cd,u.nm, t.id, t.cd
FROM oralv.u_list u, oralv.u_listtp t 
WHERE u.fk_listtp=t.id
  and t.cd='REG_TP'
order by u.id


select * from oralv.v_reg_status_tp
drop view oralv.v_reg_status_tp
CREATE OR REPLACE FORCE VIEW oralv.v_reg_status_tp
( id ,name,cd,nm,t_id,t_cd)
as 
SELECT u.id,u.name,u.cd,u.nm, t.id, t.cd
FROM oralv.u_list u, oralv.u_listtp t 
WHERE u.fk_listtp=t.id
  and t.cd='REG_STATUS_TP'
order by u.id
  
ldo.l_registr@hp
select * from oralv.v_UNREG_REASON_TP
drop view oralv.v_UNREG_REASON_TP
CREATE OR REPLACE FORCE VIEW oralv.v_UNREG_REASON_TP
( id ,name,cd,nm,t_id,t_cd)
as 
SELECT u.id,u.name,u.cd,u.nm, t.id, t.cd
FROM oralv.u_list u, oralv.u_listtp t 
WHERE u.fk_listtp=t.id
  and t.cd='UNREG_REASON_TP'
order by u.id

select * from oralv.v_form_s
drop view oralv.v_form_s
CREATE OR REPLACE FORCE VIEW oralv.v_form_s
( id ,name,cd,nm,t_id,t_cd)
as 
SELECT u.id,u.name,u.cd,u.nm, t.id, t.cd
FROM oralv.u_list u, oralv.u_listtp t 
WHERE u.fk_listtp=t.id
  and t.cd='FORM_S_TP'
order by u.id


select * from oralv.v_temp_reg_tp
drop view oralv.v_temp_tp
CREATE OR REPLACE FORCE VIEW oralv.v_temp_reg_tp
( id ,name,cd,nm,t_id,t_cd)
as 
SELECT u.id,u.name,u.cd,u.nm, t.id, t.cd
FROM oralv.u_list u, oralv.u_listtp t 
WHERE u.fk_listtp=t.id
  and t.cd='TEMP_REG_TP'
order by u.id


select * from oralv.v_temp_reason_tp
drop view oralv.v_temp_treason_p
CREATE OR REPLACE FORCE VIEW oralv.v_temp_reason_tp
( id ,name,cd,nm,t_id,t_cd)
as 
SELECT u.id,u.name,u.cd,u.nm, t.id, t.cd
FROM oralv.u_list u, oralv.u_listtp t 
WHERE u.fk_listtp=t.id
  and t.cd='TEMP_REASON_TP'
order by u.id


select * from oralv.v_DOC_REG_TP
drop view oralv.v_DOC_REG_TP
CREATE OR REPLACE FORCE VIEW oralv.v_DOC_REG_TP
( id ,name,cd,nm,t_id,t_cd)
as 
SELECT u.id,u.name,u.cd,u.nm, t.id, t.cd
FROM oralv.u_list u, oralv.u_listtp t 
WHERE u.fk_listtp=t.id
  and t.cd='DOC_REG_TP'
order by u.id


select * from oralv.v_DOC_KW_TP
drop view oralv.v_DOC_KW_TP
CREATE OR REPLACE FORCE VIEW oralv.v_DOC_KW_TP
( id ,name,cd,nm,t_id,t_cd)
as 
SELECT u.id,u.name,u.cd,u.nm, t.id, t.cd
FROM oralv.u_list u, oralv.u_listtp t 
WHERE u.fk_listtp=t.id
  and t.cd='DOC_KW_TP'
order by u.id


select * from oralv.v_military
drop view oralv.v_military
CREATE OR REPLACE FORCE VIEW oralv.v_military
( id ,name,cd,nm,t_id,t_cd)
as 
SELECT u.id,u.name,u.cd,u.nm, t.id, t.cd
FROM oralv.u_list u, oralv.u_listtp t 
WHERE u.fk_listtp=t.id
  and t.cd='MILITARY_TP'
order by u.id

select * from oralv.v_area_tp
drop view oralv.v_area_tp
CREATE OR REPLACE FORCE VIEW oralv.v_area_tp
( id ,name,cd,nm,t_id,t_cd)
as
SELECT u.id,u.name,u.cd,u.nm, t.id, t.cd
FROM oralv.u_list u, oralv.u_listtp t 
WHERE u.fk_listtp=t.id
  and t.cd in ('AREA_TP','AREA_NP_TP')
order by t.cd, u.npp


SELECT ul.id,ul.name
FROM oralv.u_list ul inner join oralv.u_listtp ultp
on ul.fk_listtp=ultp.id
and ultp.cd='AREA_NP_TP'



/*
select * from ldo.v_oplata@hp where lsk='37012433'
select * from prep.kwtp_h@hp h , prep.kwtp_b@hp b 
where h.id=b.id
and h.lsk='37012433'
and h.dtek='06.10.2013'
and b.dtek>'06.11.2013'

select * from prep.kwtp_h@hp h where h.lsk='37012433' 
select * from oralv.U_LIST t where t.name like 'Реги%'
scott.s_stra@hp
FKV.TEMP_par@hp

select * from ldo.v_oplata@hp
select * from scott.oper@hp where oper='84'

select * from scott.s_reu_trest@hp
select * from ldo.v_reg@hp
se

select t.*, t.rowid from oralv.U_LIST t where t.fk_listtp=432122

