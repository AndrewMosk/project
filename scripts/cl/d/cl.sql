DO $$
BEGIN
DELETE FROM cl WHERE c_client IN (select "R_TABLE"::bigint from ora_replog999 WHERE "N_TABLE" = 'CL' and "OPER" = 'D');
DELETE FROM ora_replog999 WHERE "N_TABLE" = 'CL' AND "OPER" = 'D';
END;
$$ LANGUAGE plpgsql;