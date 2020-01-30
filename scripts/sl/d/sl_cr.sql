DO $$
BEGIN
DELETE FROM sl_cr WHERE cr_cod IN (select "R_TABLE"::bigint from ora_replog999 WHERE "N_TABLE" = 'SL_CR' and "OPER" = 'D');
DELETE FROM ora_replog999 WHERE "N_TABLE" = 'SL_CR' AND "OPER" = 'D';
END;
$$ LANGUAGE plpgsql;