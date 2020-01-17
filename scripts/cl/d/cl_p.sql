DO $$
BEGIN
DELETE FROM cl_p WHERE r IN (select "R_TABLE"::bigint from ora_replog999 WHERE "N_TABLE" = 'CL_P' and "OPER" = 'D');
DELETE FROM ora_replog999 WHERE "N_TABLE" = 'CL_P' AND "OPER" = 'D';
END;
$$ LANGUAGE plpgsql;