DO $$
BEGIN
DELETE FROM pers_ask_prof WHERE r IN (select "R_TABLE"::bigint from ora_replog999 WHERE "N_TABLE" = 'PROF_ASK' and "OPER" = 'D');
DELETE FROM ora_replog999 WHERE "N_TABLE" = 'PROF_ASK' AND "OPER" = 'D';
END;
$$ LANGUAGE plpgsql;