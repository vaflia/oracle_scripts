Select a.*, RATIO_TO_REPORT(m08) OVER (partition by org )

FROM
(SELECT org,s.name, nach, m12, m11, m10, m09, m08, m07, m06, m05, m04, m03, m02, m01
FROM
(-- Õ¿◊»—À≈Õ»≈
SELECT org,-- sum(coalesce(payment,0)) as pay, 
'Õ‡˜ËÒÎÂÌËÂ' as nach,
sum(case when mg='201212' then charges else 0 end) as m12,
sum(case when mg='201211' then charges else 0 end) as m11,
sum(case when mg='201210' then charges else 0 end) as m10,
sum(case when mg='201209' then charges else 0 end) as m09,
sum(case when mg='201208' then charges else 0 end) as m08,
sum(case when mg='201207' then charges else 0 end) as m07,
sum(case when mg='201206' then charges else 0 end) as m06,
sum(case when mg='201205' then charges else 0 end) as m05,
sum(case when mg='201204' then charges else 0 end) as m04,
sum(case when mg='201203' then charges else 0 end) as m03,
sum(case when mg='201202' then charges else 0 end) as m02,
sum(case when mg='201201' then charges else 0 end) as m01
FROM scott.xitog2_s
WHERE mg between '201201' and '201211'  
           and trest='26'
           and  charges<>0
 GROUP BY  org
UNION ALL
-- ŒœÀ¿“¿
select t.org,-- s.name, sum(summa) as Oplatabezpeny,
     'ŒÔÎ‡Ú‡' as opl,
      sum(case when dopl='201212' then coalesce(summa,0) else 0 end) as dopl_12,
      sum(case when dopl='201211' then coalesce(summa,0) else 0 end) as dopl_11,
      sum(case when dopl='201210' then coalesce(summa,0) else 0 end) as dopl_10,
      sum(case when dopl='201209' then coalesce(summa,0) else 0 end) as dopl_09,
       sum(case when dopl='201208' then coalesce(summa,0) else 0 end) as dopl_08,
       sum(case when dopl='201207' then coalesce(summa,0) else 0 end) as dopl_07,
       sum(case when dopl='201206' then coalesce(summa,0) else 0 end) as dopl_06,
       sum(case when dopl='201205' then coalesce(summa,0) else 0 end) as dopl_05,
       sum(case when dopl='201204' then coalesce(summa,0) else 0 end) as dopl_04,
       sum(case when dopl='201203' then coalesce(summa,0) else 0 end) as dopl_03,
       sum(case when dopl='201202' then coalesce(summa,0) else 0 end) as dopl_02,
       sum(case when dopl='201201' then coalesce(summa,0) else 0 end) as dopl_01
  FROM scott.xxito10 t 
  WHERE mg='201208' 
            and t.trest='26'
           and summa<>0
  GROUP BY t.org)  a, scott.sprorg s
WHERE a.org=s.kod
ORDER BY  org, s.name, nach) A


select *
  FROM scott.xitog2_s t 
  WHERE mg='201209' 
  
  
  select * from prep.kwtp_h
      select * from prep.kwtp_b
      scott.kwtp_day 
      scott.load_kwtp