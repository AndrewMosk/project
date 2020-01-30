DO $$
BEGIN
INSERT INTO
	sl_gud ("gud_cod", "gu_cod", "gud_code", "npp", "gud_name", "gud_lname", "docfile", "pr", "p_modi", "d_modi")
SELECT "gud_cod", "gu_cod", "gud_code", "npp", "gud_name", "gud_lname", "docfile", "pr", "p_modi", "d_modi"
FROM ora_sl_gud WHERE ora_sl_gud.gud_cod = '%s'
ON CONFLICT ("gud_cod") DO UPDATE SET "gud_cod" = EXCLUDED.gud_cod, "gu_cod" = EXCLUDED.gu_cod, "gud_code" = EXCLUDED.gud_code, "npp" = EXCLUDED.npp, 
		"gud_name" = EXCLUDED.gud_name, "gud_lname" = EXCLUDED.gud_lname, "docfile" = EXCLUDED.docfile, "pr" = EXCLUDED.pr, "p_modi" = EXCLUDED.p_modi, 
		"d_modi" = EXCLUDED.d_modi;
--удаляю обработанные строки из оракл		
DELETE FROM ora_replog999 WHERE "N_TABLE" = 'SL_GUD' AND "R_TABLE" = '%s';
END;
$$ LANGUAGE plpgsql;