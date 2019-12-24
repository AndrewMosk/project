INSERT INTO
	pers_staj ("r", "reg_num", "date_begin", "date_end", "date_kf", "y_begin", "y_end", "y", "m", "d", "p_modi", "d_modi")
SELECT "r", "reg_num", "date_begin", "date_end", "date_kf", "y_begin", "y_end", "y", "m", "d", "p_modi", "d_modi"
FROM ora_pers_staj WHERE ora_pers_staj.r = '%s'
ON CONFLICT ("r") DO UPDATE SET "reg_num" = EXCLUDED.reg_num, "date_begin" = EXCLUDED.date_begin, "date_end" = EXCLUDED.date_end, "date_kf" = EXCLUDED.date_kf, 
		"y_begin" = EXCLUDED.y_begin, "y_end" = EXCLUDED.y_end, "y" = EXCLUDED.y, "m" = EXCLUDED.m, "d" = EXCLUDED.d, "p_modi" = EXCLUDED.p_modi, 
		"d_modi" = EXCLUDED.d_modi;