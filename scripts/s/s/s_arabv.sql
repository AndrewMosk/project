DO $$
BEGIN
INSERT INTO
	s_arabv ("r", "reg_num", "sumv", "nu_cod", "nun_cod", "sp_cod", "pp_date", "godr", "mesr", "period", "r_p", "p_modi", "d_modi")
SELECT "r", "reg_num", "sumv", "nu_cod", "nun_cod", "sp_cod", "pp_date", "godr", "mesr", "period", "r_p", "p_modi", "d_modi"
FROM ora_s_arabv WHERE ora_s_arabv.r IN %s
ON CONFLICT ("r") DO UPDATE SET "reg_num" = EXCLUDED.reg_num, "sumv" = EXCLUDED.sumv, "nu_cod" = EXCLUDED.nu_cod, "nun_cod" = EXCLUDED.nun_cod, 
		"sp_cod" = EXCLUDED.sp_cod, "pp_date" = EXCLUDED.pp_date, "godr" = EXCLUDED.godr, "mesr" = EXCLUDED.mesr, "period" = EXCLUDED.period, "r_p" = EXCLUDED.r_p, 
		"p_modi" = EXCLUDED.p_modi, "d_modi" = EXCLUDED.d_modi;
--удаляю обработанные строки из оракл		
DELETE FROM ora_replog999 WHERE "N_TABLE" = 'S_ARABV' AND "R_TABLE" IN %s;
END;
$$ LANGUAGE plpgsql;