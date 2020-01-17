DO $$
BEGIN
DELETE FROM prof_vac_gr WHERE r IN (select "R_TABLE"::bigint from ora_replog999 WHERE "N_TABLE" = 'PROF_VAC_GR' and "OPER" = 'D');
DELETE FROM ora_replog999 WHERE "N_TABLE" = 'PROF_VAC_GR' AND "OPER" = 'D';
END;
$$ LANGUAGE plpgsql;