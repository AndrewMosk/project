DO $$
BEGIN
INSERT INTO
	cl_potr ("r", "date_doc", "c_client", "cz_cod", "c_contact", "fok_cod", "vac_adress", "vac_way", "adinfcl", "stat", "date_stat", "stat_comm", "date_reg", 
		"num_reg", "p_modi", "d_modi")
SELECT "r", "date_doc", "c_client", "org_cod" AS "cz_cod", "cod_kont_ent" AS "c_contact", FOK.fok_cod, "vac_adress", "vac_way", "adinfcl", "stat", "date_stat", 
	"stat_comm", "date_reg", "num_reg", "p_modi", "d_modi"  FROM (SELECT * 
	 FROM ora_cl_potr WHERE ora_cl_potr.r  = '%s') AS ora_cl_potr_filter
		LEFT JOIN (SELECT sl_spar.par_cod AS fok_cod, sl_spar.par_code AS par_code FROM sl_spar	WHERE sl_spar.gpar_cod = '46') AS FOK
			ON ora_cl_potr_filter.fok_code = FOK.par_code
ON CONFLICT ("r") DO UPDATE SET "date_doc" = EXCLUDED.date_doc, "c_client" = EXCLUDED.c_client, "cz_cod" = EXCLUDED.cz_cod, "c_contact" = EXCLUDED.c_contact, 
		"fok_cod" = EXCLUDED.fok_cod, "vac_adress" = EXCLUDED.vac_adress, "vac_way" = EXCLUDED.vac_way, "adinfcl" = EXCLUDED.adinfcl, "stat" = EXCLUDED.stat, 
		"date_stat" = EXCLUDED.date_stat, "stat_comm" = EXCLUDED.stat_comm, "date_reg" = EXCLUDED.date_reg, "num_reg" = EXCLUDED.num_reg, "p_modi" = EXCLUDED.p_modi, 
		"d_modi" = EXCLUDED.d_modi;
DELETE FROM ora_replog999 WHERE "N_TABLE" = 'CL_POTR' AND "R_TABLE" = '%s';
END;
$$ LANGUAGE plpgsql;