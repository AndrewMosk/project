DO $$
BEGIN
DELETE FROM cl_potr WHERE r IN (select "R_TABLE"::bigint from ora_replog999 WHERE "N_TABLE" = 'CL_POTR' and "OPER" = 'D');
DELETE FROM ora_replog999 WHERE "N_TABLE" = 'CL_POTR' AND "OPER" = 'D';
END;
$$ LANGUAGE plpgsql;