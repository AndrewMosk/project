DO $$
BEGIN
INSERT INTO
	s_fpers ("pol_cod", "pol_name", "pol_names", "vid", "ind", "adres", "otd_cod", "fil_cod", "sch_num", "spis", "proc", "bak", "pr", "cz_cod", "p_modi", "d_modi")
SELECT "pol_cod", "pol_name", "pol_names", "vid", "ind", "adres", "otd_cod", "fil_cod", "sch_num", "spis", "proc", "bak", "pr", "cz_cod", "p_modi", "d_modi"
FROM ora_s_fpers WHERE ora_s_fpers.pol_cod IN %s
ON CONFLICT ("pol_cod") DO UPDATE SET "pol_name" = EXCLUDED.pol_name, "pol_names" = EXCLUDED.pol_names, "vid" = EXCLUDED.vid, "ind" = EXCLUDED.ind, 
		"adres" = EXCLUDED.adres, "otd_cod" = EXCLUDED.otd_cod, "fil_cod" = EXCLUDED.fil_cod, "sch_num" = EXCLUDED.sch_num, "spis" = EXCLUDED.spis, 
		"proc" = EXCLUDED.proc, "bak" = EXCLUDED.bak, "pr" = EXCLUDED.pr, "cz_cod" = EXCLUDED.cz_cod, "p_modi" = EXCLUDED.p_modi, "d_modi" = EXCLUDED.d_modi;
--удаляю обработанные строки из оракл		
DELETE FROM ora_replog999 WHERE "N_TABLE" = 'S_FPERS' AND "R_TABLE" IN %s;
END;
$$ LANGUAGE plpgsql;