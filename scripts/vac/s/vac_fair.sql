DO $$
BEGIN
INSERT INTO
	vac_fair ("r", "cz_cod", "sob_date", "sob_dateend", "sob_name", "sob_vid", "sob_typ", "note", "cont_name", "salary", "pers_count", "trud_count", "p_modi", "d_modi")
SELECT "r", "cz_cod", "sob_date", "sob_dateend", "sob_name", "sob_vid", "sob_typ", "note", "cont_name", "salary", "pers_count", "trud_count", "p_modi", "d_modi"
FROM ora_vac_fair WHERE ora_vac_fair.r = '%s'
ON CONFLICT ("r") DO UPDATE SET "cz_cod" = EXCLUDED.cz_cod, "sob_date" = EXCLUDED.sob_date, "sob_dateend" = EXCLUDED.sob_dateend, "sob_name" = EXCLUDED.sob_name, 
		"sob_vid" = EXCLUDED.sob_vid, "sob_typ" = EXCLUDED.sob_typ, "note" = EXCLUDED.note, "cont_name" = EXCLUDED.cont_name, "salary" = EXCLUDED.salary, 
		"pers_count" = EXCLUDED.pers_count, "trud_count" = EXCLUDED.trud_count, "p_modi" = EXCLUDED.p_modi, "d_modi" = EXCLUDED.d_modi;
--удаляю обработанные строки из оракл		
DELETE FROM ora_replog999 WHERE "N_TABLE" = 'VAC_FAIR' AND "R_TABLE" = '%s';
END;
$$ LANGUAGE plpgsql;