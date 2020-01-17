DO $$
BEGIN
DELETE FROM pers_spar WHERE r IN (select "R_TABLE"::bigint from ora_replog999 WHERE "N_TABLE" = 'PERS_SPAR' and "OPER" = 'D');
DELETE FROM ora_replog999 WHERE "N_TABLE" = 'PERS_SPAR' AND "OPER" = 'D';
END;
$$ LANGUAGE plpgsql;