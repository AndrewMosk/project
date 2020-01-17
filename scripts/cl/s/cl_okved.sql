DO $$
BEGIN
INSERT INTO
	cl_okved ("r", "c_client", "shifr", "p_modi", "d_modi")
SELECT "r", "c_client", "shifr", "pers_modi" AS "p_modi", "d_modi"
FROM ora_cl_okved WHERE ora_cl_okved.r  = '%s'
ON CONFLICT ("r") DO UPDATE SET "c_client" = EXCLUDED.c_client, "shifr" = EXCLUDED.shifr, "p_modi" = EXCLUDED.p_modi, "d_modi" = EXCLUDED.d_modi;
DELETE FROM ora_replog999 WHERE "N_TABLE" = 'CL_OKVED' AND "R_TABLE" = '%s';
END;
$$ LANGUAGE plpgsql;