DO $$
BEGIN
INSERT INTO
	avac_lg ("r", "vac_num", "lg_cod", "p_modi", "d_modi", "p_ins", "d_ins")
SELECT "r", "vac_num", "lg_cod", "p_modi", "d_modi", "p_ins", "d_ins"
FROM ora_avac_lg WHERE ora_avac_lg.r = '%s'
ON CONFLICT ("r") DO UPDATE SET "vac_num" = EXCLUDED.vac_num, "lg_cod" = EXCLUDED.lg_cod, "p_modi" = EXCLUDED.p_modi, "d_modi" = EXCLUDED.d_modi, 
		"p_ins" = EXCLUDED.p_ins, "d_ins" = EXCLUDED.d_ins;
--удаляю обработанные строки из оракл		
DELETE FROM ora_replog999 WHERE "N_TABLE" = 'AVAC_LG' AND "R_TABLE" = '%s';
END;
$$ LANGUAGE plpgsql;