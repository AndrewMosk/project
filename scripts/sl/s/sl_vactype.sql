DO $$
BEGIN
INSERT INTO
	sl_vactype ("type_cod", "agr_type", "type_names", "type_name", "type_code", "rez_cod", "rez_det", "rez_osn", "type_comm", "np", "rn_trud_osn", "rpu", "rpu_rm", 
		"p_dop", "rpu_prg", "rpu_krm", "pr", "p_modi", "d_modi")
SELECT "type_cod", "agr_type", "type_names", "type_name", "type_code", "rez_cod", "rez_det", "rez_osn", "type_comm", "np", "rn_trud_osn", "rpu", "rpu_rm", 
		"p_dop", "rpu_prg", "rpu_krm", "pr", "p_modi", "d_modi"
FROM ora_sl_vactype WHERE ora_sl_vactype.type_cod = '%s'
ON CONFLICT ("type_cod") DO UPDATE SET "agr_type" = EXCLUDED.agr_type, "type_names" = EXCLUDED.type_names, "type_name" = EXCLUDED.type_name, 
		"type_code" = EXCLUDED.type_code, "rez_cod" = EXCLUDED.rez_cod, "rez_det" = EXCLUDED.rez_det, "rez_osn" = EXCLUDED.rez_osn, "type_comm" = EXCLUDED.type_comm, 
		"np" = EXCLUDED.np, "rn_trud_osn" = EXCLUDED.rn_trud_osn, "rpu" = EXCLUDED.rpu, "rpu_rm" = EXCLUDED.rpu_rm, "p_dop" = EXCLUDED.p_dop, 
		"rpu_prg" = EXCLUDED.rpu_prg, "rpu_krm" = EXCLUDED.rpu_krm, "pr" = EXCLUDED.pr, "p_modi" = EXCLUDED.p_modi, "d_modi" = EXCLUDED.d_modi;
--удаляю обработанные строки из оракл		
DELETE FROM ora_replog999 WHERE "N_TABLE" = 'SL_VACTYPE' AND "R_TABLE" = '%s';
END;
$$ LANGUAGE plpgsql;