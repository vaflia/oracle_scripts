

SELECT l.id FROM oralv.u_listtp lt, oralv.u_list l
                                        WHERE lt.cd='LOG'
                                              AND l.id IN ( SELECT l2.id FROM oralv.u_list l2
                                                            WHERE l2.fk_listtp=lt.id
                                                            START WITH l2.cd='¬—≈ журналы'    --'ѕлан типовой'
                                                            CONNECT BY l2.parent_id=PRIOR l2.id)
                                                            

SELECT l.id FROM  oralv.u_list l
                                        WHERE 
                                             l.id IN ( SELECT l2.id FROM oralv.u_list l2, oralv.u_listtp lt
                                                         WHERE l2.fk_listtp=lt.id
                                                              and lt.cd='LOG'
                                                         START WITH l2.cd='¬—≈ журналы'    --'ѕлан типовой'
                                                         CONNECT BY l2.parent_id=PRIOR l2.id)                                                            
                                                         
                                                         
      SELECT COUNT(*) FROM oralv.u_meter t 
         WHERE t.fk_meter_log= 1
               AND (  ('01.09.2013' BETWEEN t.dt1 AND t.dt2)
                    OR('01.09.2013' BETWEEN t.dt1 AND t.dt2)
                    OR(t.dt1 BETWEEN '01.09.2013' AND '01.09.2013')
                    OR(t.dt2 BETWEEN '01.09.2013' AND '01.09.2013')
                    );
                    
                    
                    select mv.*,doctp.name, ml.fk_hfpar,hfp.name
                     from oralv.u_meter_vol@hotora mv,
                                        oralv.t_doc@hotora d,
                                        oralv.t_doc_tp@hotora doctp,
                                        oralv.u_meter@hotora m,
                                        oralv.u_meter_log@hotora ml,
                                        ORALV.U_HFPAR@hotora hfp
                    where -- vol1 <>0 and 
                          doctp.id in (9,11)
                    and doctp.id=d.fk_doctp
                    and mv.fk_doc=d.id
                    and m.id=mv.fk_meter
                    and ml.id=m.fk_meter_log
                    and ml.fk_hfpar=hfp.id
                    and fk_doc=264243
                    
                    SELECT mv.*,doctp.name, ml.fk_hfpar,hfp.name
                      FROM oralv.u_meter_vol  mv,
                                        oralv.t_doc  d,
                                        oralv.t_doc_tp  doctp,
                                        oralv.u_meter  m,
                                        oralv.u_meter_log  ml,
                                        ORALV.U_HFPAR  hfp
                    WHERE -- vol1 <>0 and 
                          doctp.id in (9,11)
                    and doctp.id=d.fk_doctp
                    and mv.fk_doc=d.id
                    and m.id=mv.fk_meter
                    and ml.id=m.fk_meter_log
                    and ml.fk_hfpar=hfp.id
                    and fk_doc=264243
                    
                    select * from scott.kart where KODSC=99
                    select * from scott.kart 
                    where lsk in ('65030744','65030745','65022765','65022766')
                    
                    SCOTT.SPTAR
                    
select * from scott.kart where lsk='36010339'
                    
                    scott.usl
                    
             select kpr, kpr_ot,reu,kul,nd,kw,lsk,psch,PEL,MEL,PGW,MGW,PHW,MHW,
                    KODSC,KODSCH,KODSCG
          from scott.load_kart where lsk in ('66097949','66090035','66189206','72198626','72198627','78020015','78020024','10173728','10141447','10141446') 
          and
           psch=0
          
         select * from scott.kart where psch =0
         
         select * from LDO.LOAD_GW where tip=4
         
         1 Ч электроэнерги€, 2 - холодна€ вода , 3 Ч гор€ча€ вода, 4 Ч отопление
         
           select * from ldo.load_gw
  where reu='74' and kul='0588' and nd='000022'
  
 select * from oralv.c_houses where reu='74' and kul='0588' and nd='000022'
 fk_k_lsk=472380
 
 select * from oralv.u_meter_log where fk_klsk_obj=472380
  select * from oralv.u_meter_vol where fk_doc=249686
 8250226
8250223
8250220
8250217
8250214
8256999

 select * from oralv.u_meter where fk_meter_log in (8250226,8250223,8250220,8250217,8250214,8256999)
 SELECT fk_doc,vol1,vol2,vol3, d.mg
   FROM oralv.u_meter_vol mv, oralv.t_doc d 
 WHERE MV.FK_DOC=d.id
 AND fk_meter in (8250215,8250218,8250221,8250224,8250227,8257000) --and fk_doc=249686
 GROUP BY fk_doc, d.mg
 
 select * from oralv.t_doc where fk_doctp=11
 oralv.t_doc_tp
 doc.id=249686 это за июнь
 
 select count(*),tip,reu,kul,nd from
 ldo.load_gw  
 group by tip,reu,kul,nd
 
   select * from ldo.load_gw
  where reu='74' and kul='0588' and nd='000022'
  
oralv.u_meter_vol

select period_cap from params
scott.usl