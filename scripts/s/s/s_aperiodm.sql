DO $$
BEGIN
INSERT INTO
	s_aperiodm ("r_p", "godr", "mesr", "period", "periodk", "cz_cod", "date_b", "date_e", "d_oper", "p_modi", "d_modi")
SELECT "r" AS "r_p", "godr", "mesr", "period", "periodk", "cz_cod", "date_b", "date_e", "d_oper", "p_modi", "d_modi"
FROM ora_s_aperiodm WHERE ora_s_aperiodm.r IN %s
ON CONFLICT ("r_p") DO UPDATE SET "godr" = EXCLUDED.godr, "mesr" = EXCLUDED.mesr, "period" = EXCLUDED.period, "periodk" = EXCLUDED.periodk, "cz_cod" = EXCLUDED.cz_cod, 
		"date_b" = EXCLUDED.date_b, "date_e" = EXCLUDED.date_e, "d_oper" = EXCLUDED.d_oper, "p_modi" = EXCLUDED.p_modi, "d_modi" = EXCLUDED.d_modi;
--удаляю обработанные строки из оракл		
DELETE FROM ora_replog999 WHERE "N_TABLE" = 'S_APERIODM' AND "R_TABLE" IN %s;
END;
$$ LANGUAGE plpgsql;