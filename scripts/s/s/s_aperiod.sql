DO $$
BEGIN
INSERT INTO
	s_aperiod ("r_p", "cz_cod", "godr", "mesr", "period", "periodk", "date_b", "date_e", "d_oper", "p_modi", "d_modi")
SELECT "r_p", "cz_cod", "godr", "mesr", "period", "periodk", "date_b", "date_e", "d_oper", "p_modi", "d_modi"
FROM ora_s_aperiod WHERE ora_s_aperiod.r_p IN %s
ON CONFLICT ("r_p") DO UPDATE SET "cz_cod" = EXCLUDED.cz_cod, "godr" = EXCLUDED.godr, "mesr" = EXCLUDED.mesr, "period" = EXCLUDED.period, 
		"periodk" = EXCLUDED.periodk, "date_b" = EXCLUDED.date_b, "date_e" = EXCLUDED.date_e, "d_oper" = EXCLUDED.d_oper, "p_modi" = EXCLUDED.p_modi, 
		"d_modi" = EXCLUDED.d_modi;
--удаляю обработанные строки из оракл		
DELETE FROM ora_replog999 WHERE "N_TABLE" = 'S_APERIOD' AND "R_TABLE" IN %s;
END;
$$ LANGUAGE plpgsql;