DO $$
BEGIN
DELETE FROM prof_dir WHERE dir_num IN (select "R_TABLE"::bigint from ora_replog999 WHERE "N_TABLE" = 'PROF_DIR' and "OPER" = 'D');
DELETE FROM ora_replog999 WHERE "N_TABLE" = 'PROF_DIR' AND "OPER" = 'D';
END;
$$ LANGUAGE plpgsql;