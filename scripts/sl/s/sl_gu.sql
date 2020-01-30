DO $$
BEGIN
INSERT INTO
	sl_gu ("gu_cod", "gu_code", "npp", "gu_name", "gu_lname", "pr", "p_modi", "d_modi")
SELECT "gu_cod", "gu_code", "npp", "gu_name", "gu_lname", "pr", "p_modi", "d_modi"
FROM ora_sl_gu WHERE ora_sl_gu.gu_cod = '%s'
ON CONFLICT ("gu_cod") DO UPDATE SET "gu_cod" = EXCLUDED.gu_cod, "gu_code" = EXCLUDED.gu_code, "npp" = EXCLUDED.npp, "gu_name" = EXCLUDED.gu_name, 
		"gu_lname" = EXCLUDED.gu_lname, "pr" = EXCLUDED.pr, "p_modi" = EXCLUDED.p_modi, "d_modi" = EXCLUDED.d_modi;
--удаляю обработанные строки из оракл		
DELETE FROM ora_replog999 WHERE "N_TABLE" = 'SL_GU' AND "R_TABLE" = '%s';
END;
$$ LANGUAGE plpgsql;