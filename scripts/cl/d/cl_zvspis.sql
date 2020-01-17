DO $$
BEGIN
DELETE FROM cl_zvspis WHERE r IN (select "R_TABLE"::bigint from ora_replog999 WHERE "N_TABLE" = 'CL_ZVSPIS' and "OPER" = 'D');
DELETE FROM ora_replog999 WHERE "N_TABLE" = 'CL_ZVSPIS' AND "OPER" = 'D';
END;
$$ LANGUAGE plpgsql;