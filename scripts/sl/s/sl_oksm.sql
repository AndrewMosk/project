DO $$
INSERT INTO
	sl_oksm ("oksm_cod", "oksm_name", "oksm_namel", "oksm_code2", "oksm_code3", "oksm_vid", "pr", "p_modi", "d_modi")
SELECT "oksm_cod", "oksm_name", "oksm_namel", "oksm_code2", "oksm_code3", "oksm_vid", "pr", "p_modi", "d_modi"
FROM ora_sl_oksm WHERE ora_sl_oksm.oksm_cod = '%s'
ON CONFLICT ("oksm_cod") DO UPDATE SET "oksm_name" = EXCLUDED.oksm_name, "oksm_namel" = EXCLUDED.oksm_namel, "oksm_code2" = EXCLUDED.oksm_code2, 
		"oksm_code3" = EXCLUDED.oksm_code3, "oksm_vid" = EXCLUDED.oksm_vid, "pr" = EXCLUDED.pr, "p_modi" = EXCLUDED.p_modi, "d_modi" = EXCLUDED.d_modi;
--удаляю обработанные строки из оракл		
DELETE FROM ora_replog999 WHERE "N_TABLE" = 'SL_OKSM' AND "R_TABLE" = '%s';
END;
$$ LANGUAGE plpgsql;