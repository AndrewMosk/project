DO $$
BEGIN
INSERT INTO 
	prof_vac_cl ("r", "vac_num", "cours_name", "hours", "p_hours", "p_modi", "d_modi")
SELECT "r", "vac_num", "cours_name", "hours", "p_hours", "p_modi", "d_modi"
FROM ora_prof_vac_cl WHERE ora_prof_vac_cl.r  = '%s'
ON CONFLICT ("r") DO UPDATE SET "vac_num" = EXCLUDED.vac_num, "cours_name" = EXCLUDED.cours_name, "hours" = EXCLUDED.hours, "p_hours" = EXCLUDED.p_hours, 
	"p_modi" = EXCLUDED.p_modi, "d_modi" = EXCLUDED.d_modi;
--удаляю обработанные строки из оракл		
DELETE FROM ora_replog999 WHERE "N_TABLE" = 'PROF_VAC_CL' AND "R_TABLE"  = '%s';
END;
$$ LANGUAGE plpgsql;