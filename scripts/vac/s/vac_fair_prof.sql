DO $$
BEGIN
INSERT INTO
	vac_fair_prof ("r", "r_fair", "prof_cod", "prof_spec", "salary", "salary1", "start_free", "p_modi", "d_modi")
SELECT "r", "r_fair", "prof_cod", "prof_spec", "salary", "salary1", "start_free", "p_modi", "d_modi"
FROM ora_vac_fair_prof WHERE ora_vac_fair_prof.r = '%s'
ON CONFLICT ("r") DO UPDATE SET "r_fair" = EXCLUDED.r_fair, "prof_cod" = EXCLUDED.prof_cod, "prof_spec" = EXCLUDED.prof_spec, "salary" = EXCLUDED.salary, 
		"salary1" = EXCLUDED.salary1, "start_free" = EXCLUDED.start_free, "p_modi" = EXCLUDED.p_modi, "d_modi" = EXCLUDED.d_modi;
--удаляю обработанные строки из оракл		
DELETE FROM ora_replog999 WHERE "N_TABLE" = 'VAC_FAIR_PROF' AND "R_TABLE" = '%s';
END;
$$ LANGUAGE plpgsql;