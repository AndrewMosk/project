DO $$
BEGIN
DELETE FROM prof_agr WHERE agr_cod IN (select "R_TABLE"::bigint from ora_replog999 WHERE "N_TABLE" = 'PROF_AGRR' and "OPER" = 'D');
DELETE FROM ora_replog999 WHERE "N_TABLE" = 'PROF_AGRR' AND "OPER" = 'D';
END;
$$ LANGUAGE plpgsql;