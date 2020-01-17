DO $$
BEGIN
DELETE FROM pers_staj WHERE r IN (select "R_TABLE"::bigint from ora_replog999 WHERE "N_TABLE" = 'PERS_STAJ' and "OPER" = 'D');
DELETE FROM ora_replog999 WHERE "N_TABLE" = 'PERS_STAJ' AND "OPER" = 'D';
END;
$$ LANGUAGE plpgsql;