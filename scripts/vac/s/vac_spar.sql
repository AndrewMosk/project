DO $$
BEGIN
INSERT INTO
	vac_spar ("r", "vac_num", "tz", "p_cod", "p_modi", "d_modi", "p_ins", "d_ins")
SELECT "r", "vac_num", "tz", "p_cod", "p_modi", "d_modi", "p_ins", "d_ins"
FROM ora_vac_spar WHERE ora_vac_spar.r = '%s'
ON CONFLICT ("r") DO UPDATE SET "vac_num" = EXCLUDED.vac_num, "tz" = EXCLUDED.tz, "p_cod" = EXCLUDED.p_cod, "p_modi" = EXCLUDED.p_modi, "d_modi" = EXCLUDED.d_modi, 
		"p_ins" = EXCLUDED.p_ins, "d_ins" = EXCLUDED.d_ins;
--удаляю обработанные строки из оракл		
DELETE FROM ora_replog999 WHERE "N_TABLE" = 'VAC_SPAR' AND "R_TABLE" = '%s';
END;
$$ LANGUAGE plpgsql;