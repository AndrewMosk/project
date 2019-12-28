DO $$
BEGIN
INSERT INTO
	s_rabdn ("r", "reg_num", "prot_num", "prot_date", "r_rk", "nu_cod", "proc_cod", "date_b", "date_e", "procm", "sumb", "poor", "poord", "p_alg", "p_modi", "d_modi")
SELECT "r", "reg_num", "prot_num", "prot_date", "r_rk", "nu_cod", "proc_cod", "date_b", "date_e", "procm", "sumb", "poor", "poord", "p_alg", "p_modi", "d_modi"
FROM ora_s_rabdn WHERE ora_s_rabdn.r IN %s
ON CONFLICT ("r") DO UPDATE SET "reg_num" = EXCLUDED.reg_num, "prot_num" = EXCLUDED.prot_num, "prot_date" = EXCLUDED.prot_date, "r_rk" = EXCLUDED.r_rk, 
		"nu_cod" = EXCLUDED.nu_cod, "proc_cod" = EXCLUDED.proc_cod, "date_b" = EXCLUDED.date_b, "date_e" = EXCLUDED.date_e, "procm" = EXCLUDED.procm, 
		"sumb" = EXCLUDED.sumb, "poor" = EXCLUDED.poor, "poord" = EXCLUDED.poord, "p_alg" = EXCLUDED.p_alg, "p_modi" = EXCLUDED.p_modi, "d_modi" = EXCLUDED.d_modi;
--удаляю обработанные строки из оракл		
DELETE FROM ora_replog999 WHERE "N_TABLE" = 'S_RABDN' AND "R_TABLE" IN %s;
END;
$$ LANGUAGE plpgsql;