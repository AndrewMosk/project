DO $$
BEGIN
DELETE FROM s_rabdu WHERE r IN (select "R_TABLE"::bigint from ora_replog999 WHERE "N_TABLE" = 'S_RABDU' and "OPER" = 'D');
DELETE FROM ora_replog999 WHERE "N_TABLE" = 'S_RABDU' AND "OPER" = 'D';
END;
$$ LANGUAGE plpgsql;