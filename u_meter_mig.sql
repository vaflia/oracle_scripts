CREATE OR REPLACE package body  vaflia.u_meter_mig IS
 
    PROCEDURE imp_MV (P_var number)
    IS
    /*CREATE by VAFLIA 12.09.2013 */
    --!!!! ���������� ��� ����������� ���� �� %TYPE!!!!
            l_imp_type integer; --1 ������ ����, 2-- ������ � ������� ���� id
            l_cnt number; -- ��� ������ �������� �� ��� �����
        /*return id*/
            l_id_t_doc number;--t_doc
            l_id_ml number; --u_meter_log
            l_id_meter number; --u_meter
            L_parent_ml number; -- u_meter_log.parent_id
        /*end treturn id*/
        l_reu        ORALV.C_HOUSES.REU%type;
        l_kul         ORALV.C_HOUSES.kul%type;
        l_nd         ORALV.C_HOUSES.nd%type;
        l_fk_k_lsk  ORALV.C_HOUSES.FK_K_LSK%type;
        l_ml_id_old number; -- id �� ������
        l_fk_hfpar_old number;
        l_hw_id number;   --�������� ���� ID ������
        l_gw_id number;   --������� ���� ID ������
        l_otop_id number; --��������� ID ������
        l_el_id number;     --������������� ID ������
        l_user number; 
        l_id_m3 oralv.d_serv.FK_UNIT1%TYPE;  -- id ��.��� �� u_list
        l_id_giga oralv.d_serv_LOG.FK_UNIT2%TYPE;-- id ��.��� �� u_list
        l_id_giga_m2 oralv.d_serv.FK_UNIT3%TYPE;-- id ��.��� �� u_list
        l_id_org number; -- id  ���-�� �� t_org
        l_id_type number; -- id ���� ������ ������ �� u_list
        L_ml_have number; --������� ����� �������� � ����� ����
        L_meter_have number; --������� ����� �������� � ����� ����
        l_ml_cd_old varchar2(100); --cd �������� � ������ ���� 
        l_err varchar2(1000);
        ir NUMBER; --��� ��������
        k number; --��������
        t number; --��������
        
        Cursor C_ML (p_id in oralv.u_meter_log.id%type) is
        SELECT * FROM oralv.u_meter_log@hotora where id=p_id;
        Cursor C_M (p_id in oralv.u_meter.id%type) is
        SELECT * FROM oralv.u_meter@hotora where fk_meter_log=p_id;
        
    BEGIN   
    EXECUTE IMMEDIATE 'alter sequence oralv.seq_base cache 15000'; --������������� ��� ������������������ ��� ����������� �������
    SELECT max(CASE WHEN UPPER(CD)='�������� ����' THEN ID END) AS a,
                max(CASE WHEN UPPER(CD)='������� ����' THEN ID END) AS b,
                max(CASE WHEN UPPER(CD)='���������' THEN ID END) AS c,
                max(CASE WHEN UPPER(CD)='����������������' THEN ID END) AS d
               INTO L_HW_ID,L_GW_ID, L_OTOP_ID, L_EL_ID 
               FROM (SELECT distinct CD,id FROM ORALV.D_SERV WHERE UPPER(CD) IN ('�������� ����','������� ����','���������','����������������'));

    SELECT id into l_id_m3 from ORALV.V_METER_VOL_UNIT where cd in ('�3'); 
    SELECT id into l_id_giga from ORALV.V_METER_VOL_UNIT where cd in ('�����������');
    SELECT id into l_id_giga_m2 from ORALV.V_METER_VOL_UNIT where cd in ('����/�2');      
    SELECT id into l_id_type from ORALV.V_METER_VOL_TYPE where trim(cd)='����������� �����';    --���������� ���������� ����� �� ����     
    SELECT id into l_id_org      FROM oralv.t_org where cd='�� "���"';
    
    IF p_var = 1 THEN
              --��������� ���������� �������� ����
              DELETE  from ORALV.U_METER_LOG;  
              INSERT INTO oralv.u_meter_log
                SELECT  id, cd,  
                             decode(fk_hfpar,1643,L_GW_ID,1702, l_OTOP_ID),
                             fk_k_lsk,  parent_id,
                             dt1, dt2,(select id from oralv.t_user where cd=l_user), dtf, fk_k_lsk, name, l_id_m3, l_id_giga, l_id_giga_m2 
                FROM oralv.u_meter_log@hotora;
                --��������� ���������� ��������
                DELETE  from ORALV.U_METER;  
              INSERT INTO oralv.u_meter
                SELECT      ID, FK_K_LSK, FK_METER_LOG, (select id from oralv.t_user where cd=l_user) as l_user, DTF
                FROM oralv.u_meter@hotora; 
             
              --����� �������� ����������
                 /* 
                  
                  1 �������� id ���� ��������� �� T_DOC_TP, �������� id_org �� t_org (��� fk_org)
                  1 � - ������� ������ �� ���������� ���� , ������� ���� ��������� �� t_doc
                  2 ���� - �������� ��������� �� ���� �� ������
                  3 ��������� �������� � ���� t_doc. 
                  4 �������� �� ������ ���������.
                  4� - ������� ��� ������ fk_type (���������� ���������� ����� �� ����)
                  5 ��������� ������ �� ������ � ����
                  8 ��������� �� ���� �������� */
               --1    
               -- SELECT id into l_id_doc_tp FROM oralv.t_doc_tp where cd='�������� ������ ����';
                SELECT id into l_id_org      FROM oralv.t_org where cd='�� "���"';
               --1�
      --          DELETE  FROM ORALV.U_meter_vol where fk_doc 
    --                        in (select id from ORALV.T_DOC WHERE fk_doctp in ()l_id_doc_tp);
         --       DELETE  FROM ORALV.T_DOC WHERE fk_doctp=l_id_doc_tp;
              --2
              
                FOR rec in (select * from oralv.t_doc@hotora where fk_doctp in (select id from oralv.t_doc_tp@hotora where cd in ('�������� ������ ����','����-�������')) order by dt1) -- �������� ��  
                LOOP 
              --3  
                 insert into ORALV.T_DOC 
                        values (
                                    null, get_doc_tp(12), 
                                    rec.name ,
                                    rec.npp,rec.v,rec.parent_id,rec.dt1,rec.dt2,rec.fk_log,rec.fk_cat,rec.fk_time,
                                    rec.fk_result, l_id_org,
                                    rec.place, rec.fault, rec.fk_wrkr, rec.s1,rec.s2,rec.s3,rec.dt3,rec.dt4,rec.fk_k_lsk,
                                    rec.mg, rec.reu, rec.kul, rec.nd, rec.kw, rec.lsk, rec.trest, rec.tp_1234, rec.uch,
                                    rec.fk_ext1, rec.ext1_count, rec.sm_n, rec.dt4_last, rec.fk_k_lsk_doc,1,rec.id
                                )  returning id into l_id_t_doc; --FK_DOC   ; --4
                  --4 �

                       IF l_id_type is not null then 
                         --5    
                               INSERT INTO oralv.u_meter_vol   
                               SELECT null,l_id_type, fk_meter, (select id from oralv.t_user where cd=l_user) as fk_user, l_id_t_doc as FK_DOC,
                                           dt1,dt2,vol1,summ1,vol2,summ2,vol3,summ3,
                                           (select to_char(sysdate,'yyyymm') from dual) as MG,dtf
                               FROM oralv.u_meter_vol@hotora where fk_doc=rec.id;         
                        ELSE 
                           l_err:='�� ������ id ��� ����- ����������� ����� (������� oralv.u_list). �������� - 4�';
                        END IF;
               END LOOP;                 
    END IF;
    /*������ ���� ��������� � ������ �������. (����� ����� ID �� ����� seq)*/
    IF p_var=2 then
    DELETE  from ORALV.U_METER_LOG; 
    DELETE  from ORALV.U_METER;
    DELETE  FROM ORALV.U_meter_vol where fk_doc 
             in (select id from ORALV.T_DOC WHERE fk_doctp in (select id from oralv.t_doc_tp where cd in('�������� ������ ����','����-�������')));
    DELETE  FROM ORALV.T_DOC WHERE fk_doctp in (select id from oralv.t_doc_tp where cd in('�������� ������ ����','����-�������'));
-- �������� ��������� ��� �������      
        FOR rec_t_doc in (select * from oralv.t_doc@hotora where coalesce(fk_time,0) not in ('17') and fk_doctp in (select id from oralv.t_doc_tp@hotora where cd in('�������� ������ ����','����-�������')) order by dt1) 
        LOOP 
          k:=0;  
          /*������� ��������� � ����� ���� � ��������� id */
            INSERT INTO ORALV.T_DOC 
            VALUES (
                        null, get_doc_tp(rec_t_doc.fk_doctp), 
                        rec_t_doc.name,
                        rec_t_doc.npp,rec_t_doc.v,rec_t_doc.parent_id,rec_t_doc.dt1,rec_t_doc.dt2,get_id_ulist(rec_t_doc.fk_log,'LOG'),rec_t_doc.fk_cat,get_id_ulist(rec_t_doc.fk_time,'PTIME'),
                        rec_t_doc.fk_result, l_id_org,
                        rec_t_doc.place, rec_t_doc.fault, rec_t_doc.fk_wrkr, rec_t_doc.s1,rec_t_doc.s2,rec_t_doc.s3,rec_t_doc.dt3,rec_t_doc.dt4,rec_t_doc.fk_k_lsk,
                        rec_t_doc.mg, rec_t_doc.reu, rec_t_doc.kul, rec_t_doc.nd, rec_t_doc.kw, rec_t_doc.lsk, rec_t_doc.trest, rec_t_doc.tp_1234, rec_t_doc.uch,
                        rec_t_doc.fk_ext1, rec_t_doc.ext1_count, rec_t_doc.sm_n, rec_t_doc.dt4_last, rec_t_doc.fk_k_lsk_doc,1,rec_t_doc.id
                    )  returning id into l_id_t_doc; --FK_DOC   ; --4
            ADD_LOG ('�������� ��������' || rec_t_doc.id);    
                   FOR rec_mv in (select * from oralv.u_meter_vol@hotora where fk_doc =rec_t_doc.id order by id)  --�������� ��� ������ �� ������ �� ���������
                   LOOP
                        /*�������� (� ������ ����) - ���� �� ���������� ������� � ������ ������..��� �� ���.. �� �������� ����.*/
                            -- ������� ������ (���) � ������ ���� � ��������  ����������� �������- �����
                           -- � ��� �� ������� fk_k_lsk ������� � ����� ���� ����� ���������� �� ��� ��� ��.
                        SELECT count (*), ch_hot.reu, ch_hot.kul, ch_hot.nd, 
                                     ml.fk_hfpar, ch.fk_k_lsk, ml.id, ml.cd
                                     INTO l_cnt, l_reu,l_kul, l_nd, l_fk_hfpar_old, l_fk_k_lsk,  l_ml_id_old, l_ml_cd_old
                        FROM  oralv.u_meter_log@hotora ml, 
                                  oralv.u_meter@hotora m, 
                                  oralv.u_meter_vol@hotora mv,
                                  oralv.c_houses@hotora ch_hot,
                                  oralv.c_houses ch,
                                  oralv.k_lsk k, 
                                  oralv.t_addr_tp tp
                        WHERE 
                               ml.fk_klsk_obj= ch_hot.fk_k_lsk
                        and  m.fk_meter_log=ml.id
                        and  m.id=MV.FK_METER
                        and  mv.id=rec_mv.id--11607513
                        and  ch.reu=ch_hot.reu
                        and  ch.kul=ch_hot.kul
                        and  ch.nd=ch_hot.nd
                        and  ch.fk_k_lsk=k.id
                        and  k.fk_addrtp = tp.id
                        and  tp.id in (select id from oralv.t_addr_tp where cd='���')
                        group by ch_hot.reu, ch_hot.kul, ch_hot.nd, ch.fk_k_lsk, ch_hot.fk_k_lsk, ml.fk_hfpar, ml.id, ml.cd;
                        -- �������: rec_mv.id=11607513   
                        -- �����:  J2    0779    00033�    889935    1643 fk_k_lsk =345618, id =8243857
                        -- ������� ���������� ������� � ����� ����.
                       /*���� ��������� �� ������ �� ����� ������� � ����� ���� �� ������� ������� ������ � CD*/
                       SELECT coalesce(COUNT(*),1) 
                                INTO L_ml_have 
                       FROM oralv.u_meter_log  
                       WHERE decode(l_fk_hfpar_old,1643,L_GW_ID,1702, l_OTOP_ID)=fk_serv
                        and fk_klsk_obj=l_fk_k_lsk and cd=l_ml_cd_old;
                       
                              /*���� ������� ���� ����� ��������� ���� �� ���������� �������,����������� �� ����������*/
                              IF l_ml_have>0 THEN
                              --������� id ������������� ����������� ��������
                                 SELECT id INTO l_id_ml 
                                   FROM oralv.u_meter_log  
                                 WHERE decode(l_fk_hfpar_old,1643,L_GW_ID,1702, l_OTOP_ID)=fk_serv
                                    and fk_klsk_obj=l_fk_k_lsk and cd=l_ml_cd_old;
                               -- ��������� ���� �� ����� �������     
                                  SELECT coalesce(COUNT(*),1)  
                                            INTO L_meter_have--, l_id_meter 
                                  FROM oralv.u_meter
                                  WHERE fk_meter_log=l_id_ml; --���� �� ��� dt1 � dt2
                                  IF l_meter_have>0 THEN
                                      SELECT id INTO l_id_meter 
                                      FROM oralv.u_meter
                                      WHERE fk_meter_log=l_id_ml; --���� �� ��� dt1 � dt2
                                  END IF; 
                              ELSE
                              l_ml_have:=0;    
                              l_meter_have:=0;
                              END IF; 
                             
                       FOR rec_ml in C_ML (l_ml_id_old) loop
                           IF l_ml_have=0 then 
                                INSERT INTO oralv.u_meter_log
                                values 
                                (null, rec_ml.cd, decode(rec_ml.fk_hfpar,1643,L_GW_ID,1702, l_OTOP_ID),
                                 rec_ml.fk_k_lsk, rec_ml.parent_id, rec_ml.dt1, rec_ml.dt2,  -- parent id ���� ������ ������� �� ��������������, k - ��� ��������.
                                 get_user_id(rec_ml.fk_user,NULL), 
                                 rec_ml.dtf, l_fk_k_lsk, rec_ml.name, --l_fk_k_lsk(������ �� ������ �� ������� ���� � c_houses) ����������� � ���� fk_klsk_obj -  
                                 l_id_m3, l_id_giga, l_id_giga_m2) RETURNING id INTO l_id_ml;--id ����� ����������� ��� � ML
                          END IF;
                                  --������� ���������� �������
                                   FOR rec_m in C_M (l_ml_id_old) loop
                                      IF l_meter_have=0 THEN
                                            INSERT INTO oralv.u_meter
                                            values 
                                            (null, rec_m.fk_k_lsk, l_id_ml,
                                             get_user_id(rec_m.fk_user,null), 
                                             rec_m.dtf) RETURNING id INTO l_id_meter;--id ����� ����������� ��� � u_Meter
                                      END IF;   
                                             --������� ������ �� ��������
                                             INSERT INTO oralv.u_meter_vol
                                               VALUES 
                                                (null, l_id_type,l_id_meter, get_user_id(rec_mv.fk_user,null),
                                                    l_id_t_doc, rec_mv.dt1, rec_mv.dt2, rec_mv.vol1,
                                                    rec_mv.summ1,rec_mv.vol2,rec_mv.summ2,rec_mv.vol3,rec_mv.summ3,
                                                    rec_t_doc.mg, rec_mv.dtf
                                                );
                                   END LOOP; -- CM
                       END LOOP;      --C_ML
                       k:=k+1;
                       IF k mod 1000=0 then ADD_LOG ('��������� �����'|| k ||' �� ���������-' || rec_t_doc.id);
                       END IF;
                   END LOOP;--MV
        END LOOP;--T_DOC
    END IF;
    COMMIT;
    -------------------------------------------------------------------------------------------------
    /*�������� ��������� ���*/
    BEGIN
    IF p_var=3 THEN

    
        FOR rec_kart IN (
                                  SELECT ka.reu,ka.kul,ka.nd, ka.kw, ka.lsk, lk_h.VVOD, lk_h.VVOD_GW ,lk_h.VVOD_OT, lk_h.VVOD_EL, -- ad.name,
-- kl.*, ad.*,
                                              lk_h.SCHEL_DT, NOMSCH, 
                                              lk_h.DT_POVHW, lk_h.DT_POVGW, lk_h.DTPOVHW, lk_h.DTPOVGW, lk_h.NOM_SCHW, lk_h.NOM_SCGW, 
                                              lk_h.PGW, lk_h.PHW, lk_h.PSCH_DT, lk_h.PSCH_DTG,
                                              lk_h.MHW, lk_h.MGW, lk_h.PEL, lk_h.MEL,  ok.k_lsk_id as k_lsk_id
                                    FROM oralv.kart@hotora ka, --oralv.k_lsk@hotora kl, ORALV.T_ADDR_TP ad, 
                                              scott.load_kart@hotora lk_h, ORALV.KART ok
                                  WHERE-- ka.k_lsk_id=kl.id 
                                       --and AD.ID=kl.FK_ADDRTP 
                                             ka.lsk=lk_h.lsk 
                                      and Ok.lsk=ka.lsk
                                ) -- select * from oralv.kart@hotora where reu='11'
        LOOP    
        
/*        select count(*) from oralv.kart
        union all
        select count(*) from scott.kart@hotora
        union all
        select count(*) from scott.load_kart@hotora
        union all
        select count(*) from oralv.kart@hotora*/
        
      /*  SELECT 
         FROM oralv.u_meter_log ml, --oralv.c_houses ch, 
                    oralv.t_addr_tp ad
        WHERE ad.cd='���'
             and ad.id=ch 
        select * from oralv.k_lsk@hotora where id=1040284
        select * from oralv.t_addr_tp@hotora where id=12*/

        --//������� ������ �� ������ ���� ��� �� � ��. ��� ��� �� ��-�� ���� ������ ������.
        u_meter_mig.get_parent_id(
                            p_reu=>rec_kart.reu, 
                            p_kul=>rec_kart.kul, 
                            p_nd=>rec_kart.nd, 
                            p_vvod=>rec_kart.vvod_gw, 
                            p_parent_ml=>L_parent_ml, 
                            p_k_lsk_obj=>l_fk_k_lsk, 
                            p_serv=>l_gw_id) ;
         -- ������� ��������� ����� �������� �� ������� ����
           ORALV.P_METER.U_METER_LOG_INS_UPD
               (
                    P_IR => ir--P_IR OUT NUMBER--��� ��������: =0 - �������� ����������
                  , P_ID => l_id_ml--, P_ID IN OUT U_METER_LOG.id%TYPE--! ID ��������� ������
                  , P_CD => l_gw_id
                  , P_FK_KLSK_OBJ => rec_kart.k_lsk_id
                  , P_FK_SERV => l_gw_id --, FK_SERV  IN U_METER_LOG.fk_hfpar%TYPE:= NULL--!! ������

                  , P_DT1 => coalesce(rec_kart.psch_dt,sysdate)--, P_DT1 IN U_METER_LOG.DT1%TYPE:= NULL--!! ���� ������ ������� ��� ����������� ��������  
                  , P_DT2 => to_date('20990101', 'YYYYMMDD')--, P_DT2 IN U_METER_LOG.DT2%TYPE:= NULL--!! ���� ��������� ������� ��� ����������� ��������
                  
                  , P_PARENT_ID => l_parent_ml--, P_PARENT_ID IN U_METER_LOG.PARENT_ID%TYPE:= NULL
                  , P_NAME => '����������'--, P_NAME IN U_METER_LOG.NAME%TYPE:= NULL--������������ ��� �������
                  , P_FK_UNIT1 => l_id_m3--, P_FK_UNIT1 IN U_METER_LOG.FK_UNIT1%TYPE:= NULL--!! ����������� 1-� ������������ ������
                  , P_FK_UNIT2 => l_id_giga--, P_FK_UNIT2 IN U_METER_LOG.FK_UNIT2%TYPE:= NULL--����������� 2-� ������������ ������
                  , P_FK_UNIT3 => l_id_giga_m2--, P_FK_UNIT3 IN U_METER_LOG.FK_UNIT3%TYPE:= NULL--����������� 3-� ������������ ������
                  , P_IS_UPDATEBLE =>0                  
                  , P_IS_COMMIT => 1--, PIS_COMMIT IN NUMBER:= 0--��������� COMMIT, ���� = 1
               );              
              
           IF ir IN ( 0, 4) THEN
                l_id_meter:=0;
                oralv.P_METER.u_meter_ins_upd
               ( 
                    P_IR => ir
                  , P_ID => l_id_meter
                  , P_IS_UPDATEBLE => 0
                  , P_FK_METER_LOG => l_id_ml
              --    , P_DT1 =>to_date('20990101', 'YYYYMMDD')--rec_kart.psch_dtg-- to_date('20130101', 'YYYYMMDD') --���� ���������(������������) �� ��� ����
              --    , P_DT2 => to_date('20990101', 'YYYYMMDD')
                  , P_IS_COMMIT => 1
               ); 
          --��������� ������� ������ ��������.  
            oralv.p_meter.U_METER_EXS_INS_UPD
              (   P_IR=> ir
                 , P_ID => l_id_meter --????? - l_id_meter
                 , P_IS_UPDATEBLE => 0
                 , P_FK_METER => l_id_meter
                 , P_DT1 => rec_kart.psch_dtg
                 , P_DT2 => to_date('20990101', 'YYYYMMDD')
                 , P_IS_COMMIT => 1--��������� COMMIT, ���� = 1
              );

           END IF;
                                     
        END LOOP;                        
    END IF;--p_var=3
  EXCEPTION
  WHEN OTHERS THEN
       BEGIN
         ROLLBACK;
       --  CLOSE c_d;
           dbms_output.put_line('ERRcode - '||SQLCODE||' -ERRmsg- '||SQLERRM);
        -- ADD_LOG('ERRcode - '||SQLCODE||' -ERRmsg- '||SQLERRM);      
        -- scott.logger.log_(sysdate,'������ ���������� �����!!!'|| 'ERRcode - '||SQLCODE||' -ERRmsg- '||SQLERRM);
       END;
  END;-- begin if p_var=3
   
  EXECUTE IMMEDIATE 'alter sequence oralv.seq_base cache 100'; --���������� ��� ������������������
END;
    
PROCEDURE get_parent_id(p_reu  varchar2, p_kul varchar2, p_nd varchar2 
                                        , p_vvod  varchar2 -- ����� ����� � �������� �����.. ����� ������� �� ������ ����� � ����������� �� ������.
                                        , p_parent_ml OUT oralv.U_METER_LOG.ID%TYPE  -- ��� ������ ��� ��� ����� ���-�� ��� ������ id ��� ����� ������ �������� ��� 
                                        , p_k_lsk_obj OUT oralv.U_METER_LOG.FK_KLSK_OBJ%TYPE
                                        , p_serv IN number)
IS
BEGIN
    SELECT ml.id, ch.fk_k_lsk-- , ad.name, reu, kul, nd, ml.cd, ml.fk_serv 
                into p_parent_ml, p_k_lsk_obj
      FROM oralv.c_houses ch,
               oralv.k_lsk kl, oralv.t_addr_tp ad, oralv.u_meter_log ml
    WHERE 
               ad.id=kl.fk_addrtp
        AND ml.fk_klsk_obj=kl.id
        AND kl.id=ch.fk_k_lsk
        AND upper(ad.cd)='���'
        AND ml.fk_serv=p_serv
        AND ch.reu=p_reu
        AND ch.kul=p_kul
        AND ch.nd=p_nd 
        and ml.cd=p_vvod;
      -- and ch.reu='16'
     --   and ch.kul='0109'
       -- and ch.nd='000006';
END;

FUNCTION GET_DOC_TP (p_id oralv.t_doc_tp.id@hotora%type) return number
  IS
  l_id_doc_tp number:=null;
BEGIN  
    SELECT a.id into l_id_doc_tp FROM oralv.t_doc_tp a, oralv.t_doc_tp@hotora b 
    WHERE a.cd=b.cd and b.id=p_id;
    RETURN l_id_doc_tp;
END;        
-- -------------------
-- ��������� ������� ������ � ���
PROCEDURE ADD_LOG (p_msg log_parser.msg%type)
   IS
   PRAGMA AUTONOMOUS_TRANSACTION;
BEGIN
     INSERT INTO vaflia.log_parser (msg) VALUES (p_msg);
     COMMIT;
END; 


FUNCTION get_user_id(p_id number,p_cd varchar2 ) return number
    is
    l_id number;
BEGIN
   IF p_id is not null  then
           SELECT ub.id into l_id 
           FROM ORALV.T_USER@HOTORA UH, ORALV.T_USER UB  
           WHERE  uh.id=p_id
           and uh.cd=ub.cd;
          return  l_id;
    ELSE
          IF p_cd='ORALV' then
               SELECT ub.id 
                    into  l_id 
                 FROM ORALV.T_USER UB  
               WHERE ub.cd= 'ORALV';
              return  l_id;
          ELSE   
               SELECT ub.id 
                    into  l_id 
                 FROM ORALV.T_USER UB  
               WHERE ub.cd= (select user from dual);
              return  l_id;  
          END IF;
   END IF;       
end;
    
FUNCTION get_id_ulist (p_id number, p_cd varchar2) return number
    is
    l_id number;
BEGIN 
           SELECT coalesce(u.id,null) into l_id 
           FROM ORALV.u_list@HOTORA U_H, ORALV.U_listtp@HOTORA LTP_H,  
                    ORALV.u_list U, ORALV.u_listtp LTP
           WHERE  u_h.id=p_id
           AND u_h.fk_listtp=ltp_h.id
           AND U_H.cd=U.cd
           AND ltp_h.cd=LTP.cd
           AND ltp_h.cd=p_cd;
        RETURN  l_id;
END;    
END u_meter_mig;
/
