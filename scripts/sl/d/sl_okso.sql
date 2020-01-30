DO $$
BEGIN
DELETE FROM sl_okso WHERE okso_cod IN (select "R_TABLE"::bigint from ora_replog999 WHERE "N_TABLE" = 'SL_OKSO' and "OPER" = 'D');
DELETE FROM ora_replog999 WHERE "N_TABLE" = 'SL_OKSO' AND "OPER" = 'D';
END;
$$ LANGUAGE plpgsql;