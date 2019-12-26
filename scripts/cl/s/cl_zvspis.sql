DO $$
BEGIN
INSERT INTO
	cl_zvspis ("r", "r_zv", "prof_cod", "pd_cod", "salary", "oksm_cod", "date_b", "date_e", "prim", "k_prof", "p_prof_ok", "p_prof_no", "z_prof_ok", "z_prof_no", "p_no", 
		"z_no", "p_modi", "d_modi", "d_ins")
SELECT "r", "r_zv", "prof_cod", "prof_f11" AS "pd_cod", "salary", "oksm" AS "oksm_cod", "date_b", "date_e", "prim", "k_prof", "p_prof_ok", "p_prof_no", "z_prof_ok", "z_prof_no", "p_no", 
		"z_no", "p_modi", "d_modi", "v_date" AS "d_ins"
FROM ora_cl_zvspis WHERE ora_cl_zvspis.r  = '%s'
ON CONFLICT ("r") DO UPDATE SET "r_zv" = EXCLUDED.r_zv, "prof_cod" = EXCLUDED.prof_cod, "pd_cod" = EXCLUDED.pd_cod, "salary" = EXCLUDED.salary, 
		"oksm_cod" = EXCLUDED.oksm_cod, "date_b" = EXCLUDED.date_b, "date_e" = EXCLUDED.date_e, "prim" = EXCLUDED.prim, "k_prof" = EXCLUDED.k_prof, 
		"p_prof_ok" = EXCLUDED.p_prof_ok, "p_prof_no" = EXCLUDED.p_prof_no, "z_prof_ok" = EXCLUDED.z_prof_ok, "z_prof_no" = EXCLUDED.z_prof_no, "p_no" = EXCLUDED.p_no, 
		"z_no" = EXCLUDED.z_no,  "p_modi" = EXCLUDED.p_modi, "d_modi" = EXCLUDED.d_modi, "d_ins" = EXCLUDED.d_ins;
DELETE FROM ora_replog999 WHERE "N_TABLE" = 'CL_ZVSPIS' AND "R_TABLE" = '%s';
END;
$$ LANGUAGE plpgsql;