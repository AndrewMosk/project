DO $$
BEGIN
INSERT INTO
	s_svodu ("r", "cz_cod", "czu_cod", "godr", "mesr", "godv", "mesv", "period", "periodk", "nu_cod", "nun_cod", "sumu", "kolu", "p_modi", "d_modi")
SELECT "r", "cz_cod", "czu_cod", "godr", "mesr", "godv", "mesv", "period", "periodk", "nu_cod", "nun_cod", "sumu", "kolu", "p_modi", "d_modi"
FROM ora_s_svodu WHERE ora_s_svodu.r IN %s
ON CONFLICT ("r") DO UPDATE SET "cz_cod" = EXCLUDED.cz_cod, "czu_cod" = EXCLUDED.czu_cod, "godr" = EXCLUDED.godr, "mesr" = EXCLUDED.mesr, "godv" = EXCLUDED.godv, 
		"mesv" = EXCLUDED.mesv, "period" = EXCLUDED.period, "periodk" = EXCLUDED.periodk, "nu_cod" = EXCLUDED.nu_cod, "nun_cod" = EXCLUDED.nun_cod, 
		"sumu" = EXCLUDED.sumu, "kolu" = EXCLUDED.kolu, "p_modi" = EXCLUDED.p_modi, "d_modi" = EXCLUDED.d_modi;
--удаляю обработанные строки из оракл		
DELETE FROM ora_replog999 WHERE "N_TABLE" = 'S_SVODU' AND "R_TABLE" IN %s;
END;
$$ LANGUAGE plpgsql;