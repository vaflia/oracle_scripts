SQL> create package rowtypes is
  2    cursor cur is select * from all_objects;
  3    type tbl is table of cur%rowtype;
  4    function f return tbl pipelined;
  5  end;
  6  /
 
Package created
SQL> create package body rowtypes is
  2    function f return tbl pipelined is
  3    begin
  4      for rec in cur loop
  5        pipe row (rec);
  6      end loop;
  7    end;
  8  end;
  9  /
 
Package body created
 
SQL> select count(*) from table(rowtypes.f);
 
  COUNT(*)
----------
     55009