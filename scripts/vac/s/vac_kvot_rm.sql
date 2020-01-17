DO $$
BEGIN
INSERT INTO
	vac_kvot_rm ("r", "pac_num", "prof_cod", "pd_cod", "prof_spec", "prof_lev", "educ_cod", "kv_rm", "salary", "notedoc", "noteprof", "p_modi", "d_modi")
SELECT "r", "pac_num", "prof_cod", "prof_pd" AS "pd_cod", "prof_spec", "kval_cod" AS "prof_lev", "educ_cod", "kv_rm", "salary", "notedoc", "noteprof", "p_modi", "d_modi"
FROM ora_vac_kvot_rm WHERE ora_vac_kvot_rm.r = '%s'
ON CONFLICT ("r") DO UPDATE SET "pac_num" = EXCLUDED.pac_num, "prof_cod" = EXCLUDED.prof_cod, "pd_cod" = EXCLUDED.pd_cod, "prof_spec" = EXCLUDED.prof_spec, 
		"prof_lev"  = EXCLUDED.prof_lev, "educ_cod" = EXCLUDED.educ_cod, "kv_rm" = EXCLUDED.kv_rm, "salary" = EXCLUDED.salary, "notedoc" = EXCLUDED.notedoc, 
		"noteprof" = EXCLUDED.noteprof, "p_modi" = EXCLUDED.p_modi, "d_modi" = EXCLUDED.d_modi;
--удаляю обработанные строки из оракл		
DELETE FROM ora_replog999 WHERE "N_TABLE" = 'VAC_KVOT_RM' AND "R_TABLE" = '%s';
END;
$$ LANGUAGE plpgsql;