DECLARE
    L_par number default 0;
    Fk_list_reg_ number default 1;   -- вставить значение
BEGIN
    prep.kwtp_parser.kwtp_pars(l_par, fk_list_reg_, prep.kwtp_parser.date_refcur_test());
END;
