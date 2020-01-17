DO $$
BEGIN
DELETE FROM s_vozv WHERE r IN (select "R_TABLE"::bigint from ora_replog999 WHERE "N_TABLE" = 'S_VOZV' and "OPER" = 'D');
DELETE FROM ora_replog999 WHERE "N_TABLE" = 'S_VOZV' AND "OPER" = 'D';
END;
$$ LANGUAGE plpgsql;