DO $$
BEGIN
INSERT INTO
	s_adep ("r", "reg_num", "sp_num", "godrd", "mesrd", "r_pd", "periodd", "spd_cod", "spd_date", "cz_cod", "godr", "mesr", "r_p", "period", "nun_cod", "sumd", 
		"sp_cod", "pp_date", "p_modi", "d_modi")
SELECT "r", "reg_num", "sp_num", "godrd", "mesrd", "r_pd", "periodd", "spd_cod", "spd_date", "cz_cod", "godr", "mesr", "r_p", "period", "nun_cod", "sumd", 
		"sp_cod", "pp_date", "p_modi", "d_modi"
FROM ora_s_adep WHERE ora_s_adep.r IN %s
ON CONFLICT ("r") DO UPDATE SET "reg_num" = EXCLUDED.reg_num, "sp_num" = EXCLUDED.sp_num, "godrd" = EXCLUDED.godrd, "mesrd" = EXCLUDED.mesrd, "r_pd" = EXCLUDED.r_pd, 
		"periodd" = EXCLUDED.periodd, "spd_cod" = EXCLUDED.spd_cod,	"spd_date" = EXCLUDED.spd_date, "cz_cod" = EXCLUDED.cz_cod, "godr" = EXCLUDED.godr, 
		"mesr" = EXCLUDED.mesr, "r_p" = EXCLUDED.r_p, "period" = EXCLUDED.period, "nun_cod" = EXCLUDED.nun_cod, "sumd" = EXCLUDED.sumd, "sp_cod" = EXCLUDED.sp_cod, 
		"pp_date" = EXCLUDED.pp_date, "p_modi" = EXCLUDED.p_modi, "d_modi" = EXCLUDED.d_modi;
--удаляю обработанные строки из оракл		
DELETE FROM ora_replog999 WHERE "N_TABLE" = 'S_ADEP' AND "R_TABLE" IN %s;
END;
$$ LANGUAGE plpgsql;