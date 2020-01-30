DO $$
BEGIN
INSERT INTO
	sl_klzn ("klzn_cod", "klzn_name", "kn", "parent", "level1", "level2", "level3", "level4", "pr", "pr_in", "comm", "gr_in1", "gr_in2", "bak", "d_modi", "p_modi")
SELECT "klzn_cod", "klzn_name", "kn", "parent", "level1", "level2", "level3", "level4", "pr", "pr_in", "comm", "gr_in1", "gr_in2", "bak", "d_modi", "p_modi"
FROM ora_sl_klzn WHERE ora_sl_klzn.klzn_cod = '%s'
ON CONFLICT ("klzn_cod") DO UPDATE SET"klzn_name" = EXCLUDED.klzn_name, "kn" = EXCLUDED.kn, "parent" = EXCLUDED.parent, "level1" = EXCLUDED.level1, 
		"level2" = EXCLUDED.level2, "level3" = EXCLUDED.level3, "level4" = EXCLUDED.level4, "pr" = EXCLUDED.pr, "pr_in" = EXCLUDED.pr_in, "comm" = EXCLUDED.comm, 
		"gr_in1" = EXCLUDED.gr_in1, "gr_in2" = EXCLUDED.gr_in2, "bak" = EXCLUDED.bak, "d_modi" = EXCLUDED.d_modi, "p_modi" = EXCLUDED.p_modi;
--удаляю обработанные строки из оракл		
DELETE FROM ora_replog999 WHERE "N_TABLE" = 'SL_KLZN' AND "R_TABLE" = '%s';
END;
$$ LANGUAGE plpgsql;