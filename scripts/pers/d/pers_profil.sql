DO $$
BEGIN
DELETE FROM pers_profil WHERE r IN (select "R_TABLE"::bigint from ora_replog999 WHERE "N_TABLE" = 'PERS_PROFIL' and "OPER" = 'D');
DELETE FROM ora_replog999 WHERE "N_TABLE" = 'PERS_PROFIL' AND "OPER" = 'D';
END;
$$ LANGUAGE plpgsql;