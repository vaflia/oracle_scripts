CREATE TABLE vaflia.S_DOC
(
  ID          NUMBER   NOT NULL,
  FK_PERS     NUMBER,
  FK_K_LSK    NUMBER,
  FK_DOC_TP  NUMBER   NOT NULL,
  SERDOC      VARCHAR2(10 char),
  NUMDOC      VARCHAR2(10 char),
  FROMDOC     varchar2 (150 char),
  KODPO       varchar2 (12 char),
  DT0         DATE,
  DT1         DATE,
  DT2         DATE,
  FK_TABLE    NUMBER,
  USE         NUMBER(1),
  NPP         NUMBER   DEFAULT 0,
  V           NUMBER   DEFAULT 1,
  COMM        VARCHAR2(64 BYTE)
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


COMMENT ON TABLE vaflia.S_DOC IS '���������� ����. ������ ����������';
COMMENT ON COLUMN vaflia.S_DOC.ID IS '���������� ����. ������ ����������';
COMMENT ON COLUMN vaflia.S_DOC.FK_K_LSK IS '������ ��������� ';
COMMENT ON COLUMN vaflia.S_DOC.FK_SDOC_TP IS '��� ���������';
COMMENT ON COLUMN vaflia.S_DOC.SERDOC IS '�����';
COMMENT ON COLUMN vaflia.S_DOC.NUMDOC IS '�����';
COMMENT ON COLUMN vaflia.S_DOC.FROMDOC IS '��� ����� ��������';
COMMENT ON COLUMN vaflia.S_DOC.KODPO IS '��� �������������';
COMMENT ON COLUMN vaflia.S_DOC.FK_TABLE IS '���� ��� ��������.��� ����� ��������.';
COMMENT ON COLUMN vaflia.S_DOC.DT0 IS '���� ������ ���������';
COMMENT ON COLUMN vaflia.S_DOC.DT1 IS '���� ������ ������� �������� ���������';
COMMENT ON COLUMN vaflia.S_DOC.DT2 IS '���� ��������� ������� �������� ��������� ';
COMMENT ON COLUMN vaflia.S_DOC.USE IS '������������ �� ���-�';
COMMENT ON COLUMN vaflia.S_DOC.NPP IS '� �/�';
COMMENT ON COLUMN vaflia.S_DOC.V IS '��������, ���� = 1';
COMMENT ON COLUMN vaflia.S_DOC.COMM IS '�������';
--COMMENT ON COLUMN vaflia.S_DOC.FK_ACT IS '�������� �����������';


CREATE UNIQUE INDEX vaflia.S_DOC_PK ON vaflia.S_DOC
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


CREATE OR REPLACE TRIGGER vaflia.s_doc_BI
  before insert ON vaflia.S_DOC  
  for each row
declare
  -- local variables here
begin
  if :new.id is null then
    select oralv.seq_base.nextval into :new.id from dual;
  end if;
end s_doc_BI;
/


ALTER TABLE vaflia.S_DOC ADD (
  CONSTRAINT S_DOC_PK
  PRIMARY KEY
  (ID)
  USING INDEX vaflia.S_DOC_PK
  ENABLE VALIDATE);

ALTER TABLE vaflia.S_DOC ADD (
  CONSTRAINT S_DOC_FK_PERS 
  FOREIGN KEY (FK_PERS) 
  REFERENCES vaflia.S_pers (ID)
  ON DELETE CASCADE
  ENABLE VALIDATE,
  CONSTRAINT S_DOC_FK_DOCTP 
  FOREIGN KEY (FK_DOC_TP) 
  REFERENCES oralv.U_LIST (ID)
  ENABLE VALIDATE,
  CONSTRAINT S_DOC_FK_TABLE 
  FOREIGN KEY (FK_TABLE) 
  REFERENCES oralv.T_ORG (ID)
  ENABLE VALIDATE);

GRANT SELECT ON vaflia.S_DOC TO HSKEEP_SELECT;
