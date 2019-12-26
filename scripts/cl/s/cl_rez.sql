DO $$
BEGIN
INSERT INTO
	cl_rez ("r","r_i","c_client","rez_det","rez_osn","date_rez","date_begin","date_end","doc_num","doc_date","doc_sum","rab","date_rab","c_contact","comm","fok_cod",
		"cz_cod","p_modi","d_modi")
SELECT "r", "r_i", "c_client", "rez_det", "rez_osn", "date_rez", "date_begin", "date_end", "doc_num", "doc_date", "doc_sum", "rab", "date_rab", "c_contact", "comm", 
		FOK.fok_cod, "org_cod" AS "cz_cod", "p_modi", "d_modi"  FROM (SELECT * 
	 FROM ora_cl_rez WHERE ora_cl_rez.r  = '%s') AS ora_cl_rez_filter
		LEFT JOIN (SELECT sl_spar.par_cod AS fok_cod, sl_spar.par_code AS par_code FROM sl_spar	WHERE sl_spar.gpar_cod = '46') AS FOK
			ON ora_cl_rez_filter.fok_code = FOK.par_code
ON CONFLICT ("r") DO UPDATE SET "r_i" = EXCLUDED.r_i, "c_client" = EXCLUDED.c_client, "rez_det" = EXCLUDED.rez_det, "rez_osn" = EXCLUDED.rez_osn, 
		"date_rez" = EXCLUDED.date_rez,	"date_begin" = EXCLUDED.date_begin, "date_end" = EXCLUDED.date_end, "doc_num" = EXCLUDED.doc_num, "doc_date" = EXCLUDED.doc_date,
		"doc_sum" = EXCLUDED.doc_sum, "rab" = EXCLUDED.rab, "date_rab" = EXCLUDED.date_rab, "c_contact" = EXCLUDED.c_contact, "comm" = EXCLUDED.comm, 
		"fok_cod" = EXCLUDED.fok_cod, "cz_cod" = EXCLUDED.cz_cod, "p_modi" = EXCLUDED.p_modi, "d_modi" = EXCLUDED.d_modi;
DELETE FROM ora_replog999 WHERE "N_TABLE" = 'CL_REZ' AND "R_TABLE" = '%s';
END;
$$ LANGUAGE plpgsql;