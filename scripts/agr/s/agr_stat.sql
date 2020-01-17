DO $$
BEGIN
INSERT INTO
	agr_stat ("r", "cz_cod", "agr_cod", "tabel_num", "tabel_date", "vid", "year", "month", "job_time", "col_trud", "salary", "cod_l", "p_modi", "d_modi")
SELECT "r", "cz_cod", "agr_cod", "tabel_num", "tabel_date", "vid", "year", "month", "job_time", "col_trud", "salary", "cod_l", "p_modi", "d_modi"
FROM ora_agr_stat WHERE ora_agr_stat.r = '%s'
ON CONFLICT ("r") DO UPDATE SET "cz_cod" = EXCLUDED.cz_cod, "agr_cod" = EXCLUDED.agr_cod, "tabel_num" = EXCLUDED.tabel_num, 
		"tabel_date" = EXCLUDED.tabel_date, "vid" = EXCLUDED.vid, "year" = EXCLUDED.year, "month" = EXCLUDED.month, "job_time" = EXCLUDED.job_time, 
		"col_trud" = EXCLUDED.col_trud, "salary" = EXCLUDED.salary, "cod_l" = EXCLUDED.cod_l, "p_modi" = EXCLUDED.p_modi, "d_modi" = EXCLUDED.d_modi;
--удаляю обработанные строки из оракл		
DELETE FROM ora_replog999 WHERE "N_TABLE" = 'AGR_STAT' AND "R_TABLE" = '%s';
END;
$$ LANGUAGE plpgsql;