DO $$
BEGIN
--данные из ora_replog999 во временную таблицу - фиксирую строки на обмен с которыми буду работать во время сеанса
CREATE TEMP TABLE ora_replog_temp (LIKE ora_replog999);
INSERT INTO ora_replog_temp("N_TABLE", "R_TABLE", "OPER", "VER", "N_FIELD", "DELTA") 
SELECT * FROM ora_replog999 WHERE ora_replog999."N_TABLE" = 'S_RABDN' AND ora_replog999."OPER" = 'S';
--вставляю новые строки, если такие уже созданы, то происходит апдейт 
INSERT INTO
	s_rabdn ("r", "reg_num", "prot_num", "prot_date", "r_rk", "nu_cod", "proc_cod", "date_b", "date_e", "procm", "sumb", "poor", "poord", "p_alg", "p_modi", "d_modi")
SELECT "r", "reg_num", "prot_num", "prot_date", "r_rk", "nu_cod", "proc_cod", "date_b", "date_e", "procm", "sumb", "poor", "poord", "p_alg", "p_modi", "d_modi"
FROM ora_s_rabdn WHERE ora_s_rabdn.r IN (SELECT ora_replog_temp."R_TABLE"::numeric FROM ora_replog_temp)
ON CONFLICT ("r") DO UPDATE SET "reg_num" = EXCLUDED.reg_num, "prot_num" = EXCLUDED.prot_num, "prot_date" = EXCLUDED.prot_date, "r_rk" = EXCLUDED.r_rk, 
		"nu_cod" = EXCLUDED.nu_cod, "proc_cod" = EXCLUDED.proc_cod, "date_b" = EXCLUDED.date_b, "date_e" = EXCLUDED.date_e, "procm" = EXCLUDED.procm, 
		"sumb" = EXCLUDED.sumb, "poor" = EXCLUDED.poor, "poord" = EXCLUDED.poord, "p_alg" = EXCLUDED.p_alg, "p_modi" = EXCLUDED.p_modi, "d_modi" = EXCLUDED.d_modi;
--удаляю обработанные строки из оракл		
DELETE FROM ora_replog999 WHERE "N_TABLE" IN (SELECT ora_replog_temp."N_TABLE" FROM ora_replog_temp)
AND "R_TABLE" IN (SELECT ora_replog_temp."R_TABLE" FROM ora_replog_temp);
--удаляю временную таблицу 
DROP TABLE ora_replog_temp;
END;
$$ LANGUAGE plpgsql;