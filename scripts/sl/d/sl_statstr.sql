DO $$
BEGIN
DELETE FROM sl_statstr WHERE str_cod IN (select "R_TABLE"::bigint from ora_replog999 WHERE "N_TABLE" = 'SL_STATSTR' and "OPER" = 'D');
DELETE FROM ora_replog999 WHERE "N_TABLE" = 'SL_STATSTR' AND "OPER" = 'D';
END;
$$ LANGUAGE plpgsql;