DO $$
BEGIN
INSERT INTO
	pers_prof ("r", "reg_num", "prof_cod", "pd_cod", "prof_lev", "prof_spec", "prof_comm", "date_begin", "date_end", "prof_stage", "prof_doc", "pr", "p_modi", "d_modi")
SELECT "r", "reg_num", "prof_cod", "pd_cod", "prof_lev", "prof_spec", "prof_comm", "date_begin", "date_end", "prof_stage", "prof_doc", "pr", "p_modi", "d_modi"
FROM ora_pers_prof WHERE ora_pers_prof.r = '%s'
ON CONFLICT ("r") DO UPDATE SET "reg_num" = EXCLUDED.reg_num, "prof_cod" = EXCLUDED.prof_cod, "pd_cod" = EXCLUDED.pd_cod, "prof_lev" = EXCLUDED.prof_lev, 
		"prof_spec" = EXCLUDED.prof_spec, "prof_comm" = EXCLUDED.prof_comm, "date_begin" = EXCLUDED.date_begin, "date_end" = EXCLUDED.date_end, 
		"prof_stage" = EXCLUDED.prof_stage, "prof_doc" = EXCLUDED.prof_doc, "pr" = EXCLUDED.pr, "p_modi" = EXCLUDED.p_modi, "d_modi" = EXCLUDED.d_modi;
--удаляю обработанные строки из оракл		
DELETE FROM ora_replog999 WHERE "N_TABLE" = 'PERS_PROF' AND "R_TABLE" = '%s';
END;
$$ LANGUAGE plpgsql;