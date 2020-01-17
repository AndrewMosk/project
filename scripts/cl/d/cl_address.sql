
DO $$
BEGIN
DELETE FROM cl_address WHERE c_address IN (select "R_TABLE"::bigint from ora_replog999 WHERE "N_TABLE" = 'CL_ADDRESS' and "OPER" = 'D');
DELETE FROM ora_replog999 WHERE "N_TABLE" = 'CL_ADDRESS' AND "OPER" = 'D';
END;
$$ LANGUAGE plpgsql;