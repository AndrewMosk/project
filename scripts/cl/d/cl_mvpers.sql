DO $$
BEGIN
DELETE FROM cl_mvpers WHERE r IN (select "R_TABLE"::bigint from ora_replog999 WHERE "N_TABLE" = 'CL_MVPERS' and "OPER" = 'D');
DELETE FROM ora_replog999 WHERE "N_TABLE" = 'CL_MVPERS' AND "OPER" = 'D';
END;
$$ LANGUAGE plpgsql;