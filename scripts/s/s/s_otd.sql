DO $$
BEGIN
--данные из ora_replog999 во временную таблицу - фиксирую строки на обмен с которыми буду работать во время сеанса
CREATE TEMP TABLE ora_replog_temp (LIKE ora_replog999);
INSERT INTO ora_replog_temp("N_TABLE", "R_TABLE", "OPER", "VER", "N_FIELD", "DELTA") 
SELECT * FROM ora_replog999 WHERE ora_replog999."N_TABLE" = 'S_OTD' AND ora_replog999."OPER" = 'S';
--вставляю новые строки, если такие уже созданы, то происходит апдейт 
INSERT INTO
	s_otd ("otd_cod", "c_client", "c_bank", "sch_num", "plc_cod", "ind1", "ind2", "bak", "pr", "p_modi", "d_modi")
SELECT "otd_cod", "c_client", "c_bank", "sch_num", "plc_cod", "ind1", "ind2", "bak", "pr", "p_modi", "d_modi"
FROM ora_s_otd WHERE ora_s_otd.otd_cod IN (SELECT ora_replog_temp."R_TABLE"::numeric FROM ora_replog_temp)
ON CONFLICT ("otd_cod") DO UPDATE SET "c_client" = EXCLUDED.c_client, "c_bank" = EXCLUDED.c_bank, "sch_num" = EXCLUDED.sch_num, "plc_cod" = EXCLUDED.plc_cod, 
		"ind1" = EXCLUDED.ind1, "ind2" = EXCLUDED.ind2, "bak" = EXCLUDED.bak, "pr" = EXCLUDED.pr, "p_modi" = EXCLUDED.p_modi, "d_modi" = EXCLUDED.d_modi;
--удаляю обработанные строки из оракл		
DELETE FROM ora_replog999 WHERE "N_TABLE" IN (SELECT ora_replog_temp."N_TABLE" FROM ora_replog_temp)
AND "R_TABLE" IN (SELECT ora_replog_temp."R_TABLE" FROM ora_replog_temp);
--удаляю временную таблицу 
DROP TABLE ora_replog_temp;
END;
$$ LANGUAGE plpgsql;