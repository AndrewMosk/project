DO $$
BEGIN
--данные из ora_replog999 во временную таблицу - фиксирую строки на обмен с которыми буду работать во время сеанса
CREATE TEMP TABLE ora_replog_temp (LIKE ora_replog999);
INSERT INTO ora_replog_temp("N_TABLE", "R_TABLE", "OPER", "VER", "N_FIELD", "DELTA") 
SELECT * FROM ora_replog999 WHERE ora_replog999."N_TABLE" = 'S_DEP' AND ora_replog999."OPER" = 'S';
--вставляю новые строки, если такие уже созданы, то происходит апдейт 
INSERT INTO
	s_dep ("r", "reg_num", "sp_num", "spd_date", "r_pd", "godrd", "mesrd", "periodd", "spd_cod", "sp_cod", "sumd", "r_p", "period", "nun_cod", "pp_date", "cz_cod", 
		"p_modi", "d_modi")
SELECT "r", "reg_num", "sp_num", "spd_date", "r_pd", "godrd", "mesrd", "periodd", "spd_cod", "sp_cod", "sumd", "r_p", "period", "nun_cod", "pp_date", "cz_cod", 
		"p_modi", "d_modi"
FROM ora_s_dep WHERE ora_s_dep.r IN (SELECT ora_replog_temp."R_TABLE"::numeric FROM ora_replog_temp)
ON CONFLICT ("r") DO UPDATE SET "reg_num" = EXCLUDED.reg_num, "sp_num" = EXCLUDED.sp_num, "spd_date" = EXCLUDED.spd_date, "r_pd" = EXCLUDED.r_pd, 
		"godrd" = EXCLUDED.godrd, "mesrd" = EXCLUDED.mesrd, "periodd" = EXCLUDED.periodd, "spd_cod" = EXCLUDED.spd_cod, "sp_cod" = EXCLUDED.sp_cod, 
		"sumd" = EXCLUDED.sumd, "r_p" = EXCLUDED.r_p, "period" = EXCLUDED.period, "nun_cod" = EXCLUDED.nun_cod, "pp_date" = EXCLUDED.pp_date, 
		"cz_cod" = EXCLUDED.cz_cod, "p_modi" = EXCLUDED.p_modi, "d_modi" = EXCLUDED.d_modi;
--удаляю обработанные строки из оракл		
DELETE FROM ora_replog999 WHERE "N_TABLE" IN (SELECT ora_replog_temp."N_TABLE" FROM ora_replog_temp)
AND "R_TABLE" IN (SELECT ora_replog_temp."R_TABLE" FROM ora_replog_temp);
--удаляю временную таблицу 
DROP TABLE ora_replog_temp;
END;
$$ LANGUAGE plpgsql;