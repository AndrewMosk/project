DO $$
BEGIN
INSERT INTO
	sl_statrep ("statrep_cod", "form_nm", "kznrep_nm", "rcznrep_nm", "beg_per", "end_per", "per_year", "calc", "multi", "p_modi", "d_modi", "pr_db")
SELECT "statrep_cod", "form_nm", "kznrep_nm", "rcznrep_nm", "beg_per", "end_per", "per_year", "calc", "multi", "pers_modi" AS "p_modi", "d_modi", "pr_db"
FROM ora_sl_statrep WHERE ora_sl_statrep.statrep_cod = '%s'
ON CONFLICT ("statrep_cod") DO UPDATE SET "form_nm" = EXCLUDED.form_nm, "kznrep_nm" = EXCLUDED.kznrep_nm, "rcznrep_nm" = EXCLUDED.rcznrep_nm, 
		"beg_per" = EXCLUDED.beg_per, "end_per" = EXCLUDED.end_per, "per_year" = EXCLUDED.per_year, "calc" = EXCLUDED.calc, "multi" = EXCLUDED.multi, 
		"p_modi" = EXCLUDED.p_modi, "d_modi" = EXCLUDED.d_modi, "pr_db" = EXCLUDED.pr_db;
--удаляю обработанные строки из оракл		
DELETE FROM ora_replog999 WHERE "N_TABLE" = 'SL_STATREP' AND "R_TABLE" = '%s';
END;
$$ LANGUAGE plpgsql;