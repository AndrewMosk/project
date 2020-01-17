DO $$
BEGIN
INSERT INTO
	cl_mvpers ("r", "r_mv", "r_mvrab", "c_client", "cz_cod", "fio", "prof_cod", "date_f", "pdubl", "pz", "reg_num", "reg_date", "trud_date", "sod_date", "pens_date", 
		"prof_date", "pr_date", "end_date", "date_borth", "p_modi", "d_modi")
SELECT "r", "r_mv", "r_mvrab", "c_client", "org_cod" AS "cz_cod", "fio", "prof_cod", "date_f", "pdubl", "pz", "reg_num", "reg_date", "trud_date", "sod_date", 
		"pens_date", "prof_date", "pr_date", "end_date", "date_borth", "p_modi", "d_modi"
FROM ora_cl_mvpers WHERE ora_cl_mvpers.r  = '%s'
ON CONFLICT ("r") DO UPDATE SET "r_mv" = EXCLUDED.r_mv, "r_mvrab" = EXCLUDED.r_mvrab, "c_client" = EXCLUDED.c_client, "cz_cod" = EXCLUDED.cz_cod, "fio" = EXCLUDED.fio, 
		"prof_cod" = EXCLUDED.prof_cod, "date_f" = EXCLUDED.date_f, "pdubl" = EXCLUDED.pdubl, "pz" = EXCLUDED.pz, "reg_num" = EXCLUDED.reg_num, 
		"reg_date" = EXCLUDED.reg_date, "trud_date" = EXCLUDED.trud_date, "sod_date" = EXCLUDED.sod_date, "pens_date" = EXCLUDED.pens_date, 
		"prof_date" = EXCLUDED.prof_date, "pr_date" = EXCLUDED.pr_date, "end_date" = EXCLUDED.end_date, "date_borth" = EXCLUDED.date_borth, 
		"p_modi" = EXCLUDED.p_modi, "d_modi" = EXCLUDED.d_modi;
DELETE FROM ora_replog999 WHERE "N_TABLE" = 'CL_MVPERS' AND "R_TABLE" = '%s';
END;
$$ LANGUAGE plpgsql;