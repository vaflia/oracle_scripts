declare
  a number;
  function test(l_par number) return number is
  begin
      return 1;
  end;
begin
  for c in (select * from scott.sprorg u) loop
      a := test(c.kod);
    end loop;
end;

declare
  a number;

  function test(l_rec sprorg%rowtype) return number is
  begin
  
    return l_rec.kod;
  end;

begin
  DBMS_OUTPUT.enable;

  for c in (select * from sprorg u) loop
  
    a := test(c);
    DBMS_OUTPUT.put_line(a);  
  end loop;


end;




declare
  a number;
  cursor c1 is (select * from scott.sprorg u);
  l_rec scott.sprorg%rowtype;
  function test(l_par number) return number is
  begin
    return l_rec.kod+10000;
  end;
  
begin
 open c1;
 LOOP 
        EXIT WHEN c1%NOTFOUND;
        fetch c1 into l_rec ;
        a := test(l_rec.kod);
        DBMS_OUTPUT.enable;
        DBMS_OUTPUT.put_line(a);
 end loop;       
  --for c in (select * from scott.sprorg u) loop
--      a := test(c.kod);
--    end loop;
end;