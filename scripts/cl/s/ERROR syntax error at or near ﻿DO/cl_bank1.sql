DO $$
BEGIN
INSERT INTO
	cl_bank ("r", "c_client", "bnk_code", "bnk_acc", "bnk_sub", "d_open", "d_close", "tp_acc", "b_registr", "p_modi", "d_modi")
SELECT "r", "c_client", "bnk_code", "bnk_acc", "bnk_sub", "d_open", "d_close", "tp_acc", "b_registr", "pers_modi" AS "p_modi", "d_modi"
FROM ora_cl_bank WHERE ora_cl_bank.r  = '%s'
ON CONFLICT ("r") DO UPDATE SET "c_client" = EXCLUDED.c_client, "bnk_code" = EXCLUDED.bnk_code, "bnk_acc" = EXCLUDED.bnk_acc, "bnk_sub" = EXCLUDED.bnk_sub, 
		"d_open" = EXCLUDED.d_open, "d_close" = EXCLUDED.d_close, "tp_acc" = EXCLUDED.tp_acc, "b_registr" = EXCLUDED.b_registr, "p_modi" = EXCLUDED.p_modi, 
		"d_modi" = EXCLUDED.d_modi;
DELETE FROM ora_replog999 WHERE "N_TABLE" = 'CL_BANK' AND "R_TABLE" = '%s';
END;
$$ LANGUAGE plpgsql;