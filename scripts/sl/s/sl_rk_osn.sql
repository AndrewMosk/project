DO $$
BEGIN
INSERT INTO
	sl_rk_osn ("rk_cod", "rk_osn", "npp", "rkd_cod", "rkd_osn", "rk_name", "p_dn", "p_de", "p_s", "p_i", "commz", "comm", "commp", "bak", "pr", "rk_named", "prim", 
		"osn_code", "psir", "ppens", "p_prodm", "p_prodd", "p_alg", "docfile", "repfile", "osn_eais", "osn_namel", "rk_srokd", "rk_srokm", "p_modi", "d_modi")
SELECT "rk_cod", "rk_osn", "npp", "rkd_cod", "rkd_osn", "rk_name", "p_dn", "p_de", "p_s", "p_i", "commz", "comm", "commp", "bak", "pr", "rk_named", "prim", 
		"osn_code", "psir", "PPENS" AS "ppens", "p_prodm", "p_prodd", "p_alg", "docfile", "repfile", "osn_eais", "osn_namel", "rk_srokd", "rk_srokm", "p_modi", "d_modi"
FROM ora_sl_rk_osn WHERE ora_sl_rk_osn.rk_osn = '%s'
ON CONFLICT ("rk_osn") DO UPDATE SET "rk_cod" = EXCLUDED.rk_cod, "npp" = EXCLUDED.npp, "rkd_cod" = EXCLUDED.rkd_cod, "rkd_osn" = EXCLUDED.rkd_osn, 
		"rk_name" = EXCLUDED.rk_name, "p_dn" = EXCLUDED.p_dn, "p_de" = EXCLUDED.p_de, "p_s" = EXCLUDED.p_s, "p_i" = EXCLUDED.p_i, "commz" = EXCLUDED.commz, 
		"comm" = EXCLUDED.comm, "commp" = EXCLUDED.commp, "bak" = EXCLUDED.bak, "pr" = EXCLUDED.pr, "rk_named" = EXCLUDED.rk_named, "prim" = EXCLUDED.prim, 
		"osn_code" = EXCLUDED.osn_code, "psir" = EXCLUDED.psir, "ppens" = EXCLUDED.ppens, "p_prodm" = EXCLUDED.p_prodm, "p_prodd" = EXCLUDED.p_prodd, 
		"p_alg" = EXCLUDED.p_alg, "docfile" = EXCLUDED.docfile, "repfile" = EXCLUDED.repfile, "osn_eais" = EXCLUDED.osn_eais, "osn_namel" = EXCLUDED.osn_namel, 
		"rk_srokd" = EXCLUDED.rk_srokd, "rk_srokm" = EXCLUDED.rk_srokm, "p_modi" = EXCLUDED.p_modi, "d_modi" = EXCLUDED.d_modi;
--удаляю обработанные строки из оракл		
DELETE FROM ora_replog999 WHERE "N_TABLE" = 'SL_RK_OSN' AND "R_TABLE" = '%s';
END;
$$ LANGUAGE plpgsql;