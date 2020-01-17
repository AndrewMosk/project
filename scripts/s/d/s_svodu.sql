DO $$
BEGIN
DELETE FROM s_svodu WHERE r IN (select "R_TABLE"::bigint from ora_replog999 WHERE "N_TABLE" = 'S_SVODU' and "OPER" = 'D');
DELETE FROM ora_replog999 WHERE "N_TABLE" = 'S_SVODU' AND "OPER" = 'D';
END;
$$ LANGUAGE plpgsql;