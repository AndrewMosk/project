DO $$
BEGIN
INSERT INTO
	sl_work ("work_cod", "work_name", "active_val", "numr", "nump", "priority", "work_namel")
SELECT "work_cod", "work_name", "active_val", "numr", "nump", "priority", "work_namel"
FROM ora_sl_work WHERE ora_sl_work.work_cod = '%s'
ON CONFLICT ("work_cod") DO UPDATE SET "work_name" = EXCLUDED.work_name, "active_val" = EXCLUDED.active_val, "numr" = EXCLUDED.numr, "nump" = EXCLUDED.nump, 
		"priority" = EXCLUDED.priority, "work_namel" = EXCLUDED.work_namel;
--удаляю обработанные строки из оракл		
DELETE FROM ora_replog999 WHERE "N_TABLE" = 'SL_WORK' AND "R_TABLE" = '%s';
END;
$$ LANGUAGE plpgsql;