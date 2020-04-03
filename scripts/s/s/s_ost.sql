DO $$
BEGIN
INSERT INTO
	s_ost ("r", "reg_num", "nu_cod", "sumo", "sumov", "p_modi", "d_modi")
SELECT "r", "reg_num", "nu_cod", "sumo", "sumov", "p_modi", "d_modi"
FROM ora_s_ost WHERE ora_s_ost.r IN %s
ON CONFLICT ("r") DO UPDATE SET "reg_num" = EXCLUDED.reg_num, "nu_cod" = EXCLUDED.nu_cod, "sumo" = EXCLUDED.sumo, "sumov" = EXCLUDED.sumov, 
		"p_modi" = EXCLUDED.p_modi, "d_modi" = EXCLUDED.d_modi;
--удаляю обработанные строки из оракл		
DELETE FROM ora_replog999 WHERE "N_TABLE" = 'S_OST' AND "R_TABLE" IN %s;
END;
$$ LANGUAGE plpgsql;