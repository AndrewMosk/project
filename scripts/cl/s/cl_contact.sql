INSERT INTO
	cl_contact ("c_contact", "c_client", "cntct_f", "cntct_i", "cntct_o", "dlg_cod", "pd_cod", "dlg_name", "tlf_no", "ext_number", "tlf_dop", "fax_number", "e_mail", 
		"note", "tlf_p", "pr", "pr_ruk", "snils",	"doc_date", "doc_num", "doc_end", "doc_typ", "p_modi", "d_modi")
SELECT "c_contact", "c_client", "cntct_f", "cntct_i", "cntct_o", "c_dlg" AS "dlg_cod", "pd_cod", "dlg_name", "tlf_no", "ext_number", "tlf_dop", "fax_number", "e_mail", 
		"note", "tlf_p", "pr", "pr_ruk", "snils", "doc_date", "doc_num", "doc_end", "doc_typ", "pers_modi" AS "p_modi", "d_modi"
FROM ora_cl_contact WHERE ora_cl_contact.c_contact  = '%s'
ON CONFLICT ("c_contact") DO UPDATE SET "c_client" = EXCLUDED.c_client, "cntct_f" = EXCLUDED.cntct_f, "cntct_i" = EXCLUDED.cntct_i, "cntct_o" = EXCLUDED.cntct_o, 
		"dlg_cod" = EXCLUDED.dlg_cod, "pd_cod" = EXCLUDED.pd_cod,	"dlg_name" = EXCLUDED.dlg_name, "tlf_no" = EXCLUDED.tlf_no, "ext_number" = EXCLUDED.ext_number, 
		"tlf_dop" = EXCLUDED.tlf_dop, "fax_number" = EXCLUDED.fax_number, "e_mail" = EXCLUDED.e_mail, "note" = EXCLUDED.note, "tlf_p" = EXCLUDED.tlf_p, 
		"pr" = EXCLUDED.pr, "pr_ruk" = EXCLUDED.pr_ruk, "snils" = EXCLUDED.snils, "doc_date" = EXCLUDED.doc_date, "doc_num" = EXCLUDED.doc_num, 
		"doc_end" = EXCLUDED.doc_end, "doc_typ" = EXCLUDED.doc_typ, "p_modi" = EXCLUDED.p_modi, "d_modi" = EXCLUDED.d_modi;