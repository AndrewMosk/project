DO $$
BEGIN
INSERT INTO
	pers_ask_or ("reg_num", "lev", "p_modi", "d_ins")
SELECT "reg_num", "lev", "p_modi", "d_ins"
FROM ora_ask_or WHERE ora_ask_or.reg_num = '%s'
ON CONFLICT ("reg_num") DO UPDATE SET "lev" = EXCLUDED.lev, "p_modi" = EXCLUDED.p_modi, "d_ins" = EXCLUDED.d_ins;
--удаляю обработанные строки из оракл		
DELETE FROM ora_replog999 WHERE "N_TABLE" = 'ASK_OR' AND "R_TABLE" = '%s';
END;
$$ LANGUAGE plpgsql;