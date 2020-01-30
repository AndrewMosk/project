DO $$
BEGIN
DELETE FROM sl_prof WHERE prof_cod IN (select "R_TABLE"::bigint from ora_replog999 WHERE "N_TABLE" = 'SL_PROF' and "OPER" = 'D');
DELETE FROM ora_replog999 WHERE "N_TABLE" = 'SL_PROF' AND "OPER" = 'D';
END;
$$ LANGUAGE plpgsql;