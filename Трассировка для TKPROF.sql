--����������� �� SYSDBA
--    ������� ������������ ��� ������, ��������, ���:
    select sid, serial#, username, machine, program from v$session;
--    ����� �������� ������ � ������� where, ��������, ���:
    select sid, serial#, username, machine, program from v$session where username = 'SCOTT';
--    ������� ������������� �������� � ������������ ������� (�� ��� ����������� ��� ���������� ����� �����������):
    select p.spid,  s.username, s.machine, s.program from v$session s, v$process p where s.paddr=p.addr;
--    ��� ���������� p.spid
--    ����� ��������� ������� ��������� �������� (���� �� ����� SID ������������(��) ��� ������(�):
    select u_dump.value
        || '/'
        || db_name.value
        || '_ora_'
        || v$process.spid
        || nvl2(v$process.traceid,  '_' || v$process.traceid, null ) 
        || '.trc'  "Trace File"
    from v$parameter u_dump 
    cross join v$parameter db_name
    cross join v$process 
    join v$session on v$process.addr = v$session.paddr
    where u_dump.name   = 'user_dump_dest'
      and db_name.name  = 'db_name'
      and v$session.sid in (&SID)
--    �������� ���� ��������� ���������� (����� �������������� ����� ����� ���������� � �������� ���������):
    alter system set timed_statistics=true;
--   �������� ����������� ������:
    begin
        sys.dbms_system.set_ev(131, 1388, 10046, 12, '');
    end;
 /*   ���:
        131 - sid �� �������, ���������� � �.1;
        1388 - serial# ������ ��;
        12 - ������� �����������:
            0 - ����������� ���������.
            1 - ����������� �������. ��������� �� ���������� �� ��������� ��������� sql_trace=true
            4 - � �������������� ���� ����������� �������� ��������� ����������.
            8 - � �������������� ���� ����������� �������� �������� ������� �� ������ ��������.
            12 - �����������, ��� �������� ��������� ����������, ��� � ���������� �� ��������� �������.*/
--    ��������� ������ ��� ������ ������� �����-�� ����� ��� ����� ���������� � ������������� �����������:
    begin
        sys.dbms_system.set_ev(131, 1388, 10046, 0, '');
    end;
--    �������� ����������������� ������ �����������:
    select value from v$parameter p where name='user_dump_dest';
--    ��������� � ������� � ��������������� ������� (��. �.6) � ������������ �������������� ���� �������� tkprof ��� ��������� "�����������" ����������:
--    tkprof db01_ora_1756.trc d:\out.txt
--    ���� ������ ����� ��� ���������� ���� <ORACLE_SID>_ora_<p.spid>.trc
/*    ���:
        <ORACLE_SID> - ORACLE_SID ������������ ��� ����;
        <p.spid> - ���� p.spid �� �������, ���������� � �.2.
*/
--����������� ����������� ������
--������������ ������ ���� ������ ����������:
grant alter session to <USER>;
--    �������� timed_statistics:
    alter session set timed_statistics=true;
--    ���� �����, �� ����� �������� ����������� ������� ����� �����������:
    alter session set max_dump_file_size='20M';
--    ����� ������ ����������� ������������� ����� �����:
    alter session set tracefile_identifier="MyTrace";
--    �������� �����������:
    alter session set sql_trace=true;
--    ���
    alter session set events '10046 trace name context forever, level 12';
/*    ��� level:
        1 � ������� ����������
        4 � level 1 + �������� ����������
        8 � level 1 + ������� ��������
        12 � ������������ ������� �����������*/
--��������� �����������:
alter session set sql_trace=false;
--���
alter session set events '10046 trace name context off';
--autotrace � ������ �� SYSDBA.
--������������ ������ ���� ������ ����������:
grant alter session to <USER>;
grant select any dictionary to <USER>
--�� ������������.
--�������� �����������:
set autotrace on;
--���������, ��������:
select table_name from user_tables;
--��������� �����������:
set autotrace off;