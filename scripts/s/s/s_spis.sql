DO $$
BEGIN
--данные из ora_replog999 во временную таблицу - фиксирую строки на обмен с которыми буду работать во время сеанса
CREATE TEMP TABLE ora_replog_temp (LIKE ora_replog999);
INSERT INTO ora_replog_temp("N_TABLE", "R_TABLE", "OPER", "VER", "N_FIELD", "DELTA") 
SELECT * FROM ora_replog999 WHERE ora_replog999."N_TABLE" = 'S_SPIS' AND ora_replog999."OPER" = 'S';
--вставляю новые строки, если такие уже созданы, то происходит апдейт 
INSERT INTO
	s_spis ("sp_cod", "sp_form", "k_priz", "cz_cod", "nun_cod", "sumv", "kolv", "r_p", "period", "otd_cod", "fil_cod", "pbo_bank", "pp_cod", "pp_date", "p_modi", 
		"d_modi")
SELECT "sp_cod", "sp_form", "k_priz", "cz_cod", "nun_cod", "sumv", "kolv", "r_p", "period", "otd_cod", "fil_cod", "pbo_bank", "pp_cod", "pp_date", "p_modi", "d_modi"
FROM ora_s_spis WHERE ora_s_spis.sp_cod IN (SELECT ora_replog_temp."R_TABLE"::numeric FROM ora_replog_temp)
ON CONFLICT ("sp_cod") DO UPDATE SET "sp_form" = EXCLUDED.sp_form, "k_priz" = EXCLUDED.k_priz, "cz_cod" = EXCLUDED.cz_cod, "nun_cod" = EXCLUDED.nun_cod, 
		"sumv" = EXCLUDED.sumv, "kolv" = EXCLUDED.kolv, "r_p" = EXCLUDED.r_p, "period" = EXCLUDED.period, "otd_cod" = EXCLUDED.otd_cod, "fil_cod" = EXCLUDED.fil_cod, 
		"pbo_bank" = EXCLUDED.pbo_bank, "pp_cod" = EXCLUDED.pp_cod, "pp_date" = EXCLUDED.pp_date, "p_modi" = EXCLUDED.p_modi, "d_modi" = EXCLUDED.d_modi;
--удаляю обработанные строки из оракл		
DELETE FROM ora_replog999 WHERE "N_TABLE" IN (SELECT ora_replog_temp."N_TABLE" FROM ora_replog_temp)
AND "R_TABLE" IN (SELECT ora_replog_temp."R_TABLE" FROM ora_replog_temp);
--удаляю временную таблицу 
DROP TABLE ora_replog_temp;
END;
$$ LANGUAGE plpgsql;