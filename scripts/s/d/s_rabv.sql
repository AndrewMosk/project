DO $$
BEGIN
DELETE FROM s_rabv WHERE r IN (select "R_TABLE"::bigint from ora_replog999 WHERE "N_TABLE" = 'S_RABV' and "OPER" = 'D');
DELETE FROM ora_replog999 WHERE "N_TABLE" = 'S_RABV' AND "OPER" = 'D';
END;
$$ LANGUAGE plpgsql;