DO $$
BEGIN
DELETE FROM sl_pers WHERE pers_num IN (select "R_TABLE"::bigint from ora_replog999 WHERE "N_TABLE" = 'SL_PERS' and "OPER" = 'D');
DELETE FROM ora_replog999 WHERE "N_TABLE" = 'SL_PERS' AND "OPER" = 'D';
END;
$$ LANGUAGE plpgsql;