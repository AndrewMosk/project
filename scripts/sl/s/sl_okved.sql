DO $$
BEGIN
INSERT INTO
	sl_okved ("r", "parent", "razdel", "shifr", "up", "name", "in_work", "out_work", "oknh", "pr", "d_modi", "p_modi")
SELECT "r", "parent", "razdel", "shifr", "up", "name", "in_work", "out_work", "oknh", "pr", "d_modi", "p_modi"
FROM ora_sl_okved WHERE ora_sl_okved.r = '%s'
ON CONFLICT ("r") DO UPDATE SET "parent" = EXCLUDED.parent, "razdel" = EXCLUDED.razdel, "shifr" = EXCLUDED.shifr, "up" = EXCLUDED.up, "name" = EXCLUDED.name, 
		"in_work" = EXCLUDED.in_work, "out_work" = EXCLUDED.out_work, "oknh" = EXCLUDED.oknh, "pr" = EXCLUDED.pr, "d_modi" = EXCLUDED.d_modi, "p_modi" = EXCLUDED.p_modi;
--удаляю обработанные строки из оракл		
DELETE FROM ora_replog999 WHERE "N_TABLE" = 'SL_OKVED' AND "R_TABLE" = '%s';
END;
$$ LANGUAGE plpgsql;