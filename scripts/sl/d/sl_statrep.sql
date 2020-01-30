DO $$
BEGIN
DELETE FROM sl_statrep WHERE statrep_cod IN (select "R_TABLE"::bigint from ora_replog999 WHERE "N_TABLE" = 'SL_STATREP' and "OPER" = 'D');
DELETE FROM ora_replog999 WHERE "N_TABLE" = 'SL_STATREP' AND "OPER" = 'D';
END;
$$ LANGUAGE plpgsql;