DO $$
BEGIN
DELETE FROM s_periodm WHERE r_p IN (select "R_TABLE"::bigint from ora_replog999 WHERE "N_TABLE" = 'S_PERIODM' and "OPER" = 'D');
DELETE FROM ora_replog999 WHERE "N_TABLE" = 'S_PERIODM' AND "OPER" = 'D';
END;
$$ LANGUAGE plpgsql;