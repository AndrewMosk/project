DO $$
BEGIN
--данные из ora_replog999 во временную таблицу - фиксирую строки на обмен с которыми буду работать во время сеанса
CREATE TEMP TABLE ora_replog_temp (LIKE ora_replog999);
INSERT INTO ora_replog_temp("N_TABLE", "R_TABLE", "OPER", "VER", "N_FIELD", "DELTA") 
SELECT * FROM ora_replog999 WHERE ora_replog999."N_TABLE" = 'S_ALG' AND ora_replog999."OPER" = 'S';
--вставляю новые строки, если такие уже созданы, то происходит апдейт 
INSERT INTO
	s_alg ("r", "reg_num", "nu_cod", "datb1", "date1", "proc1", "sumb1", "sums1", "datb2", "date2", "proc2", "sumb2", "sums2", "datb3", "date3", "proc3", "sumb3", 
		"sums3", "p_modi", "d_modi")
SELECT "r", "reg_num", "nu_cod", "datb1", "date1", "proc1", "sumb1", "sums1", "datb2", "date2", "proc2", "sumb2", "sums2", "datb3", "date3", "proc3", "sumb3", 
		"sums3", "p_modi", "d_modi"
FROM ora_s_alg WHERE ora_s_alg.r IN (SELECT ora_replog_temp."R_TABLE"::numeric FROM ora_replog_temp)
ON CONFLICT ("r") DO UPDATE SET "reg_num" = EXCLUDED.reg_num, "nu_cod" = EXCLUDED.nu_cod, "datb1" = EXCLUDED.datb1, "date1" = EXCLUDED.date1, "proc1" = EXCLUDED.proc1, 
		"sumb1" = EXCLUDED.sumb1, "sums1" = EXCLUDED.sums1,	"datb2" = EXCLUDED.datb2, "date2" = EXCLUDED.date2, "proc2" = EXCLUDED.proc2, "sumb2" = EXCLUDED.sumb2, 
		"sums2" = EXCLUDED.sums2, "datb3" = EXCLUDED.datb3, "date3" = EXCLUDED.date3, "proc3" = EXCLUDED.proc3, "sumb3" = EXCLUDED.sumb3, "sums3" = EXCLUDED.sums3,
		"p_modi" = EXCLUDED.p_modi, "d_modi" = EXCLUDED.d_modi;
--удаляю обработанные строки из оракл		
DELETE FROM ora_replog999 WHERE "N_TABLE" IN (SELECT ora_replog_temp."N_TABLE" FROM ora_replog_temp)
AND "R_TABLE" IN (SELECT ora_replog_temp."R_TABLE" FROM ora_replog_temp);
--удаляю временную таблицу 
DROP TABLE ora_replog_temp;
END;
$$ LANGUAGE plpgsql;