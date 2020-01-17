DO $$
BEGIN
DELETE FROM cl_rez WHERE r IN (select "R_TABLE"::bigint from ora_replog999 WHERE "N_TABLE" = 'CL_REZ' and "OPER" = 'D');
DELETE FROM ora_replog999 WHERE "N_TABLE" = 'CL_REZ' AND "OPER" = 'D';
END;
$$ LANGUAGE plpgsql;