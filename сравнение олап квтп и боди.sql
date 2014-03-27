SELECT 1 as a, dt.dt "Дата", lk.lk_ska, lk.lk_pn, lk.lk_summa, b_ska, b_pn, b_summa, olap_ska, olap_pn, olap_summa, lk.n7p7SUMMA , lk.summ_all,
            lk_summa-b_summa as diff_lk_b_S,lk.lk_summa-olap_summa as diff_lk_olap_S,
            bank_summa_kwtp, olap_bank_l_pay, bank_summa_kwtp - olap_bank_l_pay diff_bank
FROM
    (
    SELECT dtek,   
        sum(
            case when to_date(lk.dopl, 'mm.yyyy')<to_date('032013', 'mm.yyyy')-- and N7_<>0 
                 then ska-N7_ 
                 else ska 
            end
        ) as lk_ska,
        sum(
        case when to_date(lk.dopl, 'mm.yyyy')<to_date('032013', 'mm.yyyy') --and P7_<>0 
                 then pn-P7_ 
                 else pn 
            end
        ) as lk_pn, 
        sum( case when to_date(lk.dopl, 'mm.yyyy')<to_date('032013', 'mm.yyyy')--and N7_<>0 
                 then ska-N7_ 
                 else ska  
            end) + sum(case when to_date(lk.dopl, 'mm.yyyy')<to_date('032013', 'mm.yyyy')-- and P7_<>0 
                 then pn-P7_ 
                 else pn 
            end) as lk_summa,
         sum( case when to_date(lk.dopl, 'mm.yyyy')<to_date('032013', 'mm.yyyy') --and N7_<>0 
                 then N7_ 
                 else 0  
            end) + sum(case when to_date(lk.dopl, 'mm.yyyy')<to_date('032013', 'mm.yyyy') --and P7_<>0 
                 then P7_ 
                 else 0 
            end) as n7p7SUMMA,
            sum(ska)+sum(pn) as summ_all
                
        FROM  ldo.l_kwtp lk, scott.s_stra s, scott.oper op 
    WHERE  lk.dtek  between '01.02.2014' and '28.02.2014'
       --AND  lk.lsk not in ('00009999')
       AND  op.oper=lk.oper 
       AND  SUBSTR(op.oigu,1,1)='1'
       AND  substr(lk.lsk,1,4) = s.nreu
       AND  not exists
    (SELECT distinct r2.s1 as nkom 
         FROM ldo.l_regxpar r2
     WHERE fk_par=23 AND r2.s1=lk.nkom) 
     GROUP BY dtek
     ORDER BY dtek
        ) LK,
        (
     SELECT b.dtek, sum(b.ska) b_ska, sum(pn) b_pn, sum(ska) + sum(pn) b_summa
             FROM prep.kwtp_b  b --, scott.oper op
     WHERE  b.dtek  between '01.02.2014' and '28.02.2014'
     GROUP BY b.dtek
     ORDER BY b.dtek
         ) B, 
   (
     SELECT dtek, sum(ska) olap_ska, sum(pn) olap_pn, sum(ska) + sum(pn) olap_summa
         FROM prep.kwtp_olap  
     WHERE  dtek  between '01.02.2014' and '28.02.2014'
             and pay = 0
     GROUP BY dtek
     ORDER BY dtek
    ) OLAP,
   (
    SELECT dtek, sum(ska) as bank_ska,
                 sum(pn) as bank_pn, 
            
            sum( case when to_date(lk.dopl, 'mm.yyyy')<to_date('032013', 'mm.yyyy') and N7_<>0 
                 then ska-N7_ 
                 else ska 
            end) + 
            sum(case when to_date(lk.dopl, 'mm.yyyy')<to_date('032013', 'mm.yyyy') and P7_<>0 
                 then pn-P7_ 
                 else pn 
            end) as bank_summa_kwtp
                 --sum(ska)
               --+ sum(pn    ) as bank_summa
        FROM  ldo.l_kwtp lk, scott.s_stra s, scott.oper op 
    WHERE  lk.dtek  between '01.02.2014' and '28.02.2014'
       AND  lk.lsk not in ('00009999')
       AND  op.oper=lk.oper and op.tp_cd not in ('ND')
       AND  substr(lk.lsk,1,4) = s.nreu
       AND  exists
    (SELECT distinct r2.s1 as nkom 
         FROM ldo.l_regxpar r2
     WHERE fk_par=23 AND r2.s1=lk.nkom)
     GROUP BY dtek 
     ORDER BY dtek
        ) BANKI,
        (
     SELECT dtek,sum(ska)+ sum(pn) olap_bank_l_pay
         FROM prep.kwtp_olap  
     WHERE  dtek  between '01.02.2014' and '28.02.2014'
             and pay = 1
     GROUP BY dtek
     ORDER BY dtek
     ) OLAP_BANK ,
    (
    select  trunc(to_date('01.02.2014'),'mm') + level-1 dt
       from  dual
     connect by  trunc(to_date('01.02.2014'),'mm') + level-1  <= to_date('28.02.2014')
    ) dt
WHERE
     lk.dtek      (+) = dt.dt and 
     b.dtek      (+) = dt.dt and 
     olap.dtek  (+) = dt.dt and 
     banki.dtek (+) =  dt.dt and 
     olap_bank.dtek  (+) = dt.dt
ORDER BY dt.dt

/*select distinct dtek from scott.load_kwtp
  
     select  trunc(to_date('01.03.2013'),'mm') + level-1 dt
       from  dual
     connect by  trunc(to_date('01.03.2013'),'mm') + level-1  <= to_date('30.03.2013')
     
     ldo.v_oplata
     
     
     ELECT b.dtek, sum(b.ska) b_ska, sum(pn) b_pn, sum(ska) + sum(pn) b_summa
             FROM prep.kwtp_h  b --, scott.oper op
     WHERE  b.dtek  between '01.03.2013' and '30.03.2013'
     GROUP BY b.dtek
     ORDER BY b.dtek
     select t.rowid, t.* from prep.d_load t
     select * from prep.log_parser order by id desc*/
     
      delete from ldo.l_kwtp_crc
          select * from ldo.l_kwtp where ska=3142
          select * from scott.l_pay where lsk='24036509'
      select t.rowid, t.* from prep.d_load t
      
      select * from prep.info_usl_lsk where mg='201306' and reu='Z2'
      delete from scott.info_usl_lsk where mg='201306' and reu='Z2'
      delete from scott.info_usl_nd where mg='201306' and reu='Z2'
      insert into scott.info_usl_nd select * from prep.info_usl_nd where mg='201306' and reu='Z2'
      insert into scott.info_usl_lsk select * from prep.info_usl_lsk where mg='201306' and reu='Z2'
       
       select dtek,ska,pn,N7_ from ldo.l_kwtp t where dopl<'201303' and N7_<0 and dtek='02.08.2013' and 
        not exists
(select * from ldo.l_regxpar x, ldo.l_par p 
  where x.fk_par=p.id and p.cd='NKOM'
  and x.s1=t.nkom)
  
  select decode 
( 
   krt.psch,9,null,0,null,
   case 
         when nd<>'0'  then krt.gw_nor
   else null
   end
) 
from scott.load_kartw krt
where lsk='34016997'  
    
 (select sum(ska)+sum(pn) from ldo.l_kwtp t where dtek='02.07.2013' and
    not exists
   (select * from ldo.l_regxpar x, ldo.l_par p 
     where x.fk_par=p.id and p.cd='NKOM'
       and x.s1=t.nkom)
    GROUP BY LSK
  ) a
  full outer join
  (
  select sum(ska)+sum(pn) from prep.kwtp_olap where  dtek='02.07.2013'
  and pay=0
  
  
  ) b
  using(lsk)
  
   SELECT a.name_tr, a.name_ul, a.kul, a.nd, a.dtek, a.reu, a.trest, --b.uch, 
                                a.ska, a.pn, a.pay, a.bn , a.for_plan
                    FROM
                    (SELECT    s.trest || ' ' || s.name_tr as name_tr, SP.NAME || '  ' || ltrim(k.ND,'0') as name_ul, 
                                    h.dtek, s.reu, s.trest,
                                    sum(b.ska) ska, 
                                    sum(b.pn) pn,    
                                    sum(case when substr(op.oigu,1,2) = '10' then b.ska+b.pn else 0 end) bn, 
                                    0 as pay, sp.id as kul,k.nd as nd, coalesce(u.for_plan,0) as for_plan
                      FROM     prep.kwtp_h h, prep.kwtp_b b, scott.s_stra s, scott.oper op, scott.usl u,scott.kart K, scott.spul SP
                    WHERE      h.id = b.id
                       AND      b.usl = u.usl         
                       AND      k.kul = sp.id                    
                       AND      k.lsk = h.lsk                      
                       AND      op.tp_cd not in ('ND')                   -- в принципе не используется...  так как в вставка в kwtp_h идет уже без банков
                       AND      substr(h.lsk,1,4) = s.nreu                     
                       AND      h.oper = op.oper
                       AND      b.dtek = '01.07.2013'
                       AND      h.dtek = '12.07.2013'
                    GROUP BY    s.trest || ' ' || s.name_tr, SP.NAME || '  ' || ltrim(k.ND,'0'),s.trest, s.reu, h.dtek, sp.id, k.nd, u.for_plan ) a 
                   
   123189084,08    1956014,01
   select * from ldo.l_kwtp_prep where lsk='49060006'
   delete from ldo.l_kwtp_crc

SELECT --nink,lsk, --lk.nkom, lk.lsk
sum(
    coalesce(N4_      ,0)+
    coalesce(NOTTRI_  ,0)+
    coalesce(N4TR_    ,0)+
    coalesce(NGW_     ,0)+
    coalesce(N4TRI_   ,0)+
    coalesce(NDOPHW_  ,0)+
    coalesce(NDOPHT_  ,0)+
    coalesce(NDOPKAN_ ,0)+
    coalesce(NDOPGW_  ,0)+
    coalesce(NDOPGT_  ,0)+
    coalesce(N13_     ,0)+
    coalesce(N161_    ,0)+
    coalesce(N18_     ,0)+
    coalesce(N19_     ,0)+
    coalesce(NMPRI_   ,0)+
    coalesce(NVAXT_   ,0)+
    coalesce(NVAXTI_  ,0)+
    coalesce(N22_     ,0)+
    coalesce(N48_     ,0)+
    coalesce(NOTTR_   ,0)+
    coalesce(NKR_     ,0)+
    coalesce(NKRI_    ,0)+
    coalesce(NTR_     ,0)+
    coalesce(NTRI_    ,0)+
    coalesce(NDER_    ,0)+
    coalesce(NDERI_   ,0)+
    coalesce(NOT_     ,0)+
    coalesce(NOTI_    ,0)+
    coalesce(N42_     ,0)+
    coalesce(N412_    ,0)+
    coalesce(N6_      ,0)+
    coalesce(case when SUBSTR(dopl,3,4)||SUBSTR(dopl,1,2)<'201303' then 0 else N7_ end,0)+
   -- coalesce(N7_      ,0)+
    coalesce(N21_     ,0)+
    coalesce(N101_    ,0)+
    coalesce(NOI_     ,0)+
    coalesce(NMUSI_   ,0)+
    coalesce(NK_PLI_  ,0)+
    coalesce(NLIFI_   ,0)+
    coalesce(N12_     ,0)+
    coalesce(NGWI_    ,0)+
    coalesce(NGWTRI_  ,0)+
    coalesce(N10_     ,0)+
    coalesce(N41_     ,0)+
    coalesce(N20_     ,0)+
    coalesce(NGWTR_   ,0)+
    coalesce(NKNAI_   ,0)+
    coalesce(N47_ ,0)
)  "основные"  ,
sum(
    coalesce(N14_   ,0)+  
    coalesce(N16_    ,0)+ 
    coalesce(N15_     ,0)+
    coalesce(N46_     ,0)+
    coalesce(N45_     ,0)+
    coalesce(NGTR_    ,0)+
    coalesce(NGTRI_   ,0)+
    coalesce(N72_     ,0)+
    coalesce(N8_      ,0)+
    coalesce(N9_      ,0)+
    coalesce(N17_     ,0)+
    coalesce(NGI_     ,0)+
    coalesce(NLAND_   ,0)
)  "прочие"
  /* FROM  ldo.l_kwtp lk, scott.oper op 
    WHERE  lk.dtek  between '01.07.2013' and '11.07.2013'
       AND  op.oper=lk.oper 
       and  lk.oper=op.oper AND SUBSTR(op.oigu,1,1)='1'
       AND  not exists
    (SELECT distinct r2.s1 as nkom 
         FROM ldo.l_regxpar r2
     WHERE fk_par=23 AND r2.s1=lk.nkom)*/
   FROM  ldo.l_kwtp lk, scott.oper op
        --, scott.s_stra s 
    WHERE  lk.dtek  between '01.08.2013' and '31.08.2013'
      AND  lk.lsk not in ('00009999')
       AND  op.oper=lk.oper 
       AND SUBSTR(op.oigu,1,1)='1'
       --AND  substr(lk.lsk,1,4) = s.nreu
       AND  not exists
        (select x.s1 from ldo.l_regxpar x, ldo.l_par p , ldo.l_reg lr
          where x.fk_par=p.id and p.cd='NKOM' and lr.id=x.fk_reg
          and x.s1=lk.nkom and x.s1 is not null )
        -- GROUP BY DTEK  
    --Group by nink,lsk
    --ORDER BY nink,lsk
    UNION ALL
      select sum(case when o.for_plan=1 then ska else 0 end) "основные",
      sum(case when o.for_plan=0 then ska else 0 end) "прочие"
      from prep.kwtp_olap o
      where dtek  between '01.08.2013' and '31.08.2013'
        and pay=0
    -- GROUP BY DTEK  
        
UNION ALL
       
select sum(case when t.for_plan=1 then ska else 0 end) "основные",
      sum(case when t.for_plan=0 then ska else 0 end) "прочие"
 from PREP.KWTP_OLAP t where
t.pay=1 --and t.for_plan=1
 and t.dtek between '01.08.2013' and '31.08.2013'

    UNION ALL

select sum(CASE WHEN t.TP_CD='PAY' and u.for_plan=1 
                                        THEN --t.summa
                                            case when U.DOPL_PLAN='999901' then t.summa
                                                 else 
                                                    case when u.usl='020' and t.dopl<U.DOPL_PLAN then 0
                                                    else t.summa
                                                    end
                                            end      
                                        ELSE 0 
                                        end
                                        )  "основные",
                                        sum(CASE WHEN t.TP_CD='PAY' and u.for_plan=0
                                        THEN --t.summa
                                            case when U.DOPL_PLAN='999901' then t.summa
                                                 else 
                                                    case when u.usl='020' and t.dopl<U.DOPL_PLAN then 0
                                                    else t.summa
                                                    end
                                            end      
                                        ELSE 0 
                                        end)  "прочие"
FROM l_pay t, ldo.l_list_reg lr,
  (SELECT U.USL, vu.usl1, u.for_plan, u.dopl_plan
                                   FROM  
                                       (select distinct usl,usl1 from scott.var_usl1) vu , scott.usl u
                                        where vu.usl=u.usl
                                  ) u
WHERE
t.pay_cd in ('PU') and t.tp_cd='PAY' 
AND  lr.state_cd in ('LD','KW')
AND  lr.id=t.fk_list_reg
and t.dt1 between '01.08.2013' and '31.08.2013'
and u.usl1=t.fk_usl


select sys_context('USER','LANGUAGE') from dual

d_load

SELECT sum(lk.N4_  + lk.NOTTRI_+lk.N4TR_   + lk.NGW_    +lk.N4TRI_  +lk.NDOPHW_ +lk.NDOPHT_ +lk.NDOPKAN_+lk.NDOPGW_ +lk.NDOPGT_ +  
     lk.N13_    +lk.N161_   + lk.N18_   +lk.N19_    + lk.NMPRI_  +lk.NVAXT_ +
     lk.NVAXTI_ +lk.N22_    + lk.N48_   +lk.NOTTR_  + lk.NKR_ +
     case when SUBSTR(lk.dopl,3,4)||SUBSTR(lk.dopl,1,2)<'201303' then 0 else N7_ end +
     lk.NKRI_  + lk.NTR_    + lk.NTRI_+ lk.NDER_   + lk.NDERI_  +  
     lk.NOT_    +lk.NOTI_   +  lk.N42_ +  
     lk.N412_   + lk.N6_     +  lk.N21_  + lk.N101_   + lk.NOI_ + lk.NMUSI_  + lk.NK_PLI_ + lk.NLIFI_  + lk.N12_ +  
     lk.NGWI_   +lk.NGWTRI_ + lk.N10_ + lk.N41_ + lk.N20_ +lk.NGWTR_  +
     lk.NKNAI_  +
     lk.N47_) as основные,
     sum(lk.N14_+lk.N16_  +lk.N15_ + lk.N46_ +lk.N45_+ lk.NGTR_  +  lk.NGTRI_ + lk.N72_ + lk.N8_  +  lk.N9_ + lk.N17_ + lk.NGI_ + lk.NLAND_ )
     as прочие
   FROM  ldo.l_kwtp  lk, scott.oper 
    WHERE  (lk.dtek between '01.08.2013' and '31.08.2013'
       AND  op.oper= lk.oper
       AND SUBSTR(op.oigu,1,1)='1'  AND  lk.lsk not in ('00009999') 
       AND nkom not in ('900',    '901',    '910',    '911',    '915',    '951',    'B10',    'B11',    'B12',    'B13',    'B14',    'B15',    'B16',    'B17',    'B18',    'B19',    'B20',    'B21',    'B22',    'B23',    'B24',  
         'B25',    'B26',    'B27',    'B28',    'B29',    'B30',    'B31',    'B32',    'B33',    'B34',    'B35',    'B36',    'B37',    'B38',    'B39',    'B40',    'B41',    'B42',    'B43',    'B44',    'B45',    'B46',    'B47',  
           'B48',    'B49','B50',    'B51',    'B52',    'B53',    'B54',    'B55',    'B56',    'B57',    'B58',    'B59',    'B60',    'B61',    'B62',    'B63',    'B64',    'B65',    'B66',    'M11',    'M12',    'M13',    'SS1' ,'B67') 


prep.d_load