DO $$
BEGIN
DELETE FROM vac_kvot_trud WHERE r IN (select "R_TABLE"::bigint from ora_replog999 WHERE "N_TABLE" = 'VAC_KVOT_TRUD' and "OPER" = 'D');
DELETE FROM ora_replog999 WHERE "N_TABLE" = 'VAC_KVOT_TRUD' AND "OPER" = 'D';
END;
$$ LANGUAGE plpgsql;