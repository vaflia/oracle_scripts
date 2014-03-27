declare 
BEGIN
    FOR I IN 49..58 LOOP
            execute immediate 'alter table scott.load_koop add I'||i||' number';
            execute immediate 'alter table scott.load_kart add I'||i||' number';
            execute immediate 'alter table scott.load_kwni add I'||i||' number';
            execute immediate 'alter table scott.load_kwtp add I'||i||'_ number';
            execute immediate 'alter table scott.load_kartw add I'||i||' number';
    END LOOP;
END;

select count(*) from scott.kart
select count(*) from scott.load_kart 
load_koop
load_kart 
load_kwni
load_kwtp
load_kartw
select * from scott.load_kart 
where kpr_s<>0 or kpr_cem<>0 or lpdt<>'' or comtel<>0 or org<>0 or err<>0

alter table prep. t_changes_for_saldo add  i50 number


scott.s_stra

select * from scott.cap_transactions where id =298252

select * from oralv.t_user
select * from all_users

user    BUGH_ALTER_3 
pass    SL62VGZ84ME

drop table scott.tree_usl_temp

CREATE GLOBAL TEMPORARY TABLE SCOTT.TREE_USL_TEMP
(
  FK_USER      NUMBER,
  USLM    CHAR(3 BYTE),
  NM1      VARCHAR2(255),
  SEL      NUMBER
  
)
ON COMMIT PRESERVE ROWS
NOCACHE;

GRANT SELECT, UPDATE ON SCOTT.TREE_USL_TEMP TO BASE_CONNECT;

GRANT SELECT, UPDATE ON SCOTT.TREE_USL_TEMP TO "¡”’√_ ¬¿–“œÀ¿“€";


CREATE GLOBAL TEMPORARY TABLE SCOTT.TREE_ORG_TEMP
(
  FK_USER     NUMBER,
  ORG     number,
  NAME     VARCHAR2(255),
  SEL      NUMBER
)
ON COMMIT PRESERVE ROWS
NOCACHE;
GRANT SELECT, UPDATE ON SCOTT.TREE_ORG_TEMP TO BASE_CONNECT;
GRANT SELECT, UPDATE ON SCOTT.TREE_ORG_TEMP TO "¡”’√_ ¬¿–“œÀ¿“€";

insert into SCOTT.TREE_ORG_TEMP (fk_user,org,name,sel)
select userenv('sessionid'),t.kod, to_char(t.kod)||' '||t.name as name, 0 
from scott.sprorg t
where kod<>0 and to_char(kod)<>name
and name is not null
order by t.kod



