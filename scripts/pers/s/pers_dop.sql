DO $$
BEGIN
INSERT INTO
	pers ("reg_num", "reg_bak" , "reg_id", "cz_cod", "czu_cod", "plc_cod", "status", "reg_status", "reg_sost1", "reg_sost2", "reg_date", "regd_date", "fam", "nam", 
		"famn", "name", "date_borth", "sex", "doctype", "austype", "ausnum", "sprav", "ausd", "ausp", "date_doc", "citizenship", "b_country", "b_region", "b_ra", 
		"place_borth", "post_i", "street_cod", "aoid_j", "houseid_j", "building", "house", "apart", "comm_j", "adress_old", "paoid_f", "post_i_f", "aoid_f", 
		"houseid_f", "building_f", "house_f", "apart_f", "comm_f", "adress_old_f", "srok_f", "p_ra", "tel_h", "tel_m", "e_mail", "inn", "spens", "fem_cod", "zvan_cod", 
		"poor_num", "educ_cod", "empl_cod", "nez_cod", "stage_v", "stage_p", "stage_o", "stage_om", "stage_od", "stage_y", "stage_yp", "stage_t", "stage_s", "stage_sm", 
		"stage_sd", "date_s",  "stage_d", "kzot_f", "nez_name", "date_f", "date_sal", "salary", "c_client_p", "c_name_p", "date_f_p", "doc_p", "shifr_p", "cd_inn", 
		"c_client", "c_name", "shifr", "prof_cod", "pd_cod", "prof_lev", "prof_spec", "prof_comm", "prof_stage", "prof_stagem", "prof_staged", "k_priz", "fil_cod", 
		"k_num", "sch_num",  "pbo_bank", "k_date", "driv_kat", "hf", "job_priz", "priz_st", "is_direct", "direct_name", "job_i", "soc_i", "dost_i", "p_zin", "stin_ipra", 
		"n_ipra", "d_ipra", "p_planw", "home_c", "p_osn", "rnpo", "jlrb", "vtb", "pdm", "srm", "pts", "katv", "r_mv", "r_mvrab", "comm", "pers_num", "pers_nump", 
		"pers_comj", "pers_prof", "date_end", "date_z", "date_z1", "p_modi", "d_modi")
SELECT	ora_pers.reg_num, ora_pers.reg_bak , ora_pers.reg_id, ora_pers.cz_cod, ora_pers.czu_cod, ora_pers.plc_cod, ora_pers.status, ora_pers.reg_status, 
		ora_pers.reg_sost1, ora_pers.reg_sost2, ora_pers.reg_date, ora_pers.regd_date, ora_pers.fam, ora_pers.nam, ora_pers.famn, ora_pers.name, ora_pers.date_borth, 
		pers_dop.sex, ora_pers.doctype, ora_pers.austype, ora_pers.ausnum, ora_pers.sprav, ora_pers.ausd, ora_pers.ausp, ora_pers.date_doc, pers_dop.citizenship, 
		ora_pers.b_country, ora_pers.b_region, ora_pers.b_ra, ora_pers.place_borth, pers_dop.post_i, pers_dop.street_cod, pers_dop.aoid_j, pers_dop.houseid_j, 
		pers_dop.building, pers_dop.house, pers_dop.apart, pers_dop.comm_j, pers_dop.adress_old, pers_dop.paoid_f, pers_dop.post_i_f, pers_dop.aoid_f, 
		pers_dop.houseid_f,	pers_dop.building_f, pers_dop.house_f, pers_dop.apart_f, pers_dop.comm_f, pers_dop.adress_old_f, pers_dop.srok_f, ora_pers.p_ra, 
		pers_dop.tel_h, pers_dop.tel_m, pers_dop.e_mail, pers_dop.inn, pers_dop.spens, pers_dop.fem_cod, pers_dop.zvan_cod, pers_dop.poor_num, pers_dop.educ_cod, 
		pers_dop.empl_cod, pers_dop.nez_cod, pers_dop.stage_v, pers_dop.stage_p, pers_dop.stage_o, pers_dop.stage_om, pers_dop.stage_od, pers_dop.stage_y, 
		pers_dop.stage_yp, pers_dop.stage_t, pers_dop.stage_s, pers_dop.stage_sm, pers_dop.stage_sd, pers_dop.date_s, pers_dop.stage_d, pers_dop.kzot_f, 
		pers_dop.nez_name, pers_dop.date_f, pers_dop.date_sal, pers_dop.salary, pers_dop.c_client_p, pers_dop.c_name_p, pers_dop.date_f_p, pers_dop.doc_p, 
		pers_dop.shifr_p, pers_dop.cd_inn, pers_dop.c_client, pers_dop.c_name, pers_dop.shifr, pers_dop.prof_cod, pers_dop.pd_cod, pers_dop.prof_lev, 
		pers_dop.prof_spec, pers_dop.prof_comm, pers_dop.prof_stage, pers_dop.prof_stagem, pers_dop.prof_staged, pers_dop.k_priz, pers_dop.fil_cod, pers_dop.k_num, 
		pers_dop.sch_num, pers_dop.pbo_bank, pers_dop.k_date, pers_dop.driv_kat, pers_dop.hf, pers_dop.job_priz, pers_dop.priz_st, pers_dop.is_direct, 
		pers_dop.direct_name, pers_dop.job_i, pers_dop.soc_i, pers_dop.dost_i, pers_dop.p_zin, pers_dop.stin_ipra, pers_dop.n_ipra, pers_dop.d_ipra, pers_dop.p_planw, 
		pers_dop.home_c, pers_dop.p_osn, pers_dop.rnpo, pers_dop.jlrb, pers_dop.vtb, pers_dop.pdm, pers_dop.srm, pers_dop.pts, pers_dop.katv, pers_dop.r_mv, 
		pers_dop.r_mvrab, pers_dop.comm, ora_pers.pers_num, ora_pers.pers_nump, ora_pers.pers_comj, ora_pers.pers_prof, ora_pers.date_end, ora_pers.date_z, 
		ora_pers.date_z1, ora_pers.p_modi, ora_pers.d_modi FROM ora_pers 
	LEFT JOIN (SELECT * FROM ora_pers_dop WHERE ora_pers_dop.reg_num IN %s) AS pers_dop
		ON ora_pers.reg_num = pers_dop.reg_num WHERE ora_pers.reg_num IN %s
ON CONFLICT ("reg_num") DO UPDATE SET "reg_num" = EXCLUDED.reg_num, "reg_bak" = EXCLUDED.reg_bak , "reg_id" = EXCLUDED.reg_id, "cz_cod" = EXCLUDED.cz_cod, 
		"czu_cod" = EXCLUDED.czu_cod, "plc_cod" = EXCLUDED.plc_cod, "status" = EXCLUDED.status, "reg_status" = EXCLUDED.reg_status, "reg_sost1" = EXCLUDED.reg_sost1, 
		"reg_sost2" = EXCLUDED.reg_sost2, "reg_date" = EXCLUDED.reg_date, "regd_date" = EXCLUDED.regd_date, "fam" = EXCLUDED.fam, "nam" = EXCLUDED.nam, 
		"famn" = EXCLUDED.famn, "name" = EXCLUDED.name, "date_borth" = EXCLUDED.date_borth, "sex" = EXCLUDED.sex, "doctype" = EXCLUDED.doctype, 
		"austype" = EXCLUDED.austype, "ausnum" = EXCLUDED.ausnum, "sprav" = EXCLUDED.sprav, "ausd" = EXCLUDED.ausd, "ausp" = EXCLUDED.ausp, 
		"date_doc" = EXCLUDED.date_doc, "citizenship" = EXCLUDED.citizenship, "b_country" = EXCLUDED.b_country, "b_region" = EXCLUDED.b_region, "b_ra" = EXCLUDED.b_ra, 
		"place_borth" = EXCLUDED.place_borth, "post_i" = EXCLUDED.post_i, "street_cod" = EXCLUDED.street_cod, "aoid_j" = EXCLUDED.aoid_j, 
		"houseid_j" = EXCLUDED.houseid_j, "building" = EXCLUDED.building, "house" = EXCLUDED.house, "apart" = EXCLUDED.apart, "comm_j" = EXCLUDED.comm_j, 
		"adress_old" = EXCLUDED.adress_old, "paoid_f" = EXCLUDED.paoid_f, "post_i_f" = EXCLUDED.post_i_f, "aoid_f" = EXCLUDED.aoid_f, "houseid_f" = EXCLUDED.houseid_f, 
		"building_f" = EXCLUDED.building_f, "house_f" = EXCLUDED.house_f, "apart_f" = EXCLUDED.apart_f, "comm_f" = EXCLUDED.comm_f,	
		"adress_old_f" = EXCLUDED.adress_old_f, "srok_f" = EXCLUDED.srok_f, "p_ra" = EXCLUDED.p_ra, "tel_h" = EXCLUDED.tel_h, "tel_m" = EXCLUDED.tel_m, 
		"e_mail" = EXCLUDED.e_mail, "inn" = EXCLUDED.inn, "spens" = EXCLUDED.spens, "fem_cod" = EXCLUDED.fem_cod, "zvan_cod" = EXCLUDED.zvan_cod, 
		"poor_num" = EXCLUDED.poor_num, "educ_cod" = EXCLUDED.educ_cod, "empl_cod" = EXCLUDED.empl_cod, "nez_cod" = EXCLUDED.nez_cod, "stage_v" = EXCLUDED.stage_v, 
		"stage_p" = EXCLUDED.stage_p, "stage_o" = EXCLUDED.stage_o, "stage_om" = EXCLUDED.stage_om, "stage_od" = EXCLUDED.stage_od, "stage_y" = EXCLUDED.stage_y, 
		"stage_yp" = EXCLUDED.stage_yp, "stage_t" = EXCLUDED.stage_t, "stage_s" = EXCLUDED.stage_s, "stage_sm" = EXCLUDED.stage_sm, "stage_sd" = EXCLUDED.stage_sd,
		"date_s" = EXCLUDED.date_s, "stage_d" = EXCLUDED.stage_d, "kzot_f" = EXCLUDED.kzot_f, "nez_name" = EXCLUDED.nez_name, "date_f" = EXCLUDED.date_f, 
		"date_sal" = EXCLUDED.date_sal, "salary" = EXCLUDED.salary, "c_client_p" = EXCLUDED.c_client_p, "c_name_p" = EXCLUDED.c_name_p, "date_f_p" = EXCLUDED.date_f_p, 
		"doc_p" = EXCLUDED.doc_p, "shifr_p" = EXCLUDED.shifr_p, "cd_inn" = EXCLUDED.cd_inn, "c_client" = EXCLUDED.c_client, "c_name" = EXCLUDED.c_name, 
		"shifr" = EXCLUDED.shifr, "prof_cod" = EXCLUDED.prof_cod, "pd_cod" = EXCLUDED.pd_cod, "prof_lev" = EXCLUDED.prof_lev, "prof_spec" = EXCLUDED.prof_spec, 
		"prof_comm" = EXCLUDED.prof_comm, "prof_stage" = EXCLUDED.prof_stage, "prof_stagem" = EXCLUDED.prof_stagem, "prof_staged" = EXCLUDED.prof_staged, 
		"k_priz" = EXCLUDED.k_priz, "fil_cod" = EXCLUDED.fil_cod, "k_num" = EXCLUDED.k_num, "sch_num" = EXCLUDED.sch_num, "pbo_bank" = EXCLUDED.pbo_bank, 
		"k_date" = EXCLUDED.k_date, "driv_kat" = EXCLUDED.driv_kat, "hf" = EXCLUDED.hf, "job_priz" = EXCLUDED.job_priz, "priz_st" = EXCLUDED.priz_st, 
		"is_direct" = EXCLUDED.is_direct, "direct_name" = EXCLUDED.direct_name, "job_i" = EXCLUDED.job_i, "soc_i" = EXCLUDED.soc_i, "dost_i" = EXCLUDED.dost_i, 
		"p_zin" = EXCLUDED.p_zin, "stin_ipra" = EXCLUDED.stin_ipra, "n_ipra" = EXCLUDED.n_ipra, "d_ipra" = EXCLUDED.d_ipra, "p_planw" = EXCLUDED.p_planw, 
		"home_c" = EXCLUDED.home_c, "p_osn" = EXCLUDED.p_osn, "rnpo" = EXCLUDED.rnpo, "jlrb" = EXCLUDED.jlrb, "vtb" = EXCLUDED.vtb, "pdm" = EXCLUDED.pdm, 
		"srm" = EXCLUDED.srm, "pts" = EXCLUDED.pts, "katv" = EXCLUDED.katv, "r_mv" = EXCLUDED.r_mv, "r_mvrab" = EXCLUDED.r_mvrab, "comm" = EXCLUDED.comm, 
		"pers_num" = EXCLUDED.pers_num, "pers_nump" = EXCLUDED.pers_nump, "pers_comj" = EXCLUDED.pers_comj, "pers_prof" = EXCLUDED.pers_prof, 
		"date_end" = EXCLUDED.date_end, "date_z" = EXCLUDED.date_z, "date_z1" = EXCLUDED.date_z1, "p_modi" = EXCLUDED.p_modi, "d_modi" = EXCLUDED.d_modi;
--удаляю обработанные строки из оракл		
DELETE FROM ora_replog999 WHERE "N_TABLE" = 'PERS_DOP' AND "R_TABLE" IN %s;
END;
$$ LANGUAGE plpgsql;