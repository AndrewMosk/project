DO $$
BEGIN
INSERT INTO
	vac_lang ("r", "vac_num", "lang_cod", "lang_level", "p_modi", "d_modi", "p_ins", "d_ins")
SELECT "r", "vac_num", "lang_cod", "lang_level", "p_modi", "d_modi", "p_ins", "d_ins"
FROM ora_vac_lang WHERE ora_vac_lang.r = '%s'
ON CONFLICT ("r") DO UPDATE SET "vac_num" = EXCLUDED.vac_num, "lang_cod" = EXCLUDED.lang_cod, "lang_level" = EXCLUDED.lang_level, "p_modi" = EXCLUDED.p_modi, 
		"d_modi" = EXCLUDED.d_modi, "p_ins" = EXCLUDED.p_ins, "d_ins" = EXCLUDED.d_ins;
--удаляю обработанные строки из оракл		
DELETE FROM ora_replog999 WHERE "N_TABLE" = 'VAC_LANG' AND "R_TABLE" = '%s';
END;
$$ LANGUAGE plpgsql;