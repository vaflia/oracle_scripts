   --��������� �� SYS ����� �������� ������.
 declare
 l_cnt integer;
 L_role varchar2(1000);
 L_dir varchar2(1000);
 begin
  
  L_role:='ADMIN_FINDAY';
  for rec in (select * from dba_roles where role=L_role) loop
    execute immediate 'DROP ROLE '|| L_role;
  end loop;
  execute immediate 'CREATE ROLE ADMIN_FINDAY NOT IDENTIFIED';
  
  L_role:='ADMIN_REG';
  for rec in (select * from dba_roles where role=L_role) loop
    execute immediate 'DROP ROLE '|| L_role;
  end loop;
  execute immediate 'CREATE ROLE ADMIN_REG NOT IDENTIFIED';
  L_role:='BASE_CONNECT';

  for rec in (select * from dba_roles where role=L_role) loop
    execute immediate 'DROP ROLE '|| L_role;
  end loop;
  execute immediate 'CREATE ROLE BASE_CONNECT NOT IDENTIFIED';
  
  L_role:='CAP_REMONT_DELETE';
  for rec in (select * from dba_roles where role=L_role) loop
    execute immediate 'DROP ROLE '|| L_role;
  end loop;
--execute immediate 'DROP ROLE CAP_REMONT_DELETE';
  execute immediate 'CREATE ROLE CAP_REMONT_DELETE NOT IDENTIFIED';
  
  L_role:='CONNECT';
  for rec in (select * from dba_roles where role=L_role) loop
    execute immediate 'DROP ROLE '|| L_role;
  end loop;
--execute immediate 'DROP ROLE CONNECT';
execute immediate 'CREATE ROLE CONNECT NOT IDENTIFIED';

  L_role:='FINSEQ_ADMIN';
  for rec in (select * from dba_roles where role=L_role) loop
    execute immediate 'DROP ROLE '|| L_role;
  end loop; 
--execute immediate 'DROP ROLE FINSEQ_ADMIN';
execute immediate 'CREATE ROLE FINSEQ_ADMIN NOT IDENTIFIED';

   L_role:='HSKEEP_ADMIN';
  for rec in (select * from dba_roles where role=L_role) loop
    execute immediate 'DROP ROLE '|| L_role;
  end loop; 
--execute immediate 'DROP ROLE HSKEEP_ADMIN';
execute immediate 'CREATE ROLE HSKEEP_ADMIN NOT IDENTIFIED';

 L_role:='HSKEEP_DISPATCHER';
 for rec in (select * from dba_roles where role=L_role) loop
   execute immediate 'DROP ROLE '|| L_role;
 end loop;  
--execute immediate 'DROP ROLE HSKEEP_DISPATCHER';
execute immediate 'CREATE ROLE HSKEEP_DISPATCHER NOT IDENTIFIED';

  L_role:='HSKEEP_ECON';
  for rec in (select * from dba_roles where role=L_role) loop
    execute immediate 'DROP ROLE '|| L_role;
  end loop;  
--execute immediate 'DROP ROLE HSKEEP_ECON';
execute immediate 'CREATE ROLE HSKEEP_ECON NOT IDENTIFIED';

  L_role:='HSKEEP_ENGINEER';
  for rec in (select * from dba_roles where role=L_role) loop
    execute immediate 'DROP ROLE '|| L_role;
  end loop;  
--execute immediate 'DROP ROLE HSKEEP_ENGINEER';
execute immediate 'CREATE ROLE HSKEEP_ENGINEER NOT IDENTIFIED';

   L_role:='HSKEEP_FUNPROC';
  for rec in (select * from dba_roles where role=L_role) loop
    execute immediate 'DROP ROLE '|| L_role;
  end loop;  
--execute immediate 'DROP ROLE HSKEEP_FUNPROC';
execute immediate 'CREATE ROLE HSKEEP_FUNPROC NOT IDENTIFIED';

   L_role:='HSKEEP_METER';
  for rec in (select * from dba_roles where role=L_role) loop
    execute immediate 'DROP ROLE '|| L_role;
  end loop;  
--execute immediate 'DROP ROLE HSKEEP_METER';
 execute immediate 'CREATE ROLE HSKEEP_METER NOT IDENTIFIED';

 L_role:='KASS_BASE';
 for rec in (select * from dba_roles where role=L_role) loop
   execute immediate 'DROP ROLE '|| L_role;
 end loop;  
 --execute immediate 'DROP ROLE KASS_BASE';
 execute immediate  'CREATE ROLE KASS_BASE  NOT IDENTIFIED';

 L_role:='PAYDOC_USER';
 for rec in (select * from dba_roles where role=L_role) loop
   execute immediate 'DROP ROLE '|| L_role;
 end loop;  
 --execute immediate 'DROP ROLE PAYDOC_USER';
 execute immediate 'CREATE ROLE PAYDOC_USER NOT IDENTIFIED';
 
 L_role:='VALIDATOR';
 for rec in (select * from dba_roles where role=L_role) loop
   execute immediate 'DROP ROLE '|| L_role;
 end loop;  
 --execute immediate 'DROP ROLE VALIDATOR';
 execute immediate 'CREATE ROLE VALIDATOR NOT IDENTIFIED';
 
      L_role:='����_���_������';
  for rec in (select * from dba_roles where role=L_role) loop
    execute immediate 'DROP ROLE '|| L_role;
  end loop;  
--execute immediate 'DROP ROLE ����_���_������';
execute immediate 'CREATE ROLE ����_���_������ NOT IDENTIFIED';

      L_role:='����_����������';
  for rec in (select * from dba_roles where role=L_role) loop
    execute immediate 'DROP ROLE '|| L_role;
  end loop;  
--execute immediate 'DROP ROLE ����_����������';
execute immediate 'CREATE ROLE ����_���������� NOT IDENTIFIED';

  L_role:='����_����������_�����';
  for rec in (select * from dba_roles where role=L_role) loop
    execute immediate 'DROP ROLE '|| L_role;
  end loop;  
--execute immediate 'DROP ROLE ����_����������_�����';
execute immediate 'CREATE ROLE ����_����������_����� NOT IDENTIFIED';

 L_role:='����_�����';
  for rec in (select * from dba_roles where role=L_role) loop
    execute immediate 'DROP ROLE '|| L_role;
  end loop;  
--execute immediate 'DROP ROLE ����_�����';
execute immediate 'CREATE ROLE ����_����� NOT IDENTIFIED';

  L_role:='����_�����';
  for rec in (select * from dba_roles where role=L_role) loop
    execute immediate 'DROP ROLE '|| L_role;
  end loop;  
 --execute immediate 'DROP ROLE ����_�����';
 execute immediate 'CREATE ROLE ����_����� NOT IDENTIFIED';
 
   L_role:='�������_��������';
  for rec in (select * from dba_roles where role=L_role) loop
    execute immediate 'DROP ROLE '|| L_role;
  end loop;  
 --execute immediate 'DROP ROLE �������_��������';
  execute immediate 'CREATE ROLE �������_�������� NOT IDENTIFIED';
  
    L_role:='������';
  for rec in (select * from dba_roles where role=L_role) loop
    execute immediate 'DROP ROLE '|| L_role;
  end loop;  
--execute immediate 'DROP ROLE ������';
execute immediate 'CREATE ROLE ������ NOT IDENTIFIED';

--execute immediate 'DROP ROLE ���_������';
  L_role:='���_������';
  for rec in (select * from dba_roles where role=L_role) loop
    execute immediate 'DROP ROLE '|| L_role;
  end loop;  
execute immediate 'CREATE ROLE ���_������ NOT IDENTIFIED';

  L_role:='���_������_�����';
  for rec in (select * from dba_roles where role=L_role) loop
    execute immediate 'DROP ROLE '|| L_role;
  end loop;  
--execute immediate 'DROP ROLE ���_������_�����';
execute immediate 'CREATE ROLE ���_������_����� NOT IDENTIFIED';

 L_role:='������';
  for rec in (select * from dba_roles where role=L_role) loop
    execute immediate 'DROP ROLE '|| L_role;
  end loop;  
--execute immediate 'DROP ROLE ������';
execute immediate 'CREATE ROLE ������ NOT IDENTIFIED';

   L_role:='����_����';
  for rec in (select * from dba_roles where role=L_role) loop
    execute immediate 'DROP ROLE '|| L_role;
  end loop;  
--execute immediate 'DROP ROLE ����_����';
execute immediate 'CREATE ROLE ����_���� NOT IDENTIFIED';

   L_role:='SVCO_REP_ADMIN';
  for rec in (select * from dba_roles where role=L_role) loop
    execute immediate 'DROP ROLE '|| L_role;
  end loop;  
execute immediate 'CREATE ROLE SVCO_REP_ADMIN NOT IDENTIFIED';

   L_role:='SVCO_REP_OPERATOR';
  for rec in (select * from dba_roles where role=L_role) loop
    execute immediate 'DROP ROLE '|| L_role;
  end loop;  
execute immediate 'CREATE ROLE SVCO_REP_OPERATOR NOT IDENTIFIED';

   L_role:='��������_�����';
  for rec in (select * from dba_roles where role=L_role) loop
    execute immediate 'DROP ROLE '|| L_role;
  end loop;  
--execute immediate 'DROP ROLE ��������_�����';
execute immediate 'CREATE ROLE ��������_����� NOT IDENTIFIED';

   L_role:='��������';
  for rec in (select * from dba_roles where role=L_role) loop
    execute immediate 'DROP ROLE '|| L_role;
  end loop;  
--execute immediate 'DROP ROLE ��������';
execute immediate 'CREATE ROLE �������� NOT IDENTIFIED';

   L_role:='����������������_�����';
  for rec in (select * from dba_roles where role=L_role) loop
    execute immediate 'DROP ROLE '|| L_role;
  end loop;  
--execute immediate 'DROP ROLE ����������������_�����';
execute immediate 'CREATE ROLE ����������������_����� NOT IDENTIFIED';

   L_role:='���_�������������';
  for rec in (select * from dba_roles where role=L_role) loop
    execute immediate 'DROP ROLE '|| L_role;
  end loop;  
--execute immediate 'DROP ROLE ���_�������������';
execute immediate 'CREATE ROLE ���_������������� NOT IDENTIFIED';

end;