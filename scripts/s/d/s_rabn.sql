DO $$
BEGIN
DELETE FROM s_rabn WHERE r IN (select "R_TABLE"::bigint from ora_replog999 WHERE "N_TABLE" = 'S_RABN' and "OPER" = 'D');
DELETE FROM ora_replog999 WHERE "N_TABLE" = 'S_RABN' AND "OPER" = 'D';
END;
$$ LANGUAGE plpgsql;