DO $$
BEGIN
DELETE FROM sl_spec WHERE spec_cod IN (select "R_TABLE"::bigint from ora_replog999 WHERE "N_TABLE" = 'SL_SPEC' and "OPER" = 'D');
DELETE FROM ora_replog999 WHERE "N_TABLE" = 'SL_SPEC' AND "OPER" = 'D';
END;
$$ LANGUAGE plpgsql;