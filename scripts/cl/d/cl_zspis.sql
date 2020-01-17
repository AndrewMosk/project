DO $$
BEGIN
DELETE FROM cl_zspis WHERE r IN (select "R_TABLE"::bigint from ora_replog999 WHERE "N_TABLE" = 'CL_ZSPIS' and "OPER" = 'D');
DELETE FROM ora_replog999 WHERE "N_TABLE" = 'CL_ZSPIS' AND "OPER" = 'D';
END;
$$ LANGUAGE plpgsql;