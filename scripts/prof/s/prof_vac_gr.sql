DO $$
BEGIN
INSERT INTO 
	prof_vac_gr ("r", "vac_num", "num_pog", "stu_beg", "stu_end", "vacpl", "p_modi", "d_modi")
SELECT "r", "vac_num", "num_pog", "stu_beg", "stu_end", "vacpl", "p_modi", "d_modi"
FROM ora_prof_vac_gr WHERE ora_prof_vac_gr.r  = '%s'
ON CONFLICT ("r") DO UPDATE SET "vac_num" = EXCLUDED.vac_num, "num_pog" = EXCLUDED.num_pog, "stu_beg" = EXCLUDED.stu_beg, "stu_end" = EXCLUDED.stu_end, 
	"vacpl" = EXCLUDED.vacpl, "p_modi" = EXCLUDED.p_modi, "d_modi" = EXCLUDED.d_modi;
--удаляю обработанные строки из оракл		
DELETE FROM ora_replog999 WHERE "N_TABLE" = 'PROF_VAC_GR' AND "R_TABLE"  = '%s';
END;
$$ LANGUAGE plpgsql;