SELECT sum(summa) as summa, substr(t.mg,1,4) as mg 
FROM scott.a_flow t 
WHERE
    t.fk_type=1 and t.summa<0
GROUP BY substr(t.mg,1,4)  

select sum(a.summa) as summa, substr(a.mg,1,4) from (
    select t.lsk, sum(t.summa) as summa, t.mg
    from a_flow t where t.fk_type=1
    group by t.lsk, t.mg
    having sum(t.summa) < 0
) a
group by substr(a.mg,1,4)