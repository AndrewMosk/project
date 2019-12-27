DO $$
BEGIN
INSERT INTO
	s_rabv ("r", "reg_num", "nu_cod", "nun_cod", "sp_cod", "sumv", "r_p", "period", "p_modi", "d_modi")
SELECT "r", "reg_num", "nu_cod", "nun_cod", "sp_cod", "sumv", "r_p", "period", "p_modi", "d_modi"
FROM ora_s_rabv WHERE ora_s_rabv.r = '%s'
ON CONFLICT ("r") DO UPDATE SET "reg_num" = EXCLUDED.reg_num, "nu_cod" = EXCLUDED.nu_cod, "nun_cod" = EXCLUDED.nun_cod, "sp_cod" = EXCLUDED.sp_cod, 
		"sumv" = EXCLUDED.sumv, "r_p" = EXCLUDED.r_p, "period" = EXCLUDED.period, "p_modi" = EXCLUDED.p_modi, "d_modi" = EXCLUDED.d_modi;
--удаляю обработанные строки из оракл		
DELETE FROM ora_replog999 WHERE "N_TABLE" = 'S_RABV' AND "R_TABLE" = '%s';
END;
$$ LANGUAGE plpgsql;