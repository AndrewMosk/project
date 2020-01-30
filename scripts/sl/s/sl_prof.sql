DO $$
BEGIN
INSERT INTO
	sl_prof ("prof_cod", "prof_name", "prof_lname", "prof_k", "prof_lev", "prof_code", "are_cod", "prof_okz", "prof_okz14", "prof_etkc", "prof_add", "bak", "pr", 
		"prof_old", "p_modi", "d_modi")
SELECT "prof_cod", "prof_name", "prof_lname", "prof_k", "prof_lev", "prof_code", "are_cod", "prof_okz", "prof_okz14", "prof_etkc", "prof_add", "bak", "pr", 
		"prof_old", "slp_modi" AS "p_modi", "sld_modi" AS "d_modi"
FROM ora_sl_prof WHERE ora_sl_prof.prof_cod = '%s'
ON CONFLICT ("prof_cod") DO UPDATE SET "prof_name" = EXCLUDED.prof_name, "prof_lname" = EXCLUDED.prof_lname, "prof_k" = EXCLUDED.prof_k, "prof_lev" = EXCLUDED.prof_lev, 
		"prof_code" = EXCLUDED.prof_code, "are_cod" = EXCLUDED.are_cod, "prof_okz" = EXCLUDED.prof_okz, "prof_okz14" = EXCLUDED.prof_okz14, 
		"prof_etkc" = EXCLUDED.prof_etkc, "prof_add" = EXCLUDED.prof_add, "bak" = EXCLUDED.bak, "pr" = EXCLUDED.pr, "prof_old" = EXCLUDED.prof_old, 
		"p_modi" = EXCLUDED.p_modi, "d_modi" = EXCLUDED.d_modi;
--удаляю обработанные строки из оракл		
DELETE FROM ora_replog999 WHERE "N_TABLE" = 'SL_PROF' AND "R_TABLE" = '%s';
END;
$$ LANGUAGE plpgsql;