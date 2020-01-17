DO $$
BEGIN
INSERT INTO
	prof_dir ("dir_num", "dir_date", "cz_cod", "reg_num", "vac_num", "dog_num", "statpo_cod", "prtype_cod", "rez_date", "dir_rez", "dir_rez_osn", "stu_beg", 
		"stu_end", "num_pog", "time_h", "time_w", "prof_pri_num", "prof_pri_date", "prof_rz_cod", "date_begin", "date_fin", "instr_num", "instr_date", "doc_num", 
		"doc_cod", "job_after", "kout_reason", "end_rez_date", "rem_text", "p_modi", "d_modi")
SELECT "dir_num", "dir_date", "cz_cod", "reg_num", "vac_num", "dog_num", "statpo_cod", "prtype_cod", "rez_date", "dir_rez", "dir_rez_osn", "stu_beg", 
		"stu_end", "num_pog", "time_h", "time_w", "prof_pri_num", "prof_pri_date", "prof_rz_cod", "date_begin", "date_fin", "instr_num", "instr_date", "doc_num", 
		"doc_cod", "job_after", "kout_reason", "end_rez_date", "rem_text", "p_modi", "d_modi"
FROM ora_prof_dir WHERE ora_prof_dir.dir_num  = '%s'
ON CONFLICT ("dir_num") DO UPDATE SET "dir_date" = EXCLUDED.dir_date, "cz_cod" = EXCLUDED.cz_cod, "reg_num" = EXCLUDED.reg_num, "vac_num" = EXCLUDED.vac_num, 
		"dog_num" = EXCLUDED.dog_num, "statpo_cod" = EXCLUDED.statpo_cod, "prtype_cod" = EXCLUDED.prtype_cod, "rez_date" = EXCLUDED.rez_date, 
		"dir_rez" = EXCLUDED.dir_rez, "dir_rez_osn" = EXCLUDED.dir_rez_osn, "stu_beg" = EXCLUDED.stu_beg, "stu_end" = EXCLUDED.stu_end,
		"num_pog" = EXCLUDED.num_pog, "time_h" = EXCLUDED.time_h, "time_w" = EXCLUDED.time_w, "prof_pri_num" = EXCLUDED.prof_pri_num, 
		"prof_pri_date" = EXCLUDED.prof_pri_date, "prof_rz_cod" = EXCLUDED.prof_rz_cod, "date_begin" = EXCLUDED.date_begin, "date_fin" = EXCLUDED.date_fin, 
		"instr_num" = EXCLUDED.instr_num, "instr_date" = EXCLUDED.instr_date, "doc_num" = EXCLUDED.doc_num, "doc_cod" = EXCLUDED.doc_cod, 
		"job_after" = EXCLUDED.job_after, "kout_reason" = EXCLUDED.kout_reason, "end_rez_date" = EXCLUDED.end_rez_date, "rem_text" = EXCLUDED.rem_text, 
		"p_modi" = EXCLUDED.p_modi, "d_modi" = EXCLUDED.d_modi;
--удаляю обработанные строки из оракл		
DELETE FROM ora_replog999 WHERE "N_TABLE" = 'PROF_DIR' AND "R_TABLE"  = '%s';
END;
$$ LANGUAGE plpgsql;