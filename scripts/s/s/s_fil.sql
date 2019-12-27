DO $$
BEGIN
INSERT INTO
	s_fil ("otd_cod", "fil_cod", "fil_name", "adress", "bak", "pr", "p_modi", "d_modi")
SELECT "otd_cod", "fil_cod", "fil_name", "adress", "bak", "pr", "p_modi", "d_modi"
FROM ora_s_fil WHERE ora_s_fil.fil_cod = '%s'
ON CONFLICT ("fil_cod") DO UPDATE SET "otd_cod" = EXCLUDED.otd_cod, "fil_name" = EXCLUDED.fil_name, "adress" = EXCLUDED.adress, "bak" = EXCLUDED.bak, 
		"pr" = EXCLUDED.pr, "p_modi" = EXCLUDED.p_modi, "d_modi" = EXCLUDED.d_modi;
--удаляю обработанные строки из оракл		
DELETE FROM ora_replog999 WHERE "N_TABLE" = 'S_FIL' AND "R_TABLE" = '%s';
END;
$$ LANGUAGE plpgsql;