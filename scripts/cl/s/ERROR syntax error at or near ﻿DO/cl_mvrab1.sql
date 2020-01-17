DO $$
BEGIN
INSERT INTO
	cl_mvrab ("r", "r_mv", "fio", "date_borth", "dfree", "sex", "age", "prof", "prof_cod", "distr", "c_distr", "p_ra", "educ", "educ_cod", "salary", "kat", "comm", 
		"reg_num", "p_modi", "d_modi")
SELECT "r", "r_mv", "fio", "date_borth", "dfree", "sex", "age", "prof", "prof_cod", "distr", "c_distr", "p_ra", "educ", "educ_cod", "salary", "kat", "comm", "reg_num", 
		"p_modi", "d_modi"
FROM ora_cl_mvrab WHERE ora_cl_mvrab.r  = '%s'
ON CONFLICT ("r") DO UPDATE SET "r_mv" = EXCLUDED.r_mv, "fio" = EXCLUDED.fio, "date_borth" = EXCLUDED.date_borth, "dfree" = EXCLUDED.dfree, "sex" = EXCLUDED.sex, 
		"age" = EXCLUDED.age, "prof" = EXCLUDED.prof, "prof_cod" = EXCLUDED.prof_cod, "distr" = EXCLUDED.distr, "c_distr" = EXCLUDED.c_distr, "p_ra" = EXCLUDED.p_ra, 
		"educ" = EXCLUDED.educ,	"educ_cod" = EXCLUDED.educ_cod, "salary" = EXCLUDED.salary, "kat" = EXCLUDED.kat, "comm" = EXCLUDED.comm, "reg_num" = EXCLUDED.reg_num, 
		"p_modi" = EXCLUDED.p_modi, "d_modi" = EXCLUDED.d_modi;
DELETE FROM ora_replog999 WHERE "N_TABLE" = 'CL_MVRAB' AND "R_TABLE" = '%s';
END;
$$ LANGUAGE plpgsql;