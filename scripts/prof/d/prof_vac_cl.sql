DO $$
BEGIN
DELETE FROM prof_vac_cl WHERE r IN (select "R_TABLE"::bigint from ora_replog999 WHERE "N_TABLE" = 'PROF_VAC_CL' and "OPER" = 'D');
DELETE FROM ora_replog999 WHERE "N_TABLE" = 'PROF_VAC_CL' AND "OPER" = 'D';
END;
$$ LANGUAGE plpgsql;