DO $$
BEGIN
DELETE FROM cl_pspis WHERE r IN (select "R_TABLE"::bigint from ora_replog999 WHERE "N_TABLE" = 'CL_PSPIS' and "OPER" = 'D');
DELETE FROM ora_replog999 WHERE "N_TABLE" = 'CL_PSPIS' AND "OPER" = 'D';
END;
$$ LANGUAGE plpgsql;