DO $$
BEGIN
DELETE FROM job_dir WHERE dir_num IN (select "R_TABLE"::bigint from ora_replog999 WHERE "N_TABLE" = 'JOB_DIR' and "OPER" = 'D');
DELETE FROM ora_replog999 WHERE "N_TABLE" = 'JOB_DIR' AND "OPER" = 'D';
END;
$$ LANGUAGE plpgsql;