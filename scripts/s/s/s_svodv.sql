DO $$
BEGIN
INSERT INTO
	s_svodv ("r", "cz_cod", "czu_cod", "godr", "mesr", "period", "periodk", "nu_cod", "nun_cod", "sumv", "kolv", "p_modi", "d_modi")
SELECT "r", "cz_cod", "czu_cod", "godr", "mesr", "period", "periodk", "nu_cod", "nun_cod", "sumv", "kolv", "p_modi", "d_modi"
FROM ora_s_svodv WHERE ora_s_svodv.r IN %s
ON CONFLICT ("r") DO UPDATE SET "cz_cod" = EXCLUDED.cz_cod, "czu_cod" = EXCLUDED.czu_cod, "godr" = EXCLUDED.godr, "mesr" = EXCLUDED.mesr, "period" = EXCLUDED.period, 
		"periodk" = EXCLUDED.periodk, "nu_cod" = EXCLUDED.nu_cod, "nun_cod" = EXCLUDED.nun_cod, "sumv" = EXCLUDED.sumv, "kolv" = EXCLUDED.kolv, 
		"p_modi" = EXCLUDED.p_modi, "d_modi" = EXCLUDED.d_modi;
--удаляю обработанные строки из оракл		
DELETE FROM ora_replog999 WHERE "N_TABLE" = 'S_SVODV' AND "R_TABLE" IN %s;
END;
$$ LANGUAGE plpgsql;