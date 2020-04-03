DO $$
BEGIN
INSERT INTO
	vac ("vac_num", "type_cod", "in_date", "cz_cod", "c_client", "c_contact", "prof_cod", "pd_cod", "prof_lev", "prof_spec", "are_cod", "jreg_cod", "job_time", 
		"salary", "salary1", "pr_salary", "salf_cod", "jchar_cod", "jcond_cod", "start_free", "max_dir", "max_spr", "vac_adress", "vac_way", "vac_sob", "p_ra", 
		"spe_cod", "stin_cod", "ncp_cod", "pr_comp", "cntc_cod", "ident_yn", "pr_show", "ness_stage", "educ_cod", "driv_cod", "okso_cod", "spec_cod", 
		"kval_cod", "prof_cod2", "dolz_ob", "usl", "treb", "adinf70", "adinfcl", "adinf", "att_f", "beg_date", "end_date", "rem_text", "vac_guid", 
		"inst_date", "r", "agr_cod", "pr_sod", "r_vac_agr", "p_modi", "d_modi")
SELECT "vac_num", "type_cod", "in_date", "cz_cod", "c_client", "c_contact", "prof_cod", "pd_cod", "prof_lev", "prof_spec", "are_cod", "jreg_cod", "job_time", 
		"salary", "salary1", "pr_salary", "salf_cod", "jchar_cod", "jcond_cod", "start_free", "max_dir", "max_spr", "vac_adress", "vac_way", "vac_sob", "p_ra", 
		SPE.spe_cod, "stin_cod", "ncp_cod", "pr_comp", "cntc_cod", "ident_yn", "pr_show", "ness_stage", "educ_cod", "driv_cod", "okso_cod", "spec_cod", 
		"kval_cod", "prof_cod2", "dolz_ob", "usl", "treb", "adinf70", "adinfcl", "adinf", "att_f", "beg_date", "end_date", "rem_text", "vac_guid", 
		"inst_date", "r", "agr_cod", "pr_sod", "r_vac_agr", "p_modi", "d_modi"  FROM (SELECT * 
	 FROM ora_vac WHERE ora_vac.vac_num IN %s AND ora_vac.salary is not null) AS ora_vac_filter
		LEFT JOIN (SELECT sl_spar.par_cod AS spe_cod, sl_spar.par_code AS par_code FROM sl_spar	WHERE sl_spar.gpar_cod = '129') AS SPE
			ON ora_vac_filter.spe_code = SPE.par_code
ON CONFLICT ("vac_num") DO UPDATE SET "type_cod" = EXCLUDED.type_cod, "in_date" = EXCLUDED.in_date, "cz_cod" = EXCLUDED.cz_cod, "c_client" = EXCLUDED.c_client, 
		"c_contact" = EXCLUDED.c_contact, "prof_cod" = EXCLUDED.prof_cod, "pd_cod" = EXCLUDED.pd_cod, "prof_lev" = EXCLUDED.prof_lev, "prof_spec" = EXCLUDED.prof_spec, 
		"are_cod" = EXCLUDED.are_cod, "jreg_cod" = EXCLUDED.jreg_cod, "job_time" = EXCLUDED.job_time, "salary" = EXCLUDED.salary, "salary1" = EXCLUDED.salary1, 
		"pr_salary" = EXCLUDED.pr_salary, "salf_cod" = EXCLUDED.salf_cod, "jchar_cod" = EXCLUDED.jchar_cod, "jcond_cod" = EXCLUDED.jcond_cod, 
		"start_free" = EXCLUDED.start_free, "max_dir" = EXCLUDED.max_dir, "max_spr" = EXCLUDED.max_spr, "vac_adress" = EXCLUDED.vac_adress, "vac_way" = EXCLUDED.vac_way,
		"vac_sob" = EXCLUDED.vac_sob, "p_ra" = EXCLUDED.p_ra, "spe_cod" = EXCLUDED.spe_cod, "stin_cod" = EXCLUDED.stin_cod, "ncp_cod" = EXCLUDED.ncp_cod, 
		"pr_comp" = EXCLUDED.pr_comp, "cntc_cod" = EXCLUDED.cntc_cod, "ident_yn" = EXCLUDED.ident_yn, "pr_show" = EXCLUDED.pr_show, "ness_stage" = EXCLUDED.ness_stage, 
		"educ_cod" = EXCLUDED.educ_cod, "driv_cod" = EXCLUDED.driv_cod, "okso_cod" = EXCLUDED.okso_cod, "spec_cod" = EXCLUDED.spec_cod, "kval_cod" = EXCLUDED.kval_cod, 
		"prof_cod2" = EXCLUDED.prof_cod2, "dolz_ob" = EXCLUDED.dolz_ob, "usl" = EXCLUDED.usl, "treb" = EXCLUDED.treb, "adinf70" = EXCLUDED.adinf70, 
		"adinfcl" = EXCLUDED.adinfcl, "adinf" = EXCLUDED.adinf, "att_f" = EXCLUDED.att_f, "beg_date" = EXCLUDED.beg_date, "end_date" = EXCLUDED.end_date, 
		"rem_text" = EXCLUDED.rem_text, "vac_guid" = EXCLUDED.vac_guid, "inst_date" = EXCLUDED.inst_date, "r" = EXCLUDED.r, "agr_cod" = EXCLUDED.agr_cod, 
		"pr_sod" = EXCLUDED.pr_sod, "r_vac_agr" = EXCLUDED.r_vac_agr, "p_modi" = EXCLUDED.p_modi, "d_modi" = EXCLUDED.d_modi;
--удаляю обработанные строки из оракл		
DELETE FROM ora_replog999 WHERE "N_TABLE" = 'VAC' AND "R_TABLE" IN %s;
END;
$$ LANGUAGE plpgsql;