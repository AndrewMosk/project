DO $$
BEGIN
INSERT INTO
	pers_pcl ("r", "reg_num", "pcl_cod", "p_modi", "d_modi")
SELECT "r", "reg_num", "pcl_cod", "p_modi", "d_modi"
FROM ora_pers_pcl WHERE ora_pers_pcl.r = '%s'
ON CONFLICT ("r") DO UPDATE SET "reg_num" = EXCLUDED.reg_num, "pcl_cod" = EXCLUDED.pcl_cod, "p_modi" = EXCLUDED.p_modi, "d_modi" = EXCLUDED.d_modi;
--удаляю обработанные строки из оракл		
DELETE FROM ora_replog999 WHERE "N_TABLE" = 'PERS_PCL' AND "R_TABLE" = '%s';
END;
$$ LANGUAGE plpgsql;