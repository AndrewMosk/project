DO $$
BEGIN
INSERT INTO
	sl_executor ("executor_cod", "support_group", "active_val")
SELECT "executor_cod", "support_group", "active_val"
FROM ora_sl_executor WHERE ora_sl_executor.executor_cod  = '%s'
ON CONFLICT ("executor_cod") DO UPDATE SET "support_group" = EXCLUDED.support_group, "active_val" = EXCLUDED.active_val;
--удаляю обработанные строки из оракл		
DELETE FROM ora_replog999 WHERE "N_TABLE" = 'SL_EXECUTOR' AND "R_TABLE" = '%s';
END;
$$ LANGUAGE plpgsql;