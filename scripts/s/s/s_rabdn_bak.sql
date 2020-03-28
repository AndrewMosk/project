DO $$
BEGIN
INSERT INTO
	s_rabdn_bak ("r", "pr_num", "reg_num", "prot_num", "prot_date", "r_rk", "nu_cod", "proc_cod", "date_b", "date_e", "procm", "sumb", "poor", "p_modi", "d_modi", "poord", "p_alg", "p_ins", "d_ins")
SELECT "r", "pr_num", "reg_num", "prot_num", "prot_date", "r_rk", "nu_cod", "proc_cod", "date_b", "date_e", "procm", "sumb", "poor", "p_modi", "d_modi", "poord", "p_alg", 0 AS "p_ins", TO_TIMESTAMP('00000000','YYYYMMDD') AS "d_ins"
FROM ora_s_rabdn_bak WHERE ora_s_rabdn_bak.r IN %s
ON CONFLICT ("r") DO UPDATE SET "pr_num" = EXCLUDED.pr_num, "reg_num" = EXCLUDED.reg_num, "prot_num" = EXCLUDED.prot_num, "prot_date" = EXCLUDED.prot_date, 
		"r_rk" = EXCLUDED.r_rk, "nu_cod" = EXCLUDED.nu_cod, "proc_cod" = EXCLUDED.proc_cod, "date_b" = EXCLUDED.date_b, "date_e" = EXCLUDED.date_e, "procm" = EXCLUDED.procm, 
		"sumb" = EXCLUDED.sumb, "poor" = EXCLUDED.poor, "p_modi" = EXCLUDED.p_modi, "d_modi" = EXCLUDED.d_modi, "poord" = EXCLUDED.poord, "p_alg" = EXCLUDED.p_alg , "p_ins" = EXCLUDED.p_ins, "d_ins" = EXCLUDED.d_ins;
--удаляю обработанные строки из оракл		
DELETE FROM ora_replog999 WHERE "N_TABLE" = 'S_RABDN_BAK' AND "R_TABLE" IN %s;
END;
$$ LANGUAGE plpgsql;