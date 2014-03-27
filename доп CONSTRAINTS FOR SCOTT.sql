/*запускать от скота. некоторые constrents от скотта, которые не залились из дампа из за нехватки прав у system*/
DECLARE
L_CNT INTEGER;
BEGIN

SELECT  count(*) into l_cnt 
FROM all_constraints
WHERE constraint_name='PM_SUMTEMP_FK_USER';
if l_cnt =0 then
    execute immediate 'ALTER TABLE PAYDOC.PM_SUMTEMP ADD CONSTRAINT PM_SUMTEMP_FK_USER FOREIGN KEY (FK_USER) REFERENCES SCOTT.T_USER (ID) ENABLE';
END IF;

SELECT  count(*) into l_cnt 
FROM all_constraints
WHERE constraint_name='L_REG_F_ORG';
if l_cnt =0 then
    execute immediate 'ALTER TABLE LDO.L_REG ADD CONSTRAINT L_REG_F_ORG FOREIGN KEY (FK_ORG) REFERENCES ORALV.T_ORG (ID) ENABLE';
END IF;

SELECT  count(*) into l_cnt 
FROM all_constraints
WHERE constraint_name='L_REGXOPER_F_OPER';
if l_cnt =0 then      
    execute immediate 'ALTER TABLE LDO.L_REGXOPER ADD CONSTRAINT L_REGXOPER_F_OPER FOREIGN KEY (FK_OPER) REFERENCES SCOTT.OPER (OPER) ENABLE';
END IF;      

SELECT  count(*) into l_cnt 
FROM all_constraints
WHERE constraint_name='OPER_F_FK_ORG';
if l_cnt =0 then
        execute immediate 'ALTER TABLE SCOTT.OPER ADD CONSTRAINT OPER_F_FK_ORG FOREIGN KEY (FK_ORG) REFERENCES ORALV.T_ORG (ID) ENABLE';
END IF;        
SELECT  count(*) into l_cnt 
FROM all_constraints
WHERE constraint_name='SHET_CONTRAGENT_F_ID';
if l_cnt =0 then        
        execute immediate 'ALTER TABLE SCOTT.SCHET_CONTRAGENT ADD CONSTRAINT SHET_CONTRAGENT_F_ID FOREIGN KEY (FK_ORG) REFERENCES ORALV.T_ORG (ID) ENABLE';
END IF;        
SELECT  count(*) into l_cnt 
FROM all_constraints
WHERE constraint_name='PLAT_GROUP_F_T_ORG';
if l_cnt =0 then        
        execute immediate 'ALTER TABLE SCOTT.PLAT_GROUP ADD CONSTRAINT PLAT_GROUP_F_T_ORG FOREIGN KEY (FK_ORG) REFERENCES ORALV.T_ORG (ID) ENABLE';
END IF;        
SELECT  count(*) into l_cnt 
FROM all_constraints
WHERE constraint_name='PLAT_FORMULA_F_T_ORG';
if l_cnt =0 then        
        execute immediate 'ALTER TABLE SCOTT.PLAT_FORMULA ADD CONSTRAINT PLAT_FORMULA_F_T_ORG FOREIGN KEY (FK_ORG) REFERENCES ORALV.T_ORG (ID) ENABLE';
END IF;        
SELECT  count(*) into l_cnt 
FROM all_constraints
WHERE constraint_name='PLAT_ORG_T_FK_T_ORG';
if l_cnt =0 then        
        execute immediate 'ALTER TABLE SCOTT.PLAT_ORG_T ADD CONSTRAINT PLAT_ORG_T_FK_T_ORG FOREIGN KEY (FK_ORG) REFERENCES ORALV.T_ORG (ID) ENABLE';
END IF;        
SELECT  count(*) into l_cnt 
FROM all_constraints
WHERE constraint_name='PLAT_ITOG_T_FK_T_ORG';
if l_cnt =0 then        
        execute immediate 'ALTER TABLE SCOTT.PLAT_ITOG_T ADD CONSTRAINT PLAT_ITOG_T_FK_T_ORG FOREIGN KEY (FK_ORG) REFERENCES ORALV.T_ORG (ID) ENABLE';
END IF;        
SELECT  count(*) into l_cnt 
FROM all_constraints
WHERE constraint_name='PLAT_SALDO_T_FK_T_ORG';
if l_cnt =0 then        
        execute immediate 'ALTER TABLE SCOTT.PLAT_SALDO_T ADD CONSTRAINT PLAT_SALDO_T_FK_T_ORG FOREIGN KEY (FK_ORG) REFERENCES ORALV.T_ORG (ID) ENABLE';
END IF;        
SELECT  count(*) into l_cnt 
FROM all_constraints
WHERE constraint_name='PLAT_CORR_T_FK_T_ORG';
if l_cnt =0 then        
        execute immediate 'ALTER TABLE SCOTT.PLAT_CORRECTS_T ADD CONSTRAINT PLAT_CORR_T_FK_T_ORG FOREIGN KEY (FK_ORG) REFERENCES ORALV.T_ORG (ID) ENABLE';
END IF;        
SELECT  count(*) into l_cnt 
FROM all_constraints
WHERE constraint_name='PLAT_SALDO_BUGH_F';
if l_cnt =0 then
        execute immediate 'ALTER TABLE SCOTT.PLAT_SALDO_BUGH ADD CONSTRAINT PLAT_SALDO_BUGH_F FOREIGN KEY (FK_ORG) REFERENCES ORALV.T_ORG (ID) ENABLE';
END IF;        
SELECT  count(*) into l_cnt 
FROM all_constraints
WHERE constraint_name='PLAT_CLIENT_BANK_F';
if l_cnt =0 then        
        execute immediate 'ALTER TABLE SCOTT.PLAT_CLIENT_BANK ADD CONSTRAINT PLAT_CLIENT_BANK_F FOREIGN KEY (FK_ORG) REFERENCES ORALV.T_ORG (ID) ENABLE';
END IF;        
SELECT  count(*) into l_cnt 
FROM all_constraints
WHERE constraint_name='PLAT_CONTRAGENT_F';
if l_cnt =0 then        
        execute immediate 'ALTER TABLE SCOTT.PLAT_CONTRAGENT ADD CONSTRAINT PLAT_CONTRAGENT_F FOREIGN KEY (FK_ORG) REFERENCES ORALV.T_ORG (ID) ENABLE';
END IF;        
SELECT  count(*) into l_cnt 
FROM all_constraints
WHERE constraint_name='FK_L_PAY_L_LIST_REG';
if l_cnt =0 then        
        execute immediate 'ALTER TABLE SCOTT.L_PAY ADD CONSTRAINT FK_L_PAY_L_LIST_REG FOREIGN KEY (FK_LIST_REG) REFERENCES LDO.L_LIST_REG (ID) ON DELETE CASCADE ENABLE';
END IF;        
SELECT  count(*) into l_cnt 
FROM all_constraints
WHERE constraint_name='L_KOOPXPAR_F';
if l_cnt =0 then        
        execute immediate 'ALTER TABLE SCOTT.LOAD_KOOPXPAR ADD CONSTRAINT L_KOOPXPAR_F FOREIGN KEY (FK_PAR) REFERENCES ORALV.U_LIST (ID) ENABLE';
END IF;        
end;