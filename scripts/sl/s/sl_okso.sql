DO $$
BEGIN
INSERT INTO
	sl_okso ("okso_cod", "okso_parent", "razdel", "obl", "grup", "ur", "prof", "okso_code", "okso_name", "prog_code", "area_code", "is_gr", "pr", "p_modi", "d_modi")
SELECT "okso_cod", "okso_parent", "razdel", "obl", "grup", "ur", "prof", "okso_code", "okso_name", "prog_code", "area_code", "is_gr", "pr", "p_modi", "d_modi"
FROM ora_sl_okso WHERE ora_sl_okso.okso_cod = '%s'
ON CONFLICT ("okso_cod") DO UPDATE SET "okso_parent" = EXCLUDED.okso_parent, "razdel" = EXCLUDED.razdel, "obl" = EXCLUDED.obl, "grup" = EXCLUDED.grup, 
		"ur" = EXCLUDED.ur, "prof" = EXCLUDED.prof, "okso_code" = EXCLUDED.okso_code, "okso_name" = EXCLUDED.okso_name, "prog_code" = EXCLUDED.prog_code, 
		"area_code" = EXCLUDED.area_code, "is_gr" = EXCLUDED.is_gr, "pr" = EXCLUDED.pr, "p_modi" = EXCLUDED.p_modi, "d_modi" = EXCLUDED.d_modi;
--удаляю обработанные строки из оракл		
DELETE FROM ora_replog999 WHERE "N_TABLE" = 'SL_OKSO' AND "R_TABLE" = '%s';
END;
$$ LANGUAGE plpgsql;