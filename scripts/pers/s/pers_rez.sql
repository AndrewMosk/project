DO $$
BEGIN
INSERT INTO
	pers_rez ("r_rez", "reg_num", "rez_det", "rez_osn", "date_rez", "rab", "date_next", "date_rab", "date_begin", "date_end", "doc_num", "doc_date", "doc_sum", "comm", 
		"commd", "old_d", "old_o", "r_parent", "plc_cod", "p_modi", "d_modi", "p_ins", "d_ins")
SELECT "r_rez", "reg_num", "rez_det", "rez_osn", "date_rez", "rab", "date_next", "date_rab", "date_begin", "date_end", "doc_num", "doc_date", "doc_sum", "comm", 
		"commd", "old_d", "old_o", "r_parent", "plc_cod", "p_modi", "d_modi", "p_ins", "d_ins" 
	 FROM ora_pers_rez WHERE ora_pers_rez.r_rez = '%s' AND ora_pers_rez.rez_det != null
ON CONFLICT ("r_rez") DO UPDATE SET "reg_num" = EXCLUDED.reg_num, "rez_det" = EXCLUDED.rez_det, "rez_osn" = EXCLUDED.rez_osn, "date_rez" = EXCLUDED.date_rez, 
		"rab" = EXCLUDED.rab, "date_next" = EXCLUDED.date_next, "date_rab" = EXCLUDED.date_rab, "date_begin" = EXCLUDED.date_begin, "date_end" = EXCLUDED.date_end, 
		"doc_num" = EXCLUDED.doc_num, "doc_date" = EXCLUDED.doc_date, "doc_sum" = EXCLUDED.doc_sum, "comm" = EXCLUDED.comm, "commd" = EXCLUDED.commd, 
		"old_d" = EXCLUDED.old_d, "old_o" = EXCLUDED.old_o, "r_parent" = EXCLUDED.r_parent, "plc_cod" = EXCLUDED.plc_cod, "p_modi" = EXCLUDED.p_modi, 
		"d_modi" = EXCLUDED.d_modi, "p_ins" = EXCLUDED.p_ins, "d_ins" = EXCLUDED.d_ins;
--удаляю обработанные строки из оракл		
DELETE FROM ora_replog999 WHERE "N_TABLE" = 'PERS_REZ' AND "R_TABLE" = '%s';
END;
$$ LANGUAGE plpgsql;