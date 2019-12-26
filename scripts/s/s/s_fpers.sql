DO $$
BEGIN
--данные из ora_replog999 во временную таблицу - фиксирую строки на обмен с которыми буду работать во время сеанса
CREATE TEMP TABLE ora_replog_temp (LIKE ora_replog999);
INSERT INTO ora_replog_temp("N_TABLE", "R_TABLE", "OPER", "VER", "N_FIELD", "DELTA") 
SELECT * FROM ora_replog999 WHERE ora_replog999."N_TABLE" = 'S_FPERS' AND ora_replog999."OPER" = 'S';
--вставляю новые строки, если такие уже созданы, то происходит апдейт 
INSERT INTO
	s_fpers ("pol_cod", "pol_name", "pol_names", "vid", "ind", "adres", "otd_cod", "fil_cod", "sch_num", "spis", "proc", "bak", "pr", "cz_cod", "p_modi", "d_modi")
SELECT "pol_cod", "pol_name", "pol_names", "vid", "ind", "adres", "otd_cod", "fil_cod", "sch_num", "spis", "proc", "bak", "pr", "cz_cod", "p_modi", "d_modi"
FROM ora_s_fpers WHERE ora_s_fpers.pol_cod IN (SELECT ora_replog_temp."R_TABLE"::numeric FROM ora_replog_temp)
ON CONFLICT ("pol_cod") DO UPDATE SET "pol_name" = EXCLUDED.pol_name, "pol_names" = EXCLUDED.pol_names, "vid" = EXCLUDED.vid, "ind" = EXCLUDED.ind, 
		"adres" = EXCLUDED.adres, "otd_cod" = EXCLUDED.otd_cod, "fil_cod" = EXCLUDED.fil_cod, "sch_num" = EXCLUDED.sch_num, "spis" = EXCLUDED.spis, 
		"proc" = EXCLUDED.proc, "bak" = EXCLUDED.bak, "pr" = EXCLUDED.pr, "cz_cod" = EXCLUDED.cz_cod, "p_modi" = EXCLUDED.p_modi, "d_modi" = EXCLUDED.d_modi;
--удаляю обработанные строки из оракл		
DELETE FROM ora_replog999 WHERE "N_TABLE" IN (SELECT ora_replog_temp."N_TABLE" FROM ora_replog_temp)
AND "R_TABLE" IN (SELECT ora_replog_temp."R_TABLE" FROM ora_replog_temp);
--удаляю временную таблицу 
DROP TABLE ora_replog_temp;
END;
$$ LANGUAGE plpgsql;