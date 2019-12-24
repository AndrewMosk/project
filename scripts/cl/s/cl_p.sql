INSERT INTO
	cl_p ("r", "cz_cod", "c_client", "date_beg", "date_end", "tel", "k_all", "k_alli", "r1", "r2", "r3", "r4", "r5", "r6", "ri1", "ri2", "ri3", "ri4", "ri5", "ri6", 
		"in_date", "np", "osn_prim", "vidd", "krizf1", "krizf2", "krizf3", "krizf4", "krizf5", "krizf5n", "p_modi", "d_modi")
SELECT "r", "org_cod" AS "cz_cod", "c_client", "date_beg", "date_end", "tel", "k_all", "k_alli", "r1", "r2", "r3", "r4", "r5", "r6", "ri1", "ri2", "ri3", "ri4", "ri5", 
		"ri6", "in_date", "np", "osn_prim", "vidd", "krizf1", "krizf2", "krizf3", "krizf4", "krizf5", "krizf5n", "p_modi", "d_modi"
FROM ora_cl_p WHERE ora_cl_p.r  = '%s'
ON CONFLICT ("r") DO UPDATE SET "cz_cod" = EXCLUDED.cz_cod, "c_client" = EXCLUDED.c_client, "date_beg" = EXCLUDED.date_beg, "date_end" = EXCLUDED.date_end, 
		"tel" = EXCLUDED.tel, "k_all" = EXCLUDED.k_all, "k_alli" = EXCLUDED.k_alli, "r1" = EXCLUDED.r1, "r2" = EXCLUDED.r2, "r3" = EXCLUDED.r3, "r4" = EXCLUDED.r4, 
		"r5" = EXCLUDED.r5, "r6" = EXCLUDED.r6, "ri1" = EXCLUDED.ri1, "ri2" = EXCLUDED.ri2, "ri3" = EXCLUDED.ri3, "ri4" = EXCLUDED.ri4, "ri5" = EXCLUDED.ri5, 
		"ri6" = EXCLUDED.ri6, "in_date" = EXCLUDED.in_date, "np" = EXCLUDED.np, "osn_prim" = EXCLUDED.osn_prim, "vidd" = EXCLUDED.vidd, "krizf1" = EXCLUDED.krizf1, 
		"krizf2" = EXCLUDED.krizf2, "krizf3" = EXCLUDED.krizf3, "krizf4" = EXCLUDED.krizf4, "krizf5" = EXCLUDED.krizf5, "krizf5n" = EXCLUDED.krizf5n, 
		"p_modi" = EXCLUDED.p_modi, "d_modi" = EXCLUDED.d_modi;