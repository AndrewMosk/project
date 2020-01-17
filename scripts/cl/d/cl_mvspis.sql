DO $$
BEGIN
DELETE FROM cl_mvspis WHERE r IN (select "R_TABLE"::bigint from ora_replog999 WHERE "N_TABLE" = 'CL_MVSPIS' and "OPER" = 'D');
DELETE FROM ora_replog999 WHERE "N_TABLE" = 'CL_MVSPIS' AND "OPER" = 'D';
END;
$$ LANGUAGE plpgsql;