DO $$
BEGIN
INSERT INTO
	s_otd ("otd_cod", "c_client", "c_bank", "sch_num", "plc_cod", "ind1", "ind2", "bak", "pr", "p_modi", "d_modi")
SELECT "otd_cod", "c_client", "c_bank", "sch_num", "plc_cod", "ind1", "ind2", "bak", "pr", "p_modi", "d_modi"
FROM ora_s_otd WHERE ora_s_otd.otd_cod IN %s
ON CONFLICT ("otd_cod") DO UPDATE SET "c_client" = EXCLUDED.c_client, "c_bank" = EXCLUDED.c_bank, "sch_num" = EXCLUDED.sch_num, "plc_cod" = EXCLUDED.plc_cod, 
		"ind1" = EXCLUDED.ind1, "ind2" = EXCLUDED.ind2, "bak" = EXCLUDED.bak, "pr" = EXCLUDED.pr, "p_modi" = EXCLUDED.p_modi, "d_modi" = EXCLUDED.d_modi;
--удаляю обработанные строки из оракл		
DELETE FROM ora_replog999 WHERE "N_TABLE" = 'S_OTD' AND "R_TABLE" IN %s;
END;
$$ LANGUAGE plpgsql;