DO $$
BEGIN
INSERT INTO
	sl_rez_det ("rez_cod", "rez_det", "npp", "pr", "rez_name", "rez_namep", "pos_priz", "pdat", "pdel", "psum", "pprint", "next_dni", "pvvod", "commp", "comm", "pdoc", 
		"pdoc_code", "ptyp_code", "det_code", "det_eais", "gu_cod", "gud_code", "gu_typ", "rk_cod", "rk_osn", "det_n", "osn_n", "det_p", "osn_p", "docfile", "commtitle",
		"commdtitle", "commz", "p_1", "p_2", "p_3", "p_4", "p_5", "p_6", "d_1", "d_2", "d_3", "d_4", "p_modi", "d_modi")
SELECT "rez_cod", "rez_det", "npp", "pr", "rez_name", "rez_namep", "pos_priz", "pdat", "pdel", "psum", "pprint", "next_dni", "pvvod", "commp", "comm", "pdoc", 
		"pdoc_code", "ptyp_code", "det_code", "det_eais", "gu_cod", "gud_code", "gu_typ", "rk_cod", "rk_osn", "det_n", "osn_n", "det_p", "osn_p", "docfile", "commtitle",
		"commdtitle", "commz", "p_1", "p_2", "p_3", "p_4", "p_5", "p_6", "d_1", "d_2", "d_3", "d_4", "p_modi", "d_modi"
FROM ora_sl_rez_det WHERE ora_sl_rez_det.rez_det = '%s'
ON CONFLICT ("rez_det") DO UPDATE SET "rez_cod" = EXCLUDED.rez_cod, "npp" = EXCLUDED.npp, "pr" = EXCLUDED.pr, "rez_name" = EXCLUDED.rez_name, 
		"rez_namep" = EXCLUDED.rez_namep, "pos_priz" = EXCLUDED.pos_priz, "pdat" = EXCLUDED.pdat, "pdel" = EXCLUDED.pdel, "psum" = EXCLUDED.psum, 
		"pprint" = EXCLUDED.pprint, "next_dni" = EXCLUDED.next_dni, "pvvod" = EXCLUDED.pvvod, "commp" = EXCLUDED.commp, "comm" = EXCLUDED.comm, 
		"pdoc" = EXCLUDED.pdoc, "pdoc_code" = EXCLUDED.pdoc_code, "ptyp_code" = EXCLUDED.ptyp_code, "det_code" = EXCLUDED.det_code, "det_eais" = EXCLUDED.det_eais, 
		"gu_cod" = EXCLUDED.gu_cod, "gud_code" = EXCLUDED.gud_code, "gu_typ" = EXCLUDED.gu_typ, "rk_cod" = EXCLUDED.rk_cod, "rk_osn" = EXCLUDED.rk_osn, 
		"det_n" = EXCLUDED.det_n, "osn_n" = EXCLUDED.osn_n, "det_p" = EXCLUDED.det_p, "osn_p" = EXCLUDED.osn_p, "docfile" = EXCLUDED.docfile, 
		"commtitle" = EXCLUDED.commtitle, "commdtitle" = EXCLUDED.commdtitle, "commz" = EXCLUDED.commz, "p_1" = EXCLUDED.p_1, "p_2" = EXCLUDED.p_2, 
		"p_3" = EXCLUDED.p_3, "p_4" = EXCLUDED.p_4, "p_5" = EXCLUDED.p_5, "p_6" = EXCLUDED.p_6, "d_1" = EXCLUDED.d_1, "d_2" = EXCLUDED.d_2, 
		"d_3" = EXCLUDED.d_3, "d_4" = EXCLUDED.d_4, "p_modi" = EXCLUDED.p_modi, "d_modi" = EXCLUDED.d_modi;
--удаляю обработанные строки из оракл		
DELETE FROM ora_replog999 WHERE "N_TABLE" = 'SL_REZ_DET' AND "R_TABLE" = '%s';
END;
$$ LANGUAGE plpgsql;