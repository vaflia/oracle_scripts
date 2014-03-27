          SELECT
                    ml.id,ch.reu,ch.kul,ch.nd,ml.cd,
                     /*�����������*/
                    --1- ���� �� �� �� ���������
                    --2- ����� �� �� �� ���� �� ���������
                    coalesce(sum(case when par.cd='���_����' and doctp.cd='����-�������' then mv.vol2 end),0) as sf_gkal_otopl,
                    coalesce(sum(case when par.cd='���_����' and doctp.cd='����-�������' then mv.summ2 end),0) as sf_summ_gkal_otopl,                
                     /*�����������*/
                    --1- ���� �� �� �� ��
                    --2- ����� �� �� �� ���� �� ��
                    --3- ����� �� �� �� ��
                    --4- ����� �� �� �� ������ ��� �� ��
                    coalesce(sum(case when par.cd='���_��' and doctp.cd='����-�������' then mv.vol2 end),0) as sf_gkal_gv,
                    coalesce(sum(case when par.cd='���_��' and doctp.cd='����-�������' then mv.summ2 end),0) as sf_summ_gkal_gv,
                    coalesce(sum(case when par.cd='���_��' and doctp.cd='����-�������' then mv.vol1 end),0) as sf_metr_gv,
                    coalesce(sum(case when par.cd='���_��' and doctp.cd='����-�������' then mv.summ1 end),0) as sf_summ_metr_gv,
                    /*������� �� ����*/
                    --1- ����   �� ���������
                    --2- ����   �� ��             
                    --3- ����  �� ��
                    coalesce(sum(case when par.cd='���_����' and doctp.cd='�������� ������ ����' then mv.vol2 end),0) as odpu_otopl_gkal,
                    coalesce(sum(case when par.cd='���_��' and doctp.cd='�������� ������ ����' then mv.vol2 end),0) as odpu_gv_gkal,
                    coalesce(sum(case when par.cd='���_��' and doctp.cd='�������� ������ ����' then mv.vol1 end),0) as odpu_gv_metr,
                    /*V ����������� �������� �������*/
                    coalesce(sum(case when par.cd='���_����' and doctp.cd='�������� ������ ����' then mv.vol3 end),0) as vol_te
            FROM oralv.u_meter m,
                     oralv.u_meter_log ml     
                     ,oralv.u_meter_vol mv
                     ,oralv.u_hfpar par
               --      ,ORALV.U_LIST i
                     ,oralv.c_houses ch,
                     scott.spul sp,
                     scott.s_reu_trest s,
                     oralv.t_doc doc,
                     oralv.t_doc_tp doctp
            WHERE
                    doc.mg between '201302' and '201302' AND
                    ml.id = M.FK_METER_LOG  AND
                    m.id = mv.fk_meter (+) AND
                    par.id=ml.fk_hfpar AND
                 --   i.id=ml.fk_unit1 AND 
                    (par.cd='���_��' or par.cd='���_����') 
                    and ch.fk_k_lsk = ml.fk_klsk_obj and
                    ch.kul=sp.id  AND 
                    s.reu=ch.reu
                    and doc.id=mv.fk_doc
                    and doc.fk_doctp=doctp.id
            --        and s.trest='65'
            GROUP BY  ml.id,ch.reu,ch.kul,ch.nd,ml.cd
            
select * from oralv.u_meter_vol where fk_meter=8252140
order by dt1

/*�������. ����� ��� ������ �� 0.24 � meter_vol.*/
select * from oralv.u_meter_vol where fk_meter=8254584
select * 
from ldo.LOAD_GW t 
where kul='0094' and nd='000081' and t.tip=4
/*+ �������. �������������� - � dom_vvod ��� ��� �����, 
       � ��� � meter_log ���� ����, 
       ���� � meter_vol ������ ��� ������ �� 0.24.*/
select * from oralv.u_meter_vol where fk_meter=8254088
select * 
from ldo.LOAD_GW t 
where kul='0061' and nd='000007' and t.tip=4

select * from oralv.c_houses
where kul='0061' and nd='000007' and reu='L2'

select * from scott.kart 
where kul='0094' and nd='000081'