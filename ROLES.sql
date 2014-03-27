   --гюосяйюрэ нр SYS ОНЯКЕ ЯНГДЮМХЪ ЧГЕПНБ.
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
 
      L_role:='асуц_йюо_пелнмр';
  for rec in (select * from dba_roles where role=L_role) loop
    execute immediate 'DROP ROLE '|| L_role;
  end loop;  
--execute immediate 'DROP ROLE асуц_йюо_пелнмр';
execute immediate 'CREATE ROLE асуц_йюо_пелнмр NOT IDENTIFIED';

      L_role:='асуц_йбюпрокюрш';
  for rec in (select * from dba_roles where role=L_role) loop
    execute immediate 'DROP ROLE '|| L_role;
  end loop;  
--execute immediate 'DROP ROLE асуц_йбюпрокюрш';
execute immediate 'CREATE ROLE асуц_йбюпрокюрш NOT IDENTIFIED';

  L_role:='асуц_йбюпрокюрш_рпеяр';
  for rec in (select * from dba_roles where role=L_role) loop
    execute immediate 'DROP ROLE '|| L_role;
  end loop;  
--execute immediate 'DROP ROLE асуц_йбюпрокюрш_рпеяр';
execute immediate 'CREATE ROLE асуц_йбюпрокюрш_рпеяр NOT IDENTIFIED';

 L_role:='асуц_кэцнр';
  for rec in (select * from dba_roles where role=L_role) loop
    execute immediate 'DROP ROLE '|| L_role;
  end loop;  
--execute immediate 'DROP ROLE асуц_кэцнр';
execute immediate 'CREATE ROLE асуц_кэцнр NOT IDENTIFIED';

  L_role:='асуц_яверю';
  for rec in (select * from dba_roles where role=L_role) loop
    execute immediate 'DROP ROLE '|| L_role;
  end loop;  
 --execute immediate 'DROP ROLE асуц_яверю';
 execute immediate 'CREATE ROLE асуц_яверю NOT IDENTIFIED';
 
   L_role:='цкюбмши_ноепюрнп';
  for rec in (select * from dba_roles where role=L_role) loop
    execute immediate 'DROP ROLE '|| L_role;
  end loop;  
 --execute immediate 'DROP ROLE цкюбмши_ноепюрнп';
  execute immediate 'CREATE ROLE цкюбмши_ноепюрнп NOT IDENTIFIED';
  
    L_role:='фспмюк';
  for rec in (select * from dba_roles where role=L_role) loop
    execute immediate 'DROP ROLE '|| L_role;
  end loop;  
--execute immediate 'DROP ROLE фспмюк';
execute immediate 'CREATE ROLE фспмюк NOT IDENTIFIED';

--execute immediate 'DROP ROLE йюо_пелнмр';
  L_role:='йюо_пелнмр';
  for rec in (select * from dba_roles where role=L_role) loop
    execute immediate 'DROP ROLE '|| L_role;
  end loop;  
execute immediate 'CREATE ROLE йюо_пелнмр NOT IDENTIFIED';

  L_role:='йюо_пелнмр_рпеяр';
  for rec in (select * from dba_roles where role=L_role) loop
    execute immediate 'DROP ROLE '|| L_role;
  end loop;  
--execute immediate 'DROP ROLE йюо_пелнмр_рпеяр';
execute immediate 'CREATE ROLE йюо_пелнмр_рпеяр NOT IDENTIFIED';

 L_role:='йюяяхп';
  for rec in (select * from dba_roles where role=L_role) loop
    execute immediate 'DROP ROLE '|| L_role;
  end loop;  
--execute immediate 'DROP ROLE йюяяхп';
execute immediate 'CREATE ROLE йюяяхп NOT IDENTIFIED';

   L_role:='оюяо_ярнк';
  for rec in (select * from dba_roles where role=L_role) loop
    execute immediate 'DROP ROLE '|| L_role;
  end loop;  
--execute immediate 'DROP ROLE оюяо_ярнк';
execute immediate 'CREATE ROLE оюяо_ярнк NOT IDENTIFIED';

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

   L_role:='окюмнбши_нрдек';
  for rec in (select * from dba_roles where role=L_role) loop
    execute immediate 'DROP ROLE '|| L_role;
  end loop;  
--execute immediate 'DROP ROLE окюмнбши_нрдек';
execute immediate 'CREATE ROLE окюмнбши_нрдек NOT IDENTIFIED';

   L_role:='окюрефйх';
  for rec in (select * from dba_roles where role=L_role) loop
    execute immediate 'DROP ROLE '|| L_role;
  end loop;  
--execute immediate 'DROP ROLE окюрефйх';
execute immediate 'CREATE ROLE окюрефйх NOT IDENTIFIED';

   L_role:='опнхгбндярбеммши_нрдек';
  for rec in (select * from dba_roles where role=L_role) loop
    execute immediate 'DROP ROLE '|| L_role;
  end loop;  
--execute immediate 'DROP ROLE опнхгбндярбеммши_нрдек';
execute immediate 'CREATE ROLE опнхгбндярбеммши_нрдек NOT IDENTIFIED';

   L_role:='щйн_юдлхмхярпюжхх';
  for rec in (select * from dba_roles where role=L_role) loop
    execute immediate 'DROP ROLE '|| L_role;
  end loop;  
--execute immediate 'DROP ROLE щйн_юдлхмхярпюжхх';
execute immediate 'CREATE ROLE щйн_юдлхмхярпюжхх NOT IDENTIFIED';

end;