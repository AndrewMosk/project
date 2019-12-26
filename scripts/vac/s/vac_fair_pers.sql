DO $$
BEGIN
INSERT INTO
	vac_fair_pers ("r", "r_fair", "reg_num", "pfakt", "date_rezu", "date_rez", "p_modi", "d_modi")
SELECT "r", "r_fair", "reg_num", "pfakt", "date_rezu", "date_rez", "p_modi", "d_modi"
FROM ora_vac_fair_pers WHERE ora_vac_fair_pers.r = '%s'
ON CONFLICT ("r") DO UPDATE SET "r_fair" = EXCLUDED.r_fair, "reg_num" = EXCLUDED.reg_num, "pfakt" = EXCLUDED.pfakt, "date_rezu" = EXCLUDED.date_rezu, 
		"date_rez" = EXCLUDED.date_rez, "p_modi" = EXCLUDED.p_modi, "d_modi" = EXCLUDED.d_modi;
--удаляю обработанные строки из оракл		
DELETE FROM ora_replog999 WHERE "N_TABLE" = 'VAC_FAIR_PERS' AND "R_TABLE" = '%s';
END;
$$ LANGUAGE plpgsql;