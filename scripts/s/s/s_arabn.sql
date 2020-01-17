DO $$
BEGIN
INSERT INTO
	s_arabn ("r", "godr", "mesr", "reg_num", "godv", "mesv", "nu_cod", "doc_num", "date_b", "date_e", "dni", "procb", "sumb", "poor", "procm", "sumn", "sumd", "sumsn",
		"sump", "r_p", "period", "pp", "p_modi", "d_modi")
SELECT "r", "godr", "mesr", "reg_num", "godv", "mesv", "nu_cod", "doc_num", "date_b", "date_e", "dni", "procb", "sumb", "poor", "procm", "sumn", "sumd", "sumsn",
		"sump", "r_p", "period", "pp", "p_modi", "d_modi"
FROM ora_s_arabn WHERE ora_s_arabn.r IN %s
ON CONFLICT ("r") DO UPDATE SET "godr" = EXCLUDED.godr, "mesr" = EXCLUDED.mesr, "reg_num" = EXCLUDED.reg_num, "godv" = EXCLUDED.godv, "mesv" = EXCLUDED.mesv, 
		"nu_cod" = EXCLUDED.nu_cod, "doc_num" = EXCLUDED.doc_num, "date_b" = EXCLUDED.date_b, "date_e" = EXCLUDED.date_e, "dni" = EXCLUDED.dni, "procb" = EXCLUDED.procb, 
		"sumb" = EXCLUDED.sumb, "poor" = EXCLUDED.poor, "procm" = EXCLUDED.procm, "sumn" = EXCLUDED.sumn, "sumd" = EXCLUDED.sumd, "sumsn" = EXCLUDED.sumsn, 
		"sump" = EXCLUDED.sump, "r_p" = EXCLUDED.r_p, "period" = EXCLUDED.period, "pp" = EXCLUDED.pp, "p_modi" = EXCLUDED.p_modi, "d_modi" = EXCLUDED.d_modi;
--удаляю обработанные строки из оракл		
DELETE FROM ora_replog999 WHERE "N_TABLE" = 'S_ARABN' AND "R_TABLE" IN %s;
END;
$$ LANGUAGE plpgsql;