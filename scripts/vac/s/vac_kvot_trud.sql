DO $$
BEGIN
INSERT INTO
	vac_kvot_trud ("r", "pac_num", "prof_cod", "pd_cod", "prof_spec", "prof_lev", "kv_trud", "kv_gr", "notedoc", "cz_cod", "noteprof", "p_modi", "d_modi")
SELECT "r", "pac_num", "prof_cod", "prof_pd" AS "pd_cod", "prof_spec", "kval_cod" AS "prof_lev", "kv_trud", "kv_gr", "notedoc", "org_cod" AS "cz_cod", "noteprof", 
		"p_modi", "d_modi"
FROM ora_vac_kvot_trud WHERE ora_vac_kvot_trud.r = '%s'
ON CONFLICT ("r") DO UPDATE SET "pac_num" = EXCLUDED.pac_num, "prof_cod" = EXCLUDED.prof_cod, "pd_cod" = EXCLUDED.pd_cod, "prof_spec" = EXCLUDED.prof_spec, 
		"prof_lev"  = EXCLUDED.prof_lev, "kv_trud" = EXCLUDED.kv_trud, "kv_gr" = EXCLUDED.kv_gr, "notedoc" = EXCLUDED.notedoc, "cz_cod" = EXCLUDED.cz_cod, 
		"noteprof" = EXCLUDED.noteprof, "p_modi" = EXCLUDED.p_modi, "d_modi" = EXCLUDED.d_modi;
--удаляю обработанные строки из оракл		
DELETE FROM ora_replog999 WHERE "N_TABLE" = 'VAC_KVOT_TRUD' AND "R_TABLE" = '%s';
END;
$$ LANGUAGE plpgsql;