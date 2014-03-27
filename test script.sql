--тестовый скрипт для проверки вставки счетчика главного и подчиненного по одному объекту и услуге
create or replace procedure test1

as
ir number;
l_id_ml number;
l_parent_ml number;
i number;
BEGIN/*
IF l_parent_ml IS null THEN 
       ORALV.P_METER2.U_METER_LOG_INS_UPD
       (
            P_IR => ir
          , P_ID => l_id_ml
          , P_FK_KLSK_OBJ => 342259
          , P_FK_SERV     => 23976
          , P_CD          => 0
          , P_DT1   => to_date('20000101', 'YYYYMMDD')  
          , P_DT2   => to_date('20990101', 'YYYYMMDD')
          , P_PARENT_ID    => null
          , P_NAME => 'Фэйковый счетчик по услуге и вводу-'  -- на нем будут сидеть счетчики ОДПУ    !!ИЛИ  счетчики ИПУ  (так как ОДПУ может не быть)
          , P_IS_UPDATEBLE => 0                 
          , P_IS_COMMIT     => 1 --  -1 - вызов для проверки существования, без DML (и без COMMIT)
                                          --   0 - DML без COMMIT
                                          --   1 - DML и COMMIT
       );  
       l_parent_ml:=l_id_ml;
       l_id_ml:=null;
      -- IF ir<>0 then add_log ('ERRcode - '||SQLCODE||' -ERRmsg- '||SQLERRM||'.',sysdate,i,350, ir);  end if;
END IF;       */
l_parent_ml:=1161978;
ir:=0;
IF l_parent_ml is not null and ir=0  THEN
  -- вставляем логический ОДПУ привязанный к фэйкуовому по вводу услуге
  --(в fk_klsk_obj вставялем klsk дома-nd_klsk)
   ORALV.P_METER2.U_METER_LOG_INS_UPD
      (
        P_IR => ir
      , P_ID => l_id_ml
      , P_FK_KLSK_OBJ => 342259
      , P_FK_SERV     => 23976
      , P_CD          => 0
      , P_DT1   => to_date('20000101', 'YYYYMMDD')  
      , P_DT2   => to_date('20990101', 'YYYYMMDD')
      , P_PARENT_ID => 1161978--l_parent_ml
      , P_NAME => 'ОДПУ по услуге  и вводу  ' 
      , P_IS_UPDATEBLE => 1                  
      , P_IS_COMMIT => 1 --  -1 - вызов для проверки существования, без DML (и без COMMIT)
                                      --   0 - DML без COMMIT
                                      --   1 - DML и COMMIT
     ); --IF ir<>0 then add_log ('ERRcode - '||SQLCODE||' -ERRmsg- '||SQLERRM||'.',sysdate,i,350, ir);  end if;
END IF; 
END;