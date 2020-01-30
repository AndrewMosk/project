DO $$
BEGIN
INSERT INTO
	sl_ok_kzot ("id_article", "kzot_shifr", "kzot_code", "rpu_code", "kzot_name", "vid", "article_cod", "item", "letter", "article_name", "pr", "d_modi", "p_modi")
SELECT "id_article", "kzot_shifr", "kzot_code", "rpu_code", "kzot_name", "vid", "article_cod", "item", "letter", "article_name", "pr", "d_modi", "p_modi"
FROM ora_sl_ok_kzot WHERE ora_sl_ok_kzot.id_article = '%s'
ON CONFLICT ("id_article") DO UPDATE SET "kzot_shifr" = EXCLUDED.kzot_shifr, "kzot_code" = EXCLUDED.kzot_code, "rpu_code" = EXCLUDED.rpu_code, 
		"kzot_name" = EXCLUDED.kzot_name, "vid" = EXCLUDED.vid, "article_cod" = EXCLUDED.article_cod, "item" = EXCLUDED.item, "letter" = EXCLUDED.letter, 
		"article_name" = EXCLUDED.article_name, "pr" = EXCLUDED.pr, "d_modi" = EXCLUDED.d_modi, "p_modi" = EXCLUDED.p_modi;
--удаляю обработанные строки из оракл		
DELETE FROM ora_replog999 WHERE "N_TABLE" = 'SL_OK_KZOT' AND "R_TABLE" = '%s';
END;
$$ LANGUAGE plpgsql;