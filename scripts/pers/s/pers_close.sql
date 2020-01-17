DO $$
BEGIN
INSERT INTO
	pers_close ("r", "pers_num", "date_close", "p_modi", "d_modi")
SELECT "r", "pers_num", "date_close", "p_modi", "d_modi"
FROM ora_pers_close WHERE ora_pers_close.r = '%s'
ON CONFLICT ("r") DO UPDATE SET "pers_num" = EXCLUDED.pers_num, "date_close" = EXCLUDED.date_close, "p_modi" = EXCLUDED.p_modi, "d_modi" = EXCLUDED.d_modi;
--удаляю обработанные строки из оракл		
DELETE FROM ora_replog999 WHERE "N_TABLE" = 'PERS_CLOSE' AND "R_TABLE" = '%s';
END;
$$ LANGUAGE plpgsql;