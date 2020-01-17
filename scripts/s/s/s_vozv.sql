DO $$
BEGIN
INSERT INTO
	s_vozv ("r", "reg_num", "r_p", "nu_cod", "v_cod", "v_doc", "v_date", "v_sum", "p_modi", "d_modi")
SELECT "r", "reg_num", "r_p", "nu_cod", "v_cod", "v_doc", "v_date", "v_sum", "p_modi", "d_modi"
FROM ora_s_vozv WHERE ora_s_vozv.r IN %s
ON CONFLICT ("r") DO UPDATE SET "reg_num" = EXCLUDED.reg_num, "r_p" = EXCLUDED.r_p, "nu_cod" = EXCLUDED.nu_cod, "v_cod" = EXCLUDED.v_cod, "v_doc" = EXCLUDED.v_doc, 
		"v_date" = EXCLUDED.v_date, "v_sum" = EXCLUDED.v_sum, "p_modi" = EXCLUDED.p_modi, "d_modi" = EXCLUDED.d_modi;
--удаляю обработанные строки из оракл		
DELETE FROM ora_replog999 WHERE "N_TABLE" = 'S_VOZV' AND "R_TABLE" IN %s;
END;
$$ LANGUAGE plpgsql;