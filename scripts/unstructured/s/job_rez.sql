DO $$
BEGIN
INSERT INTO
	job_rez ("r_rez", "reg_num", "dir_num", "job_in_type", "c_client", "prof_cod", "pd_cod", "salf_cod", "jchar_cod", "jreg_cod", "salary", "spe_cod", "rez_date" , 
		"rez_pri", "id_yn", "end_date", "d_uvol", "kyv_cod", "kzot_f", "date_rez", "plc_cod", "p_modi", "d_modi")
SELECT "r_rez", "reg_num", "dir_num", "job_in_type", "c_client", "prof_cod", "pd_cod", "salf_cod", "jchar_cod", "jreg_cod", "salary", SPE.spe_cod, "rez_date", 
		"rez_pri", "id_yn", "end_date", "d_uvol", KYV.kyv_cod, "kzot_f", "date_rez", "plc_cod", "p_modi", "d_modi"  FROM (SELECT * 
	 FROM ora_job_rez WHERE ora_job_rez.r_rez = '%s') AS ora_job_rez_filter
		LEFT JOIN (SELECT sl_spar.par_cod AS kyv_cod, sl_spar.par_code AS par_code FROM sl_spar	WHERE sl_spar.gpar_cod = '131') AS KYV
			ON ora_job_rez_filter.kyv_code = KYV.par_code
		LEFT JOIN (SELECT sl_spar.par_cod AS spe_cod, sl_spar.par_code AS par_code FROM sl_spar	WHERE sl_spar.gpar_cod = '129') AS SPE
			ON ora_job_rez_filter.spe_code = SPE.par_code
ON CONFLICT ("r_rez") DO UPDATE SET "reg_num" = EXCLUDED.reg_num, "dir_num" = EXCLUDED.dir_num, "job_in_type" = EXCLUDED.job_in_type, "c_client" = EXCLUDED.c_client, 
		"prof_cod" = EXCLUDED.prof_cod, "pd_cod" = EXCLUDED.pd_cod, "salf_cod" = EXCLUDED.salf_cod, "jchar_cod" = EXCLUDED.jchar_cod, "jreg_cod" = EXCLUDED.jreg_cod, 
		"salary" = EXCLUDED.salary, "spe_cod" = EXCLUDED.spe_cod, "rez_date" = EXCLUDED.rez_date, "rez_pri" = EXCLUDED.rez_pri, "id_yn" = EXCLUDED.id_yn, 
		"end_date" = EXCLUDED.end_date, "d_uvol" = EXCLUDED.d_uvol, "kyv_cod" = EXCLUDED.kyv_cod, "kzot_f" = EXCLUDED.kzot_f, "date_rez" = EXCLUDED.date_rez, 
		"plc_cod" = EXCLUDED.plc_cod,  "p_modi" = EXCLUDED.p_modi, "d_modi" = EXCLUDED.d_modi;
--удаляю обработанные строки из оракл		
DELETE FROM ora_replog999 WHERE "N_TABLE" = 'JOB_REZ' AND "R_TABLE" = '%s';
END;
$$ LANGUAGE plpgsql;