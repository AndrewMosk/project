DO $$
BEGIN
INSERT INTO
	pers_pos ("reg_num", "date_p", "date_n", "pers_num", "date_rezp", "date_prof", "pers_prof", "date_rezc", "date_comj", "pers_comj", "p_modi", "d_modi")
SELECT "reg_num", "date_p", "date_n", "pers_num", "date_rezp", "date_prof", "pers_prof", "date_rezc", "date_comj", "pers_comj", "p_modi", "d_modi"
FROM ora_pers_pos WHERE ora_pers_pos.reg_num = '%s'
ON CONFLICT ("reg_num") DO UPDATE SET "date_p" = EXCLUDED.date_p, "date_n" = EXCLUDED.date_n, "pers_num" = EXCLUDED.pers_num, "date_rezp" = EXCLUDED.date_rezp, 
	"date_prof" = EXCLUDED.date_prof, "pers_prof" = EXCLUDED.pers_prof, "date_rezc" = EXCLUDED.date_rezc, "date_comj" = EXCLUDED.date_comj, 
	"pers_comj" = EXCLUDED.pers_comj, "p_modi" = EXCLUDED.p_modi, "d_modi = EXCLUDED.d_modi";
--удаляю обработанные строки из оракл		
DELETE FROM ora_replog999 WHERE "N_TABLE" = 'PERS_POS' AND "R_TABLE" = '%s';
END;
$$ LANGUAGE plpgsql;