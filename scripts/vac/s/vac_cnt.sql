DO $$
BEGIN
INSERT INTO
	vac_cnt ("vac_num", "cur_free", "cur_dir", "cur_spr", "att_f")
SELECT "vac_num", "cur_free", "cur_dir", "cur_spr", "att_f"
FROM ora_vac_cnt WHERE ora_vac_cnt.vac_num = '%s'
ON CONFLICT ("vac_num") DO UPDATE SET "cur_free" = EXCLUDED.cur_free, "cur_dir" = EXCLUDED.cur_dir, "cur_spr" = EXCLUDED.cur_spr, "att_f" = EXCLUDED.att_f;
--удаляю обработанные строки из оракл		
DELETE FROM ora_replog999 WHERE "N_TABLE" = 'VAC_CNT' AND "R_TABLE" = '%s';
END;
$$ LANGUAGE plpgsql;