DO $$
BEGIN
INSERT INTO
	sl_pers ("pers_num", "pers_fam", "plc_cod", "ora_user", "os_user", "dlg_name", "rm_name", "tel", "email", "pr")
SELECT "pers_num", "pers_fam", "plc_cod", "ora_user", "os_user", "dlg_name", "rm_name", "tel", "email", "pr"
FROM ora_sl_pers WHERE ora_sl_pers.pers_num = '%s'
ON CONFLICT ("pers_num") DO UPDATE SET "pers_fam" = EXCLUDED.pers_fam, "plc_cod" = EXCLUDED.plc_cod, "ora_user" = EXCLUDED.ora_user, "os_user" = EXCLUDED.os_user, 
		"dlg_name" = EXCLUDED.dlg_name, "rm_name" = EXCLUDED.rm_name, "tel" = EXCLUDED.tel, "email" = EXCLUDED.email, "pr" = EXCLUDED.pr;
--удаляю обработанные строки из оракл		
DELETE FROM ora_replog999 WHERE "N_TABLE" = 'SL_PERS' AND "R_TABLE" = '%s';
END;
$$ LANGUAGE plpgsql;