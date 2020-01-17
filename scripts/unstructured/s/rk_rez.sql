DO $$
BEGIN
INSERT INTO
	rk_rez ("r_rk", "r_parent", "r_rko", "r_rez", "reg_num", "r_prot", "d_prot", "pnum", "pref", "rk_cod_pro", "rk_cod", "rk_osn_pro", "rk_osn", "date_beg", "date_end",
		"rab", "poor", "uv_num", "uv_date", "comm", "pr", "p_alg", "priz_soc", "plc_cod", "p_modi", "d_modi")
SELECT "r_rk", "r_parent", "r_rko", "r_rez", "reg_num", "r_prot", "d_prot", "pnum", "pref", "rk_cod_pro", "rk_cod", "rk_osn_pro", "rk_osn", "date_beg", "date_end",
		"rab", "poor", "uv_num", "uv_date", "comm", "pr", "p_alg", "priz_soc", "plc_cod", "p_modi", "d_modi"
FROM ora_rk_rez WHERE ora_rk_rez.r_rk IN %s
ON CONFLICT ("r_rk") DO UPDATE SET "r_parent" = EXCLUDED.r_parent, "r_rko" = EXCLUDED.r_rko, "r_rez" = EXCLUDED.r_rez, "reg_num" = EXCLUDED.reg_num, 
		"r_prot" = EXCLUDED.r_prot, "d_prot" = EXCLUDED.d_prot, "pnum" = EXCLUDED.pnum, "pref" = EXCLUDED.pref, "rk_cod_pro" = EXCLUDED.rk_cod_pro, 
		"rk_cod" = EXCLUDED.rk_cod, "rk_osn_pro" = EXCLUDED.rk_osn_pro, "rk_osn" = EXCLUDED.rk_osn, "date_beg" = EXCLUDED.date_beg, "date_end" = EXCLUDED.date_end, 
		"rab" = EXCLUDED.rab, "poor" = EXCLUDED.poor, "uv_num" = EXCLUDED.uv_num, "uv_date" = EXCLUDED.uv_date, "comm" = EXCLUDED.comm, "pr" = EXCLUDED.pr, 
		"p_alg" = EXCLUDED.p_alg, "priz_soc" = EXCLUDED.priz_soc, "plc_cod" = EXCLUDED.plc_cod, "p_modi" = EXCLUDED.p_modi, "d_modi" = EXCLUDED.d_modi;
--удаляю обработанные строки из оракл		
DELETE FROM ora_replog999 WHERE "N_TABLE" = 'RK_REZ' AND "R_TABLE" IN %s;
END;
$$ LANGUAGE plpgsql;