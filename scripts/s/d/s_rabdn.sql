DO $$
BEGIN
DELETE FROM s_rabdn WHERE r IN (select "R_TABLE"::bigint from ora_replog999 WHERE "N_TABLE" = 'S_RABDN' and "OPER" = 'D');
DELETE FROM ora_replog999 WHERE "N_TABLE" = 'S_RABDN' AND "OPER" = 'D';
END;
$$ LANGUAGE plpgsql;