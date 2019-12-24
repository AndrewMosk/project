INSERT INTO
	cl_mv ("r", "cz_cod", "c_client", "tel", "prim", "date_beg", "date_end", "k_all", "k_alli", "k_v", "k_vi", "k_pens", "k_inv", "osn_doc", "osn_date", 
		"p_trud", "p_trud_cl", "p_pens", "p_cz", "in_date", "end_date", "mv", "n_date", "vid", "r1", "r2", "r3", "r4", "r5", "r6", "np", "osn_prim", "vidd", "krizf1", 
		"krizf2", "krizf3", "krizf4", "krizf5", "k_v1", "k_v2", "k_v3", "k_v4", "k_v5", "k_v6", "k_v7", "krizf5n", "p_modi", "d_modi")
SELECT "r", "org_cod" AS "cz_cod", "c_client", "tel", "prim", "date_beg", "date_end", "k_all", "k_alli", "k_v", "k_vi", "k_pens", "k_inv", "osn_doc", "osn_date", 
		"p_trud", "p_trud_cl", "p_pens", "p_cz", "in_date", "end_date", "mv", "n_date", "vid", "r1", "r2", "r3", "r4", "r5", "r6", "np", "osn_prim", "vidd", "krizf1", 
		"krizf2", "krizf3", "krizf4", "krizf5", "k_v1", "k_v2", "k_v3", "k_v4", "k_v5", "k_v6",	"k_v7",	"krizf5n", "p_modi", "d_modi"
FROM ora_cl_mv WHERE ora_cl_mv.r  = '%s'
ON CONFLICT ("r") DO UPDATE SET "cz_cod" = EXCLUDED.cz_cod, "c_client" = EXCLUDED.c_client, "tel" = EXCLUDED.tel, "prim" = EXCLUDED.prim, 
		"date_beg" = EXCLUDED.date_beg, "date_end" = EXCLUDED.date_end, "k_all" = EXCLUDED.k_all, "k_alli" = EXCLUDED.k_alli,	"k_v" = EXCLUDED.k_v, 
		"k_vi" = EXCLUDED.k_vi, "k_pens" = EXCLUDED.k_pens, "k_inv" = EXCLUDED.k_inv, "osn_doc" = EXCLUDED.osn_doc, "osn_date" = EXCLUDED.osn_date, 
		"p_trud" = EXCLUDED.p_trud, "p_trud_cl" = EXCLUDED.p_trud_cl, "p_pens" = EXCLUDED.p_pens, "p_cz" = EXCLUDED.p_cz, "in_date" = EXCLUDED.in_date, 
		"end_date" = EXCLUDED.end_date, "mv" = EXCLUDED.mv, "n_date" = EXCLUDED.n_date, "vid" = EXCLUDED.vid, "r1" = EXCLUDED.r1, "r2" = EXCLUDED.r2, 
		"r3" = EXCLUDED.r3, "r4" = EXCLUDED.r4, "r5" = EXCLUDED.r5, "r6" = EXCLUDED.r6, "np" = EXCLUDED.np, "osn_prim" = EXCLUDED.osn_prim,	"vidd" = EXCLUDED.vidd, 
		"krizf1" = EXCLUDED.krizf1, "krizf2" = EXCLUDED.krizf2, "krizf3" = EXCLUDED.krizf3, "krizf4" = EXCLUDED.krizf4, "krizf5" = EXCLUDED.krizf5,	
		"k_v1" = EXCLUDED.k_v1, "k_v2" = EXCLUDED.k_v2, "k_v3" = EXCLUDED.k_v3, "k_v4" = EXCLUDED.k_v4, "k_v5" = EXCLUDED.k_v5, "k_v6" = EXCLUDED.k_v6,	
		"k_v7" = EXCLUDED.k_v7,	"krizf5n" = EXCLUDED.krizf5n, "p_modi" = EXCLUDED.p_modi, "d_modi" = EXCLUDED.d_modi;