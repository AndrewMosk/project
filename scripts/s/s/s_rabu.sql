DO $$
BEGIN
--данные из ora_replog999 во временную таблицу - фиксирую строки на обмен с которыми буду работать во время сеанса
CREATE TEMP TABLE ora_replog_temp (LIKE ora_replog999);
INSERT INTO ora_replog_temp("N_TABLE", "R_TABLE", "OPER", "VER", "N_FIELD", "DELTA") 
SELECT * FROM ora_replog999 WHERE ora_replog999."N_TABLE" = 'S_RABU' AND ora_replog999."OPER" = 'S';
--вставляю новые строки, если такие уже созданы, то происходит апдейт 
INSERT INTO
	s_rabu ("r", "reg_num", "nu_cod", "nun_cod", "godv", "mesv", "r_d", "doc_num", "dnid", "sumn", "proc", "sumu", "sumud", "dnid", "dnip", "sump", "sumk", "r_p", 
		"period", "pp_cod", "p_modi", "d_modi")
SELECT "r", "reg_num", "nu_cod", "nun_cod", "godv", "mesv", "r_d", "doc_num", "dnid", "sumn", "proc", "sumu", "sumud", "dnid", "dnip", "sump", "sumk", "r_p", 
		"period", "pp_cod", "p_modi", "d_modi"
FROM ora_s_rabu WHERE ora_s_rabu.r IN (SELECT ora_replog_temp."R_TABLE"::numeric FROM ora_replog_temp)
ON CONFLICT ("r") DO UPDATE SET "reg_num" = EXCLUDED.reg_num, "nu_cod" = EXCLUDED.nu_cod, "nun_cod" = EXCLUDED.nun_cod, "godv" = EXCLUDED.godv, 
		"mesv" = EXCLUDED.mesv, "r_d" = EXCLUDED.r_d, "doc_num" = EXCLUDED.doc_num, "dnid" = EXCLUDED.dnid, "sumn" = EXCLUDED.sumn, "proc" = EXCLUDED.proc, 
		"sumu" = EXCLUDED.sumu, "sumud" = EXCLUDED.sumud, "dnid" = EXCLUDED.dnid, "dnip" = EXCLUDED.dnip, "sump" = EXCLUDED.sump, "sumk" = EXCLUDED.sumk, 
		"r_p" = EXCLUDED.r_p, "period" = EXCLUDED.period, "pp_cod" = EXCLUDED.pp_cod, "p_modi" = EXCLUDED.p_modi, "d_modi" = EXCLUDED.d_modi;
--удаляю обработанные строки из оракл		
DELETE FROM ora_replog999 WHERE "N_TABLE" IN (SELECT ora_replog_temp."N_TABLE" FROM ora_replog_temp)
AND "R_TABLE" IN (SELECT ora_replog_temp."R_TABLE" FROM ora_replog_temp);
--удаляю временную таблицу 
DROP TABLE ora_replog_temp;
END;
$$ LANGUAGE plpgsql;