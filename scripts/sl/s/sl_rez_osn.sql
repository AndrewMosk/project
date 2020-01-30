DO $$
BEGIN
INSERT INTO
	sl_rez_osn ("rez_cod", "rez_det", "rez_osn", "npp", "pr", "rez_name", "rez_namep", "psum", "commp", "comm", "commz", "pdoc", "pdoc_code", "ptyp_code", "osn_code", 
		"osn_eais", "rk_cod", "rk_osn", "det_n", "det_p", "osn_n", "osn_p", "docfile", "gu_cod", "gud_code", "gu_typ", "commtitle", "commdtitle", "p_modi", "d_modi")
SELECT "rez_cod", "rez_det", "rez_osn", "npp", "pr", "rez_name", "rez_namep", "psum", "commp", "comm", "commz", "pdoc", "pdoc_code", "ptyp_code", "osn_code", 
		"osn_eais", "rk_cod", "rk_osn", "det_n", "det_p", "osn_n", "osn_p", "docfile", "gu_cod", "gud_code", "gu_typ", "commtitle", "commdtitle", "p_modi", "d_modi"
FROM ora_sl_rez_osn WHERE ora_sl_rez_osn.rez_osn = '%s'
ON CONFLICT ("rez_osn") DO UPDATE SET "rez_cod" = EXCLUDED.rez_cod, "rez_det" = EXCLUDED.rez_det, "npp" = EXCLUDED.npp, "pr" = EXCLUDED.pr, "rez_name" = EXCLUDED.rez_name, 
		"rez_namep" = EXCLUDED.rez_namep, "psum" = EXCLUDED.psum, "commp" = EXCLUDED.commp, "comm" = EXCLUDED.comm, "commz" = EXCLUDED.commz, "pdoc" = EXCLUDED.pdoc, 
		"pdoc_code" = EXCLUDED.pdoc_code, "ptyp_code" = EXCLUDED.ptyp_code, "osn_code" = EXCLUDED.osn_code, "osn_eais" = EXCLUDED.osn_eais, "rk_cod" = EXCLUDED.rk_cod, 
		"rk_osn" = EXCLUDED.rk_osn, "det_n" = EXCLUDED.det_n, "det_p" = EXCLUDED.det_p, "osn_n" = EXCLUDED.osn_n, "osn_p" = EXCLUDED.osn_p, "docfile" = EXCLUDED.docfile, 
		"gu_cod" = EXCLUDED.gu_cod, "gud_code" = EXCLUDED.gud_code, "gu_typ" = EXCLUDED.gu_typ, "commtitle" = EXCLUDED.commtitle, "commdtitle" = EXCLUDED.commdtitle, 
		"p_modi" = EXCLUDED.p_modi, "d_modi" = EXCLUDED.d_modi;
--удаляю обработанные строки из оракл		
DELETE FROM ora_replog999 WHERE "N_TABLE" = 'SL_REZ_OSN' AND "R_TABLE" = '%s';
END;
$$ LANGUAGE plpgsql;