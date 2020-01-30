DO $$
BEGIN
DELETE FROM sl_klzn WHERE klzn_cod IN (select "R_TABLE"::bigint from ora_replog999 WHERE "N_TABLE" = 'SL_KLZN' and "OPER" = 'D');
DELETE FROM ora_replog999 WHERE "N_TABLE" = 'SL_KLZN' AND "OPER" = 'D';
END;
$$ LANGUAGE plpgsql;