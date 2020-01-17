DO $$
BEGIN
INSERT INTO
	vac_trv ("r", "vac_num", "trv_cod", "p_modi", "d_modi", "p_ins", "d_ins")
SELECT "r", "vac_num", "trv_cod", "p_modi", "d_modi", "p_ins", "d_ins"
FROM ora_vac_trv WHERE ora_vac_trv.r = '%s'
ON CONFLICT ("r") DO UPDATE SET "vac_num" = EXCLUDED.vac_num, "trv_cod" = EXCLUDED.trv_cod, "p_modi" = EXCLUDED.p_modi, "d_modi" = EXCLUDED.d_modi, 
		"p_ins" = EXCLUDED.p_ins, "d_ins" = EXCLUDED.d_ins;
--удаляю обработанные строки из оракл		
DELETE FROM ora_replog999 WHERE "N_TABLE" = 'VAC_TRV' AND "R_TABLE" = '%s';
END;
$$ LANGUAGE plpgsql;