DO $$
BEGIN
DELETE FROM cl_zv WHERE r IN (select "R_TABLE"::bigint from ora_replog999 WHERE "N_TABLE" = 'CL_ZV' and "OPER" = 'D');
DELETE FROM ora_replog999 WHERE "N_TABLE" = 'CL_ZV' AND "OPER" = 'D';
END;
$$ LANGUAGE plpgsql;