DO $$
BEGIN
DELETE FROM cl_sr WHERE r IN (select "R_TABLE"::bigint from ora_replog999 WHERE "N_TABLE" = 'CL_SR' and "OPER" = 'D');
DELETE FROM ora_replog999 WHERE "N_TABLE" = 'CL_SR' AND "OPER" = 'D';
END;
$$ LANGUAGE plpgsql;