DO $$
BEGIN
INSERT INTO
	sl_rez ("rez_cod", "npp", "rez_reg", "rez_name", "pvvod", "bak", "pr", "rez_code", "rez_eais", "p_1", "p_2", "p_3", "p_4", "p_5", "p_6", "d_1", "d_2", "d_3", "d_4",
		"d_5", "p_modi", "d_modi")
SELECT "rez_cod", "npp", "rez_reg", "rez_name", "pvvod", "bak", "pr", "rez_code", "rez_eais", "p_1", "p_2", "p_3", "p_4", "p_5", "p_6", "d_1", "d_2", "d_3", "d_4",
		"d_5", "p_modi", "d_modi"
FROM ora_sl_rez WHERE ora_sl_rez.rez_cod = '%s'
ON CONFLICT ("rez_cod") DO UPDATE SET "npp" = EXCLUDED.npp, "rez_reg" = EXCLUDED.rez_reg, "rez_name" = EXCLUDED.rez_name, "pvvod" = EXCLUDED.pvvod, "bak" = EXCLUDED.bak, 
		"pr" = EXCLUDED.pr, "rez_code" = EXCLUDED.rez_code, "rez_eais" = EXCLUDED.rez_eais, "p_1" = EXCLUDED.p_1, "p_2" = EXCLUDED.p_2, "p_3" = EXCLUDED.p_3, 
		"p_4" = EXCLUDED.p_4, "p_5" = EXCLUDED.p_5, "p_6" = EXCLUDED.p_6, "d_1" = EXCLUDED.d_1, "d_2" = EXCLUDED.d_2, "d_3" = EXCLUDED.d_3, "d_4" = EXCLUDED.d_4, 
		"d_5" = EXCLUDED.d_5, "p_modi" = EXCLUDED.p_modi, "d_modi" = EXCLUDED.d_modi;
--удаляю обработанные строки из оракл		
DELETE FROM ora_replog999 WHERE "N_TABLE" = 'SL_REZ' AND "R_TABLE" = '%s';
END;
$$ LANGUAGE plpgsql;