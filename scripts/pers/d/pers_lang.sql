DO $$
BEGIN
DELETE FROM pers_lang WHERE r IN (select "R_TABLE"::bigint from ora_replog999 WHERE "N_TABLE" = 'PERS_LANG' and "OPER" = 'D');
DELETE FROM ora_replog999 WHERE "N_TABLE" = 'PERS_LANG' AND "OPER" = 'D';
END;
$$ LANGUAGE plpgsql;