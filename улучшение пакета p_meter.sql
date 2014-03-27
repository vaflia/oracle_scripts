        
DECLARE
   P_ID U_METER_EXS.id%TYPE;
   P_IS_UPDATEBLE NUMBER;
   P_FK_METER  U_METER.Id%TYPE;
   lnx number;
   l_P_IS_UPDATEBLE number;
   P_IS_UPDATEBLE number:=1;
  CURSOR c IS
    SELECT t.id FROM oralv.u_meter_exs t WHERE t.id= P_ID;
  rc c%ROWTYPE;
  --
  CURSOR cme IS 
    SELECT t.id FROM oralv.u_meter_exs t 
     WHERE t.fk_meter= P_FK_METER 
           AND (P_DT1 BETWEEN t.dt1 AND t.dt2) AND (P_DT2 BETWEEN t.dt1 AND t.dt2); 
  rme cme%ROWTYPE;
  rme0 cme%ROWTYPE;  
  --
  CURSOR cml IS 
    SELECT m.id FROM oralv.u_meter_log ml, oralv.u_meter m
    WHERE ml.id= m.fk_meter_log AND m.id= P_FK_METER 
          AND (P_DT1 BETWEEN ml.dt1 AND ml.dt2) AND (P_DT2 BETWEEN ml.dt1 AND ml.dt2); 
  rml cml%ROWTYPE;
BEGIN
 IF p_ir= 1 THEN
      OPEN  CME;
      /*FETCH cme INTO rme;
     IF cme%FOUND THEN--
              FETCH cme INTO rme0;
              IF cme%FOUND THEN--���! ������� ����� ����� ������ ��� ���������� U_METER_EXS
                  p_ir:= 13;--������������� ���������� �������� ��� �������� �� �����������
              ELSE--!������ ����
                P_ID:= rme.id;
                IF P_IS_UPDATEBLE= 1 THEN--������ ������� � UPDATE ��������
                  l_P_IS_UPDATEBLE:= 1;  
                ELSE--
                  p_ir:= 11;--������ P_FK_METER + P_DT1 + P_DT2 � ������ ������� � ���������� UPDATE 
                          --��� ������� ���������� ��������� ��� ����������� ������������� ��������� ������
                END IF;
              END IF;*/
     IF CME%ROWCOUNT>0 THEN
         IF CME%ROWCOUNT=1 THEN 
            FETCH cme INTO rme;
            P_ID:= rme.id;
            IF P_IS_UPDATEBLE= 1 THEN--������ ������� � UPDATE ��������
                l_P_IS_UPDATEBLE:= 1;
            ELSE
              p_ir:=11;          
            END IF;
         ELSE 
              p_ir:= 11;
         END IF;
     ELSE
        --��� ������� ��������� �� ������  �� P_FK_METER , P_DT1, P_DT2
        --��� INS - ���������:
        -- 1.������ ������� ������ ����������� ������� � ������ �����������
            OPEN cml;
            FETCH cml INTO rml;
            IF cml%FOUND THEN--��������� ����� ����� ���������� ������ ������������� ������ �����
            -- 2.������ ������ u_meter_exs �� ���������� ��� ��������� � u_meter �������
              SELECT COUNT(*) INTO lnx FROM oralv.u_meter_exs t 
               WHERE t.fk_meter= P_FK_METER
                     AND (  (P_DT1 BETWEEN t.dt1 AND t.dt2)
                          OR(P_DT2 BETWEEN t.dt1 AND t.dt2)
                          OR(t.dt1 BETWEEN P_DT1 AND P_DT2)
                          OR(t.dt2 BETWEEN P_DT1 AND P_DT2));
              IF lnx = 0 THEN--��� ����������� ��������
                NULL;
                l_P_IS_UPDATEBLE:= 0;
              ELSE
               p_ir:= 6;--������ ������ u_meter_exs ���� ����������� ��������
              END IF;
            ELSE
               p_ir:= 7;--��������� ����� �� ����� ���������� ������ ������������� ������ �����
            END IF;
            CLOSE cml;
     END IF;
        CLOSE cme;
    END IF;
END;