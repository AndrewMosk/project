INSERT INTO
	cl_zspis ("r", "r_z", "shifr", "prof_cod", "pd_cod", "k_prof", "k_prof_year", "k_prof_rf", "oksm_cod", "srok", "salary", "build_n", "build_o", "build_a", "med_o", 
		"med_d", "staj1", "staj2", "staj3", "staj4", "educ1", "educ2", "educ3", "educ4", "vac_count", "vac_date", "cel1", "cel2", "cel3", "cel4", "educ", "cel5", 
		"k_prof_fakt", "salary_fakt", "k_prof_add", "k_prof_fakt1", "p_modi", "d_modi", "d_ins")
SELECT "r", "r_z", "shifr", "prof_cod", "prof_f11" AS "pd_cod", "k_prof", "k_prof_year", "k_prof_rf", "oksm" AS "oksm_cod", "srok", "salary", "build_n", "build_o", 
		"build_a", "med_o", "med_d", "staj1", "staj2", "staj3", "staj4", "educ1", "educ2", "educ3", "educ4", "vac_count", "vac_date", "cel1", "cel2", "cel3", "cel4", 
		"educ", "cel5", "k_prof_fakt", "salary_fakt", "k_prof_add", "k_prof_fakt1", "p_modi", "d_modi", "v_date" AS "d_ins"
FROM ora_cl_zspis WHERE ora_cl_zspis.r  = '%s'
ON CONFLICT ("r") DO UPDATE SET "r_z" = EXCLUDED.r_z, "shifr" = EXCLUDED.shifr, "prof_cod" = EXCLUDED.prof_cod, "pd_cod" = EXCLUDED.pd_cod, 
		"k_prof" = EXCLUDED.k_prof, "k_prof_year" = EXCLUDED.k_prof_year, "k_prof_rf" = EXCLUDED.k_prof_rf, "oksm_cod" = EXCLUDED.oksm_cod, "srok" = EXCLUDED.srok, 
		"salary" = EXCLUDED.salary, "build_n" = EXCLUDED.build_n, "build_o" = EXCLUDED.build_o, "build_a" = EXCLUDED.build_a, "med_o" = EXCLUDED.med_o, 
		"med_d" = EXCLUDED.med_d, "staj1" = EXCLUDED.staj1, "staj2" = EXCLUDED.staj2, "staj3" = EXCLUDED.staj3, "staj4" = EXCLUDED.staj4, "educ1" = EXCLUDED.educ1, 
		"educ2" = EXCLUDED.educ2, "educ3" = EXCLUDED.educ3, "educ4" = EXCLUDED.educ4, "vac_count" = EXCLUDED.vac_count, "vac_date" = EXCLUDED.vac_date, 
		"cel1" = EXCLUDED.cel1, "cel2" = EXCLUDED.cel2,	"cel3" = EXCLUDED.cel3, "cel4" = EXCLUDED.cel4, "educ" = EXCLUDED.educ, "cel5" = EXCLUDED.cel5,	
		"k_prof_fakt" = EXCLUDED.k_prof_fakt, "salary_fakt" = EXCLUDED.salary_fakt, "k_prof_add" = EXCLUDED.k_prof_add, "k_prof_fakt1" = EXCLUDED.k_prof_fakt1,	
		"p_modi" = EXCLUDED.p_modi, "d_modi" = EXCLUDED.d_modi, "d_ins" = EXCLUDED.d_ins;