begin
delete from scott.t_corrects_payments where fk_corr_doc=1505;
delete from scott.t_corr_doc where id=1505;

delete  from scott.t_corrects_for_saldo where fk_corr_doc=1505;
end;

select *  from scott.t_corrects_payments where fk_corr_doc=1505;
select *  from scott.t_corrects_for_saldo where fk_corr_doc=1505;

select *  from scott.t_corr_doc where id=1505;