DO $$
BEGIN
DELETE FROM cl_bank WHERE r IN (select "R_TABLE"::bigint from ora_replog999 WHERE "N_TABLE" = 'CL_BANK' and "OPER" = 'D');
DELETE FROM ora_replog999 WHERE "N_TABLE" = 'CL_BANK' AND "OPER" = 'D';
END;
$$ LANGUAGE plpgsql;