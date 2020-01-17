DO $$
BEGIN
DELETE FROM job_rez WHERE r_rez IN (select "R_TABLE"::bigint from ora_replog999 WHERE "N_TABLE" = 'JOB_REZ' and "OPER" = 'D');
DELETE FROM ora_replog999 WHERE "N_TABLE" = 'JOB_REZ' AND "OPER" = 'D';
END;
$$ LANGUAGE plpgsql;