DO $$
BEGIN
--данные из ora_replog999 во временную таблицу - фиксирую строки на обмен с которыми буду работать во время сеанса
CREATE TEMP TABLE ora_replog_temp (LIKE ora_replog999);
INSERT INTO ora_replog_temp("N_TABLE", "R_TABLE", "OPER", "VER", "N_FIELD", "DELTA") 
SELECT * FROM ora_replog999 WHERE ora_replog999."N_TABLE" = 'S_SVODU' AND ora_replog999."OPER" = 'S';
--вставляю новые строки, если такие уже созданы, то происходит апдейт 
INSERT INTO
	s_svodu ("r", "cz_cod", "czu_cod", "godr", "mesr", "godv", "mesv", "period", "periodk", "nu_cod", "nun_cod", "sumu", "kolu", "p_modi", "d_modi")
SELECT "r", "cz_cod", "czu_cod", "godr", "mesr", "godv", "mesv", "period", "periodk", "nu_cod", "nun_cod", "sumu", "kolu", "p_modi", "d_modi"
FROM ora_s_svodu WHERE ora_s_svodu.r IN (SELECT ora_replog_temp."R_TABLE"::numeric FROM ora_replog_temp)
ON CONFLICT ("r") DO UPDATE SET "cz_cod" = EXCLUDED.cz_cod, "czu_cod" = EXCLUDED.czu_cod, "godr" = EXCLUDED.godr, "mesr" = EXCLUDED.mesr, "godv" = EXCLUDED.godv, 
		"mesv" = EXCLUDED.mesv, "period" = EXCLUDED.period, "periodk" = EXCLUDED.periodk, "nu_cod" = EXCLUDED.nu_cod, "nun_cod" = EXCLUDED.nun_cod, 
		"sumu" = EXCLUDED.sumu, "kolu" = EXCLUDED.kolu, "p_modi" = EXCLUDED.p_modi, "d_modi" = EXCLUDED.d_modi;
--удаляю обработанные строки из оракл		
DELETE FROM ora_replog999 WHERE "N_TABLE" IN (SELECT ora_replog_temp."N_TABLE" FROM ora_replog_temp)
AND "R_TABLE" IN (SELECT ora_replog_temp."R_TABLE" FROM ora_replog_temp);
--удаляю временную таблицу 
DROP TABLE ora_replog_temp;
END;
$$ LANGUAGE plpgsql;