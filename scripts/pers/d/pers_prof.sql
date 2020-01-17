DO $$
BEGIN
DELETE FROM pers_prof WHERE r IN (select "R_TABLE"::bigint from ora_replog999 WHERE "N_TABLE" = 'PERS_PROF' and "OPER" = 'D');
DELETE FROM ora_replog999 WHERE "N_TABLE" = 'PERS_PROF' AND "OPER" = 'D';
END;
$$ LANGUAGE plpgsql;