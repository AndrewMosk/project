DO $$
BEGIN
DELETE FROM cl_z WHERE r IN (select "R_TABLE"::bigint from ora_replog999 WHERE "N_TABLE" = 'CL_Z' and "OPER" = 'D');
DELETE FROM ora_replog999 WHERE "N_TABLE" = 'CL_Z' AND "OPER" = 'D';
END;
$$ LANGUAGE plpgsql;