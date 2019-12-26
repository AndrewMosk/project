DO $$
BEGIN
INSERT INTO
	vac_history ("r", "vac_num", "acs_date", "acs_cod", "cod_cond_a", "cod_cond_b", "reg_num", "c_contact", "cz_cod", "cont_comm", "p_modi", "d_modi")
SELECT "r", "vac_num", "acs_date", "acs_cod", "cod_cond_a", "cod_cond_b", "reg_num", "c_contact", "cz_cod", "cont_comm", "p_modi", "d_modi"
FROM ora_vac_history WHERE ora_vac_history.r = '%s'
ON CONFLICT ("r") DO UPDATE SET "vac_num" = EXCLUDED.vac_num, "acs_date" = EXCLUDED.acs_date, "acs_cod" = EXCLUDED.acs_cod, "cod_cond_a" = EXCLUDED.cod_cond_a, 
		"cod_cond_b" = EXCLUDED.cod_cond_b, "reg_num" = EXCLUDED.reg_num, "c_contact" = EXCLUDED.c_contact, "cz_cod" = EXCLUDED.cz_cod, "cont_comm" = EXCLUDED.cont_comm, 
		"p_modi" = EXCLUDED.p_modi, "d_modi" = EXCLUDED.d_modi;
--удаляю обработанные строки из оракл		
DELETE FROM ora_replog999 WHERE "N_TABLE" = 'VAC_HISTORY' AND "R_TABLE" = '%s';
END;
$$ LANGUAGE plpgsql;