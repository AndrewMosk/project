DO $$
BEGIN
INSERT INTO
	s_stat ("r", "godr", "mesr", "cz_cod", "sumo", "k_pers", "k_new", "k_bak", "k_min", "k_max", "k_minr", "k_maxr", "k_mat", "k_educ", "k_poor", "k_perspoor", "s_poor",
		"s_sr_p", "s_sr_p1", "s_sr_s", "s_sumsn", "s_sumpr", "k_sir", "s_sump_sir", "s_sums_sir", "k_minm", "k_mins", "k_1", "k_2", "k_3", "k_4", "k_5", "s_1", "s_2", 
		"s_3", "s_4", "s_5", "s_6", "s_7", "s_8", "s_9", "s_10", "k_6", "k_7", "k_8", "k_9", "k_10", "k_sirp", "k_sirs", "p_modi", "d_modi")
SELECT "r", "godr", "mesr", "cz_cod", "sumo", "k_pers", "k_new", "k_bak", "k_min", "k_max", "k_minr", "k_maxr", "k_mat", "k_educ", "k_poor", "k_perspoor", "s_poor",
		"s_sr_p", "s_sr_p1", "s_sr_s", "s_sumsn", "s_sumpr", "k_sir", "s_sump_sir", "s_sums_sir", "k_minm", "k_mins", "k_1", "k_2", "k_3", "k_4", "k_5", "s_1", "s_2", 
		"s_3", "s_4", "s_5", "s_6", "s_7", "s_8", "s_9", "s_10", "k_6", "k_7", "k_8", "k_9", "k_10", "k_sirp", "k_sirs", "p_modi", "d_modi"
FROM ora_s_stat WHERE ora_s_stat.r = '%s'
ON CONFLICT ("r") DO UPDATE SET "godr" = EXCLUDED.godr, "mesr" = EXCLUDED.mesr, "cz_cod" = EXCLUDED.cz_cod, "sumo" = EXCLUDED.sumo, "k_pers" = EXCLUDED.k_pers, 
		"k_new" = EXCLUDED.k_new, "k_bak" = EXCLUDED.k_bak, "k_min" = EXCLUDED.k_min, "k_max" = EXCLUDED.k_max, "k_minr" = EXCLUDED.k_minr, "k_maxr" = EXCLUDED.k_maxr, 
		"k_mat" = EXCLUDED.k_mat, "k_educ" = EXCLUDED.k_educ, "k_poor" = EXCLUDED.k_poor, "k_perspoor" = EXCLUDED.k_perspoor, "s_poor" = EXCLUDED.s_poor, 
		"s_sr_p" = EXCLUDED.s_sr_p, "s_sr_p1" = EXCLUDED.s_sr_p1, "s_sr_s" = EXCLUDED.s_sr_s, "s_sumsn" = EXCLUDED.s_sumsn, "s_sumpr" = EXCLUDED.s_sumpr, 
		"k_sir" = EXCLUDED.k_sir, "s_sump_sir" = EXCLUDED.s_sump_sir, "s_sums_sir" = EXCLUDED.s_sums_sir, "k_minm" = EXCLUDED.k_minm, "k_mins" = EXCLUDED.k_mins, 
		"k_1" = EXCLUDED.k_1, "k_2" = EXCLUDED.k_2, "k_3" = EXCLUDED.k_3, "k_4" = EXCLUDED.k_4, "k_5" = EXCLUDED.k_5, "s_1" = EXCLUDED.s_1, "s_2" = EXCLUDED.s_2, 
		"s_3" = EXCLUDED.s_3, "s_4" = EXCLUDED.s_4, "s_5" = EXCLUDED.s_5, "s_6" = EXCLUDED.s_6, "s_7" = EXCLUDED.s_7, "s_8" = EXCLUDED.s_8, "s_9" = EXCLUDED.s_9, 
		"s_10" = EXCLUDED.s_10, "k_6" = EXCLUDED.k_6, "k_7" = EXCLUDED.k_7, "k_8" = EXCLUDED.k_8, "k_9" = EXCLUDED.k_9, "k_10" = EXCLUDED.k_10, 
		"k_sirp" = EXCLUDED.k_sirp, "k_sirs" = EXCLUDED.k_sirs, "p_modi" = EXCLUDED.p_modi, "d_modi" = EXCLUDED.d_modi;
--удаляю обработанные строки из оракл		
DELETE FROM ora_replog999 WHERE "N_TABLE" = 'S_STAT' AND "R_TABLE" = '%s';
END;
$$ LANGUAGE plpgsql;