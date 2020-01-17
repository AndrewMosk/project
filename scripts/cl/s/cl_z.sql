DO $$
BEGIN
INSERT INTO
	cl_z ("r", "cz_cod", "c_client", "in_date", "ogrn", "year", "k_all", "k_prof_bak", "pos", "pos_date", "pos_num", "v_num", "p_modi", "d_modi", "d_ins")
SELECT "r", "org_cod" AS "cz_cod", "c_client", "in_date", "ogrn", "year", "k_all", "k_prof_bak", "pos", "pos_date", "pos_num", "v_num", "p_modi", "d_modi", 
		"v_date" AS"d_ins"
FROM ora_cl_z WHERE ora_cl_z.r  = '%s'
ON CONFLICT ("r") DO UPDATE SET "cz_cod" = EXCLUDED.cz_cod, "c_client" = EXCLUDED.c_client, "in_date" = EXCLUDED.in_date, "ogrn" = EXCLUDED.ogrn, 
		"year" = EXCLUDED.year, "k_all" = EXCLUDED.k_all, "k_prof_bak" = EXCLUDED.k_prof_bak, "pos" = EXCLUDED.pos, "pos_date" = EXCLUDED.pos_date, 
		"pos_num" = EXCLUDED.pos_num, "v_num" = EXCLUDED.v_num, "p_modi" = EXCLUDED.p_modi, "d_modi" = EXCLUDED.d_modi, "d_ins" = EXCLUDED.d_ins;
DELETE FROM ora_replog999 WHERE "N_TABLE" = 'CL_Z' AND "R_TABLE" = '%s';
END;
$$ LANGUAGE plpgsql;