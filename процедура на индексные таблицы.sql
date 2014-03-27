DECLARE
        type t_usl is record
        ( usl varchar(150),  spk varchar (150) );
        type usl_array is table of t_usl index by binary_integer;
        l_data usl_array;
        
        
      type temp_spk   is table of  varchar2(110) ;
      type temp_usl   is table of varchar2(110) ;
      l_usl      temp_usl;
      l_spk     temp_usl;
BEGIN
 SELECT u.usl,u.spk BULK COLLECT INTO l_usl,l_spk FROM scott.usl u WHERE spk IS NOT NULL;
 for i in 1 .. l_usl.count
 loop
     DBMS_OUTPUT.put_line(l_usl(i));
 end loop;
 
 FORALL i in 1 .. l_usl.count
       Execute immediate ' INSERT INTO prep.spk_usl_mg(spk_id, usl_id, mg) 
                                SELECT nk, :usl_, p.period FROM scott.load_spk s, scott.params p WHERE nk IS NOT NULL' USING l_usl(i);-- (l_usl(i),l_spk(i)) ;
             --SELECT nk, l_key(i),l_val(i), p.period FROM scott.load_spk s, scott.params p WHERE nk IS NOT NULL;  
END;