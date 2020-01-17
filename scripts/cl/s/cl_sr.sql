DO $$
BEGIN
INSERT INTO
	cl_sr ("r", "c_client", "year", "month", "kol", "doc_typ", "doc_date", "doc_num", "p_modi", "d_modi")
SELECT "r", "c_client", "year", "month", "kol", "doc_typ", "doc_date", "doc_num", "p_modi", "d_modi"
FROM ora_cl_sr WHERE ora_cl_sr.r  = '%s'
ON CONFLICT ("r") DO UPDATE SET "c_client" = EXCLUDED.c_client, "year" = EXCLUDED.year, "month" = EXCLUDED.month, "kol" = EXCLUDED.kol, 
		"doc_typ" = EXCLUDED.doc_typ, "doc_date" = EXCLUDED.doc_date, "doc_num" = EXCLUDED.doc_num, "p_modi" = EXCLUDED.p_modi, "d_modi" = EXCLUDED.d_modi;
DELETE FROM ora_replog999 WHERE "N_TABLE" = 'CL_SR' AND "R_TABLE" = '%s';
END;
$$ LANGUAGE plpgsql;