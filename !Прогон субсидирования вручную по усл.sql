declare
  cursor r is -- Выбираем в курсор все главные услуги 
  select usl,f_ras_v,usl_norm
  from usl u
  where f_ras_v  is not null and usl in ('011','012','054','055','056','057');
  
  cursor r1 is
  select usl,u.s_ras_sch
  from usl u
  where f_ras_v is not null and s_ras_sch is not null;
 
  usl_    usl.usl%type;
  usl_norm_ usl.usl_norm%type;
  f_ras_v_    usl.f_ras_v%type;
  s_ras_sch_ usl.s_ras_sch%type;

  mg_ params.period%type;
  time_ date;
BEGIN
 /*------------------------------------------------------------------------------------------*/
  --insert into '.nabor select * from scott.nabor;
  --drop table prep.load_kartw
  --grant select ,insert,  update, delete on prep.load_kartw to scott

 select '201306'  into mg_ from dual;
  --select to_char(add_months(sysdate,-1),'yyyymm') into mg_ from dual;
 update prep.load_kartw201306 k set k.nabor_id = (select t.nabor_id from kart t where t.lsk = k.lsk);
 execute immediate 'drop table scott.prepload_kartw';
  execute immediate 'create table scott.prepload_kartw as select * from prep.load_kartw201306';
  execute immediate 'create index PREPLOAD_KARTW_LSK_IDX on scott.prepload_kartw (LSK) 
                      tablespace INDX2
                      pctfree 10
                      initrans 2
                      maxtrans 255
                      storage
                      (
                        initial 64K
                        minextents 1
                        maxextents unlimited
                      ) ';
                      
 execute immediate 'analyze table scott.prepload_kartw compute statistics';
  
 --эти апдейты сделаны потому что кварплата.ру никак не смогла выдавать нормальные суммы 
/* UPDATE scott.prepload_kartw SET gw_nor=
        case when abs(mgw)>(kpr-kpr_ot)*3.6 then -(kpr-kpr_ot)*3.6
             else mgw 
        end 
 WHERE psch in (1,3) and mgw<0 ;
 
 UPDATE scott.prepload_kartw SET gw_nor= mgw*(kpr-kpr_ot)
 WHERE psch IN (0,2) AND mgw<>0 
  AND  mgw*(kpr-kpr_ot)<gw_nor ;

 UPDATE scott.prepload_kartw SET hw_nor=
   case when abs(mhw)>(kpr-kpr_ot)*6.6 then -(kpr-kpr_ot)*6.6
     else mhw 
   end 
 WHERE psch in (1,2) and mhw<0 ;

 UPDATE scott.prepload_kartw SET hw_nor= mhw*(kpr-kpr_ot)
 WHERE psch in (0,3) and mhw<>0 
  and  mhw*(kpr-kpr_ot)<hw_nor ;*/
 --конец апдейтов
   execute immediate ' truncate table t_volume_usl';
   --временная таблица, несколько напоминающая различные t_ _for_saldo 
   --и temp_stat c детализацией до usl а не uslm как в статистике
  OPEN R;
  LOOP    
      fetch r
        into usl_, f_ras_v_, usl_norm_;
      exit when r%notfound;
  EXECUTE IMMEDIATE 'insert into t_volume_usl (lsk, usl, org, summa, kpr, opl, gkal, gkal_n)
    select krt.lsk,
           n.usl,
           CASE 
            WHEN :mg_ >= SUBSTR (o.dat3, 3, 4) || SUBSTR (o.dat3, 1, 2)
               THEN o.kod3
            WHEN :mg_ >= SUBSTR (o.dat2, 3, 4) || SUBSTR (o.dat2, 1, 2)
               THEN o.kod2
            WHEN :mg_ >= SUBSTR (o.dat, 3, 4) || SUBSTR (o.dat, 1, 2)
               THEN o.kod1
            ELSE o.kod
           END org,
           '||f_ras_v_||' v,
           decode(:usl_norm_,0,kpr-kpr_ot,null) kpr,
           decode(:usl_norm_,0,opl,null) opl,
           case when n.usl=''008'' then coalesce(case when mot>mot_n then mot-mot_n else 0 end,0) else 0 end+coalesce(krt.dop_ot,0)+case when n.usl=''007'' then mot_n else 0 end as gkal,
           case when n.usl=''007'' then mot_n else 0 end as gkal_n
     from scott.prepload_kartw krt,
           (
           SELECT lsk, sum(gw) as gw, sum(gw_dop) gw_dop, sum(ot) ot, sum(ot_dop) ot_dop, sum(hw) hw, sum(hw_dop) hw_dop
              FROM prep.load_kwni201306 ki
             WHERE coalesce(ki.gw,0)<>0 or coalesce(ki.gw_dop,0)<>0 or coalesce(ki.ot,0)<>0 
                or coalesce(ki.ot_dop,0) <>0 or coalesce(ki.hw,0)<>0 or coalesce(ki.hw_dop,0)<>0
          GROUP BY lsk  
            ) ki, 
          prep.sptar201306 spt,
          prep.nabor201306 n,
          prep.sprorg201306 o
    where krt.gt=spt.gtr
      and krt.nabor_id=n.id
      and n.usl=:usl_
      and n.org=o.kod
      and krt.lsk = ki.lsk (+)
      and '||f_ras_v_||' is not null'  
    using mg_,mg_,mg_,usl_norm_,usl_norm_,usl_;
    commit; 
  END LOOP;
  CLOSE R;    
    
--тут для неглавных услуг очищаются поля для главных услуг и заполняются для неглавных услуг
UPDATE scott.t_volume_usl t SET dop_vol=summa, dop_opl=opl, dop_kpr=kpr, summa=null ,kpr=null,opl=null
WHERE usl in ('009','010','017','018','060','054','055','057');

    execute immediate 'truncate table temp_info_usl';

    --таблица содержащая все возможные сочетания lsk,usl,org
    insert into temp_info_usl(lsk,usl,org)
    select distinct lsk,usl,org 
    from 
    ( select lsk,usl,org  from t_volume_usl
        union all
        select lsk,usl,org  from prep.t_charges_usl201306
        where usl in (select usl from usl where f_ras_v is not null)
        union all
        select lsk,usl,org  from prep.t_changes_usl201306
        where usl in (select usl from usl where f_ras_v is not null)
        union all
        select lsk,usl,org  from prep.t_privs_usl201306
        where usl in (select usl from usl where f_ras_v is not null)
        union all
        select lsk,usl,org  from prep.t_payment_usl201306
        where usl in (select usl from usl where f_ras_v is not null)
    )
  GROUP BY lsk,usl,org;

  DELETE FROM scott.info_usl_lsk t where mg='201306' and usl in ('011','012','054','055','056','057');-- and reu='K1';
              -- 004   007-ОТ
            -- 006   011-ХВ
            -- 008   015-ГВ
  INSERT INTO scott.info_usl_lsk
       (lsk, usl, org, charges, changes, privs, payment, volume, mg,
        psch, kpr, reu, kul, nd, kw, sch_el, opl, f, dop_kpr, dop_opl, dop_vol, vvod_gw, status, gkal, gkal_n)
  SELECT h.lsk,h.usl,h.org,
           coalesce(cr.summa,0)+coalesce(cn.summa,0),cn.summa,pr.summa,pm.summa,vl.summa,
           '201306',
           decode(u.s_ras_sch,null,0,h.psch) psch,
           vl.kpr kpr,
           h.reu,h.kul,h.nd,h.kw,sch_el,
           vl.opl opl,
           pr.summa_cn,
           vl.dop_kpr,
           vl.dop_opl,
           vl.dop_vol,
           decode(u.uslm,'006',vvod,'008',vvod_gw,'004',vvod_ot,null) vvod_gw,    
           h.id,
           vl.gkal,
           vl.gkal_n
  FROM (SELECT t.*, reu, kul, nd, kw, psch, sch_el, vvod, vvod_gw, vvod_ot, s.id 
              FROM scott.temp_info_usl t, scott.prepload_kartw k, scott.status s 
            WHERE t.lsk=k.lsk and s.id=k.status ) h,
         prep.t_charges_usl201306 cr,
         prep.t_changes_usl201306 cn,
         (select lsk,usl,org,sum(summa) summa, sum(decode(type,0,0,null,0,summa)) summa_cn from prep.t_privs_usl201306 group by lsk,usl,org) pr,
         scott.t_volume_usl vl,
         prep.t_payment_usl201306 pm, usl u
   WHERE 
          h.lsk=cr.lsk(+)
     -- and h.reu='K1'    
      and h.usl=cr.usl(+)
      and h.org=cr.org(+)
      and h.lsk=cn.lsk(+)
      and h.usl=cn.usl(+)
      and h.org=cn.org(+)  
      and h.lsk=pr.lsk(+)
      and h.usl=pr.usl(+)
      and h.org=pr.org(+) 
      and h.lsk=vl.lsk(+)
      and h.usl=vl.usl(+)
      and h.org=vl.org(+)
      and h.lsk=pm.lsk(+)
      and h.usl=pm.usl(+)
      and h.org=pm.org(+)
      and h.usl=u.usl 
      and u.usl in ('011','012','054','055','056','057');   
    commit; 


-- проставляем признаки счетчиков ОДПУ
 /*    MERGE INTO scott.info_usl_lsk i
                using ( select lg.*,u.usl from
                                 (SELECT reu,kul,nd,vvod,coalesce(sch,0) as sch, 
                                            case when tip=2 then '006' 
                                                   when tip=3 then '008'
                                                   when tip=4 then '004'
                                            else null
                                            end as uslm     
                                  FROM ldo.load_gw t1
                                WHERE '201306' between dat_nach and dat_end) lg , scott.usl u
                                where lg.uslm=u.uslm ) lg
                 ON  
                (
                      i.reu=lg.reu and i.kul=lg.kul and i.nd=lg.nd 
                  and i.vvod_gw=lg.VVOD and i.usl=lg.usl and i.mg='201306'-- and i.reu in('K1')
                  and i.usl in ('011','012','054','055','056','057')
                )
                WHEN MATCHED THEN UPDATE
                      set  i.sch=LG.SCH;*/

  FOR rec in
   (SELECT usl, u.s_ras_sch
      FROM usl u
     WHERE f_ras_v IS NOT NULL AND s_ras_sch IS NOT NULL
     and usl in ('011','012','054','055','056','057')
   )
   LOOP
    execute immediate 
    'UPDATE scott.info_usl_lsk krt SET psch=nvl('||rec.s_ras_sch||',0)
      WHERE usl=:usl_ and mg=:mg_ '
     USING rec.usl, '201306' ;
   END LOOP;
   commit;


 DELETE FROM scott.info_usl_nd t where mg='201306' and usl in ('011','012','054','055','056','057'); 
 INSERT INTO scott.info_usl_nd ( reu,kul,nd,usl,org,vvod_gw,charges,changes,privs,payment,volume,mg,
                                        psch,kpr,opl, f, f1, dop_opl, dop_kpr, dop_vol,  status, gkal, gkal_n, vol_izm, gkal_izm,sch
                                       )
 SELECT  t.reu, t.kul, t.nd, t.usl, t.org, t.vvod_gw, sum(t.charges), sum(t.changes), sum(t.privs) , sum(t.payment), sum(t.volume), t.mg,
              t.psch, sum(t.kpr) , sum(t.opl), sum(f), sum(t.k_sum), sum(t.dop_opl), sum(t.dop_kpr), sum(t.dop_vol), t.status, sum(t.gkal), sum(t.gkal_n)
              ,sum (case when t.usl<>'007' then izm.vol_izm else 0 end) as  vol_izm
              ,sum (case when t.usl='007' then izm.gkal_izm else 0 end) as gkal_izm,
              t.sch
  FROM   scott.info_usl_lsk t, 
          ( select lsk, org, usl, sum(vol) as vol_izm,sum(gkal) as gkal_izm from scott.t_volume_usl_izm 
             where mg='201306' and usl in ('011','012','054','055','056','057') group by lsk, org, usl ) izm
  WHERE     t.mg = '201306'
         and t.usl in ('011','012','054','055','056','057')
         and t.lsk  = izm.lsk (+)
         and t.org = izm.org  (+)
         and t.usl  = izm.usl (+)
  GROUP BY t.reu, t.kul, t.nd, t.usl, t.org, t.mg, t.psch, t.vvod_gw, t.status,t.sch;
end;
     
--вначале делаем изменения