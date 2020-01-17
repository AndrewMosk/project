DO $$
BEGIN
INSERT INTO
	pers_profil ("r", "reg_num", "p_date", "p_next", "p_gr", "v1", "v2", "v3", "v4", "v5", "v6", "v7", "v8", "v9", "v10", "v11", "v12", "v13", "v14", "v15", "v16", 
		"v17", "v18", "v19", "v20", "v21", "v22", "v23", "v24", "v25", "v26", "v27", "v28", "v29", "v30", "p_modi", "d_modi")
SELECT "r", "reg_num", "p_date", "p_next", "p_gr", "v1", "v2", "v3", "v4", "v5", "v6", "v7", "v8", "v9", "v10", "v11", "v12", "v13", "v14", "v15", "v16", 
		"v17", "v18", "v19", "v20", "v21", "v22", "v23", "v24", "v25", "v26", "v27", "v28", "v29", "v30", "p_modi", "d_modi"
FROM ora_pers_profil WHERE ora_pers_profil.r = '%s'
ON CONFLICT ("r") DO UPDATE SET "reg_num" = EXCLUDED.reg_num, "p_date" = EXCLUDED.p_date, "p_next" = EXCLUDED.p_next, "p_gr" = EXCLUDED.p_gr, "v1" = EXCLUDED.v1, 
			"v2" = EXCLUDED.v2, "v3" = EXCLUDED.v3, "v4" = EXCLUDED.v4, "v5" = EXCLUDED.v5, "v6" = EXCLUDED.v6, "v7" = EXCLUDED.v7, "v8" = EXCLUDED.v8, "v9" = EXCLUDED.v9, 
			"v10" = EXCLUDED.v10, "v11" = EXCLUDED.v11,	"v12" = EXCLUDED.v12, "v13" = EXCLUDED.v13, "v14" = EXCLUDED.v14, "v15" = EXCLUDED.v15, "v16" = EXCLUDED.v16, 
			"v17" = EXCLUDED.v17, "v18" = EXCLUDED.v18, "v19" = EXCLUDED.v19, "v20" = EXCLUDED.v20, "v21" = EXCLUDED.v21, "v22" = EXCLUDED.v22, "v23" = EXCLUDED.v23, 
			"v24" = EXCLUDED.v24, "v25" = EXCLUDED.v25, "v26" = EXCLUDED.v26, "v27" = EXCLUDED.v27, "v28" = EXCLUDED.v28, "v29" = EXCLUDED.v29, "v30" = EXCLUDED.v30, 
			"p_modi" = EXCLUDED.p_modi, "d_modi" = EXCLUDED.d_modi;
--удаляю обработанные строки из оракл		
DELETE FROM ora_replog999 WHERE "N_TABLE" = 'PERS_PROFIL' AND "R_TABLE" = '%s';
END;
$$ LANGUAGE plpgsql;