INSERT INTO
	pers_book ("r", "reg_num", "period", "date_begin", "date_end", "prof_cod", "pd_cod", "prof_lev", "prof_spec", "prof_doc", "prof_comm", "c_client", "c_name", "date_kf", "st", 
		"y", "m", "d", "p_prof", "p_modi", "d_modi")
SELECT "r", "reg_num", "period", "date_begin", "date_end", "prof_cod", "pd_cod", "prof_lev", "prof_spec", "prof_doc", "prof_comm", "c_client", "c_name", "date_kf", "st", 
		"y", "m", "d", "p_prof", "p_modi", "d_modi"
FROM ora_pers_book WHERE ora_pers_book.r = '%s'
ON CONFLICT ("r") DO UPDATE SET "reg_num" = EXCLUDED.reg_num, "period" = EXCLUDED.period, "date_begin" = EXCLUDED.date_begin, "date_end" = EXCLUDED.date_end, 
		"prof_cod" = EXCLUDED.prof_cod, "pd_cod" = EXCLUDED.pd_cod, "prof_lev" = EXCLUDED.prof_lev, "prof_spec" = EXCLUDED.prof_spec, "prof_doc" = EXCLUDED.prof_doc, 
		"prof_comm" = EXCLUDED.prof_comm, "c_client" = EXCLUDED.c_client, "c_name" = EXCLUDED.c_name, "date_kf" = EXCLUDED.date_kf, "st" = EXCLUDED.st, "y" = EXCLUDED.y, 
		"m" = EXCLUDED.m, "d" = EXCLUDED.d, "p_prof" = EXCLUDED.p_prof, "p_modi" = EXCLUDED.p_modi, "d_modi" = EXCLUDED.d_modi;