DO $$
BEGIN
DELETE FROM pers_close WHERE r IN (select "R_TABLE"::bigint from ora_replog999 WHERE "N_TABLE" = 'PERS_CLOSE' and "OPER" = 'D');
DELETE FROM ora_replog999 WHERE "N_TABLE" = 'PERS_CLOSE' AND "OPER" = 'D';
END;
$$ LANGUAGE plpgsql;