DO $$
BEGIN
INSERT INTO
	sl_spar ("r", "r_parent", "gpar_cod", "gpar_code", "np", "par_cod", "par_code", "par_code_d", "par_name", "par_names", "par_comm", "pr", "end_date", 
		"p_modi", "d_modi")
SELECT "r", "r_parent", "gpar_cod", "gpar_code", "np", "par_cod", "par_code", "par_code_d", "par_name", "par_names", "par_comm", "pr", "end_date", "p_modi", "d_modi"
FROM ora_sl_spar WHERE ora_sl_spar.r = '%s'
ON CONFLICT ("r") DO UPDATE SET "r_parent" = EXCLUDED.r_parent, "gpar_cod" = EXCLUDED.gpar_cod, "gpar_code" = EXCLUDED.gpar_code, "np" = EXCLUDED.np, 
		"par_cod" = EXCLUDED.par_cod, "par_code" = EXCLUDED.par_code, "par_code_d" = EXCLUDED.par_code_d, "par_name" = EXCLUDED.par_name, 
		"par_names" = EXCLUDED.par_names, "par_comm" = EXCLUDED.par_comm, "pr" = EXCLUDED.pr, "end_date" = EXCLUDED.end_date, "p_modi" = EXCLUDED.p_modi, 
		"d_modi" = EXCLUDED.d_modi;
--удаляю обработанные строки из оракл		
DELETE FROM ora_replog999 WHERE "N_TABLE" = 'SL_SPAR' AND "R_TABLE" = '%s';
END;
$$ LANGUAGE plpgsql;