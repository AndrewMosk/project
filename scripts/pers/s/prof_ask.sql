DO $$
BEGIN
INSERT INTO
	pers_ask_prof ("r", "reg_num", "prof_name", "prof_cod")
SELECT "r", "reg_num", "prof_name", "prof_cod"
FROM ora_prof_ask WHERE ora_prof_ask.r = '%s'
ON CONFLICT ("r") DO UPDATE SET "reg_num" = EXCLUDED.reg_num, "prof_name" = EXCLUDED.prof_name, "prof_cod" = EXCLUDED.prof_cod;
--удаляю обработанные строки из оракл		
DELETE FROM ora_replog999 WHERE "N_TABLE" = 'PROF_ASK' AND "R_TABLE" = '%s';
END;
$$ LANGUAGE plpgsql;