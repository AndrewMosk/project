DO $$
BEGIN
INSERT INTO
	agr_tabel ("r", "agr_cod", "r_stat", "godr", "mesr", "reg_num", "sumb", "dni", "sumv", "date_b", "date_e", "sp_cod", "pp_cod", "pp_date", "d1", "d2", "d3", "d4", 
		"d5", "d6", "d7", "d8", "d9", "d10", "d11", "d12", "d13", "d14", "d15", "d16", "d17", "d18", "d19", "d20", "d21", "d22", "d23", "d24", "d25", "d26", "d27", 
		"d28", "d29", "d30", "d31", "r_rez", "d_modi", "p_modi")
SELECT "r", "agr_cod", "r_stat", "godr", "mesr", "reg_num", "sumb", "dni", "sumv", "date_b", "date_e", "sp_cod", "pp_cod", "pp_date", "d1", "d2", "d3", "d4", 
		"d5", "d6", "d7", "d8", "d9", "d10", "d11", "d12", "d13", "d14", "d15", "d16", "d17", "d18", "d19", "d20", "d21", "d22", "d23", "d24", "d25", "d26", "d27", 
		"d28", "d29", "d30", "d31", "r_rez", "d_modi", "p_modi"
FROM ora_agr_tabel WHERE ora_agr_tabel.r = '%s'
ON CONFLICT ("r") DO UPDATE SET "agr_cod" = EXCLUDED.agr_cod, "r_stat" = EXCLUDED.r_stat, "godr" = EXCLUDED.godr, "mesr" = EXCLUDED.mesr, "reg_num" = EXCLUDED.reg_num, 
		"sumb" = EXCLUDED.sumb, "dni" = EXCLUDED.dni, "sumv" = EXCLUDED.sumv, "date_b" = EXCLUDED.date_b, "date_e" = EXCLUDED.date_e, "sp_cod" = EXCLUDED.sp_cod, 
		"pp_cod" = EXCLUDED.pp_cod, "pp_date" = EXCLUDED.pp_date, "d1" = EXCLUDED.d1, "d2" = EXCLUDED.d2, "d3" = EXCLUDED.d3, "d4" = EXCLUDED.d4, "d5" = EXCLUDED.d5, 
		"d6" = EXCLUDED.d6, "d7" = EXCLUDED.d7, "d8" = EXCLUDED.d8, "d9" = EXCLUDED.d9, "d10" = EXCLUDED.d10, "d11" = EXCLUDED.d11, "d12" = EXCLUDED.d12, 
		"d13" = EXCLUDED.d13, "d14" = EXCLUDED.d14, "d15" = EXCLUDED.d15, "d16" = EXCLUDED.d16, "d17" = EXCLUDED.d17, "d18" = EXCLUDED.d18, "d19" = EXCLUDED.d19, 
		"d20" = EXCLUDED.d20, "d21" = EXCLUDED.d21, "d22" = EXCLUDED.d22, "d23" = EXCLUDED.d23, "d24" = EXCLUDED.d24, "d25" = EXCLUDED.d25, "d26" = EXCLUDED.d26, 
		"d27" = EXCLUDED.d27, "d28" = EXCLUDED.d28, "d29" = EXCLUDED.d29, "d30" = EXCLUDED.d30, "d31" = EXCLUDED.d31, "r_rez" = EXCLUDED.r_rez, 
		"d_modi" = EXCLUDED.d_modi, "p_modi" = EXCLUDED.p_modi;
--удаляю обработанные строки из оракл		
DELETE FROM ora_replog999 WHERE "N_TABLE" = 'AGR_TABEL' AND "R_TABLE" = '%s';
END;
$$ LANGUAGE plpgsql;