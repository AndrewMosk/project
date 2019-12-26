DO $$
BEGIN
INSERT INTO
	vac_distr ("r", "vac_num", "c_distr", "p_modi", "d_modi", "p_ins", "d_ins")
SELECT "r_vac_distr" AS "r", "vac_num", "district" AS "c_distr", "p_modi", "d_modi", "p_ins", "d_ins"
FROM ora_vac_distr WHERE ora_vac_distr.r_vac_distr = '%s'
ON CONFLICT ("r") DO UPDATE SET "vac_num" = EXCLUDED.vac_num, "c_distr" = EXCLUDED.c_distr, "p_modi" = EXCLUDED.p_modi, "d_modi" = EXCLUDED.d_modi, 
		"p_ins" = EXCLUDED.p_ins, "d_ins" = EXCLUDED.d_ins;
--удаляю обработанные строки из оракл		
DELETE FROM ora_replog999 WHERE "N_TABLE" = 'VAC_DISTR' AND "R_TABLE" = '%s';
END;
$$ LANGUAGE plpgsql;