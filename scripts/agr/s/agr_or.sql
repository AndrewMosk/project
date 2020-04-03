DO $$
BEGIN
INSERT INTO
	agr_or ("agr_cod", "c_client", "cz_cod", "type_cod", "vif_cod", "agr_num", "agr_form", "p_ra", "c_contact", "c_sign", "agr_begin", "agr_time", "date_beg", "date_end",
		"agr_money", "cod_l", "rp_cod", "agr_vid", "ncp_cod", "cjtyp_cod", "agr_count", "likv_kol", "likv_comm", "p_modi", "d_modi")
SELECT "agr_cod", "c_client", "cz_cod", "type_cod", VIF.vif_cod, "agr_num", "agr_form", "p_ra", "c_contact", "c_sign", "agr_begin", "agr_time", "date_beg", "date_end",
		"agr_money", "cod_l", RP.rp_cod, "agr_vid", "ncp_cod", "cjtyp_cod", "agr_count", "likv_kol", "likv_comm", "p_modi", "d_modi"   FROM (SELECT * 
	 FROM ora_agr_or WHERE ora_agr_or.agr_cod = '%s'  AND ora_agr_or.c_client is not null) AS ora_agr_or_filter
		LEFT JOIN (SELECT sl_spar.par_cod AS vif_cod, sl_spar.par_code AS par_code FROM sl_spar	WHERE sl_spar.gpar_cod = '133') AS VIF
			ON ora_agr_or_filter.vif_cod = VIF.par_code
		LEFT JOIN (SELECT sl_spar.par_cod AS rp_cod, sl_spar.par_code AS par_code FROM sl_spar	WHERE sl_spar.gpar_cod = '142') AS RP
			ON ora_agr_or_filter.rpu_rp = RP.par_code
ON CONFLICT ("agr_cod") DO UPDATE SET "c_client" = EXCLUDED.c_client, "cz_cod" = EXCLUDED.cz_cod, "type_cod" = EXCLUDED.type_cod, "vif_cod" = EXCLUDED.vif_cod, 
		"agr_num" = EXCLUDED.agr_num, "agr_form" = EXCLUDED.agr_form, "p_ra" = EXCLUDED.p_ra, "c_contact" = EXCLUDED.c_contact, "c_sign" = EXCLUDED.c_sign, 
		"agr_begin" = EXCLUDED.agr_begin, "agr_time" = EXCLUDED.agr_time, "date_beg" = EXCLUDED.date_beg, "date_end" = EXCLUDED.date_end, 
		"agr_money" = EXCLUDED.agr_money, "cod_l" = EXCLUDED.cod_l, "rp_cod" = EXCLUDED.rp_cod, "agr_vid" = EXCLUDED.agr_vid, "ncp_cod" = EXCLUDED.ncp_cod, 
		"cjtyp_cod" = EXCLUDED.cjtyp_cod, "agr_count" = EXCLUDED.agr_count, "likv_kol" = EXCLUDED.likv_kol, "likv_comm" = EXCLUDED.likv_comm, 
		"p_modi" = EXCLUDED.p_modi, "d_modi" = EXCLUDED.d_modi;
--удаляю обработанные строки из оракл		
DELETE FROM ora_replog999 WHERE "N_TABLE" = 'AGR_OR' AND "R_TABLE" = '%s';
END;
$$ LANGUAGE plpgsql;