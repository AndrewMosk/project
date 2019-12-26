DO $$
BEGIN
--данные из ora_replog999 во временную таблицу - фиксирую строки на обмен с которыми буду работать во время сеанса
CREATE TEMP TABLE ora_replog_temp (LIKE ora_replog999);
INSERT INTO ora_replog_temp("N_TABLE", "R_TABLE", "OPER", "VER", "N_FIELD", "DELTA") 
SELECT * FROM ora_replog999 WHERE ora_replog999."N_TABLE" = 'S_PPS' AND ora_replog999."OPER" = 'S';
--вставляю новые строки, если такие уже созданы, то происходит апдейт 
INSERT INTO
	s_pps ("r", "pp_cod", "pp_date", "plc_cod", "otd_cod", "sumv", "sumd", "kolv", "kold", "summ", "kolm", "sumbs", "godr", "mesr", "period", "periodk", "sp_num", 
		"pp_parent", "p_modi", "d_modi")
SELECT "r", "pp_cod", "pp_date", "plc_cod", "otd_cod", "sumv", "sumd", "kolv", "kold", "summ", "kolm", "sumbs", "godr", "mesr", "period", "periodk", "sp_num", 
		"pp_parent", "p_modi", "d_modi"
FROM ora_s_pps WHERE ora_s_pps.r IN (SELECT ora_replog_temp."R_TABLE"::numeric FROM ora_replog_temp)
ON CONFLICT ("r") DO UPDATE SET "pp_cod" = EXCLUDED.pp_cod, "pp_date" = EXCLUDED.pp_date, "plc_cod" = EXCLUDED.plc_cod, "otd_cod" = EXCLUDED.otd_cod, 
		"sumv" = EXCLUDED.sumv, "sumd" = EXCLUDED.sumd, "kolv" = EXCLUDED.kolv, "kold" = EXCLUDED.kold, "summ" = EXCLUDED.summ, 
		"kolm" = EXCLUDED.kolm, "sumbs" = EXCLUDED.sumbs, "godr" = EXCLUDED.godr, "mesr" = EXCLUDED.mesr, "period" = EXCLUDED.period, 
		"periodk" = EXCLUDED.periodk, "sp_num" = EXCLUDED.sp_num, "pp_parent" = EXCLUDED.pp_parent, "p_modi" = EXCLUDED.p_modi, "d_modi" = EXCLUDED.d_modi;
--удаляю обработанные строки из оракл		
DELETE FROM ora_replog999 WHERE "N_TABLE" IN (SELECT ora_replog_temp."N_TABLE" FROM ora_replog_temp)
AND "R_TABLE" IN (SELECT ora_replog_temp."R_TABLE" FROM ora_replog_temp);
--удаляю временную таблицу 
DROP TABLE ora_replog_temp;
END;
$$ LANGUAGE plpgsql;
