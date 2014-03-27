Declare
 type t is table of base%rowtype index by pls_integer;
 i integer;
 k integer;
BEGIN
  select * bulk collect into r from base;
  forall k in r.first..r.last 
        delete from base where nomer like r(k).nomer;
        dbms_output.put_line(sql%rowcount);
END: