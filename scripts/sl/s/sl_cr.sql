DO $$
BEGIN
INSERT INTO
	sl_cr ("cr_cod", "cr_name", "cr_n", "ena", "pr", "bak")
SELECT "cr_cod", "cr_name", "cr_n", "ena", "pr", "bak"
FROM ora_sl_cr WHERE ora_sl_cr.cr_cod = '%s'
ON CONFLICT ("cr_cod") DO UPDATE SET "cr_name" = EXCLUDED.cr_name, "cr_n" = EXCLUDED.cr_n, "ena" = EXCLUDED.ena, "pr" = EXCLUDED.pr, "bak" = EXCLUDED.bak;
--удаляю обработанные строки из оракл		
DELETE FROM ora_replog999 WHERE "N_TABLE" = 'SL_CR' AND "R_TABLE" = '%s';
END;
$$ LANGUAGE plpgsql;