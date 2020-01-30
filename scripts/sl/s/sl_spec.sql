DO $$
BEGIN
INSERT INTO
	sl_spec ("spec_cod", "spec_code", "spec_name", "bak", "up_cod", "pr")
SELECT "spec_cod", "spec_code", "spec_name", "bak", "up_cod", "pr"
FROM ora_sl_spec WHERE ora_sl_spec.spec_cod = '%s'
ON CONFLICT ("spec_cod") DO UPDATE SET "spec_code" = EXCLUDED.spec_code, "spec_name" = EXCLUDED.spec_name, "bak" = EXCLUDED.bak, "up_cod" = EXCLUDED.up_cod, 
		"pr" = EXCLUDED.pr;
--удаляю обработанные строки из оракл		
DELETE FROM ora_replog999 WHERE "N_TABLE" = 'SL_SPEC' AND "R_TABLE" = '%s';
END;
$$ LANGUAGE plpgsql;