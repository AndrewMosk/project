DO $$
BEGIN
DELETE FROM pers_poor WHERE r IN (select "R_TABLE"::bigint from ora_replog999 WHERE "N_TABLE" = 'PERS_POOR' and "OPER" = 'D');
DELETE FROM ora_replog999 WHERE "N_TABLE" = 'PERS_POOR' AND "OPER" = 'D';
END;
$$ LANGUAGE plpgsql;