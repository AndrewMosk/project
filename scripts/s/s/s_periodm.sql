DO $$
BEGIN
INSERT INTO
	s_periodm ("r_p", "period", "periodk", "cz_cod", "date_b", "date_e", "d_oper", "p_modi", "d_modi")
SELECT "r" AS "r_p", "period", "periodk", "cz_cod", "date_b", "date_e", "d_oper", "p_modi", "d_modi"
FROM ora_s_periodm WHERE ora_s_periodm.r = '%s'
ON CONFLICT ("r_p") DO UPDATE SET "period" = EXCLUDED.period, "periodk" = EXCLUDED.periodk, "cz_cod" = EXCLUDED.cz_cod, "date_b" = EXCLUDED.date_b, 
		"date_e" = EXCLUDED.date_e, "d_oper" = EXCLUDED.d_oper, "p_modi" = EXCLUDED.p_modi, "d_modi" = EXCLUDED.d_modi;
--удаляю обработанные строки из оракл		
DELETE FROM ora_replog999 WHERE "N_TABLE" = 'S_PERIODM' AND "R_TABLE" = '%s';
END;
$$ LANGUAGE plpgsql;