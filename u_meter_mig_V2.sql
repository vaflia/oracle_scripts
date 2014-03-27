CREATE OR REPLACE package body  vaflia.u_meter_mig IS
 
    PROCEDURE imp_MV (P_var number)
    IS
    /*CREATE by VAFLIA 12.09.2013 */
    --!!!! ПЕРЕДЕЛАТЬ ВСЕ СТАНДАРТНЫЕ ТИПЫ НА %TYPE!!!!
            l_imp_type integer; --1 импорт тупо, 2-- импорт с заменой всех id
            l_cnt number; -- для разных проверок на кол строк
        /*return id*/
            l_id_t_doc    number;--t_doc
            l_id_ml        number; --u_meter_log
            l_id_meter   number; --u_meter
            l_id_meter_vol   number; --u_meter_vol
            L_parent_ml number; -- u_meter_log.parent_id
            l_id_exs       number;
            l_meter_vol_fk_type   oralv.u_meter_vol.fk_type%TYPE; --Фактический объем
            l_meter_vol_fk_type2 oralv.u_meter_vol.fk_type%TYPE;  --показание счетчика
            /*return values for U_METER / hfpxklsk  */
            l_hfpxklsk_id                     oralv.u_hfpxklsk.id%TYPE:= NULL;
            l_hfpxklsk_pfk_hfp             oralv.u_hfpxklsk.fk_hfp%TYPE:=null;
            l_meter_fk_k_lsk               oralv.k_lsk.id%type:= NULL;
            l_hfpxklsk_pdt1                 oralv.u_hfpxklsk.dt1%TYPE:=NULL;
            l_hfpxklsk_pdt2                 oralv.u_hfpxklsk.dt2%TYPE:=NULL;
          --значение
        /*end treturn id*/
        l_reu        ORALV.C_HOUSES.REU%type;
        l_kul         ORALV.C_HOUSES.kul%type;
        l_nd         ORALV.C_HOUSES.nd%type;
        l_nd_klsk  ORALV.C_HOUSES.FK_K_LSK%type;
        l_kw_klsk  ORALV.C_HOUSES.FK_K_LSK%type;
        l_lsk_klsk  ORALV.C_HOUSES.FK_K_LSK%type;
        l_ml_id_old number; -- id из хоторы
        l_fk_hfpar_old number;
        l_hw_id number;   --холодная вода ID услуги
        l_gw_id number;   --горячая вода ID услуги
        l_otop_id number; --отопление ID услуги
        l_el_id number;     --электричество ID услуги
        l_user number; 
        l_id_m3           oralv.d_serv.FK_UNIT1%TYPE;  -- id ед.изм из u_list
        l_id_giga         oralv.d_serv.FK_UNIT2%TYPE;-- id ед.изм из u_list
        l_id_giga_m2   oralv.d_serv.FK_UNIT3%TYPE;-- id ед.изм из u_list
        l_uslm_gw  varchar2(10):='008';
        l_uslm_hw  varchar2(10):='006';
        l_uslm_el  varchar2(10):='015';
        l_id_org number; -- id  орг-ии из t_org
        l_id_type number; -- id вида записи объема из u_list
        L_ml_have number; --наличие логич счетчика в новой базе
        L_meter_have number; --наличие физич счетчика в новой базе
        l_ml_cd_old varchar2(100); --cd счетчика в старой базе 
        l_err varchar2(1000);
        ir NUMBER; --окд возврата
        k number; --счетчики
        t number; --счетчики
        i number; --счетчики (итерация лупа ИПУ)
        
        Cursor C_ML (p_id in oralv.u_meter_log.id%type) is
        SELECT * FROM oralv.u_meter_log@hotora where id=p_id;
        
        Cursor C_M (p_id in oralv.u_meter.id%type) is
        SELECT * FROM oralv.u_meter@hotora where fk_meter_log=p_id;
        
        Cursor C_GRSC (p_uslm in varchar2, 
                                p_lsk in oralv.kart.lsk%type                                        
                                ) IS
        SELECT  * FROM ldo.sp_grsc@hotora
        WHERE uslm=p_uslm and lsk=p_lsk;
 /*-------------------------------------------------------------------------------------------------------------------------------------------------------------*/       
    BEGIN  
    --очищаем лог
    DBMS_OUTPUT.disable;
    DBMS_OUTPUT.enable;
    dbms_output.put_line('начало-'||to_char (sysdate,'hh24:MI:SS'));
    execute immediate 'truncate table vaflia.log';
    EXECUTE IMMEDIATE 'alter sequence oralv.seq_base cache 15000'; --устанавливаем кэш последовательности для интенсивной вставки
    SELECT max(CASE WHEN UPPER(CD)='ХОЛОДНАЯ ВОДА' THEN ID END) AS a,
                max(CASE WHEN UPPER(CD)='ГОРЯЧАЯ ВОДА' THEN ID END) AS b,
                max(CASE WHEN UPPER(CD)='ОТОПЛЕНИЕ' THEN ID END) AS c,
                max(CASE WHEN UPPER(CD)='ЭЛЕКТРОСНАБЖЕНИЕ' THEN ID END) AS d
               INTO L_HW_ID,L_GW_ID, L_OTOP_ID, L_EL_ID 
               FROM (SELECT distinct CD,id FROM ORALV.D_SERV WHERE UPPER(CD) IN ('ХОЛОДНАЯ ВОДА','ГОРЯЧАЯ ВОДА','ОТОПЛЕНИЕ','ЭЛЕКТРОСНАБЖЕНИЕ'));

    SELECT id into l_id_m3 from ORALV.V_METER_VOL_UNIT where cd in ('м3'); 
    SELECT id into l_id_giga from ORALV.V_METER_VOL_UNIT where cd in ('гигакалория');
    SELECT id into l_id_giga_m2 from ORALV.V_METER_VOL_UNIT where cd in ('ГКал/м2');      
    SELECT id into l_id_type from ORALV.V_METER_VOL_TYPE where trim(cd)='Фактический объем';    --фактически занесенный объем по ОДПУ     
    SELECT id into l_id_org      FROM oralv.t_org where cd='МП "РИЦ"';
    SELECT t.id INTO l_meter_vol_fk_type FROM oralv.u_list t 
     WHERE t.cd='Фактический объем' AND t.fk_listtp=(SELECT tp.id FROM oralv.u_listtp tp WHERE tp.cd='METER_VOL_TYPE');    
    SELECT t.id INTO l_meter_vol_fk_type2 FROM oralv.u_list t 
     WHERE t.cd='Показание счетчика' AND t.fk_listtp=(SELECT tp.id FROM oralv.u_listtp tp WHERE tp.cd='METER_VOL_TYPE');  
    
    --НЕ ИСПОЛЬЗОВАТЬ! 
    /*ИМПОРТ ОДПУ ПОСТРОЧНО В КАЖДУЮ ТАБЛИЦУ. (везде новые ID из новых seq)*/
    IF p_var=2 then
    DELETE  from ORALV.U_METER_LOG; 
    DELETE  from ORALV.U_METER;
    DELETE  FROM ORALV.U_meter_vol where fk_doc 
             in (select id from ORALV.T_DOC WHERE fk_doctp in (select id from oralv.t_doc_tp where cd in('Итоговый реестр ОДПУ','Счет-фактура')));
    DELETE  FROM ORALV.T_DOC WHERE fk_doctp in (select id from oralv.t_doc_tp where cd in('Итоговый реестр ОДПУ','Счет-фактура'));
-- выбираем документы для импорта      
        FOR rec_t_doc in (select * from oralv.t_doc@hotora where coalesce(fk_time,0) not in ('17') and fk_doctp in (select id from oralv.t_doc_tp@hotora where cd in('Итоговый реестр ОДПУ'/*,'Счет-фактура'*/)) order by dt1) 
        LOOP 
          k:=0;  
          /*вставка документа в новую базу с возвратом id */
            INSERT INTO ORALV.T_DOC 
            VALUES (
                        null, get_doc_tp(rec_t_doc.fk_doctp), 
                        rec_t_doc.name,
                        rec_t_doc.npp,rec_t_doc.v,rec_t_doc.parent_id,rec_t_doc.dt1,rec_t_doc.dt2,decode(get_id_ulist(rec_t_doc.fk_log,'LOG'),0,null),rec_t_doc.fk_cat,
                        decode(get_id_ulist(rec_t_doc.fk_time,'PTIME'),0,null),
                        rec_t_doc.fk_result, l_id_org,
                        rec_t_doc.place, rec_t_doc.fault, rec_t_doc.fk_wrkr, rec_t_doc.s1,rec_t_doc.s2,rec_t_doc.s3,rec_t_doc.dt3,rec_t_doc.dt4,rec_t_doc.fk_k_lsk,
                        rec_t_doc.mg, rec_t_doc.reu, rec_t_doc.kul, rec_t_doc.nd, rec_t_doc.kw, rec_t_doc.lsk, rec_t_doc.trest, rec_t_doc.tp_1234, rec_t_doc.uch,
                        rec_t_doc.fk_ext1, rec_t_doc.ext1_count, rec_t_doc.sm_n, rec_t_doc.dt4_last, rec_t_doc.fk_k_lsk_doc,1,rec_t_doc.id
                    )  returning id into l_id_t_doc; --FK_DOC   ; --4
            ADD_LOG ('вставлен документ' || rec_t_doc.id);    
                   FOR rec_mv in (select * from oralv.u_meter_vol@hotora where fk_doc =rec_t_doc.id order by id)  --выбираем все объемы из хоторы по документу
                   LOOP
                        /*проверка (в старой базе) - есть ли логический счетчик у записи объема..как бэ зря.. он полюбому есть.*/
                            -- находим объект (дом) в старой базе к которому  принадлежит счетчик- объем
                           -- и тут же находим fk_k_lsk объекта в новой базе через соединения по рэу кул нд.
                        SELECT count (*), ch_hot.reu, ch_hot.kul, ch_hot.nd, 
                                     ml.fk_hfpar, ch.fk_k_lsk, ml.id, ml.cd
                                     INTO l_cnt, l_reu,l_kul, l_nd, l_fk_hfpar_old, l_nd_klsk,  l_ml_id_old, l_ml_cd_old
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
                        and  tp.id in (select id from oralv.t_addr_tp where cd='Дом')
                        group by ch_hot.reu, ch_hot.kul, ch_hot.nd, ch.fk_k_lsk, ch_hot.fk_k_lsk, ml.fk_hfpar, ml.id, ml.cd;
                        -- входной: rec_mv.id=11607513   
                        -- ответ:  J2    0779    00033а    889935    1643 fk_k_lsk =345618, id =8243857
                        -- создаем логический счетчик в новой базе.
                       /*НАДО ПРОВЕРИТЬ НЕ СОЗДАН ЛИ ЛОГИЧ СЧЕТЧИК В НОВОЙ БАЗЕ ПО ДАННОМУ ОБЪЕКТУ УСЛУГЕ И CD*/
                       SELECT coalesce(COUNT(*),1) 
                                INTO L_ml_have 
                       FROM oralv.u_meter_log  
                       WHERE decode(l_fk_hfpar_old,1643,L_GW_ID,1702, l_OTOP_ID)=fk_serv
                        and fk_klsk_obj=l_nd_klsk and cd=l_ml_cd_old;
                       
                              /*если счетчик есть тогда проверяем есть ли физический счетчик,ссылающийся на логический*/
                              IF l_ml_have>0 THEN
                              --получим id существующего логического счетчика
                                 SELECT id INTO l_id_ml 
                                   FROM oralv.u_meter_log  
                                 WHERE decode(l_fk_hfpar_old,1643,L_GW_ID,1702, l_OTOP_ID)=fk_serv
                                    and fk_klsk_obj=l_nd_klsk and cd=l_ml_cd_old;
                               -- проверяем есть ли физич счетчик     
                                  SELECT coalesce(COUNT(*),1)  
                                            INTO L_meter_have--, l_id_meter 
                                  FROM oralv.u_meter
                                  WHERE fk_meter_log=l_id_ml; --сюда бы еще dt1 и dt2
                                  IF l_meter_have>0 THEN
                                      SELECT id INTO l_id_meter 
                                      FROM oralv.u_meter
                                      WHERE fk_meter_log=l_id_ml; --сюда бы еще dt1 и dt2
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
                                 rec_ml.fk_k_lsk, rec_ml.parent_id, rec_ml.dt1, rec_ml.dt2,  -- parent id пока пустой поэтому не заморачиваемся, k - это свойства.
                                 get_user_id(rec_ml.fk_user,NULL), 
                                 rec_ml.dtf, l_nd_klsk, rec_ml.name,null,null --l_fk_k_lsk(ссылка на объект из текущий базы в c_houses) вставляется в поле fk_klsk_obj -  
                                 ) RETURNING id INTO l_id_ml;--id новой вставленной зап в ML
                          END IF;
                                  --создаем физический счетчик
                                   FOR rec_m in C_M (l_ml_id_old) loop
                                      IF l_meter_have=0 THEN
                                            INSERT INTO oralv.u_meter
                                            values 
                                            (null, rec_m.fk_k_lsk, l_id_ml,
                                             get_user_id(rec_m.fk_user,null), 
                                             rec_m.dtf,0,0,0,null,null) RETURNING id INTO l_id_meter;--id новой вставленной зап в u_Meter
                                      END IF;   
                                             --создаем объемы по счетчику
                                             INSERT INTO oralv.u_meter_vol
                                               VALUES 
                                                (null, l_id_type,l_id_meter, get_user_id(rec_mv.fk_user,null),
                                                    l_id_t_doc, rec_mv.dt1, rec_mv.dt2, rec_mv.vol1,
                                                    rec_mv.summ1,rec_mv.vol2,rec_mv.summ2,rec_mv.vol3,rec_mv.summ3,
                                                    rec_t_doc.mg, rec_mv.dtf,null,null
                                                );
                                   END LOOP; -- CM
                       END LOOP;      --C_ML
                       k:=k+1;
                       IF k mod 1000=0 then ADD_LOG ('вставлено строк'|| k ||' по документу-' || rec_t_doc.id);
                       END IF;
              END LOOP;--MV
        END LOOP;--T_DOC
    END IF;
    COMMIT;
    /*---------------------------------------------------------------------------------------------*/
    -- ЗАГРУЗКА СЧЕТЧИКОВ ОДПУ ПО ГВ И ОТОПЛ ЧЕРЕЗ ПАКЕТ P_METER2
 BEGIN   
 IF P_var= 4 THEN 
          L_parent_ml   :=null;
          l_id_meter    :=null;
          l_id_ml       :=null;
          l_id_exs      :=null;
          l_id_meter_vol:=null;
          ir:=0;
          
     DELETE FROM oralv.U_METER_VOL;DELETE FROM oralv.U_METER_EXS;DELETE FROM oralv.U_METER;DELETE FROM oralv.U_METER_LOG;
     DELETE  FROM ORALV.U_METER_LOG ml
           WHERE
                 exists (select fk_meter_log from ORALV.U_METER m where 
                  exists ( select  * FROM ORALV.U_meter_vol mv where fk_doc 
                                 in (select id from ORALV.T_DOC 
                                      WHERE fk_doctp in (select id from oralv.t_doc_tp where cd in('Итоговый реестр ОДПУ','Счет-фактура'))
                                    )
                                 and mv.fk_meter=m.id   
                 ) and ml.id=m.fk_meter_log
              ) 
              ; 
             DELETE  from ORALV.U_METER_EXS m where 
              exists ( select  * FROM ORALV.U_meter_vol mv where fk_doc 
                             in (select id from ORALV.T_DOC 
                                  WHERE fk_doctp in (select id from oralv.t_doc_tp where cd in('Итоговый реестр ОДПУ','Счет-фактура'))
                                )
                             and mv.fk_meter=m.fk_meter  
             );
           DELETE  from ORALV.U_METER m where 
              exists ( select  * FROM ORALV.U_meter_vol mv where fk_doc 
                             in (select id from ORALV.T_DOC 
                                  WHERE fk_doctp in (select id from oralv.t_doc_tp where cd in('Итоговый реестр ОДПУ','Счет-фактура'))
                                )
                             and mv.fk_meter=m.id   
           );
          DELETE  FROM ORALV.U_meter_vol where fk_doc 
                   in (select id from ORALV.T_DOC WHERE fk_doctp in (select id from oralv.t_doc_tp where cd in('Итоговый реестр ОДПУ','Счет-фактура')));
                   
          DELETE  FROM ORALV.T_DOC WHERE fk_doctp in (select id from oralv.t_doc_tp where cd in('Итоговый реестр ОДПУ','Счет-фактура'));
         
-- выбираем документы для импорта      
   FOR rec_t_doc in (select * from oralv.t_doc@hotora where coalesce(fk_time,0) not in ('17') and fk_doctp in (select id from oralv.t_doc_tp@hotora 
                        where cd in('Итоговый реестр ОДПУ','Счет-фактура')) and id IN(264243)
                      order by dt1) 
                      
                     /*  null-198523,
                        null-198687,198708,198737,198750,198965,200852,201264,201288,201544,201550,
                        +  201867,202967+,202977+,202978+,203138+,204659+,205477+,210384+,210386+,210388+,211305+,211979+,2+-19362,220065,221350,221573,221994,221995,225454,226127,
                        +- 226206,226476,229546,232519,233533,234432,234481,240350,240850,248104,252968,253179,253360,253741,254121,
                        +  на все 256544,256950,258048,258052,258054,258072,258077,258081,263145,263591,263594,270662,272233,276148*/
   LOOP  
            k:=0;  
             /*вставка документа в новую базу с возвратом id */
            l_id_t_doc:=null;
            INSERT INTO ORALV.T_DOC 
            VALUES (
                        null, get_doc_tp(rec_t_doc.fk_doctp), 
                        rec_t_doc.name,
                        rec_t_doc.npp,rec_t_doc.v,rec_t_doc.parent_id,rec_t_doc.dt1,rec_t_doc.dt2,
                     --   decode(get_id_ulist(rec_t_doc.fk_log,'LOG'),0,null),
                        get_id_ulist(rec_t_doc.fk_log,'LOG')
                       ,rec_t_doc.fk_cat,
                     --   decode(get_id_ulist(rec_t_doc.fk_time,'PTIME'),0,null),
                        get_id_ulist(rec_t_doc.fk_time,'PTIME'),
                        rec_t_doc.fk_result, l_id_org,
                        rec_t_doc.place, rec_t_doc.fault, rec_t_doc.fk_wrkr, rec_t_doc.s1,rec_t_doc.s2,rec_t_doc.s3,rec_t_doc.dt3,rec_t_doc.dt4,rec_t_doc.fk_k_lsk,
                        rec_t_doc.mg, rec_t_doc.reu, rec_t_doc.kul, rec_t_doc.nd, rec_t_doc.kw, rec_t_doc.lsk, rec_t_doc.trest, rec_t_doc.tp_1234, rec_t_doc.uch,
                        rec_t_doc.fk_ext1, rec_t_doc.ext1_count, rec_t_doc.sm_n, rec_t_doc.dt4_last, rec_t_doc.fk_k_lsk_doc,1,rec_t_doc.id
                    )  returning id into l_id_t_doc; --FK_DOC   ; --4
            ADD_LOG ('вставлен документ' || rec_t_doc.id);    
           FOR rec_mv in (select * from oralv.u_meter_vol@hotora where fk_doc =rec_t_doc.id order by id)  --выбираем все объемы из хоторы по документу
           LOOP
             --выбираем все сведения по логическому и физическому счетчику для послед вставки по пакету p_meter2
               FOR rec_attr in (SELECT ch_hot.reu, ch_hot.kul, ch_hot.nd, 
                                                     decode(ml.fk_hfpar,1643,L_GW_ID,1702, l_OTOP_ID) as usl, 
                                                     ch.fk_k_lsk as nd_klsk,
                                                     ml.cd as vvod,
                                                     GW.DAT_NACH,
                                                     gw.dat_end,
                                                     gw.sch,
                                                     gw.tip
                                          FROM  oralv.u_meter_log@hotora ml, 
                                                    oralv.u_meter@hotora m, 
                                                    oralv.u_meter_vol@hotora mv,
                                                    oralv.c_houses@hotora ch_hot,
                                                    ldo.load_gw@hotora gw,
                                                    (SELECT reu, kul, nd, ch.fk_k_lsk 
                                                       FROM  oralv.c_houses ch, oralv.k_lsk k, oralv.t_addr_tp ad
                                                     WHERE k.id=ch.fk_k_lsk
                                                          and k.fk_addrtp=ad.id
                                                          and ad.cd='Дом'
                                                    ) ch        
                --                     oralv.k_lsk k, 
                --                     oralv.t_addr_tp tp
                                        WHERE  
                                                   ml.fk_klsk_obj = ch_hot.fk_k_lsk
                                            and  m.fk_meter_log = ml.id
                                            and  m.id = MV.FK_METER
                                            and  mv.id=rec_mv.id--14031561
                                            and  ch.reu = ch_hot.reu
                                            and  ch.kul = ch_hot.kul
                                            and  ch.nd = ch_hot.nd
                                            and  gw.reu= ch.reu
                                            and  gw.nd=ch.nd
                                            and  gw.kul=ch.kul
                                            and  gw.tip=decode(ml.fk_hfpar,1643, 3, 1702, 4,null)--1643, 1702
                                            and  ml.cd=GW.VVOD
                                            and  ch.nd='00031в'
                                            and  ch.kul='0039'
                   --                     and  ch.fk_k_lsk=k.id
                   --                     and  k.fk_addrtp = tp.id
                   --                     and  tp.id in (select id from oralv.t_addr_tp where cd='Дом')
                                       -- GROUP BY ch_hot.reu, ch_hot.kul, ch_hot.nd, ch.fk_k_lsk, ch_hot.fk_k_lsk, ml.fk_hfpar, ml.id, ml.cd
                                      )
               LOOP
                    l_parent_ml:=null;
                    l_id_ml:=null;
                    l_id_meter:=null;
                    l_id_meter_vol:=null;
                    l_id_exs:=null;
                    --фиксируем ошибку для дебага
                   IF rec_mv.id=13298679 then    
                              null;
                   end if;    
                  --узнаем есть ли СЧЕТЧИК на доме по услуге и вводу.
                    u_meter_mig.get_ml_have( 
                                        p_reu=>rec_attr.reu, 
                                        p_kul=>rec_attr.kul, 
                                        p_nd=>rec_attr.nd, 
                                        p_vvod=>rec_attr.vvod, 
                                        p_parent_ml=>l_id_ml, 
                                        p_k_lsk_obj=>rec_attr.nd_klsk,   -- закидываем сюда klsk дома, 
                                        p_serv=>rec_attr.usl);
                    --ЕСЛИ НЕТУ ЛОГИЧ СЧЕТЧИКА ТО СОЗДАЕМ ЕГО
                    IF l_id_ml IS null THEN 
                           ORALV.P_METER2.U_METER_LOG_INS_UPD
                           (
                                P_IR => ir--P_IR OUT NUMBER--код возврата: =0 - успешное завершение
                              , P_ID => l_id_ml
                              , P_FK_KLSK_OBJ => rec_attr.nd_klsk
                              , P_FK_SERV       => rec_attr.usl
                              , P_CD                => rec_attr.vvod
                              , P_DT1   => to_date('20000101', 'YYYYMMDD')  
                              , P_DT2   => to_date('20990101', 'YYYYMMDD')
                              , P_PARENT_ID    => null
                              , P_NAME => 'ОДПУ по услуге ' ||  rec_attr.usl || ' и вводу  ' || rec_attr.vvod 
                              , P_IS_UPDATEBLE => 0                 
                              , P_IS_COMMIT     => 1 --  -1 - вызов для проверки существования, без DML (и без COMMIT)
                                                              --   0 - DML без COMMIT
                                                              --   1 - DML и COMMIT
                           );  
                        --   l_parent_ml:=l_id_ml;
                        --   l_id_ml:=null;
                           IF ir<>0 then add_log ('ERRcode - '||SQLCODE||' -ERRmsg- '||SQLERRM||'.' ||rec_attr.nd_klsk,sysdate,i,356, ir);  end if;
                   /* ELSIF l_parent_ml is not null and ir=0  THEN
                      -- вставляем логический ОДПУ привязанный к фэйкуовому по вводу услуге
                      --(в fk_klsk_obj вставялем klsk дома-nd_klsk)
                       ORALV.P_METER2.U_METER_LOG_INS_UPD
                          (
                            P_IR => ir--P_IR OUT NUMBER--код возврата: =0 - успешное завершение
                          , P_ID => l_id_ml
                          , P_FK_KLSK_OBJ => rec_attr.nd_klsk
                          , P_FK_SERV       => rec_attr.usl
                          , P_CD                => rec_attr.vvod
                          , P_DT1   => to_date('20000101', 'YYYYMMDD')  
                          , P_DT2   => to_date('20990101', 'YYYYMMDD')
                          , P_PARENT_ID => l_parent_ml
                          , P_NAME => 'ОДПУ по услуге ' ||  rec_attr.usl || ' и вводу  ' || rec_attr.vvod 
                          , P_IS_UPDATEBLE => 0                  
                          , P_IS_COMMIT => 1 --  -1 - вызов для проверки существования, без DML (и без COMMIT)
                                                          --   0 - DML без COMMIT
                                                          --   1 - DML и COMMIT
                         ); IF ir<>0 then add_log ('ERRcode - '||SQLCODE||' -ERRmsg- '||SQLERRM||'.' ||rec_attr.nd_klsk,sysdate,i,350, ir);  end if;
                    END IF;*/         
            /*------------------------------------------------------------*/
            /*ЕСЛИ ЕСТЬ ЛОГИЧЕСКИЙ СЧЕТЧКИ ТО Выберем l_id_meter*/
                    ELSIF l_id_ml is not null then  
                       SELECT  id 
                         INTO l_id_meter 
                         FROM oralv.u_meter where fk_meter_log=l_id_ml;
                    END IF;   
            --2 - вставка физ счетчика если он есть или даже если нету, ПРИТОМ ЧТО ФИЗ СЧЕТЧИКА НЕТУ ПО ДАННОМУ ЛОГИЧ-МУ
                    IF ir=0 and l_id_meter is null THEN
                        l_meter_fk_k_lsk:=null;
                           oralv.p_meter2.U_METER_INS_UPD
                           ( 
                               P_IR => ir
                             , P_ID => l_id_meter
                             , P_IS_UPDATEBLE => 1
                             , P_FK_METER_LOG => l_id_ml
                             , P_DT => trunc(sysdate,'mm')   -- дата P_DT1(начало периода показания(объема)
                             , P_FK_K_LSK => l_meter_fk_k_lsk
                             , P_IS_UNIT1 => 1
                             , P_IS_UNIT2 => 1
                             , P_IS_UNIT3 => 1
                             , P_IS_COMMIT => 1
                           ); 
                       IF ir<>0 then add_log ('ERRcode - '||SQLCODE||' -ERRmsg- '||SQLERRM||'.' ||rec_attr.nd_klsk,sysdate,i,400, ir); END IF;     
                          --добавляем периоды работы счетчика если он есть
                         IF ir = 0 and rec_attr.sch in (1,5) THEN  
                              oralv.p_meter2.U_METER_EXS_INS_UPD 
                                (P_IR => ir
                                , P_ID => l_id_exs
                                , P_FK_METER => l_id_meter
                                , P_DT1 => to_date(rec_attr.dat_nach,'YYYYMM')
                                /* case  when coalesce(rec_attr.dat_nach,trunc(sysdate,'mm'))>sysdate 
                                                        then trunc(sysdate,'mm') 
                                                      when trunc(sysdate,'mm')<>trunc(coalesce(rec_attr.dat_nach,trunc(sysdate,'mm')),'mm') 
                                                        then rec_attr.dat_nach   
                                                      else   trunc(sysdate,'mm') 
                                              end*/  
                            , P_DT2 => to_date('20990101', 'YYYYMMDD') 
                            , P_IS_UPDATEBLE => 1, 
                              P_IS_COMMIT => 1);
                            IF ir<>0 then  add_log ('ERRcode - '||SQLCODE||' -ERRmsg- '||SQLERRM||'.' ||rec_attr.nd_klsk,sysdate,i,420,ir); END IF;
                         -- если счетчика нету то ставим периоды его работы заканчиваются последним числом пред-го месяца, а начинаются первым числом
                         
                         ELSIF ir=0 and rec_attr.sch in (0) then
                             oralv.p_meter2.U_METER_EXS_INS_UPD 
                               ( P_IR => ir
                                , P_ID => l_id_exs
                                , P_FK_METER => l_id_meter
                                , P_DT1 => to_date(rec_attr.dat_nach,'YYYYMM')  /*case  when coalesce(rec_kart.psch_dtg,trunc(add_months(sysdate,-1),'mm'))>trunc(add_months(sysdate,-1),'mm')      
                                                            then trunc(add_months(sysdate,-1),'mm') 
                                                            else trunc(add_months(sysdate,-1),'mm')  
                                                   end*/  
                                , P_DT2 =>to_date(case when rec_attr.dat_end='999901' then '209901' 
                                                       else rec_attr.dat_end end,'YYYYMM')-- last_day(add_months(trunc(sysdate,'dd'),-1))
                                , P_IS_UPDATEBLE => 1, 
                                  P_IS_COMMIT => 1);
                         END IF;  
                    END IF;      
                            -- select to_date('209901','YYYYMM') from dual
          /*-------------------------------------------------------------------------------*/
          --3-Добавляем объемы и показания по ОДПУ            
                   IF ir=0 AND rec_attr.sch IN (0,1,5) 
                      and (coalesce(rec_mv.vol1,0)<>0 or coalesce(rec_mv.vol2,0)<>0 or coalesce(rec_mv.vol3,0)<>0 or
                           coalesce(rec_mv.summ1,0)<>0 or coalesce(rec_mv.summ2,0)<>0 or coalesce(rec_mv.summ3,0)<>0
                          )
                              
                   THEN 
                             oralv.p_meter2.U_METER_VOL_INS_UPD
                              (P_IR   => ir
                              , P_ID  => l_id_meter_vol
                              , P_FK_METER => l_id_meter
                              , P_FK_TYPE   => l_meter_vol_fk_type   -- Фактический объем
                              , P_DT1   => trunc(sysdate,'mm') 
                              , P_DT2   => last_day(trunc(sysdate)) 
                              , P_MG    => to_char(trunc(sysdate),'YYYYMM') 
                              , P_VOL1 => coalesce(rec_mv.vol1,0)
                              , P_VOL2 => coalesce(rec_mv.vol2,0), P_VOL3 => coalesce(rec_mv.vol3,0)
                              , P_SUMM1 => coalesce(rec_mv.summ1,0)
                              , P_SUMM2 => coalesce(rec_mv.summ2,0), P_SUMM3 => coalesce(rec_mv.summ3,0)
                              , P_FK_DOC => l_id_t_doc
                              , P_IS_UPDATEBLE => 1, P_IS_COMMIT => 1, P_IMPORT=>1);
                              IF ir<>0 then add_log('ERRcode - '||SQLCODE||' -ERRmsg- '||SQLERRM||'.' ||rec_attr.nd_klsk,sysdate,i,461,ir); END IF;
                              if ir=12 then insert into vaflia.u_meter_vol_log
                                       values ( rec_mv.id,
                                               l_meter_vol_fk_type,rec_mv.fk_meter,null,rec_mv.fk_doc,rec_mv.dt1,rec_mv.dt2,rec_mv.vol1,
                                               rec_mv.summ1,rec_mv.vol2, rec_mv.summ2, rec_mv.vol3, rec_mv.summ3,null,null,null,null );
                              end if;                 
                                     -- если нету счетчика и есть показания, то запишем показания так как раньше он мог быть (PSCH=0,2-нету сч Г.В.)
                   END IF; -- end объемы               
                  COMMIT;                                                     
               END LOOP;      
                      IF ir not in (0,12) THEN 
                               add_log('ERRcode - '||SQLCODE||' -ERRmsg- '||SQLERRM||'.' ||rec_mv.id,sysdate,i,478,ir);
                               raise_application_error(-20001,'raise');
                      END IF;
          END LOOP;
  
     END LOOP;
 END IF;  
 END ;
  
 -------------------------------------------------------------------------------------------------
    /*ЗАГРУЗКА ОДПУ СКЕК*/
 BEGIN
  IF p_var=5 THEN
    -- первый делит
   -- DELETE FROM oralv.U_METER_VOL;DELETE FROM oralv.U_METER_EXS;DELETE FROM oralv.U_METER;DELETE FROM oralv.U_METER_LOG;
  --  COMMIT;
     i:=1;       
    FOR rec_skek IN (
                              SELECT  sk.reu, sk.kul, sk.nd 
                                    , sk.VVOD_EL as vvod,sk.NOM_SCH, sk.PEL, sk.KWT
                                    , ch.fk_k_lsk as nd_klsk             --  klsk дома.
                                    , sk.pr_sch   -- признак счетчика 
                                    , sk.dat_nach
                                    , sk.dat_OK
                                FROM ldo.spr_skek@hotora sk,
                                       (SELECT reu,kul,nd,ch.fk_k_lsk 
                                          FROM  oralv.c_houses ch, oralv.k_lsk k, oralv.t_addr_tp ad
                                         WHERE  k.id=ch.fk_k_lsk
                                         and k.fk_addrtp=ad.id
                                         and ad.cd='Дом'
                                       ) ch
                               WHERE
                                      sk.reu = ch.reu and sk.kul = ch.kul and sk.nd = ch.nd 
                               --   and sk.nd='00031в'
                                  and sk.pr_sch not in (9) --так как 9 минусовой счетчик
                     ) 
      LOOP    
     --ОДПУ ПО УСЛУГЕ ЭЛ.ЭН из spr_skek     
          BEGIN 
               -- В НАШЕЙ КОНЦЕПЦИИ НА ДОМЕ СУЩ-ЕТ ЛОГ СЧ по услугам ХВ,ГВ,ОТ,ЭЛ и по вводам на эти услуги
               -- ОНИ ЯВЛЯЮТСЯ ПАРЕНТАМИ ДЛЯ ОДПУ И ДЛЯ ИПУ. СЧЕТЧИК ОДПУ НЕ МОЖЕТ ЯВЛЯТЬСЯ ПАРЕНТОМ ДЛЯ  ИПУ.
               /*-------------------------------------------------------------------*/
                  L_parent_ml :=null;
                  l_id_meter   :=null;
                  l_id_ml        :=null;
                  l_id_exs       :=null;
                  l_id_meter_vol:=null;
                  ir:=0;
              -- 1  вначале вставляем логич счетчики 
               -- узнаем есть ли счетчик на доме по услуге и вводу.
                    u_meter_mig.get_parent_id(
                                        p_reu=>rec_skek.reu, 
                                        p_kul=>rec_skek.kul, 
                                        p_nd=>rec_skek.nd, 
                                        p_vvod=>rec_skek.vvod, 
                                        p_parent_ml=>l_parent_ml, 
                                        p_k_lsk_obj=>rec_skek.nd_klsk,   -- закидываем сюда klsk дома, 
                                        p_serv=>l_el_id) ;
                                        
                     --если НЕТУ , то вставляем сначало ФЭЙКОВЫЙ СЧЕТЧИК по этому дому по этой услуге и по ввводу
                     --(в fk_klsk_obj вставялем klsk дома-nd_klsk)
            IF l_parent_ml is null THEN 
                   ORALV.P_METER2.U_METER_LOG_INS_UPD
                   (
                        P_IR => ir--P_IR OUT NUMBER--код возврата: =0 - успешное завершение
                      , P_ID => l_id_ml
                      , P_FK_KLSK_OBJ => rec_skek.nd_klsk
                      , P_FK_SERV => l_el_id 
                      , P_CD => rec_skek.vvod
                      , P_DT1 => to_date('20000101', 'YYYYMMDD')  
                      , P_DT2 => to_date('20990101', 'YYYYMMDD')
                      , P_PARENT_ID => null
                      , P_NAME => 'Счетчик ОДПУ по услуге ЭЛ.ЭН. и вводу-'||rec_skek.vvod   -- на нем будут сидеть счетчики ОДПУ    !!ИЛИ  счетчики ИПУ  (так как ОДПУ может не быть)
                      , P_IS_UPDATEBLE =>1                 
                      , P_IS_COMMIT => 1 --  -1 - вызов для проверки существования, без DML (и без COMMIT)
                                                      --   0 - DML без COMMIT
                                                      --   1 - DML и COMMIT
                   );  
                 --  l_parent_ml:=l_id_ml;
                 --  l_id_ml:=null;
            /*------------------------------------------------------------*/
            /*ЕСЛИ ЕСТЬ ЛОГИЧЕСКИЙ СЧЕТЧКИ ТО Выберем l_id_meter*/
            ELSIF l_id_ml is not null then  
               SELECT  id 
                 INTO l_id_meter 
                 FROM oralv.u_meter where fk_meter_log=l_id_ml;
            END IF;  

            /*------------------------------------------------------------*/
    --2 - вставка физ счетчика только тогда когда ФИЗ. СЧЕТЧИКА НЕТУ ПО ДАННОМУ ЛОГИЧ-МУ
            IF ir =0  and l_id_meter is null THEN
               l_meter_fk_k_lsk:=null;
               oralv.p_meter2.U_METER_INS_UPD
               ( 
                   P_IR => ir
                 , P_ID => l_id_meter
                 , P_IS_UPDATEBLE => 1
                 , P_FK_METER_LOG => l_id_ml
                 , P_DT => trunc(sysdate,'mm')   -- дата P_DT1(начало периода показания(объема)
                 , P_FK_K_LSK => l_meter_fk_k_lsk
                 , P_IS_UNIT1 =>1
                 , P_IS_COMMIT => 1
               ); 
             IF ir<>0 then add_log ('ERRcode - '||SQLCODE||' -ERRmsg- '||SQLERRM||'.' ||rec_skek.nd_klsk,sysdate,i,358, ir); END IF;     
                --добавляем периоды работы счетчика если он есть  
                 IF ir = 0 and rec_skek.pr_sch in (1) THEN  
                      oralv.p_meter2.U_METER_EXS_INS_UPD 
                        (P_IR => ir
                        , P_ID => l_id_exs
                        , P_FK_METER => l_id_meter
                        , P_DT1 => rec_skek.dat_nach
                        , P_DT2 => to_date('20990101', 'YYYYMMDD') 
                        , P_IS_UPDATEBLE => 1, 
                          P_IS_COMMIT => 1);
                    IF ir<>0 then  add_log ('ERRcode - '||SQLCODE||' -ERRmsg- '||SQLERRM||'.' ||rec_skek.nd_klsk,sysdate,i,420,ir); END IF;
                 END IF;  
            END IF;      
                           
         /*-------------------------------------------------------------------------------*/
         --3-Добавляем объемы и показания по счетчику если есть счетчик  ГВ(psch=1,3)            
           IF ir=0 THEN 
                IF rec_skek.kwt<>0 THEN 
                     oralv.p_meter2.U_METER_VOL_INS_UPD
                      (P_IR   => ir
                      , P_ID  => l_id_meter_vol
                      , P_FK_METER => l_id_meter
                      , P_FK_TYPE   => l_meter_vol_fk_type   -- Фактический объем
                      , P_DT1   => trunc(sysdate,'mm') 
                      , P_DT2   => last_day(trunc(sysdate)) 
                      , P_MG    => to_char(trunc(sysdate),'YYYYMM') 
                      , P_VOL1 => rec_skek.kwt, P_VOL2 => null, P_VOL3 => null, P_SUMM1 =>null, P_SUMM2 => null, P_SUMM3 => null
                      , P_FK_DOC => 2197 -- левый документ какойто 
                      , P_IS_UPDATEBLE => 1, P_IS_COMMIT => 1);
                      IF ir<>0 then add_log('ERRcode - '||SQLCODE||' -ERRmsg- '||SQLERRM||'.' ||rec_skek.nd_klsk,sysdate,i,405,ir); END IF;
                END IF;    
                IF ir=0 AND rec_skek.pel<>0 THEN 
                    l_id_meter_vol:=null;
                    oralv.p_meter2.U_METER_VOL_INS_UPD
                     (P_IR   => ir
                      , P_ID  => l_id_meter_vol
                      , P_FK_METER => l_id_meter
                      , P_FK_TYPE   => l_meter_vol_fk_type2   --показание счетчика
                      , P_DT1   => trunc(sysdate,'mm') 
                      , P_DT2   => last_day(trunc(sysdate)) 
                      , P_MG    => to_char(trunc(sysdate),'YYYYMM') 
                      , P_VOL1 => rec_skek.pel, P_VOL2 => null, P_VOL3 => null, P_SUMM1 => null, P_SUMM2 => null, P_SUMM3 => null
                      , P_FK_DOC => 2197
                      , P_IS_UPDATEBLE => 1, P_IS_COMMIT => 1);
                 IF ir<>0 THEN  add_log('ERRcode - '||SQLCODE||' -ERRmsg- '||SQLERRM||'.' ||rec_skek.nd_klsk,sysdate,i,420,ir); END IF;
                END IF;
           END IF; -- end объемы 
           --END вставка ФИЗ сч, периодов, объема       
           /*------------------------------------------------------------*/
            -- если у нас группа ипу на лицевом, и есть счетчик ГВ (psch-1,3) 
          END; -- END     
     END LOOP;
  END IF; --p_var=5
 END;    
---------------------------------------------------------------------------------------------------------------- 
--ОКОНЧАНИЕ ЗАГРУЗКИ ОДПУ 
-------------------------------------------------------------------------------------------------
    /*ЗАГРУЗКА СЧЕТЧИКОВ ИПУ*/
    BEGIN
    IF p_var=3 THEN
    -- первый делит
  --    DELETE FROM oralv.U_METER_VOL;DELETE FROM oralv.U_METER_EXS;DELETE FROM oralv.U_METER;DELETE FROM oralv.U_METER_LOG;
    --  COMMIT;
      i:=1;  
      ir:=0;     
    INSERT INTO oralv.t_doc (id,fk_doctp,name,npp,v,fk_org) values (null,1466683,'Импорт счетчиков ИПУ из kart',1,1,79963) 
         RETURNING ID INTO l_id_t_doc;
   -- SELECT id into doc_id FROM ORALV.T_DOC WHERE fk_doctp in (select id from oralv.t_doc_tp where cd in('Итоговый реестр ОДПУ','Счет-фактура')) and rownum<2;      
    FOR rec_kart IN (
                              SELECT ka.reu,ka.kul,ka.nd, ka.kw, ka.lsk, lk_h.VVOD, lk_h.VVOD_GW ,lk_h.VVOD_OT, lk_h.VVOD_EL, -- ad.name,
                                          lk_h.SCHEL_DT, NOMSCH, 
                                          lk_h.DT_POVHW, lk_h.DT_POVGW, lk_h.DTPOVHW, lk_h.DTPOVGW, lk_h.NOM_SCHW, lk_h.NOM_SCGW, 
                                          lk_h.PGW, lk_h.PHW, lk_h.PSCH_DT, lk_h.PSCH_DTG,
                                          lk_h.MHW, lk_h.MGW, lk_h.PEL, lk_h.MEL,
                                          LK_H.KODSC, LK_H.KODSCH, LK_H.KODSCG
                                          , ok.k_lsk_id as lsk_klsk    -- klsk лицевого счета
                                          , kw.fk_k_lsk as kw_klsk             --  klsk квартиры. 
                                          , ch.fk_k_lsk as nd_klsk             --  klsk квартиры.
                                          , ka.psch 
                                          , lk_h.sch_el  --признак сч эл. эн. (0 - нет, 1 - да, 2 - временно не начислять)
                                FROM oralv.kart@hotora ka,  
                                          scott.load_kart@hotora lk_h, ORALV.KART ok,
                                          oralv.c_kw kw,
                                          (SELECT reu,kul,nd,ch.fk_k_lsk 
                                             FROM  oralv.c_houses ch, oralv.k_lsk k, oralv.t_addr_tp ad
                                           WHERE  k.id=ch.fk_k_lsk
                                           and k.fk_addrtp=ad.id
                                           and ad.cd='Дом'
                                           ) ch
                              WHERE-- ka.k_lsk_id=kl.id   juke
                                   --and AD.ID=kl.FK_ADDRTP 
                                          ka.lsk =  lk_h.lsk 
                                  and  ok.lsk  =  ka.lsk
                                  and kw.reu = ok.reu and kw.kul = ok.kul and kw.nd = ok.nd and kw.kw = ok.kw
                                  and ch.reu = ok.reu and ch.kul = ok.kul and ch.nd = ok.nd
                                 -- and ok.kul='0133'
                          --       and kw.fk_k_lsk=353113
                                  and ok.nd='00031в'
                                  and ok.psch not in (9)  -- 0 - нету счетчика. это обработать, занести только показания счетчика
                     ) 
                            --тесты
                            -- select * from oralv.kart@hotora where reu='11'
          /*                  select distinct reu,kul,nd,kw from oralv.c_kw
                              select  reu,kul,nd,kw from oralv.c_kw
                              where reu='73'  and kul='0039' and nd='000029'
                                and kw='00000'
                              order by  reu,kul,nd,kw
                              select reu,kul,nd,kw,count(*) from oralv.c_kw 
                              group by reu,kul,nd,kw
                              select * from oralv.k_lsk where id in (33784,42675)*/
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
                WHERE ad.cd='ДОМ'
                     and ad.id=ch 
                select * from oralv.k_lsk@hotora where id=1040284
                select * from oralv.t_addr_tp@hotora where id=12*/
      /*---------------------------------------------------------------------------*/
     --ДЛЯ УСЛУГИ ГВ     
          BEGIN 
               -- В НАШЕЙ СИСТЕМЕ СУЩ ОДПУ И ИПУ, ЕСЛИ ОДПУ НЕТУ ВСЕ РАВНО СОЗЛ-СЯ ЛОГ СЧЕЧТИК ДЛЯ ПРИВЯЗКИ ИПУ И ОДПУ(В ПОСЛЕД) 
               -- ОНИ ЯВЛЯЮТСЯ ПАРЕНТАМИ ДЛЯ ОДПУ И ДЛЯ ИПУ. СЧЕТЧИК ОДПУ НЕ МОЖЕТ ЯВЛЯТЬСЯ ПАРЕНТОМ ДЛЯ  ИПУ.
               /*-------------------------------------------------------------------*/
                  l_parent_ml    :=null;
                  l_id_meter     :=null;
                  l_id_ml        :=null;
                  l_id_exs       :=null;
                  l_id_meter_vol :=null;
                  
              -- 1  вначале вставляем логич счетчики по горячей воде
              --Узнаем есть ли счетчик на ОДПУ 
                    u_meter_mig.get_parent_id(
                                        p_reu=>rec_kart.reu, 
                                        p_kul=>rec_kart.kul, 
                                        p_nd=>rec_kart.nd, 
                                        p_vvod=>rec_kart.vvod_gw, 
                                        p_parent_ml=>L_parent_ml, 
                                        p_k_lsk_obj=>rec_kart.nd_klsk,   -- закидываем сюда klsk дома, 
                                        p_serv=>l_gw_id) ;
                                        
                     --если НЕТУ , то вставляем сначало ЛОГИЧЕСКИЙ СЧЕТЧИК ОДПУ по этому дому по этой услуге и по ввводу
                     --(в fk_klsk_obj вставялем klsk дома-nd_klsk)
                    IF l_parent_ml is null THEN 
                           ORALV.P_METER2.U_METER_LOG_INS_UPD
                           (
                                P_IR => ir--P_IR OUT NUMBER--код возврата: =0 - успешное завершение
                              , P_ID => l_id_ml
                              , P_FK_KLSK_OBJ => rec_kart.nd_klsk
                              , P_FK_SERV => l_gw_id 
                              , P_CD => rec_kart.vvod_gw
                              , P_DT1 => to_date('20000101', 'YYYYMMDD')  
                              , P_DT2 => to_date('20990101', 'YYYYMMDD')
                              , P_PARENT_ID => null
                              , P_NAME => 'ОДПУ по услуге ГВ и вводу-'||rec_kart.vvod_gw   -- на нем будут сидеть счетчики ОДПУ    !!ИЛИ  счетчики ИПУ  (так как ОДПУ может не быть)
                              , P_IS_UPDATEBLE =>1                 
                              , P_IS_COMMIT => 1 --  -1 - вызов для проверки существования, без DML (и без COMMIT)
                                                              --   0 - DML без COMMIT
                                                              --   1 - DML и COMMIT
                           );  
                           l_parent_ml:=l_id_ml;
                           l_id_ml:=null;
                  END IF;
                  -- вставляем логический ИПУ привязанный к ОДПУ по вводу услуге
                  --(в fk_klsk_obj вставялем klsk квартиры-kw_klsk)
                  IF  l_parent_ml is not null and ir=0 and rec_kart.kodscg not in (98,99) and rec_kart.psch in (0,1,2,3) THEN
                           ORALV.P_METER2.U_METER_LOG_INS_UPD
                           (
                                P_IR => ir--P_IR OUT NUMBER--код возврата: =0 - успешное завершение
                              , P_ID => l_id_ml
                              , P_FK_KLSK_OBJ => rec_kart.kw_klsk
                              , P_FK_SERV => l_gw_id 
                              , P_CD => rec_kart.vvod_gw
                              , P_DT1 => to_date('20000101', 'YYYYMMDD') 
                              , P_DT2 => to_date('20990101', 'YYYYMMDD')
                              , P_PARENT_ID => l_parent_ml
                              , P_NAME => CASE WHEN rec_kart.kodsc=98 then 'Группа ИПУ на одном Л/С по услуге ' || l_gw_id || ' и вводу  ' || rec_kart.vvod_gw 
                                                           WHEN rec_kart.kodsc=99 then 'Групповой ИПУ на неск Л/С по услуге ' || l_gw_id || ' и вводу  ' || rec_kart.vvod_gw
                                                             ELSE 'ИПУ по услуге Г.В. d_sev.id=' || l_gw_id || ' и вводу  ' || rec_kart.vvod_gw
                                                   END 
                              --decode(rec_kart.kodscg,98,'Группа ИПУ на одном Л/С по услуге ',99,'Групповой ИПУ на неск Л/С по услуге ','ИПУ по услуге ') || l_gw_id 
                              , P_IS_UPDATEBLE =>1                  
                              , P_IS_COMMIT => 1 --  -1 - вызов для проверки существования, без DML (и без COMMIT)
                                                              --   0 - DML без COMMIT
                                                              --   1 - DML и COMMIT
                           ); if ir<>0 then add_log ('ERRcode - '||SQLCODE||' -ERRmsg- '||SQLERRM||'.' ||rec_kart.kw_klsk,sysdate,i,341, ir);  end if;
       /*------------------------------------------------------------*/
          --2 - вставка физ счетчика  если он есть psch=1,3 или даже если нету, просто он мог быть раньше                    
                      IF ir =0 and rec_kart.psch in (0,1,2,3) THEN
                             --      l_id_meter:=null;
                                   l_meter_fk_k_lsk:=null;
                                   oralv.p_meter2.U_METER_INS_UPD
                                   ( 
                                       P_IR => ir
                                     , P_ID => l_id_meter
                                     , P_IS_UPDATEBLE => 1
                                     , P_FK_METER_LOG => l_id_ml
                                     , P_DT => trunc(sysdate,'mm')   -- дата P_DT1(начало периода показания(объема)
                                     , P_FK_K_LSK => l_meter_fk_k_lsk
                                     , P_IS_UNIT1 =>1
                                     , P_IS_COMMIT => 1
                                   ); 
                               IF ir<>0 then add_log ('ERRcode - '||SQLCODE||' -ERRmsg- '||SQLERRM||'.' ||rec_kart.kw_klsk,sysdate,i,358, ir); END IF;     
                                  --добавляем периоды работы счетчика если он есть  
                                  IF ir = 0 and rec_kart.psch in (1,3) THEN  
                                      oralv.p_meter2.U_METER_EXS_INS_UPD 
                                        (P_IR => ir
                                        , P_ID => l_id_exs
                                        , P_FK_METER => l_id_meter
                                        , P_DT1 => case  when coalesce(rec_kart.psch_dtg,trunc(sysdate,'mm'))>sysdate 
                                                                    then trunc(sysdate,'mm') 
                                                                  when trunc(sysdate,'mm')<>trunc(coalesce(rec_kart.psch_dtg,trunc(sysdate,'mm')),'mm') 
                                                                    then rec_kart.psch_dtg   
                                                                  else   trunc(sysdate,'mm') 
                                                           end  
                                        , P_DT2 => to_date('20990101', 'YYYYMMDD') 
                                        , P_IS_UPDATEBLE => 1, 
                                          P_IS_COMMIT => 1);
                                        IF ir<>0 then  add_log ('ERRcode - '||SQLCODE||' -ERRmsg- '||SQLERRM||'.' ||rec_kart.kw_klsk,sysdate,i,374,ir); END IF;
                                  -- если счетчика нету то ставим периоды его работы заканчиваются последним числом пред-го месяца, а начинаются первым числом
                                  ELSIF ir=0 and rec_kart.psch in (0,2) then
                                     oralv.p_meter2.U_METER_EXS_INS_UPD 
                                       ( P_IR => ir
                                        , P_ID => l_id_exs
                                        , P_FK_METER => l_id_meter
                                        , P_DT1 => case  when coalesce(rec_kart.psch_dtg,trunc(add_months(sysdate,-1),'mm'))>trunc(add_months(sysdate,-1),'mm')      
                                                                    then trunc(add_months(sysdate,-1),'mm') 
                                                                    else trunc(add_months(sysdate,-1),'mm')  
                                                           end  
                                        , P_DT2 => last_day(add_months(trunc(sysdate,'dd'),-1))
                                        , P_IS_UPDATEBLE => 1, 
                                          P_IS_COMMIT => 1);
                                  END IF;  
                      END IF;      
                           
                  /*-------------------------------------------------------------------------------*/
                  --3-Добавляем объемы и показания по счетчику если есть счетчик  ГВ(psch=1,3)            
                           IF ir=0 AND rec_kart.psch IN (1,3) THEN 
                                IF rec_kart.mgw<>0 THEN 
                                     oralv.p_meter2.U_METER_VOL_INS_UPD
                                      (P_IR   => ir
                                      , P_ID  => l_id_meter_vol
                                      , P_FK_METER => l_id_meter
                                      , P_FK_TYPE   => l_meter_vol_fk_type   -- Фактический объем
                                      , P_DT1   => trunc(sysdate,'mm') 
                                      , P_DT2   => last_day(trunc(sysdate)) 
                                      , P_MG    => to_char(trunc(sysdate),'YYYYMM') 
                                      , P_VOL1 => rec_kart.mgw, P_VOL2 => null, P_VOL3 => null, P_SUMM1 =>null, P_SUMM2 => null, P_SUMM3 => null
                                      , P_FK_DOC => 2197
                                      , P_IS_UPDATEBLE => 1, P_IS_COMMIT => 1);
                                      IF ir<>0 then add_log('ERRcode - '||SQLCODE||' -ERRmsg- '||SQLERRM||'.' ||rec_kart.kw_klsk,sysdate,i,405,ir); END IF;
                                END IF;    
                                IF ir=0 AND rec_kart.pgw<>0 THEN 
                                        l_id_meter_vol:=null;
                                        oralv.p_meter2.U_METER_VOL_INS_UPD
                                              (P_IR   => ir
                                              , P_ID  => l_id_meter_vol
                                              , P_FK_METER => l_id_meter
                                              , P_FK_TYPE   => l_meter_vol_fk_type2   --показание счетчика
                                              , P_DT1   => trunc(sysdate,'mm') 
                                              , P_DT2   => last_day(trunc(sysdate)) 
                                              , P_MG    => to_char(trunc(sysdate),'YYYYMM') 
                                              , P_VOL1 => rec_kart.pgw, P_VOL2 => null, P_VOL3 => null, P_SUMM1 => null, P_SUMM2 => null, P_SUMM3 => null
                                              , P_FK_DOC => 2197
                                              , P_IS_UPDATEBLE => 1, P_IS_COMMIT => 1);
                                      IF ir<>0 THEN  add_log('ERRcode - '||SQLCODE||' -ERRmsg- '||SQLERRM||'.' ||rec_kart.kw_klsk,sysdate,i,420,ir); END IF;
                                END IF;
                           -- если нету счетчика и есть показания, то запишем показания так как раньше он мог быть (PSCH=0,2-нету сч Г.В.)
                           ELSIF ir =0  and rec_kart.psch in (0,2) and rec_kart.pgw<>0 THEN  
                                    l_id_meter_vol:=null;
                                    oralv.p_meter2.U_METER_VOL_INS_UPD
                                          (P_IR   => ir
                                          , P_ID  => l_id_meter_vol
                                          , P_FK_METER => l_id_meter
                                          , P_FK_TYPE   => l_meter_vol_fk_type2   --показание счетчика
                                          , P_DT1   => trunc(add_months(sysdate,-1),'mm')  
                                          , P_DT2   => last_day(add_months(trunc(sysdate),-1)) 
                                          , P_MG    => to_char(trunc(add_months(sysdate,-1)),'YYYYMM')
                                          , P_VOL1 => rec_kart.pgw, P_VOL2 => null, P_VOL3 => null, P_SUMM1 => null, P_SUMM2 => null, P_SUMM3 => null
                                          , P_FK_DOC => 2197
                                          , P_IS_UPDATEBLE => 1, P_IS_COMMIT => 1);
                           END IF; -- end объемы 
                  --    END IF;
           --END вставка ФИЗ сч, периодов, объема       
       /*------------------------------------------------------------*/
                          -- если у нас группа ипу на лицевом, и есть счетчик ГВ (psch-1,3) 
                  ELSIF l_parent_ml is not null and rec_kart.kodscg in (98) and rec_kart.psch in (0,1,2,3)  then 
                            FOR rec_grsc IN C_grsc(l_uslm_gw,rec_kart.lsk) LOOP
                               l_id_meter_vol:=null;
                               l_meter_fk_k_lsk:=null;
                               l_id_meter:=null;
                               l_id_exs:=null;
                               --вставка физ счетчика в любом случае
                               oralv.p_meter2.U_METER_INS_UPD
                               ( 
                                   P_IR => ir
                                 , P_ID => l_id_meter
                                 , P_IS_UPDATEBLE => 1
                                 , P_FK_METER_LOG => l_id_ml
                                 , P_DT => trunc(sysdate,'mm')   -- дата P_DT1(начало периода показания(объема)
                                 , P_FK_K_LSK => l_meter_fk_k_lsk
                                 , P_IS_UNIT1 =>1
                                 , P_IS_COMMIT => 1
                               ); 
                               IF ir<>0 then add_log ('ERRcode - '||SQLCODE||' -ERRmsg- '||SQLERRM||'.' ||rec_kart.kw_klsk,sysdate,i,458, ir); END IF;     
                                 --добавляем периоды работы счетчика если он есть  
                               IF ir IN (0) and rec_kart.psch in (1,3) THEN  
                                  oralv.p_meter2.U_METER_EXS_INS_UPD 
                                    (P_IR => ir
                                    , P_ID => l_id_exs
                                    , P_FK_METER => l_id_meter
                                    , P_DT1 => case  when coalesce(rec_kart.psch_dtg,trunc(sysdate,'mm'))>sysdate 
                                                                then trunc(sysdate,'mm') 
                                                              when trunc(sysdate,'mm')<>trunc(coalesce(rec_kart.psch_dtg,trunc(sysdate,'mm')),'mm') 
                                                                then rec_kart.psch_dtg   
                                                              else   trunc(sysdate,'mm') 
                                                       end  
                                    , P_DT2 => to_date('20990101', 'YYYYMMDD') 
                                    , P_IS_UPDATEBLE => 1, 
                                      P_IS_COMMIT => 1);
                                    IF ir<>0 then  add_log ('ERRcode - '||SQLCODE||' -ERRmsg- '||SQLERRM||'.' ||rec_kart.kw_klsk,sysdate,i,474,ir); END IF;
                                    -- если счетчика нету то ставим периоды его работы заканчиваются последним числом пред-го месяца, а начинаются первым числом
                               ELSIF ir=0 and rec_kart.psch in (0,2) then
                                  oralv.p_meter2.U_METER_EXS_INS_UPD 
                                   ( P_IR => ir
                                    , P_ID => l_id_exs
                                    , P_FK_METER => l_id_meter
                                    , P_DT1 => case  when coalesce(rec_kart.psch_dtg,trunc(add_months(trunc(sysdate,-1),'mm')))>trunc(add_months(sysdate,-1),'mm')      
                                                                then trunc(add_months(sysdate,-1),'mm') 
                                                                else trunc(add_months(sysdate,-1),'mm')  
                                                       end  
                                    , P_DT2 => last_day(add_months(trunc(sysdate,'dd'),-1))
                                    , P_IS_UPDATEBLE => 1, 
                                      P_IS_COMMIT => 1);
                               END IF;           
                               
                                /*-------------------------------------------------------------------------------*/
                               --3-Добавляем объемы и показания по счетчику если есть счетчик               
                               IF i=0 and rec_kart.psch in (1,3) THEN
                                      IF rec_grsc.mel<>0 THEN 
                                             oralv.p_meter2.U_METER_VOL_INS_UPD
                                                  (P_IR   => ir
                                                  , P_ID  => l_id_meter_vol
                                                  , P_FK_METER => l_id_meter
                                                  , P_FK_TYPE   => l_meter_vol_fk_type   -- Фактический объем
                                                  , P_DT1   => trunc(sysdate,'mm') 
                                                  , P_DT2   => last_day(trunc(sysdate)) 
                                                  , P_MG    => to_char(trunc(sysdate),'YYYYMM') 
                                                  , P_VOL1 => rec_grsc.mel, P_VOL2 => null, P_VOL3 => null, P_SUMM1 =>null, P_SUMM2 => null, P_SUMM3 => null
                                                  , P_FK_DOC => 2197
                                                  , P_IS_UPDATEBLE => 1, P_IS_COMMIT => 1);
                                                  IF ir<>0 then add_log('ERRcode - '||SQLCODE||' -ERRmsg- '||SQLERRM||'.' ||rec_kart.kw_klsk,sysdate,i,504,ir); END IF;
                                      END IF;
                                      IF ir=0 and rec_grsc.pel<>0 THEN 
                                            l_id_meter_vol:=null;
                                            oralv.p_meter2.U_METER_VOL_INS_UPD
                                                  (P_IR   => ir
                                                  , P_ID  => l_id_meter_vol
                                                  , P_FK_METER => l_id_meter
                                                  , P_FK_TYPE   => l_meter_vol_fk_type2   --показание счетчика
                                                  , P_DT1   => trunc(sysdate,'mm') 
                                                  , P_DT2   => last_day(trunc(sysdate)) 
                                                  , P_MG    => to_char(trunc(sysdate),'YYYYMM') 
                                                  , P_VOL1 => rec_grsc.pel, P_VOL2 => null, P_VOL3 => null, P_SUMM1 => null, P_SUMM2 => null, P_SUMM3 => null
                                                  , P_FK_DOC => 2197
                                                  , P_IS_UPDATEBLE => 1, P_IS_COMMIT => 1);
                                         END IF;--end показания
                                          IF ir<>0 THEN  add_log('ERRcode - '||SQLCODE||' -ERRmsg- '||SQLERRM||'.' ||rec_kart.kw_klsk,sysdate,i,518,ir); END IF;
                               -- если нету счетчика, то запишем показания так как раньше он мог быть
                               ELSIF ir IN (0)  and rec_kart.psch in (0,2) and rec_grsc.pel<>0 THEN  
                                        l_id_meter_vol:=null;
                                        oralv.p_meter2.U_METER_VOL_INS_UPD
                                              (P_IR   => ir
                                              , P_ID  => l_id_meter_vol
                                              , P_FK_METER => l_id_meter
                                              , P_FK_TYPE   => l_meter_vol_fk_type2   --показание счетчика
                                              , P_DT1   => trunc(add_months(sysdate,-1),'mm')  
                                              , P_DT2   => last_day(add_months(trunc(sysdate),-1)) 
                                              , P_MG    => to_char(trunc(add_months(sysdate,-1)),'YYYYMM')
                                              , P_VOL1 => rec_grsc.pel, P_VOL2 => null, P_VOL3 => null, P_SUMM1 => null, P_SUMM2 => null, P_SUMM3 => null
                                              , P_FK_DOC => 2197
                                              , P_IS_UPDATEBLE => 1, P_IS_COMMIT => 1);
                               END IF; -- end объемы
                             END LOOP;    
                  END IF;       

               
                   -- вставка параметров физ счетчика
              /*     l_hfpxklsk_pdt1 := trunc(sysdate,'MM');
                   l_hfpxklsk_pdt2 := null;
                   oralv.P_HF_ADD.U_HFPXKLSK_SET2 (
                              ir =>ir
                            , pid=>l_hfpxklsk_id
                            , pINPUT_TP=>3           
                            , pfk_hfp=> l_hfpxklsk_pfk_hfp                  
                            --Тип(приоритет)_Источника_Нового_Значения 
                            --и Управление_Заменой_с_Использованием_Приоритета
                            --разряд единиц - Тип(приоритет)_Источника_Нового_Значения
                            --  = 0 - источник неопределен(низший приоритет)
                            --  = 1 - введенно пользователем
                            --  = 2 - установлено выполнением Операции
                            --  = 3 - установлено заданием планировщика(высший приоритет)
                            --разряд десятков - Управление_Заменой_с_Использованием_Приоритета
                            --  = 0 - безусловная замена существующего значения новым
                            --  = 1 - заменять, если приоритет сущ.значения не выше приритета нового
                                  --"адрес ячейки" записи значения
                              --  , pid       IN OUT  u_hfpxklsk.id%TYPE--p2--ID записи редактируемого(IN) или добавленного(OUT) значения в u_hfpxklsk
                                , pfk_k_lsk=>l_meter_fk_k_lsk --p3--fk_k_lsk редактируемого(IN) или добавленного(OUT) значения в u_hfpxklsk
                               -- , PFK_ADDRTP IN     k_lsk.fk_addrtp%TYPE := NULL--p16  --добавляемого(IN) значения в u_hfpxklsk
                               -- , PCD_ADDRTP IN  t_addr_tp.cd%TYPE := NULL--p17--альтернатива PFK_ADDRTP
                                --, pfk_hfp   IN OUT  u_hfpxklsk.fk_hfp%TYPE--p4--fk_hfp  редактируемого(IN) или добавленного(OUT) значения в u_hfpxklsk
                                , pcd_hfp =>'U_METER.NOM_SCGW'  --p5--альтернатива pfk_hfp
                                , pdt1  =>l_hfpxklsk_pdt1--p29--дата начала периода(включительно) редактируемого(IN) или добавленного(OUT) значения в u_hfpxklsk
                                , pdt2  =>l_hfpxklsk_pdt2--p30--дата окончания периода(включительно) редактируемого(IN) или добавленного(OUT) значения в u_hfpxklsk
                                  --значение
                                , pS1 => rec_kart.NOM_SCGW--значения для добавления в u_hfpxklsk
                                , piInsert=> 1 
                                         --если = 1, то разршено создать запись значения  --p12
                                , pdt12_isPermition=> 1--p28 
                                         --если =1, то - безусловно добавить запись без анализа пересечений
                                , PIS_DEL=>1--p31 
                                         --если=1, то - удалить запись значения параметра для объекта
                                                      --   и текущего периода
                                         --    =2, то - удалить записи значений параметра для объекта
                                                      --   и ВСЕХ периодов
                  );*/
          END; -- END для услуги ГВ                    
      /*------------------------------------------------------------------------------------------------------------------*/              
      /*------------------------------------------------------------------------------------------------------------------*/       
      -- ДЛЯ УСЛУГИ ХВ
          BEGIN 
               -- В НАШЕЙ КОНЦЕПЦИИ НА ДОМЕ СУЩ-ЕТ ЛОГ СЧ по услугам ХВ,ГВ,ОТ,ЭЛ и по вводам на эти услуги
               -- ОНИ ЯВЛЯЮТСЯ ПАРЕНТАМИ ДЛЯ ОДПУ И ДЛЯ ИПУ. СЧЕТЧИК ОДПУ НЕ МОЖЕТ ЯВЛЯТЬСЯ ПАРЕНТОМ ДЛЯ  ИПУ.
               /*-------------------------------------------------------------------*/
                  L_parent_ml :=null;
                  l_id_meter   :=null;
                  l_id_ml        :=null;
                  l_id_exs       :=null;
                  l_id_meter_vol:=null;
              -- 1  вначале вставляем логич счетчики по горячей воде
               -- узнаем есть ли фэйковый счетчик на доме по услуге и вводу.
                    u_meter_mig.get_parent_id(
                                        p_reu=>rec_kart.reu, 
                                        p_kul=>rec_kart.kul, 
                                        p_nd=>rec_kart.nd, 
                                        p_vvod=>rec_kart.vvod, 
                                        p_parent_ml=>L_parent_ml, 
                                        p_k_lsk_obj=>rec_kart.nd_klsk,   -- закидываем сюда klsk дома, 
                                        p_serv=>l_hw_id) ;
                                        
                     --если НЕТУ , то вставляем сначало ФЭЙКОВЫЙ СЧЕТЧИК по этому дому по этой услуге и по ввводу
                     --(в fk_klsk_obj вставялем klsk дома-nd_klsk)
                    IF l_parent_ml is null THEN 
                           ORALV.P_METER2.U_METER_LOG_INS_UPD
                           (
                                P_IR => ir--P_IR OUT NUMBER--код возврата: =0 - успешное завершение
                              , P_ID => l_id_ml
                              , P_FK_KLSK_OBJ => rec_kart.nd_klsk
                              , P_FK_SERV => l_hw_id 
                              , P_CD => rec_kart.vvod
                              , P_DT1 => to_date('20000101', 'YYYYMMDD')  
                              , P_DT2 => to_date('20990101', 'YYYYMMDD')
                              , P_PARENT_ID => null
                              , P_NAME => 'ОДПУ по услуге ХВ и вводу-' || rec_kart.vvod  -- на нем будут сидеть счетчики ОДПУ    !!ИЛИ  счетчики ИПУ  (так как ОДПУ может не быть)
                              , P_IS_UPDATEBLE =>1                 
                              , P_IS_COMMIT => 1 --  -1 - вызов для проверки существования, без DML (и без COMMIT)
                                                              --   0 - DML без COMMIT
                                                              --   1 - DML и COMMIT
                           );  
                           l_parent_ml:=l_id_ml;
                           l_id_ml:=null;
                  END IF;
                  -- вставляем логический ИПУ привязанный к фэйкуовому по вводу услуге
                  --(в fk_klsk_obj вставялем klsk квартиры-kw_klsk)
                  IF  l_parent_ml is not null and ir=0 and rec_kart.kodsch not in (98,99) and rec_kart.psch in (0,1,2,3) THEN
                           ORALV.P_METER2.U_METER_LOG_INS_UPD
                           (
                                P_IR => ir--P_IR OUT NUMBER--код возврата: =0 - успешное завершение
                              , P_ID => l_id_ml
                              , P_FK_KLSK_OBJ => rec_kart.kw_klsk
                              , P_FK_SERV => l_hw_id 
                              , P_CD => rec_kart.vvod
                              , P_DT1 => to_date('20000101', 'YYYYMMDD') 
                              , P_DT2 => to_date('20990101', 'YYYYMMDD')
                              , P_PARENT_ID => l_parent_ml
                              , P_NAME => CASE WHEN rec_kart.kodsch=98 then 'Группа ИПУ на одном Л/С по услуге ' ||l_hw_id || ' и вводу  ' || rec_kart.vvod 
                                                           WHEN rec_kart.kodsch=99 then 'Групповой ИПУ на неск Л/С по услуге ' ||l_hw_id || ' и вводу  ' || rec_kart.vvod 
                                                            ELSE 'ИПУ по услуге Х.В. d_sev.id=' || l_hw_id || ' и вводу  ' || rec_kart.vvod 
                                                   END 
                              --decode(rec_kart.kodscg,98,'Группа ИПУ на одном Л/С по услуге ',99,'Групповой ИПУ на неск Л/С по услуге ','ИПУ по услуге ') || l_gw_id 
                              , P_IS_UPDATEBLE =>1                  
                              , P_IS_COMMIT => 1 --  -1 - вызов для проверки существования, без DML (и без COMMIT)
                                                              --   0 - DML без COMMIT
                                                              --   1 - DML и COMMIT
                           ); if ir<>0 then add_log ('ERRcode - '||SQLCODE||' -ERRmsg- '||SQLERRM||'.' ||rec_kart.kw_klsk,sysdate,i,646, ir);  end if;
       /*------------------------------------------------------------*/
          --2 - вставка физ счетчика  если он есть psch=1,2 или даже если нету                    
                      IF ir =0 and rec_kart.psch in (0,1,2,3) THEN--4;--существует указанная запись U_METER_LOG и неразрешен UPDATE.
                             --      l_id_meter:=null;
                                   l_meter_fk_k_lsk:=null;
                                   oralv.p_meter2.U_METER_INS_UPD
                                   ( 
                                       P_IR => ir
                                     , P_ID => l_id_meter
                                     , P_IS_UPDATEBLE => 1
                                     , P_FK_METER_LOG => l_id_ml
                                     , P_DT => trunc(sysdate,'mm')   -- дата P_DT1(начало периода показания(объема)
                                     , P_FK_K_LSK => l_meter_fk_k_lsk
                                     , P_IS_UNIT1 =>1
                                     , P_IS_COMMIT => 1
                                   ); 
                               IF ir<>0 then add_log ('ERRcode - '||SQLCODE||' -ERRmsg- '||SQLERRM||'.' ||rec_kart.kw_klsk,sysdate,i,663, ir); END IF;     
                                  --добавляем периоды работы счетчика если он есть  
                                  IF ir = 0 and rec_kart.psch in (1,2) THEN  
                                      oralv.p_meter2.U_METER_EXS_INS_UPD 
                                        (P_IR => ir
                                        , P_ID => l_id_exs
                                        , P_FK_METER => l_id_meter
                                        , P_DT1 => case  when coalesce(rec_kart.psch_dt,trunc(sysdate,'mm'))>sysdate 
                                                                    then trunc(sysdate,'mm') 
                                                                  when trunc(sysdate,'mm')<>trunc(coalesce(rec_kart.psch_dt,trunc(sysdate,'mm')),'mm') 
                                                                    then rec_kart.psch_dt   
                                                                  else   trunc(sysdate,'mm') 
                                                           end  
                                        , P_DT2 => to_date('20990101', 'YYYYMMDD') 
                                        , P_IS_UPDATEBLE => 1, 
                                          P_IS_COMMIT => 1);
                                        IF ir<>0 then  add_log ('ERRcode - '||SQLCODE||' -ERRmsg- '||SQLERRM||'.' ||rec_kart.kw_klsk,sysdate,i,679,ir); END IF;
                                  -- если счетчика нету то ставим периоды его работы заканчиваются последним числом пред-го месяца, а начинаются первым числом
                                  ELSIF ir=0 and rec_kart.psch in (0,3) then
                                     oralv.p_meter2.U_METER_EXS_INS_UPD 
                                       ( P_IR => ir
                                        , P_ID => l_id_exs
                                        , P_FK_METER => l_id_meter
                                        , P_DT1 => case  when coalesce(rec_kart.psch_dt,trunc(add_months(sysdate,-1),'mm'))>trunc(add_months(sysdate,-1),'mm')      
                                                                    then trunc(add_months(sysdate,-1),'mm') 
                                                                    else trunc(add_months(sysdate,-1),'mm')  
                                                           end  
                                        , P_DT2 => last_day(add_months(trunc(sysdate,'dd'),-1))
                                        , P_IS_UPDATEBLE => 1, 
                                          P_IS_COMMIT => 1);
                                  END IF;  
                      END IF;      
                           
                  /*-------------------------------------------------------------------------------*/
                  --3-Добавляем объемы и показания по счетчику если есть счетчик  ХВ(psch=1,2)            
                           IF ir =0  and rec_kart.psch in (1,2) THEN
                               IF rec_kart.mhw<>0 THEN
                                    oralv.p_meter2.U_METER_VOL_INS_UPD
                                          (P_IR   => ir
                                          , P_ID  => l_id_meter_vol
                                          , P_FK_METER => l_id_meter
                                          , P_FK_TYPE   => l_meter_vol_fk_type   -- Фактический объем
                                          , P_DT1   => trunc(sysdate,'mm') 
                                          , P_DT2   => last_day(trunc(sysdate)) 
                                          , P_MG    => to_char(trunc(sysdate),'YYYYMM') 
                                          , P_VOL1 => rec_kart.mhw, P_VOL2 => null, P_VOL3 => null, P_SUMM1 =>null, P_SUMM2 => null, P_SUMM3 => null
                                          , P_FK_DOC => 2197
                                          , P_IS_UPDATEBLE => 1, P_IS_COMMIT => 1);
                                            IF ir<>0 then add_log('ERRcode - '||SQLCODE||' -ERRmsg- '||SQLERRM||'.' ||rec_kart.kw_klsk,sysdate,i,710,ir); END IF;
                               END IF;
                               IF ir =0 and rec_kart.phw<>0 THEN 
                                    l_id_meter_vol:=null;
                                    oralv.p_meter2.U_METER_VOL_INS_UPD
                                          (P_IR   => ir
                                          , P_ID  => l_id_meter_vol
                                          , P_FK_METER => l_id_meter
                                          , P_FK_TYPE   => l_meter_vol_fk_type2   --показание счетчика
                                          , P_DT1   => trunc(sysdate,'mm') 
                                          , P_DT2   => last_day(trunc(sysdate)) 
                                          , P_MG    => to_char(trunc(sysdate),'YYYYMM') 
                                          , P_VOL1 => rec_kart.phw, P_VOL2 => null, P_VOL3 => null, P_SUMM1 => null, P_SUMM2 => null, P_SUMM3 => null
                                          , P_FK_DOC => 2197
                                          , P_IS_UPDATEBLE => 1, P_IS_COMMIT => 1);
                                --end показания
                                 IF ir<>0 THEN  add_log('ERRcode - '||SQLCODE||' -ERRmsg- '||SQLERRM||'.' ||rec_kart.kw_klsk,sysdate,i,725,ir); END IF;
                               END IF; 
                           -- если нету счетчика и есть показания, то запишем показания так как раньше он мог быть (PSCH=0,2-нету сч Г.В.)
                           ELSIF ir =0  and rec_kart.psch in (0,3) and rec_kart.phw<>0 THEN  
                                    l_id_meter_vol:=null;
                                    oralv.p_meter2.U_METER_VOL_INS_UPD
                                          (P_IR   => ir
                                          , P_ID  => l_id_meter_vol
                                          , P_FK_METER => l_id_meter
                                          , P_FK_TYPE   => l_meter_vol_fk_type2   --показание счетчика
                                          , P_DT1   => trunc(add_months(sysdate,-1),'mm')  
                                          , P_DT2   => last_day(add_months(trunc(sysdate),-1)) 
                                          , P_MG    => to_char(trunc(add_months(sysdate,-1)),'YYYYMM')
                                          , P_VOL1 => rec_kart.pgw, P_VOL2 => null, P_VOL3 => null, P_SUMM1 => null, P_SUMM2 => null, P_SUMM3 => null
                                          , P_FK_DOC => 2197
                                          , P_IS_UPDATEBLE => 1, P_IS_COMMIT => 1);
                           END IF; -- end объемы 
                  --    END IF;
           --END вставка ФИЗ сч, периодов, объема       
       /*------------------------------------------------------------*/
                          -- если у нас группа ипу на лицевом, и есть счетчик ГВ (psch-1,3) 
                  ELSIF l_parent_ml is not null and rec_kart.kodsch in (98) and rec_kart.psch in (0,1,2,3)  then 
                            FOR rec_grsc IN C_grsc(l_uslm_hw,rec_kart.lsk) LOOP
                               l_id_meter_vol:=null;
                               l_meter_fk_k_lsk:=null;
                               l_id_meter:=null;
                               l_id_exs:=null;
                               --вставка физ счетчика в любом случае
                               oralv.p_meter2.U_METER_INS_UPD
                               ( 
                                   P_IR => ir
                                 , P_ID => l_id_meter
                                 , P_IS_UPDATEBLE => 1
                                 , P_FK_METER_LOG => l_id_ml
                                 , P_DT => trunc(sysdate,'mm')   -- дата P_DT1(начало периода показания(объема)
                                 , P_FK_K_LSK => l_meter_fk_k_lsk
                                 , P_IS_UNIT1 =>1
                                 , P_IS_COMMIT => 1
                               ); 
                               IF ir<>0 then add_log ('ERRcode - '||SQLCODE||' -ERRmsg- '||SQLERRM||'.' ||rec_kart.kw_klsk,sysdate,i,763, ir); END IF;     
                                 --добавляем периоды работы счетчика если он есть  
                               IF ir IN (0) and rec_kart.psch in (1,2) THEN  
                                  oralv.p_meter2.U_METER_EXS_INS_UPD 
                                    (P_IR => ir
                                    , P_ID => l_id_exs
                                    , P_FK_METER => l_id_meter
                                    , P_DT1 => case  when coalesce(rec_kart.psch_dt,trunc(sysdate,'mm'))>sysdate 
                                                                then trunc(sysdate,'mm') 
                                                              when trunc(sysdate,'mm')<>trunc(coalesce(rec_kart.psch_dt,trunc(sysdate,'mm')),'mm') 
                                                                then rec_kart.psch_dt   
                                                              else   trunc(sysdate,'mm') 
                                                       end  
                                    , P_DT2 => to_date('20990101', 'YYYYMMDD') 
                                    , P_IS_UPDATEBLE => 1, 
                                      P_IS_COMMIT => 1);
                                    IF ir<>0 then  add_log ('ERRcode - '||SQLCODE||' -ERRmsg- '||SQLERRM||'.' ||rec_kart.kw_klsk,sysdate,i,779,ir); END IF;
                                    -- если счетчика нету то ставим периоды его работы заканчиваются последним числом пред-го месяца, а начинаются первым числом
                               ELSIF ir=0 and rec_kart.psch in (0,3) then
                                  oralv.p_meter2.U_METER_EXS_INS_UPD 
                                   ( P_IR => ir
                                    , P_ID => l_id_exs
                                    , P_FK_METER => l_id_meter
                                    , P_DT1 => case  when coalesce(rec_kart.psch_dt,trunc(add_months(trunc(sysdate,-1),'mm')))>trunc(add_months(sysdate,-1),'mm')      
                                                                then trunc(add_months(sysdate,-1),'mm') 
                                                                else trunc(add_months(sysdate,-1),'mm')  
                                                       end  
                                    , P_DT2 => last_day(add_months(trunc(sysdate,'dd'),-1))
                                    , P_IS_UPDATEBLE => 1, 
                                      P_IS_COMMIT => 1);
                               END IF;           
                               
                                /*-------------------------------------------------------------------------------*/
                               --3-Добавляем объемы и показания по счетчику если есть счетчик               
                               IF ir IN (0)  and rec_kart.psch in (1,2)  THEN 
                                       IF rec_grsc.mel<>0 THEN
                                            oralv.p_meter2.U_METER_VOL_INS_UPD
                                              (P_IR   => ir
                                              , P_ID  => l_id_meter_vol
                                              , P_FK_METER => l_id_meter
                                              , P_FK_TYPE   => l_meter_vol_fk_type   -- Фактический объем
                                              , P_DT1   => trunc(sysdate,'mm') 
                                              , P_DT2   => last_day(trunc(sysdate)) 
                                              , P_MG    => to_char(trunc(sysdate),'YYYYMM') 
                                              , P_VOL1 => rec_grsc.mel, P_VOL2 => null, P_VOL3 => null, P_SUMM1 =>null, P_SUMM2 => null, P_SUMM3 => null
                                              , P_FK_DOC => 2197
                                              , P_IS_UPDATEBLE => 1, P_IS_COMMIT => 1);
                                              IF ir<>0 then add_log('ERRcode - '||SQLCODE||' -ERRmsg- '||SQLERRM||'.' ||rec_kart.kw_klsk,sysdate,i,809,ir); END IF;
                                       END IF;      
                                       IF ir=0 and rec_grsc.pel<>0 THEN 
                                            l_id_meter_vol:=null;
                                            oralv.p_meter2.U_METER_VOL_INS_UPD
                                                  (P_IR   => ir
                                                  , P_ID  => l_id_meter_vol
                                                  , P_FK_METER => l_id_meter
                                                  , P_FK_TYPE   => l_meter_vol_fk_type2   --показание счетчика
                                                  , P_DT1   => trunc(sysdate,'mm') 
                                                  , P_DT2   => last_day(trunc(sysdate)) 
                                                  , P_MG    => to_char(trunc(sysdate),'YYYYMM') 
                                                  , P_VOL1 => rec_grsc.pel, P_VOL2 => null, P_VOL3 => null, P_SUMM1 => null, P_SUMM2 => null, P_SUMM3 => null
                                                  , P_FK_DOC => 2197
                                                  , P_IS_UPDATEBLE => 1, P_IS_COMMIT => 1);
                                       END IF;--end показания
                                   IF ir<>0 THEN  add_log('ERRcode - '||SQLCODE||' -ERRmsg- '||SQLERRM||'.' ||rec_kart.kw_klsk,sysdate,i,824,ir); END IF;
                               -- если нету счетчика, то запишем показания так как раньше он мог быть
                               ELSIF ir IN (0)  and rec_kart.psch in (0,3) and rec_grsc.pel<>0 THEN  
                                        l_id_meter_vol:=null;
                                        oralv.p_meter2.U_METER_VOL_INS_UPD
                                              (P_IR   => ir
                                              , P_ID  => l_id_meter_vol
                                              , P_FK_METER => l_id_meter
                                              , P_FK_TYPE   => l_meter_vol_fk_type2   --показание счетчика
                                              , P_DT1   => trunc(add_months(sysdate,-1),'mm')  
                                              , P_DT2   => last_day(add_months(trunc(sysdate),-1)) 
                                              , P_MG    => to_char(trunc(add_months(sysdate,-1)),'YYYYMM')
                                              , P_VOL1 => rec_grsc.pel, P_VOL2 => null, P_VOL3 => null, P_SUMM1 => null, P_SUMM2 => null, P_SUMM3 => null
                                              , P_FK_DOC => 2197
                                              , P_IS_UPDATEBLE => 1, P_IS_COMMIT => 1);
                               END IF; -- end объемы
                             END LOOP;    
                  END IF;    
          END; -- END для услуги ХВ     
  /*------------------------------------------------------------------------------------------------------------------*/        
  /*------------------------------------------------------------------------------------------------------------------*/        
-- ДЛЯ УСЛУГИ Эл. Эн
          BEGIN 
               -- В НАШЕЙ КОНЦЕПЦИИ НА ДОМЕ СУЩ-ЕТ ЛОГ СЧ по услугам ХВ,ГВ,ОТ,ЭЛ и по вводам на эти услуги
               -- ОНИ ЯВЛЯЮТСЯ ПАРЕНТАМИ ДЛЯ ОДПУ И ДЛЯ ИПУ. СЧЕТЧИК ОДПУ НЕ МОЖЕТ ЯВЛЯТЬСЯ ПАРЕНТОМ ДЛЯ  ИПУ.
               /*-------------------------------------------------------------------*/
                  L_parent_ml :=null;
                  l_id_meter   :=null;
                  l_id_ml        :=null;
                  l_id_exs       :=null;
                  l_id_meter_vol:=null;
              -- 1  вначале вставляем логич счетчики по горячей воде
               -- узнаем есть ли фэйковый счетчик на доме по услуге и вводу.
                    u_meter_mig.get_parent_id(
                                        p_reu=>rec_kart.reu, 
                                        p_kul=>rec_kart.kul, 
                                        p_nd=>rec_kart.nd, 
                                        p_vvod=>rec_kart.vvod_el, 
                                        p_parent_ml=>L_parent_ml, 
                                        p_k_lsk_obj=>rec_kart.nd_klsk,   -- закидываем сюда klsk дома, 
                                        p_serv=>l_el_id) ;
                                        
                     --если НЕТУ , то вставляем сначало ФЭЙКОВЫЙ СЧЕТЧИК по этому дому по этой услуге и по ввводу
                     --(в fk_klsk_obj вставялем klsk дома-nd_klsk)
                    IF l_parent_ml is null THEN 
                           ORALV.P_METER2.U_METER_LOG_INS_UPD
                           (
                                P_IR => ir--P_IR OUT NUMBER--код возврата: =0 - успешное завершение
                              , P_ID => l_id_ml
                              , P_FK_KLSK_OBJ => rec_kart.nd_klsk
                              , P_FK_SERV => l_el_id 
                              , P_CD => rec_kart.vvod_el
                              , P_DT1 => to_date('20000101', 'YYYYMMDD')  
                              , P_DT2 => to_date('20990101', 'YYYYMMDD')
                              , P_PARENT_ID => null
                              , P_NAME => 'ОДПУ по услуге ЭЛ.ЭН и вводу-'||rec_kart.vvod_el   -- на нем будут сидеть счетчики ОДПУ    !!ИЛИ  счетчики ИПУ  (так как ОДПУ может не быть)
                              , P_IS_UPDATEBLE =>1                 
                              , P_IS_COMMIT => 1 --  -1 - вызов для проверки существования, без DML (и без COMMIT)
                                                              --   0 - DML без COMMIT
                                                              --   1 - DML и COMMIT
                           );  
                           l_parent_ml:=l_id_ml;
                           l_id_ml:=null;
                  END IF;
                  -- вставляем логический ИПУ привязанный к фэйкуовому по вводу услуге
                  --(в fk_klsk_obj вставялем klsk квартиры-kw_klsk)
                  IF  l_parent_ml is not null and ir=0 and rec_kart.kodsc not in (98,99) THEN
                           ORALV.P_METER2.U_METER_LOG_INS_UPD
                           (
                                P_IR => ir--P_IR OUT NUMBER--код возврата: =0 - успешное завершение
                              , P_ID => l_id_ml
                              , P_FK_KLSK_OBJ => rec_kart.kw_klsk
                              , P_FK_SERV => l_el_id 
                              , P_CD => rec_kart.vvod_el
                              , P_DT1 => to_date('20000101', 'YYYYMMDD') 
                              , P_DT2 => to_date('20990101', 'YYYYMMDD')
                              , P_PARENT_ID => l_parent_ml
                              , P_NAME => CASE WHEN rec_kart.kodsc=98 then 'Группа ИПУ на одном Л/С по услуге ' || l_el_id || ' и вводу ' || rec_kart.vvod_el 
                                                           WHEN rec_kart.kodsc=99 then 'Групповой ИПУ на неск Л/С по услуге ' || l_el_id || ' и вводу ' || rec_kart.vvod_el 
                                                            ELSE 'ИПУ по услуге Эл.ЭН. d_sev.id=' || l_el_id || ' и вводу ' || rec_kart.vvod 
                                                  END 
                              --decode(rec_kart.kodscg,98,'Группа ИПУ на одном Л/С по услуге ',99,'Групповой ИПУ на неск Л/С по услуге ','ИПУ по услуге ') || l_gw_id 
                              , P_IS_UPDATEBLE =>1                  
                              , P_IS_COMMIT => 1 --  -1 - вызов для проверки существования, без DML (и без COMMIT)
                                                              --   0 - DML без COMMIT
                                                              --   1 - DML и COMMIT
                           ); if ir<>0 then add_log ('ERRcode - '||SQLCODE||' -ERRmsg- '||SQLERRM||'.' ||rec_kart.kw_klsk,sysdate,i,910, ir);  end if;
       /*------------------------------------------------------------*/
          --2 - вставка физ счетчика  если он есть psch=1,2 или даже если нету                    
                      IF ir =0 THEN--4;--существует указанная запись U_METER_LOG и неразрешен UPDATE.
                             --      l_id_meter:=null;
                                   l_meter_fk_k_lsk:=null;
                                   oralv.p_meter2.U_METER_INS_UPD
                                   ( 
                                       P_IR => ir
                                     , P_ID => l_id_meter
                                     , P_IS_UPDATEBLE => 1
                                     , P_FK_METER_LOG => l_id_ml
                                     , P_DT => trunc(sysdate,'mm')   -- дата P_DT1(начало периода показания(объема)
                                     , P_FK_K_LSK => l_meter_fk_k_lsk
                                     , P_IS_UNIT1 =>1
                                     , P_IS_COMMIT => 1
                                   ); 
                               IF ir<>0 then add_log ('ERRcode - '||SQLCODE||' -ERRmsg- '||SQLERRM||'.' ||rec_kart.kw_klsk,sysdate,i,927, ir); END IF;     
                                  --добавляем периоды работы счетчика если он есть  
                                  IF ir = 0  and rec_kart.sch_el =1 THEN  
                                      oralv.p_meter2.U_METER_EXS_INS_UPD 
                                        (P_IR => ir
                                        , P_ID => l_id_exs
                                        , P_FK_METER => l_id_meter
                                        , P_DT1 => case  when coalesce(rec_kart.schel_dt,trunc(sysdate,'mm'))>sysdate 
                                                                    then trunc(sysdate,'mm') 
                                                                  when trunc(sysdate,'mm')<>trunc(coalesce(rec_kart.schel_dt,trunc(sysdate,'mm')),'mm') 
                                                                    then rec_kart.schel_dt   
                                                                  else   trunc(sysdate,'mm') 
                                                           end  
                                        , P_DT2 => to_date('20990101', 'YYYYMMDD') 
                                        , P_IS_UPDATEBLE => 1, 
                                          P_IS_COMMIT => 1);
                                        IF ir<>0 then  add_log ('ERRcode - '||SQLCODE||' -ERRmsg- '||SQLERRM||'.' ||rec_kart.kw_klsk,sysdate,i,943,ir); END IF;
                                  -- если счетчика нету то ставим периоды его работы заканчиваются последним числом пред-го месяца, а начинаются первым числом
                                  ELSIF ir=0 and rec_kart.sch_el <>1 then
                                     oralv.p_meter2.U_METER_EXS_INS_UPD 
                                       ( P_IR => ir
                                        , P_ID => l_id_exs
                                        , P_FK_METER => l_id_meter
                                        , P_DT1 => case  when coalesce(rec_kart.psch_dt,trunc(add_months(trunc(sysdate),-1),'mm'))>trunc(add_months(sysdate,-1),'mm')      
                                                                    then trunc(add_months(sysdate,-1),'mm') 
                                                                    else trunc(add_months(sysdate,-1),'mm')  
                                                           end  
                                        , P_DT2 => last_day(add_months(trunc(sysdate,'dd'),-1))
                                        , P_IS_UPDATEBLE => 1, 
                                          P_IS_COMMIT => 1);
                                  END IF;  
                      END IF;      
                           
                  /*-------------------------------------------------------------------------------*/
                  --3-Добавляем объемы и показания по счетчику если есть счетчик  ГВ(sch_el=1)            
                           IF ir =0  and rec_kart.sch_el = 1   THEN 
                                IF rec_kart.mel<>0 THEN 
                                     oralv.p_meter2.U_METER_VOL_INS_UPD
                                          (P_IR   => ir
                                          , P_ID  => l_id_meter_vol
                                          , P_FK_METER => l_id_meter
                                          , P_FK_TYPE   => l_meter_vol_fk_type   -- Фактический объем
                                          , P_DT1   => trunc(sysdate,'mm') 
                                          , P_DT2   => last_day(trunc(sysdate)) 
                                          , P_MG    => to_char(trunc(sysdate),'YYYYMM') 
                                          , P_VOL1 => rec_kart.mel, P_VOL2 => null, P_VOL3 => null, P_SUMM1 =>null, P_SUMM2 => null, P_SUMM3 => null
                                          , P_FK_DOC => 2197
                                          , P_IS_UPDATEBLE => 1, P_IS_COMMIT => 1);
                                          IF ir<>0 then add_log('ERRcode - '||SQLCODE||' -ERRmsg- '||SQLERRM||'.' ||rec_kart.kw_klsk,sysdate,i,974,ir); END IF;
                                END IF;
                                IF ir =0 and rec_kart.pel<>0 THEN 
                                    l_id_meter_vol:=null;
                                    oralv.p_meter2.U_METER_VOL_INS_UPD
                                          (P_IR   => ir
                                          , P_ID  => l_id_meter_vol
                                          , P_FK_METER => l_id_meter
                                          , P_FK_TYPE   => l_meter_vol_fk_type2   --показание счетчика
                                          , P_DT1   => trunc(sysdate,'mm') 
                                          , P_DT2   => last_day(trunc(sysdate)) 
                                          , P_MG    => to_char(trunc(sysdate),'YYYYMM') 
                                          , P_VOL1 => rec_kart.pel, P_VOL2 => null, P_VOL3 => null, P_SUMM1 => null, P_SUMM2 => null, P_SUMM3 => null
                                          , P_FK_DOC => 2197
                                          , P_IS_UPDATEBLE => 1, P_IS_COMMIT => 1);
                                    --end показания
                                    IF ir<>0 THEN  add_log('ERRcode - '||SQLCODE||' -ERRmsg- '||SQLERRM||'.' ||rec_kart.kw_klsk,sysdate,i,989,ir); END IF;
                               END IF;
                               -- если нету счетчика и есть показания, то запишем показания так как раньше он мог быть (PSCH=0,2-нету сч Г.В.)
                           ELSIF ir =0  and rec_kart.sch_el <>1 and rec_kart.pel<>0 THEN  
                                    l_id_meter_vol:=null;
                                    oralv.p_meter2.U_METER_VOL_INS_UPD
                                          (P_IR   => ir
                                          , P_ID  => l_id_meter_vol
                                          , P_FK_METER => l_id_meter
                                          , P_FK_TYPE   => l_meter_vol_fk_type2   --показание счетчика
                                          , P_DT1   => trunc(add_months(sysdate,-1),'mm')  
                                          , P_DT2   => last_day(add_months(trunc(sysdate),-1)) 
                                          , P_MG    => to_char(trunc(add_months(sysdate,-1)),'YYYYMM')
                                          , P_VOL1 => rec_kart.pel, P_VOL2 => null, P_VOL3 => null, P_SUMM1 => null, P_SUMM2 => null, P_SUMM3 => null
                                          , P_FK_DOC => 2197
                                          , P_IS_UPDATEBLE => 1, P_IS_COMMIT => 1);
                           END IF; -- end объемы 
                  --    END IF;
           --END вставка ФИЗ сч, периодов, объема       
       /*------------------------------------------------------------*/
                          -- если у нас группа ипу на лицевом, и есть счетчик ГВ (psch-1,3) 
                  ELSIF l_parent_ml is not null and rec_kart.kodsc in (98) then 
                            FOR rec_grsc IN C_grsc(l_uslm_el,rec_kart.lsk) LOOP
                               l_id_meter_vol:=null;
                               l_meter_fk_k_lsk:=null;
                               l_id_meter:=null;
                               l_id_exs:=null;
                               --вставка физ счетчика в любом случае
                               oralv.p_meter2.U_METER_INS_UPD
                               ( 
                                   P_IR => ir
                                 , P_ID => l_id_meter
                                 , P_IS_UPDATEBLE => 1
                                 , P_FK_METER_LOG => l_id_ml
                                 , P_DT => trunc(sysdate,'mm')   -- дата P_DT1(начало периода показания(объема)
                                 , P_FK_K_LSK => l_meter_fk_k_lsk
                                 , P_IS_UNIT1 =>1
                                 , P_IS_COMMIT => 1
                               ); 
                               IF ir<>0 then add_log ('ERRcode - '||SQLCODE||' -ERRmsg- '||SQLERRM||'.' ||rec_kart.kw_klsk,sysdate,i,1027, ir); END IF;     
                                 --добавляем периоды работы счетчика если он есть  
                               IF ir=0 and rec_kart.sch_el =1 THEN  
                                  oralv.p_meter2.U_METER_EXS_INS_UPD 
                                    (P_IR => ir
                                    , P_ID => l_id_exs
                                    , P_FK_METER => l_id_meter
                                    , P_DT1 => case  when coalesce(rec_kart.schel_dt,trunc(sysdate,'mm'))>sysdate 
                                                                then trunc(sysdate,'mm') 
                                                              when trunc(sysdate,'mm')<>trunc(coalesce(rec_kart.schel_dt,trunc(sysdate,'mm')),'mm') 
                                                                then rec_kart.schel_dt   
                                                              else   trunc(sysdate,'mm') 
                                                       end  
                                    , P_DT2 => to_date('20990101', 'YYYYMMDD') 
                                    , P_IS_UPDATEBLE => 1, 
                                      P_IS_COMMIT => 1);
                                    IF ir<>0 then  add_log ('ERRcode - '||SQLCODE||' -ERRmsg- '||SQLERRM||'.' ||rec_kart.kw_klsk,sysdate,i,1043,ir); END IF;
                                    -- если счетчика нету то ставим периоды его работы заканчиваются последним числом пред-го месяца, а начинаются первым числом
                               ELSIF ir=0 and rec_kart.sch_el <>1 then
                                  oralv.p_meter2.U_METER_EXS_INS_UPD 
                                   ( P_IR => ir
                                    , P_ID => l_id_exs
                                    , P_FK_METER => l_id_meter
                                    , P_DT1 => case  when coalesce(rec_kart.schel_dt,trunc(add_months(trunc(sysdate,-1),'mm')))>trunc(add_months(sysdate,-1),'mm')      
                                                                then trunc(add_months(sysdate,-1),'mm') 
                                                                else trunc(add_months(sysdate,-1),'mm')  
                                                       end  
                                    , P_DT2 => last_day(add_months(trunc(sysdate,'dd'),-1))
                                    , P_IS_UPDATEBLE => 1, 
                                      P_IS_COMMIT => 1);
                               END IF;           
                               
                                /*-------------------------------------------------------------------------------*/
                               --3-Добавляем объемы и показания по счетчику если есть счетчик               
                               IF ir=0 and rec_kart.sch_el=1 THEN 
                                     IF rec_grsc.mel<>0 then
                                        oralv.p_meter2.U_METER_VOL_INS_UPD
                                          (P_IR   => ir
                                          , P_ID  => l_id_meter_vol
                                          , P_FK_METER => l_id_meter
                                          , P_FK_TYPE   => l_meter_vol_fk_type   -- Фактический объем
                                          , P_DT1   => trunc(sysdate,'mm') 
                                          , P_DT2   => last_day(trunc(sysdate)) 
                                          , P_MG    => to_char(trunc(sysdate),'YYYYMM') 
                                          , P_VOL1 => rec_grsc.mel, P_VOL2 => null, P_VOL3 => null, P_SUMM1 =>null, P_SUMM2 => null, P_SUMM3 => null
                                          , P_FK_DOC => 2197
                                          , P_IS_UPDATEBLE => 1, P_IS_COMMIT => 1);
                                          IF ir<>0 then add_log('ERRcode - '||SQLCODE||' -ERRmsg- '||SQLERRM||'.' ||rec_kart.kw_klsk,sysdate,i,1073,ir); END IF;
                                      END IF;    
                                      IF ir=0 and rec_grsc.pel<>0 THEN 
                                            l_id_meter_vol:=null;
                                            oralv.p_meter2.U_METER_VOL_INS_UPD
                                                  (P_IR   => ir
                                                  , P_ID  => l_id_meter_vol
                                                  , P_FK_METER => l_id_meter
                                                  , P_FK_TYPE   => l_meter_vol_fk_type2   --показание счетчика
                                                  , P_DT1   => trunc(sysdate,'mm') 
                                                  , P_DT2   => last_day(trunc(sysdate)) 
                                                  , P_MG    => to_char(trunc(sysdate),'YYYYMM') 
                                                  , P_VOL1 => rec_grsc.pel, P_VOL2 => null, P_VOL3 => null, P_SUMM1 => null, P_SUMM2 => null, P_SUMM3 => null
                                                  , P_FK_DOC => 2197
                                                  , P_IS_UPDATEBLE => 1, P_IS_COMMIT => 1);
                                        --  END IF;--end показания
                                            IF ir<>0 THEN  add_log('ERRcode - '||SQLCODE||' -ERRmsg- '||SQLERRM||'.' ||rec_kart.kw_klsk,sysdate,i,1088,ir); END IF;
                                      END IF;   
                               -- если нету счетчика, то запишем показания так как раньше он мог быть
                               ELSIF ir = 0  and rec_kart.sch_el <> 1  and rec_grsc.pel <> 0 THEN  
                                        l_id_meter_vol:=null;
                                        oralv.p_meter2.U_METER_VOL_INS_UPD
                                              (P_IR   => ir
                                              , P_ID  => l_id_meter_vol
                                              , P_FK_METER => l_id_meter
                                              , P_FK_TYPE   => l_meter_vol_fk_type2   --показание счетчика
                                              , P_DT1   => trunc(add_months(sysdate,-1),'mm')  
                                              , P_DT2   => last_day(add_months(trunc(sysdate),-1)) 
                                              , P_MG    => to_char(trunc(add_months(sysdate,-1)),'YYYYMM')
                                              , P_VOL1 => rec_grsc.pel, P_VOL2 => null, P_VOL3 => null, P_SUMM1 => null, P_SUMM2 => null, P_SUMM3 => null
                                              , P_FK_DOC => 2197
                                              , P_IS_UPDATEBLE => 1, P_IS_COMMIT => 1);
                               END IF; -- end объемы
                             END LOOP;    
                  END IF;    
          END; -- END для услуги ЭЛ.ЭН  

      END LOOP;--rec_kart
                  
    END IF;--p_var=3
    dbms_output.put_line('КОНЕЦ-'||to_char (sysdate,'hh24:MI:SS'));
  EXCEPTION
  WHEN OTHERS THEN
       BEGIN
         ROLLBACK;
       --  CLOSE c_d;
           l_err:='ERRcode - '||SQLCODE||' -ERRmsg- '||SQLERRM;
           dbms_output.put_line (l_err);
           ADD_LOG('ERRcode - '||SQLCODE||' -ERRmsg- '||SQLERRM);      
        -- scott.logger.log_(sysdate,'ОШИБКА ВЫПОЛНЕНИЯ ПЛАНА!!!'|| 'ERRcode - '||SQLCODE||' -ERRmsg- '||SQLERRM);
       END;
  END;-- begin if p_var=3
  EXECUTE IMMEDIATE 'alter sequence oralv.seq_base cache 100'; --сбрасываем кэш последовательности
END;
    
-- процедура только для ИПУ
PROCEDURE get_parent_id(p_reu  varchar2, p_kul varchar2, p_nd varchar2 
                                        , p_vvod  varchar2 -- номер ввода у лицевого счета.. может браться из разных полей в зависимости от услуги.
                                        , p_parent_ml in out oralv.U_METER_LOG.ID%TYPE  -- так назвал пот что будет исп-ся как парент id для новой записи счетчика ИПУ 
                                        , p_k_lsk_obj oralv.U_METER_LOG.FK_KLSK_OBJ%TYPE
                                        , p_serv IN number)
IS
CURSOR c1 IS 
    SELECT ml.id, ch.fk_k_lsk-- , ad.name, reu, kul, nd, ml.cd, ml.fk_serv 
               --into p_parent_ml, p_k_lsk_obj
      FROM oralv.c_houses ch,
              oralv.k_lsk kl, oralv.t_addr_tp ad, oralv.u_meter_log ml
     WHERE 
            ad.id = kl.fk_addrtp
        AND ml.fk_klsk_obj = kl.id
        AND kl.id = ch.fk_k_lsk
        AND upper(ad.cd) = 'ДОМ'
        AND ml.fk_serv   = p_serv
        AND ch.reu = p_reu
        AND ch.kul = p_kul
        AND ch.nd  = p_nd 
        AND ml.cd  = p_vvod;
BEGIN
    FOR REC IN C1 LOOP
        p_parent_ml := rec.id;
    END LOOP;
END;

-- процедура проверяет имеется ли логический счетчик по объекту и услуге (объект - дом)
PROCEDURE get_ml_have (p_reu  varchar2, p_kul varchar2, p_nd varchar2 
                                        , p_vvod  varchar2 -- номер ввода у лицевого счета.. может браться из разных полей в зависимости от услуги.
                                        , p_parent_ml in out oralv.U_METER_LOG.ID%TYPE  -- так назвал пот что будет исп-ся как парент id для новой записи счетчика ИПУ 
                                        , p_k_lsk_obj oralv.U_METER_LOG.FK_KLSK_OBJ%TYPE
                                        , p_serv IN number)
IS
CURSOR c1 IS 
    SELECT ml.id, ch.fk_k_lsk-- , ad.name, reu, kul, nd, ml.cd, ml.fk_serv 
               --into p_parent_ml, p_k_lsk_obj
      FROM oralv.c_houses ch,
                oralv.k_lsk kl, oralv.t_addr_tp ad, oralv.u_meter_log ml
    WHERE 
               ad.id=kl.fk_addrtp
        AND ml.fk_klsk_obj=kl.id
        AND kl.id=ch.fk_k_lsk
        AND upper(ad.cd)='ДОМ'
        AND ml.fk_serv=p_serv
        AND ch.reu=p_reu
        AND ch.kul=p_kul
        AND ch.nd=p_nd 
        AND ml.cd=p_vvod;
BEGIN
    FOR REC IN C1 LOOP
        p_parent_ml := rec.id;
    END LOOP;
END;

-- процедура заносит ошибки в лог
PROCEDURE ADD_LOG (p_msg log_parser.msg%type)
   IS
   PRAGMA AUTONOMOUS_TRANSACTION;
BEGIN
     INSERT INTO vaflia.log (msg) VALUES (p_msg);
     COMMIT;
END; 

PROCEDURE ADD_LOG (p_msg varchar2,p_dt date, p_iter number, p_stroka number, p_ir number)
   IS
   PRAGMA AUTONOMOUS_TRANSACTION;
BEGIN
    insert into vaflia.log (msg, dt, iter, stroka, ir) values (p_msg, p_dt, p_iter, p_stroka, p_ir);
    commit;
END;

FUNCTION GET_DOC_TP (p_id oralv.t_doc_tp.id@hotora%type) return number
  IS
  l_id_doc_tp number:=null;
BEGIN  
    SELECT a.id into l_id_doc_tp FROM oralv.t_doc_tp a, oralv.t_doc_tp@hotora b 
    WHERE a.cd=b.cd and b.id=p_id;
    RETURN l_id_doc_tp;
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
END;
    
FUNCTION get_id_ulist (p_id number, p_cd varchar2) return number
IS
    l_id number;
    CURSOR C1 IS
           SELECT u.id  --into l_id 
           FROM ORALV.u_list@HOTORA U_H, ORALV.U_listtp@HOTORA LTP_H,  
                    ORALV.u_list U, ORALV.u_listtp LTP
           WHERE  u_h.id=p_id
           AND u_h.fk_listtp=ltp_h.id
           AND U_H.cd=U.cd
           AND ltp_h.cd=LTP.cd
           AND ltp_h.cd=p_cd;
BEGIN 
 --  l_id:=0;
   FOR c_rec IN c1 LOOP
         l_id:=c_rec.id;
   END LOOP;
     /*      SELECT coalesce(u.id,null) into l_id 
           FROM ORALV.u_list@HOTORA U_H, ORALV.U_listtp@HOTORA LTP_H,  
                    ORALV.u_list U, ORALV.u_listtp LTP
           WHERE  u_h.id=p_id
           AND u_h.fk_listtp=ltp_h.id
           AND U_H.cd=U.cd
           AND ltp_h.cd=LTP.cd
           AND ltp_h.cd=p_cd;*/
   RETURN  l_id;
END;    
END u_meter_mig;
/
