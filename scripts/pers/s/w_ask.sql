DO $$
BEGIN
INSERT INTO
	pers_ask ("reg_num", "salary", "jchar_cod", "salf_cod", "jreg_cod", "c_client", "inter_v", "inter_yn", "tr_date", "inter_1", "inter_2", "inter_3", "inter_4", "tr_lg1", "tr_lg2", 
		"tr_lg3", "inter_p", "prizpall", "comm")
SELECT "reg_num", "salary", "jchar_cod", "salf_cod", "jreg_cod", "c_client", "inter_v", "inter_yn", "tr_date", "inter_1", "inter_2", "inter_3", "inter_4", "tr_lg1", "tr_lg2", 
		"tr_lg3", "inter_p", "prizpall", "comm"
FROM ora_w_ask WHERE ora_w_ask.reg_num = '%s'
ON CONFLICT ("reg_num") DO UPDATE SET salary = EXCLUDED.salary, jchar_cod = EXCLUDED.jchar_cod, salf_cod = EXCLUDED.salf_cod, jreg_cod = EXCLUDED.jreg_cod,  
		c_client = EXCLUDED.c_client, inter_v = EXCLUDED.inter_v, inter_yn = EXCLUDED.inter_yn, tr_date = EXCLUDED.tr_date, inter_1 = EXCLUDED.inter_1, inter_2 = EXCLUDED.inter_2, 
		inter_3 = EXCLUDED.inter_3, inter_4 = EXCLUDED.inter_4, tr_lg1 = EXCLUDED.tr_lg1, tr_lg2 = EXCLUDED.tr_lg2, tr_lg3 = EXCLUDED.tr_lg3, inter_p = EXCLUDED.inter_p, prizpall = EXCLUDED.prizpall, 
		comm = EXCLUDED.comm;
--удаляю обработанные строки из оракл		
DELETE FROM ora_replog999 WHERE "N_TABLE" = 'W_ASK' AND "R_TABLE" = '%s';
END;
$$ LANGUAGE plpgsql;