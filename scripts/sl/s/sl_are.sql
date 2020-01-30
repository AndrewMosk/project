DO $$
BEGIN
INSERT INTO
	sl_are ("are_cod", "are_code", "are_name", "are_names", "np", "pr", "rvr_txt", "p_modi", "d_modi")
SELECT "are_cod", "are_code", "are_name", "are_names", "np", "pr", "rvr_txt", "p_modi", "d_modi"
FROM ora_sl_are WHERE ora_sl_are.are_cod  = '%s'
ON CONFLICT ("are_cod") DO UPDATE SET "are_code" = EXCLUDED.are_code, "are_name" = EXCLUDED.are_name, "are_names" = EXCLUDED.are_names, "np" = EXCLUDED.np, 
		"pr" = EXCLUDED.pr, "rvr_txt" = EXCLUDED.rvr_txt, "p_modi" = EXCLUDED.p_modi, "d_modi" = EXCLUDED.d_modi;
--удаляю обработанные строки из оракл		
DELETE FROM ora_replog999 WHERE "N_TABLE" = 'SL_ARE' AND "R_TABLE" = '%s';
END;
$$ LANGUAGE plpgsql;