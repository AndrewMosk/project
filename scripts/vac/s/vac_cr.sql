DO $$
BEGIN
INSERT INTO
	vac_cr ("r", "vac_num", "vcr_cod", "vcr_det_cod", "vcr_date", "p_modi")
SELECT "r", "vac_num", "vcr_cod", "vcr_det_cod", "vcr_date", "p_modi"
FROM ora_vac_cr WHERE ora_vac_cr.r = '%s'
ON CONFLICT ("r") DO UPDATE SET "vac_num" = EXCLUDED.vac_num, "vcr_cod" = EXCLUDED.vcr_cod, "vcr_det_cod" = EXCLUDED.vcr_det_cod, "vcr_date" = EXCLUDED.vcr_date, 
		"p_modi" = EXCLUDED.p_modi;
--удаляю обработанные строки из оракл		
DELETE FROM ora_replog999 WHERE "N_TABLE" = 'VAC_CR' AND "R_TABLE" = '%s';
END;
$$ LANGUAGE plpgsql;