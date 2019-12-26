DO $$
BEGIN
--данные из ora_replog999 во временную таблицу - фиксирую строки на обмен с которыми буду работать во время сеанса
CREATE TEMP TABLE ora_replog_temp (LIKE ora_replog999);
INSERT INTO ora_replog_temp("N_TABLE", "R_TABLE", "OPER", "VER", "N_FIELD", "DELTA") 
SELECT * FROM ora_replog999 WHERE ora_replog999."N_TABLE" = 'S_RABDU' AND ora_replog999."OPER" = 'S';
--вставляю новые строки, если такие уже созданы, то происходит апдейт 
INSERT INTO
	s_rabdu ("r", "reg_num", "nu_cod", "doc_num", "priz_pol", "c_client", "pol_cod", "c_bank", "sch_num", "date_b", "date_e", "dnid", "sumd", "dnip", "sump", "procu", 
		"procmax", "sumu", "doc_type", "doc_pl", "doc_date", "ost", "doc_comm", "p_modi", "d_modi")
SELECT "r", "reg_num", "nu_cod", "doc_num", "priz_pol", "c_client", "pol_cod", "c_bank", "sch_num", "date_b", "date_e", "dnid", "sumd", "dnip", "sump", "procu", 
		"procmax", "sumu", "doc_type", "doc_pl", "doc_date", "ost", "doc_comm", "p_modi", "d_modi"
FROM ora_s_rabdu WHERE ora_s_rabdu.r IN (SELECT ora_replog_temp."R_TABLE"::numeric FROM ora_replog_temp)
ON CONFLICT ("r") DO UPDATE SET "reg_num" = EXCLUDED.reg_num, "nu_cod" = EXCLUDED.nu_cod, "doc_num" = EXCLUDED.doc_num, "priz_pol" = EXCLUDED.priz_pol, 
		"c_client" = EXCLUDED.c_client, "pol_cod" = EXCLUDED.pol_cod, "c_bank" = EXCLUDED.c_bank, "sch_num" = EXCLUDED.sch_num, "date_b" = EXCLUDED.date_b, 
		"date_e" = EXCLUDED.date_e, "dnid" = EXCLUDED.dnid, "sumd" = EXCLUDED.sumd, "dnip" = EXCLUDED.dnip, "sump" = EXCLUDED.sump, "procu" = EXCLUDED.procu, 
		"procmax" = EXCLUDED.procmax, "sumu" = EXCLUDED.sumu, "doc_type" = EXCLUDED.doc_type, "doc_pl" = EXCLUDED.doc_pl, "doc_date" = EXCLUDED.doc_date, 
		"ost" = EXCLUDED.ost, "doc_comm" = EXCLUDED.doc_comm, "p_modi" = EXCLUDED.p_modi, "d_modi" = EXCLUDED.d_modi;
--удаляю обработанные строки из оракл		
DELETE FROM ora_replog999 WHERE "N_TABLE" IN (SELECT ora_replog_temp."N_TABLE" FROM ora_replog_temp)
AND "R_TABLE" IN (SELECT ora_replog_temp."R_TABLE" FROM ora_replog_temp);
--удаляю временную таблицу 
DROP TABLE ora_replog_temp;
END;
$$ LANGUAGE plpgsql;