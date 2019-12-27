DO $$
BEGIN
INSERT INTO
	s_spproc ("proc_cod", "proc_name", "proc")
SELECT "proc_cod", "proc_name", "proc"
FROM ora_s_spproc WHERE ora_s_spproc.proc_cod = '%s'
ON CONFLICT ("proc_cod") DO UPDATE SET "proc_name" = EXCLUDED.proc_name, "proc" = EXCLUDED.proc;
--удаляю обработанные строки из оракл		
DELETE FROM ora_replog999 WHERE "N_TABLE" = 'S_SPPROC' AND "R_TABLE" = '%s';
END;
$$ LANGUAGE plpgsql;