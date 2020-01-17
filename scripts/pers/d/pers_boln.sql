DO $$
BEGIN
DELETE FROM pers_boln WHERE r IN (select "R_TABLE"::bigint from ora_replog999 WHERE "N_TABLE" = 'PERS_BOLN' and "OPER" = 'D');
DELETE FROM ora_replog999 WHERE "N_TABLE" = 'PERS_BOLN' AND "OPER" = 'D';
END;
$$ LANGUAGE plpgsql;