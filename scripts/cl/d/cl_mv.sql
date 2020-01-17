DO $$
BEGIN
DELETE FROM cl_mv WHERE r IN (select "R_TABLE"::bigint from ora_replog999 WHERE "N_TABLE" = 'CL_MV' and "OPER" = 'D');
DELETE FROM ora_replog999 WHERE "N_TABLE" = 'CL_MV' AND "OPER" = 'D';
END;
$$ LANGUAGE plpgsql;