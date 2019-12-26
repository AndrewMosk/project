DO $$
BEGIN
INSERT INTO
	pers_lang ("r", "reg_num", "lang_cod", "langl_cod", "p_modi", "d_modi")
SELECT "r", "reg_num", "lang_cod", "langl_cod", "p_modi", "d_modi"
FROM ora_pers_lang WHERE ora_pers_lang.r = '%s'
ON CONFLICT ("r") DO UPDATE SET "reg_num" = EXCLUDED.reg_num, "lang_cod" = EXCLUDED.lang_cod, "langl_cod" = EXCLUDED.langl_cod, "p_modi" = EXCLUDED.p_modi, 
		"d_modi" = EXCLUDED.d_modi;
--удаляю обработанные строки из оракл		
DELETE FROM ora_replog999 WHERE "N_TABLE" = 'PERS_LANG' AND "R_TABLE" = '%s';	 
END;
$$ LANGUAGE plpgsql;