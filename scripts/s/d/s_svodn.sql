DO $$
BEGIN
DELETE FROM s_svodn WHERE r IN (select "R_TABLE"::bigint from ora_replog999 WHERE "N_TABLE" = 'S_SVODN' and "OPER" = 'D');
DELETE FROM ora_replog999 WHERE "N_TABLE" = 'S_SVODN' AND "OPER" = 'D';
END;
$$ LANGUAGE plpgsql;