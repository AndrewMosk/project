DO $$
BEGIN
INSERT INTO
	pers_sielev ("r", "reg_num", "sielev_cod", "sience_cod", "p_modi", "d_modi")
SELECT "r", "reg_num", "sielev_cod", "sience_cod", "p_modi", "d_modi"
FROM ora_pers_sielev WHERE ora_pers_sielev.r = '%s'
ON CONFLICT ("r") DO UPDATE SET "reg_num" = EXCLUDED.reg_num, "sielev_cod" = EXCLUDED.sielev_cod, "sience_cod" = EXCLUDED.sience_cod, "p_modi" = EXCLUDED.p_modi, 
		"d_modi" = EXCLUDED.d_modi;
--удаляю обработанные строки из оракл		
DELETE FROM ora_replog999 WHERE "N_TABLE" = 'PERS_SIELEV' AND "R_TABLE" = '%s';
END;
$$ LANGUAGE plpgsql;