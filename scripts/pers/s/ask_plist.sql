DO $$
BEGIN
INSERT INTO
	pers_ask_plist ("r", "reg_num", "prof_cod", "pd_cod", "prof_lev", "p_modi", "d_modi")
SELECT "r", ora_ask_plist.reg_num, ora_ask_plist.prof_cod, ora_ask_plist.pd_cod, ora_ask_plist.prof_lev, ora_ask_plist.p_modi, ora_ask_plist.d_modi
FROM ora_ask_plist WHERE ora_ask_plist.r = '%s' AND ora_ask_plist.prof_cod is not null
ON CONFLICT ("r") DO UPDATE SET "reg_num" = EXCLUDED.reg_num, "prof_cod" = EXCLUDED.prof_cod, "pd_cod" = EXCLUDED.pd_cod, "prof_lev" = EXCLUDED.prof_lev, 
		"p_modi" = EXCLUDED.p_modi, "d_modi" = EXCLUDED.d_modi;
--удаляю обработанные строки из оракл		
DELETE FROM ora_replog999 WHERE "N_TABLE" = 'ASK_PLIST' AND "R_TABLE" = '%s';
END;
$$ LANGUAGE plpgsql;