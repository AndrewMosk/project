DO $$
BEGIN
INSERT INTO
	s_svodn ("r", "cz_cod", "czu_cod", "godr", "mesr", "period", "periodk", "godv", "mesv", "nu_cod", "sumn", "sumsn", "sumd", "koln", "p_modi", "d_modi")
SELECT "r", "cz_cod", "czu_cod", "godr", "mesr", "period", "periodk", "godv", "mesv", "nu_cod", "sumn", "sumsn", "sumd", "koln", "p_modi", "d_modi"
FROM ora_s_svodn WHERE ora_s_svodn.r = '%s'
ON CONFLICT ("r") DO UPDATE SET "cz_cod" = EXCLUDED.cz_cod, "czu_cod" = EXCLUDED.czu_cod, "godr" = EXCLUDED.godr, "mesr" = EXCLUDED.mesr, "period" = EXCLUDED.period, 
		"periodk" = EXCLUDED.periodk, "godv" = EXCLUDED.godv, "mesv" = EXCLUDED.mesv, "nu_cod" = EXCLUDED.nu_cod, "sumn" = EXCLUDED.sumn, "sumsn" = EXCLUDED.sumsn, 
		"sumd" = EXCLUDED.sumd, "koln" = EXCLUDED.koln, "p_modi" = EXCLUDED.p_modi, "d_modi" = EXCLUDED.d_modi;
--удаляю обработанные строки из оракл		
DELETE FROM ora_replog999 WHERE "N_TABLE" = 'S_SVODN' AND "R_TABLE" = '%s';
END;
$$ LANGUAGE plpgsql;