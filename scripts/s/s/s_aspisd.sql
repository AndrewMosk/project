DO $$
BEGIN
INSERT INTO
	s_aspisd ("sp_cod", "cz_cod", "k_priz", "sp_form", "nun_cod", "sumv", "kolv", "fil_cod", "otd_cod", "pbo_bank", "godr", "mesr", "r_p", "period", "pp_cod", 
		"pp_date", "p_modi", "d_modi")
SELECT "sp_cod", "cz_cod", "k_priz", "sp_form", "nun_cod", "sumv", "kolv", "fil_cod", "otd_cod", "pbo_bank", "godr", "mesr", "r_p", "period", "pp_cod", 
		"pp_date", "p_modi", "d_modi"
FROM ora_s_aspisd WHERE ora_s_aspisd.sp_cod IN %s
ON CONFLICT ("sp_cod") DO UPDATE SET "cz_cod" = EXCLUDED.cz_cod, "k_priz" = EXCLUDED.k_priz, "sp_form" = EXCLUDED.sp_form, "nun_cod" = EXCLUDED.nun_cod, 
		"sumv" = EXCLUDED.sumv, "kolv" = EXCLUDED.kolv, "fil_cod" = EXCLUDED.fil_cod, "otd_cod" = EXCLUDED.otd_cod, "pbo_bank" = EXCLUDED.pbo_bank, 
		"godr" = EXCLUDED.godr, "mesr" = EXCLUDED.mesr, "r_p" = EXCLUDED.r_p, "period" = EXCLUDED.period, "pp_cod" = EXCLUDED.pp_cod, "pp_date" = EXCLUDED.pp_date, 
		"p_modi" = EXCLUDED.p_modi, "d_modi" = EXCLUDED.d_modi;
--удаляю обработанные строки из оракл		
DELETE FROM ora_replog999 WHERE "N_TABLE" = 'S_ASPISD' AND "R_TABLE" IN %s;
END;
$$ LANGUAGE plpgsql;