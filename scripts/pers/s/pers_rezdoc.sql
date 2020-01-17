DO $$
BEGIN
INSERT INTO
	pers_rezdoc ("r", "r_rez", "c_order", "hex", "status", "p_modi", "d_modi")
SELECT "r", "r_rez", "c_order", "hex", "status", "p_modi", "d_modi"
FROM ora_pers_rezdoc WHERE ora_pers_rezdoc.r = '%s'
ON CONFLICT ("r") DO UPDATE SET "r_rez" = EXCLUDED.r_rez, "c_order" = EXCLUDED.c_order, "hex" = EXCLUDED.hex, "status" = EXCLUDED.status, 
		"p_modi" = EXCLUDED.p_modi, "d_modi" = EXCLUDED.d_modi;
--удаляю обработанные строки из оракл		
DELETE FROM ora_replog999 WHERE "N_TABLE" = 'PERS_REZDOC' AND "R_TABLE" = '%s';
END;
$$ LANGUAGE plpgsql;