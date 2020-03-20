DO $$
BEGIN
INSERT INTO 
	prof_cel ("r", "reg_num", "dir_num", "cel_cod", "p_modi", "d_modi")
SELECT "r", "reg_num", "dir_num", "cel_cod", "p_modi", "d_modi"
FROM ora_prof_cel WHERE ora_prof_cel.r  = '%s'
ON CONFLICT ("r") DO UPDATE SET "reg_num" = EXCLUDED.reg_num, "dir_num" = EXCLUDED.dir_num, "cel_cod" = EXCLUDED.cel_cod, "p_modi" = EXCLUDED.p_modi, "d_modi" = EXCLUDED.d_modi;
--удаляю обработанные строки из оракл		
DELETE FROM ora_replog999 WHERE "N_TABLE" = 'PROF_CEL' AND "R_TABLE"  = '%s';
END;
$$ LANGUAGE plpgsql;