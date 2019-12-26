DO $$
BEGIN
--данные из ora_replog999 во временную таблицу - фиксирую строки на обмен с которыми буду работать во время сеанса
CREATE TEMP TABLE ora_replog_temp (LIKE ora_replog999);
INSERT INTO ora_replog_temp("N_TABLE", "R_TABLE", "OPER", "VER", "N_FIELD", "DELTA") 
SELECT * FROM ora_replog999 WHERE ora_replog999."N_TABLE" = 'S_PERIOD' AND ora_replog999."OPER" = 'S';
--вставляю новые строки, если такие уже созданы, то происходит апдейт 
INSERT INTO
	s_period ("r_p", "period", "periodk", "cz_cod", "date_b", "date_e", "d_oper", "p_modi", "d_modi")
SELECT "r_p", "period", "periodk", "cz_cod", "date_b", "date_e", "d_oper", "p_modi", "d_modi"
FROM ora_s_period WHERE ora_s_period.r_p IN (SELECT ora_replog_temp."R_TABLE"::numeric FROM ora_replog_temp)
ON CONFLICT ("r_p") DO UPDATE SET "period" = EXCLUDED.period, "periodk" = EXCLUDED.periodk, "cz_cod" = EXCLUDED.cz_cod, "date_b" = EXCLUDED.date_b, 
		"date_e" = EXCLUDED.date_e, "d_oper" = EXCLUDED.d_oper, "p_modi" = EXCLUDED.p_modi, "d_modi" = EXCLUDED.d_modi;
--удаляю обработанные строки из оракл		
DELETE FROM ora_replog999 WHERE "N_TABLE" IN (SELECT ora_replog_temp."N_TABLE" FROM ora_replog_temp)
AND "R_TABLE" IN (SELECT ora_replog_temp."R_TABLE" FROM ora_replog_temp);
--удаляю временную таблицу 
DROP TABLE ora_replog_temp;
END;
$$ LANGUAGE plpgsql;