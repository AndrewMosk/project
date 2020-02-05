DO $$
BEGIN
INSERT INTO
	agr_spis ("r", "k_priz", "cz_cod", "sp_form", "r_p", "godr", "mesr", "period", "fil_cod", "otd_cod", "pp_cod", "pp_date", "sumv", "kolv", "cod_l", "p_modi", "d_modi")
SELECT "r", "k_priz", "cz_cod", "sp_form", "r_p", "godr", "mesr", "period", "fil_cod", "otd_cod", "pp_cod", "pp_date", "sumv", "kolv", "cod_l", "p_modi", "d_modi"
FROM ora_agr_spis WHERE ora_agr_spis.r = '%s'
ON CONFLICT ("r") DO UPDATE SET "k_priz" = EXCLUDED.k_priz, "cz_cod" = EXCLUDED.cz_cod, "sp_form" = EXCLUDED.sp_form, "r_p" = EXCLUDED.r_p, 
		"godr" = EXCLUDED.godr, "mesr" = EXCLUDED.mesr, "period" = EXCLUDED.period, "fil_cod" = EXCLUDED.fil_cod, "otd_cod" = EXCLUDED.otd_cod, 
		"pp_cod" = EXCLUDED.pp_cod, "pp_date" = EXCLUDED.pp_date, "sumv" = EXCLUDED.sumv, "kolv" = EXCLUDED.kolv, "cod_l" = EXCLUDED.cod_l, "p_modi" = EXCLUDED.p_modi, 
		"d_modi" = EXCLUDED.d_modi;
--удаляю обработанные строки из оракл		
DELETE FROM ora_replog999 WHERE "N_TABLE" = 'AGR_SPIS' AND "R_TABLE" = '%s';
END;
$$ LANGUAGE plpgsql;