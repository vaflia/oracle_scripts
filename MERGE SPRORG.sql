  
MERGE INTO prep.sprorg1 dest
  USING (SELECT * FROM prep.load_sprorg) source1
      ON (dest.kod = source1.kod and dest.kodm = source1.kodm)
      WHEN NOT MATCHED THEN
           INSERT (dest.kod,dest.kodm,
                        dest.name,
                        dest.kod1,dest.dat,
                        dest.kod2,dest.dat2,
                        dest.kod3,dest.dat3,
                        dest.type,
                        dest.for_sch,dest.nds_uszn)
           VALUES (source1.kod,source1.kodm,
                        source1.name,
                        source1.kod1,source1.dat,
                        source1.kod2,source1.dat2,
                        source1.kod3,source1.dat3,
                        source1.type,
                        source1.for_sch,source1.nds_uszn)
                        
                      