DO $$
BEGIN
DELETE FROM s_spproc WHERE proc_cod IN (select "R_TABLE"::bigint from ora_replog999 WHERE "N_TABLE" = 'S_SPPROC' and "OPER" = 'D');
DELETE FROM ora_replog999 WHERE "N_TABLE" = 'S_SPPROC' AND "OPER" = 'D';
END;
$$ LANGUAGE plpgsql;