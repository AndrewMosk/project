DO $$
BEGIN
INSERT INTO
	s_spnu ("nu_cod", "nu_name", "pr", "pol_cod", "cod_l")
SELECT "nu_cod", "nu_name", "pr", "pol_cod", "cod_l"
FROM ora_s_spnu WHERE ora_s_spnu.nu_cod IN %s
ON CONFLICT ("nu_cod") DO UPDATE SET "nu_name" = EXCLUDED.nu_name, "pr" = EXCLUDED.pr, "pol_cod" = EXCLUDED.pol_cod, "cod_l" = EXCLUDED.cod_l;
--удаляю обработанные строки из оракл		
DELETE FROM ora_replog999 WHERE "N_TABLE" = 'S_SPNU' AND "R_TABLE" IN %s;
END;
$$ LANGUAGE plpgsql;