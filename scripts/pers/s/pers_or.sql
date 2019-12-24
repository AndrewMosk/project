INSERT INTO
	pers_or ("dir_num", "reg_num", "vac_num", "agr_cod", "con_num", "con_date", "or_beg", "or_end", "or_sal", "or_npri", "or_dtpri", "or_rez_date", "npri", "dtpri", 
		"rez_or_beg", "rez_or_end", "rez_det", "rez_osn", "kyv_cod", "rez_date", "plc_cod", "p_modi", "d_modi")
SELECT "dir_num", "reg_num", "vac_num", "agr_cod", "con_num", "con_date", "or_beg", "or_end", "or_sal", "or_npri", "or_dtpri", "or_rez_date", "npri", "dtpri", 
		"rez_or_beg", "rez_or_end", "rez_det", "rez_osn", KYV.kyv_cod, "rez_date", "plc_cod", "p_modi", "d_modi"  FROM (SELECT * 
	 FROM ora_pers_or WHERE ora_pers_or.dir_num = '%s') AS ora_pers_or_filter
		LEFT JOIN (SELECT sl_spar.par_cod AS kyv_cod, sl_spar.par_code AS par_code FROM sl_spar	WHERE sl_spar.gpar_cod = '131') AS KYV
			ON ora_pers_or_filter.kyv_code = KYV.par_code
ON CONFLICT ("dir_num") DO UPDATE SET "reg_num" = EXCLUDED.reg_num, "vac_num" = EXCLUDED.vac_num, "agr_cod" = EXCLUDED.agr_cod, "con_num" = EXCLUDED.con_num, 
		"con_date" = EXCLUDED.con_date, "or_beg" = EXCLUDED.or_beg, "or_end" = EXCLUDED.or_end, "or_sal" = EXCLUDED.or_sal, "or_npri" = EXCLUDED.or_npri, 
		"or_dtpri" = EXCLUDED.or_dtpri, "or_rez_date" = EXCLUDED.or_rez_date, "npri" = EXCLUDED.npri, "dtpri" = EXCLUDED.dtpri, "rez_or_beg" = EXCLUDED.rez_or_beg, 
		"rez_or_end" = EXCLUDED.rez_or_end, "rez_det" = EXCLUDED.rez_det, "rez_osn" = EXCLUDED.rez_osn, "kyv_cod" = EXCLUDED.kyv_cod, "rez_date" = EXCLUDED.rez_date, 
		"plc_cod" = EXCLUDED.plc_cod, "p_modi" = EXCLUDED.p_modi, "d_modi" = EXCLUDED.d_modi;