DO $$
BEGIN
INSERT INTO
	vac_free_vac ("r", "pac_num", "prof_cod", "pd_cod", "prof_spec", "prof_lev", "jchar_cod", "salary", "start_free", "fakt_free", "is_gu", "p_modi", "d_modi")
SELECT "r", "pac_num", "prof_cod", "prof_pd" AS "pd_cod", "prof_spec", "kval_cod" AS "prof_lev", "job_char_cod" AS "jchar_cod", "salary", "start_free", "fakt_free", 
		"is_gu", "p_modi", "d_modi"
FROM ora_vac_free_vac WHERE ora_vac_free_vac.r = '%s'
ON CONFLICT ("r") DO UPDATE SET "pac_num" = EXCLUDED.pac_num, "prof_cod" = EXCLUDED.prof_cod, "pd_cod" = EXCLUDED.pd_cod, "prof_spec" = EXCLUDED.prof_spec, 
		"prof_lev" = EXCLUDED.prof_lev, "jchar_cod" = EXCLUDED.jchar_cod, "salary" = EXCLUDED.salary, "start_free" = EXCLUDED.start_free, 
		"fakt_free" = EXCLUDED.fakt_free, "is_gu" = EXCLUDED.is_gu, "p_modi" = EXCLUDED.p_modi, "d_modi" = EXCLUDED.d_modi;
--удаляю обработанные строки из оракл		
DELETE FROM ora_replog999 WHERE "N_TABLE" = 'VAC_FREE_VAC' AND "R_TABLE" = '%s';
END;
$$ LANGUAGE plpgsql;