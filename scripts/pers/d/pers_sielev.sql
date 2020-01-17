DO $$
BEGIN
DELETE FROM pers_sielev WHERE r IN (select "R_TABLE"::bigint from ora_replog999 WHERE "N_TABLE" = 'PERS_SIELEV' and "OPER" = 'D');
DELETE FROM ora_replog999 WHERE "N_TABLE" = 'PERS_SIELEV' AND "OPER" = 'D';
END;
$$ LANGUAGE plpgsql;