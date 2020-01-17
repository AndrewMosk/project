DO $$
BEGIN
INSERT INTO
	job_dir ("dir_num", "reg_num", "vac_num", "dir_spr", "fin_way", "give_date", "fin_date", "rez_det",  "c_client",  "prof_cod",  "salary",  "plc_cod", "agr_cod", 
		"p_modi", "d_modi")
SELECT "dir_num", "reg_num", "vac_num", "dir_spr", "fin_way", "give_date", "fin_date", "rez_det", "c_client",  "prof_cod",  "salary",  "plc_cod", "agr_cod", 
		"p_modi", "d_modi"
FROM ora_job_dir WHERE ora_job_dir.dir_num IN %s
ON CONFLICT ("dir_num") DO UPDATE SET "reg_num" = EXCLUDED.reg_num, "vac_num" = EXCLUDED.vac_num, "dir_spr" = EXCLUDED.dir_spr, "fin_way" = EXCLUDED.fin_way, 
		"give_date" = EXCLUDED.give_date,  "fin_date" = EXCLUDED.fin_date, "rez_det" = EXCLUDED.rez_det,  "c_client" = EXCLUDED.c_client,  
		"prof_cod" = EXCLUDED.prof_cod,  "salary" = EXCLUDED.salary,  "plc_cod" = EXCLUDED.plc_cod,  "agr_cod" = EXCLUDED.agr_cod, "p_modi" = EXCLUDED.p_modi,  
		"d_modi" = EXCLUDED.d_modi;
--удаляю обработанные строки из оракл		
DELETE FROM ora_replog999 WHERE "N_TABLE" = 'JOB_DIR' AND "R_TABLE" IN %s;
END;
$$ LANGUAGE plpgsql;