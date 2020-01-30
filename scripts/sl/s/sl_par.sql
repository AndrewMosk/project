DO $$
BEGIN
INSERT INTO
	sl_par ("cd_par", "n_tasc", "txt_par", "measure", "n_par", "p_plc", "par_select")
SELECT "cd_par", "n_tasc", "txt_par", "measure", "n_par", "p_plc", "par_select"
FROM ora_sl_par WHERE ora_sl_par.cd_par = '%s'
ON CONFLICT ("cd_par") DO UPDATE SET "n_tasc" = EXCLUDED.n_tasc, "txt_par" = EXCLUDED.txt_par, "measure" = EXCLUDED.measure, "n_par" = EXCLUDED.n_par, 
		"p_plc" = EXCLUDED.p_plc, "par_select" = EXCLUDED.par_select;
--удаляю обработанные строки из оракл		
DELETE FROM ora_replog999 WHERE "N_TABLE" = 'SL_PAR' AND "R_TABLE" = '%s';
END;
$$ LANGUAGE plpgsql;