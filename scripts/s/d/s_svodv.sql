DO $$
BEGIN
DELETE FROM s_svodv WHERE r IN (select "R_TABLE"::bigint from ora_replog999 WHERE "N_TABLE" = 'S_SVODV' and "OPER" = 'D');
DELETE FROM ora_replog999 WHERE "N_TABLE" = 'S_SVODV' AND "OPER" = 'D';
END;
$$ LANGUAGE plpgsql;