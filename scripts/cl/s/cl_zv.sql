DO $$
BEGIN
INSERT INTO
	cl_zv ("r", "c_client", "cz_cod", "k_all", "k_ir", "shifr", "pol_date", "in_cod", "in_num", "in_date", "out_num", "out_date", "kzn_org", "kzn_num", "kzn_date", 
		"year", "prim", "fok_cod", "r_e", "comm", "p_modi", "d_modi", "d_ins")
SELECT "r", "c_client", "org_cod" AS "cz_cod", "k_all", "k_ir", "shifr", "pol_date", "in_cod", "in_num", "in_date", "out_num", "out_date", "kzn_org", "kzn_num", 
		"kzn_date", "year", "prim", FOK.fok_cod, "r_e", "comm", "p_modi", "d_modi", "v_date" AS "d_ins"  FROM (SELECT * 
	 FROM ora_cl_zv WHERE ora_cl_zv.r  = '%s') AS ora_cl_zv_filter
		LEFT JOIN (SELECT sl_spar.par_cod AS fok_cod, sl_spar.par_code AS par_code FROM sl_spar	WHERE sl_spar.gpar_cod = '46') AS FOK
			ON ora_cl_zv_filter.fok_code = FOK.par_code
ON CONFLICT ("r") DO UPDATE SET "c_client" = EXCLUDED.c_client, "cz_cod" = EXCLUDED.cz_cod, "k_all" = EXCLUDED.k_all, "k_ir" = EXCLUDED.k_ir, "shifr" = EXCLUDED.shifr, 
		"pol_date" = EXCLUDED.pol_date, "in_cod" = EXCLUDED.in_cod, "in_num" = EXCLUDED.in_num, "in_date" = EXCLUDED.in_date, "out_num" = EXCLUDED.out_num, 
		"out_date" = EXCLUDED.out_date, "kzn_org" = EXCLUDED.kzn_org, "kzn_num" = EXCLUDED.kzn_num, "kzn_date" = EXCLUDED.kzn_date, "year" = EXCLUDED.year, 
		"prim" = EXCLUDED.prim, "fok_cod" = EXCLUDED.fok_cod, "r_e" = EXCLUDED.r_e, "comm" = EXCLUDED.comm, "p_modi" = EXCLUDED.p_modi, "d_modi" = EXCLUDED.d_modi, 
		"d_ins" = EXCLUDED.d_ins;
DELETE FROM ora_replog999 WHERE "N_TABLE" = 'CL_ZV' AND "R_TABLE" = '%s';
END;
$$ LANGUAGE plpgsql;