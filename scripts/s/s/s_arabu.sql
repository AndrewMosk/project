DO $$
BEGIN
INSERT INTO
	s_arabu ("r", "godr", "mesr", "reg_num", "godv", "mesv", "nu_cod", "nun_cod", "r_d", "doc_num", "dnin", "sumn", "proc", "sumu", "sumud", "dnid", "dnip", "sump", 
		"sumk", "r_p", "period", "pp_cod", "pp_date", "p_modi", "d_modi")
SELECT "r", "godr", "mesr", "reg_num", "godv", "mesv", "nu_cod", "nun_cod", "r_d", "doc_num", "dnin", "sumn", "proc", "sumu", "sumud", "dnid", "dnip", "sump", 
		"sumk", "r_p", "period", "pp_cod", "pp_date", "p_modi", "d_modi"
FROM ora_s_arabu WHERE ora_s_arabu.r IN %s
ON CONFLICT ("r") DO UPDATE SET "godr" = EXCLUDED.godr, "mesr" = EXCLUDED.mesr, "reg_num" = EXCLUDED.reg_num, "godv" = EXCLUDED.godv, "mesv" = EXCLUDED.mesv, 
		"nu_cod" = EXCLUDED.nu_cod, "nun_cod" = EXCLUDED.nun_cod, "r_d" = EXCLUDED.r_d, "doc_num" = EXCLUDED.doc_num, "dnin" = EXCLUDED.dnin, "sumn" = EXCLUDED.sumn, 
		"proc" = EXCLUDED.proc, "sumu" = EXCLUDED.sumu, "sumud" = EXCLUDED.sumud, "dnid" = EXCLUDED.dnid, "dnip" = EXCLUDED.dnip, "sump" = EXCLUDED.sump, 
		"sumk" = EXCLUDED.sumk, "r_p" = EXCLUDED.r_p, "period" = EXCLUDED.period, "pp_cod" = EXCLUDED.pp_cod, "pp_date" = EXCLUDED.pp_date, "p_modi" = EXCLUDED.p_modi, 
		"d_modi" = EXCLUDED.d_modi;
--удаляю обработанные строки из оракл		
DELETE FROM ora_replog999 WHERE "N_TABLE" = 'S_ARABU' AND "R_TABLE" IN %s;
END;
$$ LANGUAGE plpgsql;