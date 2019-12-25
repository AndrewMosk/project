DO $$
BEGIN
INSERT INTO
	  cl ("c_client", "short_name", "long_name", "d_reg", "cz_cod", "p_ra", "owner", "c_parent", "opf_cod", "sbs_cod", "ogrn_doc", "ogrn_date", "ogrn", "cd_inn",
		  "kpp_inn", "inn_doc", "inn_date", "regnompf", "okpo", "c_soogu", "c_soato", "clstatus_cod", "oper_name", "www", "e_mail", "d_sign", "sign_cod", "shifr",
		  "c_j_address", "c_f_address", "pr_typ", "so_cod", "uz_typ", "uztype_cod", "lic_num", "lic_start", "lic_end", "io_typ", "io_cod", "about", "emp_count",
		  "empi_count", "dost_i", "note", "reg_no", "p_modi", "d_modi", "d_ident", "p_ident")
SELECT "c_client", "short_name", "long_name", "d_reg", "cz_cod", "p_ra", "owner", "c_parent", "c_status" AS "opf_cod", "c_sobst" AS "sbs_cod", "ogrn_doc", "ogrn_date",
		"ogrn", "cd_inn", "kpp_inn", "inn_doc", "inn_date", "regnompf",	"okpo", "c_soogu", "c_soato", "status" AS "clstatus_cod", "oper_name", "www", "e_mail", "d_sign",
		"c_sign" AS "sign_cod", "shifr", "c_j_address", "c_f_address", "pr_typ", "so_cod", "uz_typ", "uz_type" AS "uztype_cod", "lic_num", "lic_start", "lic_end",
		"io_typ", "io_cod", "about", "emp_count", "empi_count", "dost_i", "note", "reg_no", "pers_modi" AS "p_modi",  "d_modi", "i_date" AS "d_ident",
		"i_pers" AS "p_ident"
FROM ora_cl WHERE ora_cl.c_client IN %s
ON CONFLICT ("c_client") DO UPDATE SET "short_name" = EXCLUDED.short_name, "long_name" = EXCLUDED.long_name, "d_reg" = EXCLUDED.d_reg, "cz_cod" = EXCLUDED.cz_cod,
		"p_ra" = EXCLUDED.p_ra, "owner" = EXCLUDED.owner, "c_parent" = EXCLUDED.c_parent, "sbs_cod" = EXCLUDED.sbs_cod,
		"ogrn_doc" = EXCLUDED.ogrn_doc, "ogrn_date" = EXCLUDED.ogrn_date, "ogrn" = EXCLUDED.ogrn, "cd_inn" = EXCLUDED.cd_inn,	"kpp_inn" = EXCLUDED.kpp_inn,
		"inn_doc" = EXCLUDED.inn_doc, "inn_date" = EXCLUDED.inn_date, "regnompf" = EXCLUDED.regnompf, "okpo" = EXCLUDED.okpo, "c_soogu" = EXCLUDED.c_soogu,
		"c_soato" = EXCLUDED.c_soato, "clstatus_cod" = EXCLUDED.clstatus_cod, "oper_name" = EXCLUDED.oper_name, "www" = EXCLUDED.www, "e_mail" = EXCLUDED.e_mail,
		"d_sign" = EXCLUDED.d_sign, "sign_cod" = EXCLUDED.sign_cod, "shifr" = EXCLUDED.shifr, "c_j_address" = EXCLUDED.c_j_address, "c_f_address" = EXCLUDED.c_f_address,
		"pr_typ" = EXCLUDED.pr_typ, "so_cod" = EXCLUDED.so_cod, "uz_typ" = EXCLUDED.uz_typ, "uztype_cod" = EXCLUDED.uztype_cod, "lic_num" = EXCLUDED.lic_num,
		"lic_start" = EXCLUDED.lic_start, "lic_end" = EXCLUDED.lic_end, "io_typ" = EXCLUDED.io_typ, "io_cod" = EXCLUDED.io_cod, "about" = EXCLUDED.about,
		"emp_count" = EXCLUDED.emp_count, "empi_count" = EXCLUDED.empi_count, "dost_i" = EXCLUDED.dost_i, "note" = EXCLUDED.note, "reg_no" = EXCLUDED.reg_no,
		"p_modi" = EXCLUDED.p_modi, "d_modi" = EXCLUDED.d_modi, "d_ident" = EXCLUDED.d_ident, "p_ident" = EXCLUDED.p_ident;
DELETE FROM ora_replog999 WHERE "N_TABLE" = 'CL' AND "R_TABLE" IN %s;
END;
$$ LANGUAGE plpgsql;