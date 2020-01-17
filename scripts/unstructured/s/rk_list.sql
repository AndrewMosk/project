DO $$
BEGIN
INSERT INTO
	rk_list ("r_prot", "plc_cod", "prot_num", "prot_datef", "prot_dateu", "prot_datep", "commutv", "p_modi", "d_modi")
SELECT "r_prot", "plc_cod", "prot_num", "prot_datef", "prot_dateu", "prot_datep", "commutv", "p_modi", "d_modi"
FROM ora_rk_list WHERE ora_rk_list.r_prot IN %s
ON CONFLICT ("r_prot") DO UPDATE SET "plc_cod" = EXCLUDED.plc_cod, "prot_num" = EXCLUDED.prot_num, "prot_datef" = EXCLUDED.prot_datef, 
		"prot_dateu" = EXCLUDED.prot_dateu, "prot_datep" = EXCLUDED.prot_datep, "commutv" = EXCLUDED.commutv, "p_modi" = EXCLUDED.p_modi, "d_modi" = EXCLUDED.d_modi;
--удаляю обработанные строки из оракл		
DELETE FROM ora_replog999 WHERE "N_TABLE" = 'RK_LIST' AND "R_TABLE" IN %s;
END;
$$ LANGUAGE plpgsql;