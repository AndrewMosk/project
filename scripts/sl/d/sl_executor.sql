DO $$
BEGIN
DELETE FROM sl_executor WHERE executor_cod IN (select "R_TABLE"::bigint from ora_replog999 WHERE "N_TABLE" = 'SL_EXECUTOR' and "OPER" = 'D');
DELETE FROM ora_replog999 WHERE "N_TABLE" = 'SL_EXECUTOR' AND "OPER" = 'D';
END;
$$ LANGUAGE plpgsql;