DO $$
BEGIN
--данные из ora_replog999 во временную таблицу - фиксирую строки на обмен с которыми буду работать во время сеанса
CREATE TEMP TABLE ora_replog_temp (LIKE ora_replog999);
INSERT INTO ora_replog_temp("N_TABLE", "R_TABLE", "OPER", "VER", "N_FIELD", "DELTA") 
SELECT * FROM ora_replog999 WHERE ora_replog999."N_TABLE" = 'S_VOZV' AND ora_replog999."OPER" = 'S';
--вставляю новые строки, если такие уже созданы, то происходит апдейт 
INSERT INTO
	s_vozv ("r", "reg_num", "r_p", "nu_cod", "v_cod", "v_doc", "v_date", "v_sum", "p_modi", "d_modi")
SELECT "r", "reg_num", "r_p", "nu_cod", "v_cod", "v_doc", "v_date", "v_sum", "p_modi", "d_modi"
FROM ora_s_vozv WHERE ora_s_vozv.r IN (SELECT ora_replog_temp."R_TABLE"::numeric FROM ora_replog_temp)
ON CONFLICT ("r") DO UPDATE SET "reg_num" = EXCLUDED.reg_num, "r_p" = EXCLUDED.r_p, "nu_cod" = EXCLUDED.nu_cod, "v_cod" = EXCLUDED.v_cod, "v_doc" = EXCLUDED.v_doc, 
		"v_date" = EXCLUDED.v_date, "v_sum" = EXCLUDED.v_sum, "p_modi" = EXCLUDED.p_modi, "d_modi" = EXCLUDED.d_modi;
--удаляю обработанные строки из оракл		
DELETE FROM ora_replog999 WHERE "N_TABLE" IN (SELECT ora_replog_temp."N_TABLE" FROM ora_replog_temp)
AND "R_TABLE" IN (SELECT ora_replog_temp."R_TABLE" FROM ora_replog_temp);
--удаляю временную таблицу 
DROP TABLE ora_replog_temp;
END;
$$ LANGUAGE plpgsql;