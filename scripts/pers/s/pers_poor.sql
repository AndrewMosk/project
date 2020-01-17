DO $$
BEGIN
INSERT INTO
	pers_poor ("r", "reg_num", "poor_cod", "date_borth", "date_end", "doc_end", "poor_priz", "p_modi", "d_modi")
SELECT "r", "reg_num", "poor_cod", "date_borth", "date_end", "doc_end", "poor_priz", "p_modi", "d_modi"
FROM ora_pers_poor WHERE ora_pers_poor.r = '%s'
ON CONFLICT ("r") DO UPDATE SET "reg_num" = EXCLUDED.reg_num, "poor_cod" = EXCLUDED.poor_cod, "date_borth" = EXCLUDED.date_borth, "date_end" = EXCLUDED.date_end, 
		"doc_end" = EXCLUDED.doc_end, "poor_priz" = EXCLUDED.poor_priz, "p_modi" = EXCLUDED.p_modi, "d_modi" = EXCLUDED.d_modi;
--удаляю обработанные строки из оракл		
DELETE FROM ora_replog999 WHERE "N_TABLE" = 'PERS_POOR' AND "R_TABLE" = '%s';
END;
$$ LANGUAGE plpgsql;