DO $$
BEGIN
INSERT INTO
	cons ("r", "cons_date", "cons_cod", "cons_det", "cz_cod", "plc_cod", "cons_count", "comm", "p_modi", "d_modi")
SELECT "r", "cons_date", "cons_cod", "cons_det", "cz_cod", "plc_cod", "cons_count", "comm", "p_modi", "d_modi"
FROM ora_cons WHERE ora_cons.r IN %s
ON CONFLICT ("r") DO UPDATE SET "cons_date" = EXCLUDED.cons_date, "cons_cod" = EXCLUDED.cons_cod, "cons_det" = EXCLUDED.cons_det, "cz_cod" = EXCLUDED.cz_cod, 
		"plc_cod" = EXCLUDED.plc_cod, "cons_count" = EXCLUDED.cons_count, "comm" = EXCLUDED.comm, "p_modi" = EXCLUDED.p_modi, "d_modi" = EXCLUDED.d_modi;
--удаляю обработанные строки из оракл		
DELETE FROM ora_replog999 WHERE "N_TABLE" = 'CONS' AND "R_TABLE" IN %s;
END;
$$ LANGUAGE plpgsql;