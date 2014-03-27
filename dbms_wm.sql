SELECT * FROM RECYCLEBIN

select * FROM wmsys.wm$versioned_tables

begin
dbms_wm.DisableVersioning( 'scott.KILLME_L_KWTP',TRUE );
end;

create table scott.KILLME_L_KWTP as select * from ldo.l_kwtp where 1=0

select * from scott.KILLME_L_KWTP