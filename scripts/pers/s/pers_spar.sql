DO $$
BEGIN
INSERT INTO
	pers_spar ("r", "reg_num", "tz", "p_cod", "p_modi", "d_modi", "p_ins", "d_ins")
SELECT "r", "reg_num", "tz", "p_cod", "p_modi", "d_modi", "p_ins", "d_ins"
FROM ora_pers_spar WHERE ora_pers_spar.r = '%s'
ON CONFLICT ("r") DO UPDATE SET "reg_num" = EXCLUDED.reg_num, "tz" = EXCLUDED.tz, "p_cod" = EXCLUDED.p_cod, "p_modi" = EXCLUDED.p_modi, 
		"d_modi" = EXCLUDED.d_modi, "p_ins" = EXCLUDED.p_ins, "d_ins" = EXCLUDED.d_ins;
--удаляю обработанные строки из оракл		
DELETE FROM ora_replog999 WHERE "N_TABLE" = 'PERS_SPAR' AND "R_TABLE" = '%s';
END;
$$ LANGUAGE plpgsql;