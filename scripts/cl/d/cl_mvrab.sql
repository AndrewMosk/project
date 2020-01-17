DO $$
BEGIN
DELETE FROM cl_mvrab WHERE r IN (select "R_TABLE"::bigint from ora_replog999 WHERE "N_TABLE" = 'CL_MVRAB' and "OPER" = 'D');
DELETE FROM ora_replog999 WHERE "N_TABLE" = 'CL_MVRAB' AND "OPER" = 'D';
END;
$$ LANGUAGE plpgsql;