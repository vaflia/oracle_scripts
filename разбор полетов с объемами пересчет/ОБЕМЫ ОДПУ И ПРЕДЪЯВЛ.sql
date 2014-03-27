select 
                 '���-'||ch.reu||' '||u.name||', �.'||ltrim(ch.nd,'0')|| ' ����� � '||ml.cd as vvod_gw,
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
                
              --  coalesce(sum(case when par.cd='���_����' and doctp.cd='�������� ������ ����' then mv.vol1 end),0) as odpu_otopl_gkal,
ch.reu,ch.kul,ch.nd
        FROM oralv.u_meter m,
                 oralv.u_meter_log ml     
                 ,oralv.u_meter_vol mv
                 ,oralv.u_hfpar par
                 ,ORALV.U_LIST i
                 ,oralv.c_houses ch,
                 scott.params p,
                 scott.spul u,
                 scott.s_reu_trest s,
                 oralv.t_doc doc,
                 oralv.t_doc_tp doctp
        WHERE
                --doc.mg between '201301' and '201301' AND
                mv.dtf between '01.01.2013' and '31.01.2013' and
                ml.id = M.FK_METER_LOG  AND
                m.id = mv.fk_meter (+) AND
                par.id=ml.fk_hfpar AND
                i.id=ml.fk_unit1 AND 
                (par.cd='���_��' or par.cd='���_����') 
                and ch.fk_k_lsk = ml.fk_klsk_obj and
                ch.kul=u.id  AND 
                s.reu=ch.reu
                and doc.id=mv.fk_doc
                and doc.fk_doctp=doctp.id
                and s.reu='73'
         --       and ch.reu='K2'
          --      and ch.kul='0118'
          --      and ch.nd='000020'
        GROUP BY   '���-'||ch.reu||' '||u.name||', �.'||ltrim(ch.nd,'0')|| ' ����� � '||ml.cd, ch.reu,ch.kul,ch.nd,u.name||', �.'||ltrim(ch.nd,'0')
        order by u.name||', �.'||ltrim(ch.nd,'0')
        
        


        select  *from oralv.t_doc where id=203138
        oralv.t_org
        oralv.u_hfpar
        select * from oralv.u_meter_vol where summ2='17504,23' 
        id=8252688
        select * from oralv.u_meter where id=8252687
        select * from oralv.k_lsk where id=1044003
        select * from oralv.u_meter_log where id=8252686
        
        select * from oralv.u_meter where id=8252687
        select * from oralv.u_meter_log where id=8252686
        select * from oralv.t_doc where id in (202977,203138)
        oralv.t_doc_tp
        select * from oralv.u_meter where id=8254275
        select * from oralv.u_meter_log where id=8254274
        oralv.c_houses
        
 fk_doc  vol2 summ1 summ2     
202967    0            0           0
203138    16,789    0    17504,23
202977    16,789    0    17504,23
201867    3    2    4
202978    3    2    4
201867    3    2    4

select * from oralv.t_doc where fk_doctp=9