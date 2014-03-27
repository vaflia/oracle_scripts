ALTER TABLE VAFLIA.S_REG
 DROP PRIMARY KEY CASCADE;

DROP TABLE VAFLIA.S_REG CASCADE CONSTRAINTS;

CREATE TABLE VAFLIA.S_REG
(
  ID               NUMBER                       NOT NULL,
  FK_PERS          NUMBER                       NOT NULL,
  LSK              VARCHAR2(8 CHAR),
  FK_LSK_1         VARCHAR2(8 CHAR),
  FK_LSK_2         VARCHAR2(8 CHAR),
  FK_REG_TP        NUMBER                       NOT NULL,
  FK_ORG           NUMBER                       NOT NULL,
  DT_RISE_CITY     DATE,
  DT_RISE_ADDR     DATE,
  DT_REG           DATE,
  DT_REG_TS        DATE                         DEFAULT sysdate,
  FK_REG_STATUS    NUMBER                       NOT NULL,
  FK_AREA          NUMBER                       NOT NULL,
  NM_STREET        VARCHAR2(45 CHAR),
  NM_HOUSE         VARCHAR2(6 CHAR),
  NM_KW            VARCHAR2(7 CHAR),
  FK_UNREG_REASON  NUMBER,
  DT_UNREG         DATE,
  DT_UNREG_TS      DATE                         DEFAULT sysdate,
  FK_AREA_UNREG    NUMBER,
  NM_STREET_UNREG  VARCHAR2(45 CHAR),
  NM_HOUSE_UNREG   VARCHAR2(6 CHAR),
  NM_KW_UNREG      VARCHAR2(7 CHAR),
  UNREG_COMM       VARCHAR2(100 BYTE),
  ARH              NUMBER(1),
  NPP              NUMBER                       DEFAULT 0                     NOT NULL,
  V                NUMBER                       DEFAULT 1                     NOT NULL,
  COMM             VARCHAR2(128 BYTE)
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

COMMENT ON TABLE VAFLIA.S_REG IS 'Паспортный стол. реестр Регистрационных Действий(РегД)';
COMMENT ON COLUMN VAFLIA.S_REG.ID IS 'Паспортный стол. реестр Регистрационных Действий(РегД)';
COMMENT ON COLUMN VAFLIA.S_REG.FK_PERS IS 'персона';
COMMENT ON COLUMN VAFLIA.S_REG.LSK IS 'LSK (В него прописывается человек)';
COMMENT ON COLUMN VAFLIA.S_REG.FK_LSK_1 IS 'kart.lsk   - лицевой счет: Откуда прописывается';
COMMENT ON COLUMN VAFLIA.S_REG.FK_LSK_2 IS 'kart.lsk   - лицевой счет: Куда выписывается';
COMMENT ON COLUMN VAFLIA.S_REG.FK_REG_TP IS 'Тип регистрации (постоянная,временная)';
COMMENT ON COLUMN VAFLIA.S_REG.FK_ORG IS 'регДействие выполнено пасСтолом ';
COMMENT ON COLUMN VAFLIA.S_REG.FK_AREA IS 'указатель на регион откуда прибыл человек: код страны:области:района:города:района';
COMMENT ON COLUMN VAFLIA.S_REG.NM_STREET IS 'наименование улицы - для чужого НП';
COMMENT ON COLUMN VAFLIA.S_REG.NM_HOUSE IS 'наименование дома - для чужого НП';
COMMENT ON COLUMN VAFLIA.S_REG.NM_KW IS 'наименование квартиры - для чужого нНП';
COMMENT ON COLUMN VAFLIA.S_REG.DT_RISE_CITY IS 'когда прибыл в НасПункт(НП) Рег';
COMMENT ON COLUMN VAFLIA.S_REG.DT_RISE_ADDR IS 'когда прибыл на адрес Рег';
COMMENT ON COLUMN VAFLIA.S_REG.DT_REG IS 'ФАкт дата регистрации';
COMMENT ON COLUMN VAFLIA.S_REG.DT_REG_TS IS 'Фактич дата регистрации занесена';
COMMENT ON COLUMN VAFLIA.S_REG.FK_REG_STATUS IS 'статус регистрации (неподтвержденная выписка, неподтвержденная прописка,
                                                 подтвержденная выписка, подтвержденная прописка) ';
COMMENT ON COLUMN VAFLIA.S_REG.DT_UNREG IS 'дата снятия с рег учета (не пуста если временная прописка)';
COMMENT ON COLUMN VAFLIA.S_REG.DT_UNREG_TS IS 'факт дата снятия с рег уч.';
COMMENT ON COLUMN VAFLIA.S_REG.FK_UNREG_REASON IS 'Причина снятия с рег учета';
COMMENT ON COLUMN VAFLIA.S_REG.FK_AREA_UNREG IS 'указатель на регион выписки: код страны:области:района:города:района';
COMMENT ON COLUMN VAFLIA.S_REG.NM_STREET_UNREG IS 'улица';
COMMENT ON COLUMN VAFLIA.S_REG.NM_HOUSE_UNREG IS 'дом';
COMMENT ON COLUMN VAFLIA.S_REG.NM_KW_UNREG IS 'кв';
COMMENT ON COLUMN VAFLIA.S_REG.UNREG_COMM IS 'комментарий к ПРег';
COMMENT ON COLUMN VAFLIA.S_REG.ARH IS '1-запись в архиве, 0 - действующая запись. обычно запись в архив уходит когда выписывается';



CREATE UNIQUE INDEX VAFLIA.S_REG_PK ON VAFLIA.S_REG
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


CREATE OR REPLACE TRIGGER VAFLIA.S_REG_BI
  before insert on vaflia.s_reg
  for each row
declare
begin
  if :new.id is null or :new.id=0 then
    select oralv.seq_base.nextval into :new.id from dual;
  end if;
end s_reg_bi;
/


ALTER TABLE VAFLIA.S_REG ADD (
  CONSTRAINT S_REG_PK
  PRIMARY KEY
  (ID)
  USING INDEX VAFLIA.S_REG_PK
  ENABLE VALIDATE);

ALTER TABLE VAFLIA.S_REG ADD (
  CONSTRAINT S_REG_FK_AREA 
  FOREIGN KEY (FK_AREA) 
  REFERENCES ORALV.S_AREA (ID)
  ENABLE VALIDATE,
  CONSTRAINT S_REG_FK_LSK 
  FOREIGN KEY (LSK) 
  REFERENCES ORALV.KART (LSK)
  ENABLE VALIDATE,
  CONSTRAINT S_REG_FK_LSK_1 
  FOREIGN KEY (FK_LSK_1) 
  REFERENCES ORALV.KART (LSK)
  ENABLE VALIDATE,
  CONSTRAINT S_REG_FK_LSK_2 
  FOREIGN KEY (FK_LSK_2) 
  REFERENCES ORALV.KART (LSK)
  ENABLE VALIDATE,
  CONSTRAINT S_REG_FK_PS 
  FOREIGN KEY (FK_ORG) 
  REFERENCES ORALV.T_ORG (ID)
  ENABLE VALIDATE,
  CONSTRAINT S_REG_FK_REG_STATUS 
  FOREIGN KEY (FK_REG_STATUS) 
  REFERENCES ORALV.U_LIST (ID)
  ENABLE VALIDATE,
  CONSTRAINT S_REG_FK_T 
  FOREIGN KEY (FK_PERS) 
  REFERENCES VAFLIA.S_PERS (ID)
  ON DELETE CASCADE
  ENABLE VALIDATE,
  CONSTRAINT S_REG_FK_UNREG_REASON 
  FOREIGN KEY (FK_UNREG_REASON) 
  REFERENCES ORALV.U_LIST (ID)
  ENABLE VALIDATE);

GRANT SELECT ON VAFLIA.S_REG TO HSKEEP_SELECT;
