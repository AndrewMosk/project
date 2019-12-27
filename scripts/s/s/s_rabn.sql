DO $$
BEGIN
INSERT INTO
	s_rabn ("r", "reg_num", "godv", "mesv", "nu_cod", "doc_num", "date_b", "date_e", "dni", "procb", "sumb", "procm", "poor", "sumn", "sumd", "sump", "sumsn", "r_p", 
		"period", "pp", "p_modi", "d_modi")
SELECT "r", "reg_num", "godv", "mesv", "nu_cod", "doc_num", "date_b", "date_e", "dni", "procb", "sumb", "procm", "poor", "sumn", "sumd", "sump", "sumsn", "r_p", 
		"period", "pp", "p_modi", "d_modi"
FROM ora_s_rabn WHERE ora_s_rabn.r = '%s'
ON CONFLICT ("r") DO UPDATE SET "reg_num" = EXCLUDED.reg_num, "godv" = EXCLUDED.godv, "mesv" = EXCLUDED.mesv, "nu_cod" = EXCLUDED.nu_cod, "doc_num" = EXCLUDED.doc_num, 
		"date_b" = EXCLUDED.date_b, "date_e" = EXCLUDED.date_e, "dni" = EXCLUDED.dni, "procb" = EXCLUDED.procb, "sumb" = EXCLUDED.sumb, "procm" = EXCLUDED.procm, 
		"poor" = EXCLUDED.poor, "sumn" = EXCLUDED.sumn, "sumd" = EXCLUDED.sumd, "sump" = EXCLUDED.sump, "sumsn" = EXCLUDED.sumsn, "r_p" = EXCLUDED.r_p, 
		"period" = EXCLUDED.period, "pp" = EXCLUDED.pp, "p_modi" = EXCLUDED.p_modi, "d_modi" = EXCLUDED.d_modi;
--удаляю обработанные строки из оракл		
DELETE FROM ora_replog999 WHERE "N_TABLE" = 'S_RABN' AND "R_TABLE" = '%s';
END;
$$ LANGUAGE plpgsql;