MERGE INTO scott.xitog2_s_lsk_test a
     USING (SELECT reu,
                   kul,
                   nd,
                   gaz
              FROM scott.load_koop
             WHERE '201311' BETWEEN dat_nach AND dat_end) b
        ON (a.reu = b.reu AND a.kul = b.kul AND a.nd = b.nd AND a.mg = '201311')
WHEN MATCHED
THEN
   UPDATE SET A.GAZ = b.gaz;
   
   
UPDATE scott.xitog2_s_lsk_test a 
SET A.GAZ =(SELECT  b.gaz FROM scott.load_koop b
             WHERE '201311' BETWEEN dat_nach AND dat_end 
                  and 
                  a.reu = b.reu AND a.kul = b.kul AND a.nd = b.nd)
WHERE a.mg = '201311'



CREATE TABLE SCOTT.XITOG2_S_LSK_test as 
SELECT * FROM SCOTT.XITOG2_S_LSK@NEWHOTORA.UEZKU.NET where mg='201311'



select count (*) from scott.xitog2_s_lsk_test where mg='201311'



oralv.t_org
select * from scott.prepload_kartw where psch is null

SELECT * 
FROM scott.info_usl_lsk 
WHERE mg='201311'
and psch=9

select * from scott.kart 
where lsk='35040675' 

se