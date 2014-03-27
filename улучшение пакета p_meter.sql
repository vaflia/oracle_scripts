        
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
              IF cme%FOUND THEN--¬ах! найдено более одной записи дл€ указанного U_METER_EXS
                  p_ir:= 13;--неоднозначные избыточные сведени€ дл€ указани€ на период‘из—ч
              ELSE--!запись одна
                P_ID:= rme.id;
                IF P_IS_UPDATEBLE= 1 THEN--запись найдена и UPDATE разрешен
                  l_P_IS_UPDATEBLE:= 1;  
                ELSE--
                  p_ir:= 11;--указан P_FK_METER + P_DT1 + P_DT2 и запись найдена и Ќ≈разрешен UPDATE 
                          --код ожидает вызывающа€ процедура дл€ определени€ существовани€ указанной записи
                END IF;
              END IF;*/
     IF CME%ROWCOUNT>0 THEN
         IF CME%ROWCOUNT=1 THEN 
            FETCH cme INTO rme;
            P_ID:= rme.id;
            IF P_IS_UPDATEBLE= 1 THEN--запись найдена и UPDATE разрешен
                l_P_IS_UPDATEBLE:= 1;
            ELSE
              p_ir:=11;          
            END IF;
         ELSE 
              p_ir:= 11;
         END IF;
     ELSE
        --нет точного попадани€ на запись  по P_FK_METER , P_DT1, P_DT2
        --дл€ INS - проверить:
        -- 1.период проекта записи физ—четчика включен в период Ћог—четчика
            OPEN cml;
            FETCH cml INTO rml;
            IF cml%FOUND THEN--указанный физ—ч имеет подход€щий период существовани€ своего лог—ч
            -- 2.проект записи u_meter_exs не пересекает уже имеющиес€ у u_meter периоды
              SELECT COUNT(*) INTO lnx FROM oralv.u_meter_exs t 
               WHERE t.fk_meter= P_FK_METER
                     AND (  (P_DT1 BETWEEN t.dt1 AND t.dt2)
                          OR(P_DT2 BETWEEN t.dt1 AND t.dt2)
                          OR(t.dt1 BETWEEN P_DT1 AND P_DT2)
                          OR(t.dt2 BETWEEN P_DT1 AND P_DT2));
              IF lnx = 0 THEN--нет пересечений периодов
                NULL;
                l_P_IS_UPDATEBLE:= 0;
              ELSE
               p_ir:= 6;--проект записи u_meter_exs имет пересечение периодов
              END IF;
            ELSE
               p_ir:= 7;--указанный физ—ч Ќ≈ имеет подход€щий период существовани€ своего лог—ч
            END IF;
            CLOSE cml;
     END IF;
        CLOSE cme;
    END IF;
END;