INSERT INTO
	cl_pspis ("r", "r_p", "year", "kv", "kv_date", "r1", r2, "r3", "r4", "r5", "r6", "ri1", "ri2", "ri3", "ri4", "ri5", "ri6", "p_modi", "d_modi")
SELECT "r", "r_p", "year", "kv", "kv_date", "r1", "r2", "r3", "r4", "r5", "r6", "ri1", "ri2", "ri3", "ri4", "ri5", "ri6", "p_modi", "d_modi"
FROM ora_cl_pspis WHERE ora_cl_pspis.r  = '%s'
ON CONFLICT ("r") DO UPDATE SET "r_p" = EXCLUDED.r_p, "year" = EXCLUDED.year, "kv" = EXCLUDED.kv, "kv_date" = EXCLUDED.kv_date, "r1" = EXCLUDED.r1, "r2" = EXCLUDED.r2, 
		"r3" = EXCLUDED.r3, "r4" = EXCLUDED.r4, "r5" = EXCLUDED.r5, "r6" = EXCLUDED.r6, "ri1" = EXCLUDED.ri1, "ri2" = EXCLUDED.ri2, "ri3" = EXCLUDED.ri3, 
		"ri4" = EXCLUDED.ri4, "ri5" = EXCLUDED.ri5, "ri6" = EXCLUDED.ri6, "p_modi" = EXCLUDED.p_modi, "d_modi" = EXCLUDED.d_modi;