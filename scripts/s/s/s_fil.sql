DO $$
BEGIN
--данные из ora_replog999 во временную таблицу - фиксирую строки на обмен с которыми буду работать во время сеанса
CREATE TEMP TABLE ora_replog_temp (LIKE ora_replog999);
INSERT INTO ora_replog_temp("N_TABLE", "R_TABLE", "OPER", "VER", "N_FIELD", "DELTA") 
SELECT * FROM ora_replog999 WHERE ora_replog999."N_TABLE" = 'S_FIL' AND ora_replog999."OPER" = 'S';
--вставляю новые строки, если такие уже созданы, то происходит апдейт 
INSERT INTO
	s_fil ("otd_cod", "fil_cod", "fil_name", "adress", "bak", "pr", "p_modi", "d_modi")
SELECT "otd_cod", "fil_cod", "fil_name", "adress", "bak", "pr", "p_modi", "d_modi"
FROM ora_s_fil WHERE ora_s_fil.fil_cod IN (SELECT ora_replog_temp."R_TABLE"::numeric FROM ora_replog_temp)
ON CONFLICT ("fil_cod") DO UPDATE SET "otd_cod" = EXCLUDED.otd_cod, "fil_name" = EXCLUDED.fil_name, "adress" = EXCLUDED.adress, "bak" = EXCLUDED.bak, 
		"pr" = EXCLUDED.pr, "p_modi" = EXCLUDED.p_modi, "d_modi" = EXCLUDED.d_modi;
--удаляю обработанные строки из оракл		
DELETE FROM ora_replog999 WHERE "N_TABLE" IN (SELECT ora_replog_temp."N_TABLE" FROM ora_replog_temp)
AND "R_TABLE" IN (SELECT ora_replog_temp."R_TABLE" FROM ora_replog_temp);
--удаляю временную таблицу 
DROP TABLE ora_replog_temp;
END;
$$ LANGUAGE plpgsql;