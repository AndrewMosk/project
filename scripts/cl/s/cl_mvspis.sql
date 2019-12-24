INSERT INTO
	cl_mvspis ("r", "r_mv", "year", "kv", "kv_date", "f_v", "f_vi", "f_trud", "f_trud_cl", "f_pens", "r1", "r2", "r3", "r4", "r5", "r6", "f_v1", "f_v2", 
		"f_v3",	"p_modi", "d_modi")
SELECT "r", "r_mv", "year", "kv", "kv_date", "f_v", "f_vi", "f_trud", "f_trud_cl", "f_pens", "r1", "r2", "r3", "r4", "r5", "r6", "f_v1", "f_v2", 
		"f_v3",	"p_modi", "d_modi"
FROM ora_cl_mvspis WHERE ora_cl_mvspis.r  = '%s'
ON CONFLICT ("r") DO UPDATE SET "r_mv" = EXCLUDED.r_mv, "year" = EXCLUDED.year, "kv" = EXCLUDED.kv, "kv_date" = EXCLUDED.kv_date, "f_v" = EXCLUDED.f_v, 
		"f_vi" = EXCLUDED.f_vi, "f_trud" = EXCLUDED.f_trud, "f_trud_cl" = EXCLUDED.f_trud_cl, "f_pens" = EXCLUDED.f_pens, "r1" = EXCLUDED.r1, "r2" = EXCLUDED.r2, 
		"r3" = EXCLUDED.r3, "r4" = EXCLUDED.r4, "r5" = EXCLUDED.r5, "r6" = EXCLUDED.r6, "f_v1" = EXCLUDED.f_v1, "f_v2" = EXCLUDED.f_v2, "f_v3" = EXCLUDED.f_v3, 
		"p_modi" = EXCLUDED.p_modi, "d_modi" = EXCLUDED.d_modi;