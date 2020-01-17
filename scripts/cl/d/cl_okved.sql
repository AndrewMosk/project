DO $$
BEGIN
DELETE FROM cl_okved WHERE r IN (select "R_TABLE"::bigint from ora_replog999 WHERE "N_TABLE" = 'CL_OKVED' and "OPER" = 'D');
DELETE FROM ora_replog999 WHERE "N_TABLE" = 'CL_OKVED' AND "OPER" = 'D';
END;
$$ LANGUAGE plpgsql;