CREATE TABLE vaflia.S_OWNER
(
  ID      NUMBER      NOT NULL,
  FK_KW   NUMBER,
  LSK   VARCHAR2 (8 CHAR),
  FK_PERS NUMBER,
  FK_DOC  NUMBER,
  DT1     date,
  DT2     date,
  FK_FORM_S number,    
  dolch   number,
  dolzn   number,
  ARH     NUMBER(1),      
  NPP     NUMBER DEFAULT 0 NOT NULL,
  V       NUMBER DEFAULT 1 NOT NULL,
  COMM    VARCHAR2(128 BYTE)
)

TABLESPACE DATA
RESULT_CACHE (MODE DEFAULT)
PCTUSED    0
PCTFREE    10
INITRANS   1
MAXTRANS   255
STORAGE    (
            INITIAL          1M
            NEXT             1M
            MINEXTENTS       1
            MAXEXTENTS       UNLIMITED
            PCTINCREASE      0
            BUFFER_POOL      DEFAULT
            FLASH_CACHE      DEFAULT
            CELL_FLASH_CACHE DEFAULT
           )
LOGGING 
NOCOMPRESS 
NOCACHE
NOPARALLEL
MONITORING;

COMMENT ON COLUMN VAFLIA.S_OWNER.ID IS 'Паспортный стол. Собственники жилья';
COMMENT ON COLUMN VAFLIA.S_OWNER.FK_KW IS 'ФК на квартиру';
COMMENT ON COLUMN VAFLIA.S_OWNER.FK_PERS IS 'ФК на персону';
COMMENT ON COLUMN VAFLIA.S_OWNER.FK_DOC IS 'ФК на документ СОБСТВЕННОСТИ';
COMMENT ON COLUMN VAFLIA.S_OWNER.DT1 IS 'Дата начала собственности';
COMMENT ON COLUMN VAFLIA.S_OWNER.DT2 IS 'Дата окончания собственности';
COMMENT ON COLUMN VAFLIA.S_OWNER.FK_FORM_S IS 'ФК на форму собственности';
COMMENT ON COLUMN VAFLIA.S_OWNER.DOLCH IS 'доля числ';
COMMENT ON COLUMN VAFLIA.S_OWNER.DOLZN IS 'доля знам';
COMMENT ON COLUMN VAFLIA.S_OWNER.ARH IS 'Собственник в архиве. становится после даты окончания собственности';

CREATE UNIQUE INDEX vaflia.S_OWNER_PK ON vaflia.S_OWNER
(ID)
LOGGING
TABLESPACE DATA
PCTFREE    10
INITRANS   2
MAXTRANS   255
STORAGE    (
            INITIAL          64K
            NEXT             1M
            MINEXTENTS       1
            MAXEXTENTS       UNLIMITED
            PCTINCREASE      0
            BUFFER_POOL      DEFAULT
            FLASH_CACHE      DEFAULT
            CELL_FLASH_CACHE DEFAULT
           )
NOPARALLEL;


CREATE OR REPLACE TRIGGER vaflia.s_owner_bi
  before insert on vaflia.s_owner
  for each row
declare
begin
  if :new.id is null or :new.id=0 then
    select oralv.seq_base.nextval into :new.id from dual;
  end if;
end s_owner_bi;
/

ALTER TABLE vaflia.s_owner ADD (
  CONSTRAINT s_owner_PK
  PRIMARY KEY
  (ID)
  USING INDEX vaflia.s_owner_PK
  ENABLE VALIDATE);

ALTER TABLE vaflia.s_owner ADD (
  CONSTRAINT s_owner_FK_FORM_S 
  FOREIGN KEY (FK_FORM_S) 
  REFERENCES oralv.U_LIST (ID)
  ENABLE VALIDATE,
  CONSTRAINT s_owner_LSK 
  FOREIGN KEY (LSK) 
  REFERENCES oralv.KART (LSK)
  ENABLE VALIDATE,
  CONSTRAINT s_owner_FK_KW 
  FOREIGN KEY (FK_KW) 
  REFERENCES oralv.c_kw (ID)
  ENABLE VALIDATE,
  CONSTRAINT s_owner_FK_PERS 
  FOREIGN KEY (FK_PERS) 
  REFERENCES vaflia.S_PERS (ID)
  ON DELETE CASCADE
  ENABLE VALIDATE,
  CONSTRAINT s_owner_FK_DOC 
  FOREIGN KEY (FK_DOC) 
  REFERENCES vaflia.s_doc (ID)
  ENABLE VALIDATE
);

GRANT SELECT ON vaflia.s_owner TO HSKEEP_SELECT;
