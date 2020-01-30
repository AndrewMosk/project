DO $$
BEGIN
DELETE FROM sl_work WHERE work_cod IN (select "R_TABLE"::bigint from ora_replog999 WHERE "N_TABLE" = 'SL_WORK' and "OPER" = 'D');
DELETE FROM ora_replog999 WHERE "N_TABLE" = 'SL_WORK' AND "OPER" = 'D';
END;
$$ LANGUAGE plpgsql;