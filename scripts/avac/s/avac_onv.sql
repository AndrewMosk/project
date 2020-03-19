DO $$
BEGIN
INSERT INTO
	avac_onv ("r", "vac_num", "onv_cod", "p_modi", "d_modi", "p_ins", "d_ins")
SELECT "r", "vac_num", "onv_cod", "p_modi", "d_modi", "p_ins", "d_ins"
FROM ora_avac_onv WHERE ora_avac_onv.r = '%s'  AND ora_avac_onv.onv_cod is not null
ON CONFLICT ("r") DO UPDATE SET "vac_num" = EXCLUDED.vac_num, "onv_cod" = EXCLUDED.onv_cod, "p_modi" = EXCLUDED.p_modi, "d_modi" = EXCLUDED.d_modi, 
		"p_ins" = EXCLUDED.p_ins, "d_ins" = EXCLUDED.d_ins;
--удаляю обработанные строки из оракл		
DELETE FROM ora_replog999 WHERE "N_TABLE" = 'AVAC_ONV' AND "R_TABLE" = '%s';
END;
$$ LANGUAGE plpgsql;