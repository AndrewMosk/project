DO $$
BEGIN
INSERT INTO
	pers_spec ("r", "reg_num", "okso_cod", "speco_cod", "spec_cod", "spec_name", "prof_cod", "pd_cod", "prof_lev", "prof_name", "date_end", "rpu_fob", "rpu_ppo", 
		"c_client", "c_name", "spec_typ", "spec_doc", "spec_date", "date_rez", "spec_stage", "spec_stage5", "st", "p_modi", "d_modi")
SELECT "r", "reg_num", "okso_cod", "speco_cod", "spec_cod", "spec_name", "prof_cod", "prof_pd" AS "pd_cod", "prof_lev", "prof_name", "date_end", FOB.rpu_fob, 
		PPO.rpu_ppo, "c_client", "c_name", "spec_typ", "spec_doc", "spec_date", "date_rez", "spec_stage", "spec_stage5", "st", "p_modi", "d_modi" FROM (SELECT * 
		FROM ora_pers_spec WHERE ora_pers_spec.r = '%s') AS ora_pers_spec_filter
		LEFT JOIN (SELECT sl_spar.par_cod AS rpu_fob, sl_spar.par_code AS par_code FROM sl_spar	WHERE sl_spar.gpar_cod = '105') AS FOB
			ON ora_pers_spec_filter.rpu_fob = FOB.par_code
		LEFT JOIN (SELECT sl_spar.par_cod AS rpu_ppo, sl_spar.par_code AS par_code FROM sl_spar	WHERE sl_spar.gpar_cod = '106') AS PPO
			ON ora_pers_spec_filter.rpu_ppo = PPO.par_code
ON CONFLICT ("r") DO UPDATE SET "reg_num" = EXCLUDED.reg_num, "okso_cod" = EXCLUDED.okso_cod, "speco_cod" = EXCLUDED.speco_cod, "spec_cod" = EXCLUDED.spec_cod, 
		"spec_name" = EXCLUDED.spec_name, "prof_cod" = EXCLUDED.prof_cod, "pd_cod" = EXCLUDED.pd_cod, "prof_lev" = EXCLUDED.prof_lev, "prof_name" = EXCLUDED.prof_name, 
		"date_end" = EXCLUDED.date_end, "rpu_fob" = EXCLUDED.rpu_fob, "rpu_ppo" = EXCLUDED.rpu_ppo, "c_client" = EXCLUDED.c_client, "c_name" = EXCLUDED.c_name, 
		"spec_typ" = EXCLUDED.spec_typ, "spec_doc" = EXCLUDED.spec_doc, "spec_date" = EXCLUDED.spec_date, "date_rez" = EXCLUDED.date_rez, 
		"spec_stage" = EXCLUDED.spec_stage, "spec_stage5" = EXCLUDED.spec_stage5, "st" = EXCLUDED.st, "p_modi" = EXCLUDED.p_modi, "d_modi" = EXCLUDED.d_modi;
--удаляю обработанные строки из оракл		
DELETE FROM ora_replog999 WHERE "N_TABLE" = 'PERS_SPEC' AND "R_TABLE" = '%s';
END;
$$ LANGUAGE plpgsql;