DO $$
BEGIN
DELETE FROM s_stat WHERE r IN (select "R_TABLE"::bigint from ora_replog999 WHERE "N_TABLE" = 'S_STAT' and "OPER" = 'D');
DELETE FROM ora_replog999 WHERE "N_TABLE" = 'S_STAT' AND "OPER" = 'D';
END;
$$ LANGUAGE plpgsql;