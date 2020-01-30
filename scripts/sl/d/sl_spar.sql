DO $$
BEGIN
DELETE FROM sl_spar WHERE r IN (select "R_TABLE"::bigint from ora_replog999 WHERE "N_TABLE" = 'SL_SPAR' and "OPER" = 'D');
DELETE FROM ora_replog999 WHERE "N_TABLE" = 'SL_SPAR' AND "OPER" = 'D';
END;
$$ LANGUAGE plpgsql;