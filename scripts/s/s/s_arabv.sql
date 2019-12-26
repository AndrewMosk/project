DO $$
BEGIN
--данные из ora_replog999 во временную таблицу - фиксирую строки на обмен с которыми буду работать во время сеанса
CREATE TEMP TABLE ora_replog_temp (LIKE ora_replog999);
INSERT INTO ora_replog_temp("N_TABLE", "R_TABLE", "OPER", "VER", "N_FIELD", "DELTA") 
SELECT * FROM ora_replog999 WHERE ora_replog999."N_TABLE" = 'S_ARABV' AND ora_replog999."OPER" = 'S';
--вставляю новые строки, если такие уже созданы, то происходит апдейт 
INSERT INTO
	s_arabv ("r", "reg_num", "sumv", "nu_cod", "nun_cod", "sp_cod", "pp_date", "godr", "mesr", "period", "r_p", "p_modi", "d_modi")
SELECT "r", "reg_num", "sumv", "nu_cod", "nun_cod", "sp_cod", "pp_date", "godr", "mesr", "period", "r_p", "p_modi", "d_modi"
FROM ora_s_arabv WHERE ora_s_arabv.r IN (SELECT ora_replog_temp."R_TABLE"::numeric FROM ora_replog_temp)
ON CONFLICT ("r") DO UPDATE SET "reg_num" = EXCLUDED.reg_num, "sumv" = EXCLUDED.sumv, "nu_cod" = EXCLUDED.nu_cod, "nun_cod" = EXCLUDED.nun_cod, 
		"sp_cod" = EXCLUDED.sp_cod, "pp_date" = EXCLUDED.pp_date, "godr" = EXCLUDED.godr, "mesr" = EXCLUDED.mesr, "period" = EXCLUDED.period, "r_p" = EXCLUDED.r_p, 
		"p_modi" = EXCLUDED.p_modi, "d_modi" = EXCLUDED.d_modi;
--удаляю обработанные строки из оракл		
DELETE FROM ora_replog999 WHERE "N_TABLE" IN (SELECT ora_replog_temp."N_TABLE" FROM ora_replog_temp)
AND "R_TABLE" IN (SELECT ora_replog_temp."R_TABLE" FROM ora_replog_temp);
--удаляю временную таблицу 
DROP TABLE ora_replog_temp;
END;
$$ LANGUAGE plpgsql;