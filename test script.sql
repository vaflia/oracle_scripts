--�������� ������ ��� �������� ������� �������� �������� � ������������ �� ������ ������� � ������
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
          , P_NAME => '�������� ������� �� ������ � �����-'  -- �� ��� ����� ������ �������� ����    !!���  �������� ���  (��� ��� ���� ����� �� ����)
          , P_IS_UPDATEBLE => 0                 
          , P_IS_COMMIT     => 1 --  -1 - ����� ��� �������� �������������, ��� DML (� ��� COMMIT)
                                          --   0 - DML ��� COMMIT
                                          --   1 - DML � COMMIT
       );  
       l_parent_ml:=l_id_ml;
       l_id_ml:=null;
      -- IF ir<>0 then add_log ('ERRcode - '||SQLCODE||' -ERRmsg- '||SQLERRM||'.',sysdate,i,350, ir);  end if;
END IF;       */
l_parent_ml:=1161978;
ir:=0;
IF l_parent_ml is not null and ir=0  THEN
  -- ��������� ���������� ���� ����������� � ���������� �� ����� ������
  --(� fk_klsk_obj ��������� klsk ����-nd_klsk)
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
      , P_NAME => '���� �� ������  � �����  ' 
      , P_IS_UPDATEBLE => 1                  
      , P_IS_COMMIT => 1 --  -1 - ����� ��� �������� �������������, ��� DML (� ��� COMMIT)
                                      --   0 - DML ��� COMMIT
                                      --   1 - DML � COMMIT
     ); --IF ir<>0 then add_log ('ERRcode - '||SQLCODE||' -ERRmsg- '||SQLERRM||'.',sysdate,i,350, ir);  end if;
END IF; 
END;