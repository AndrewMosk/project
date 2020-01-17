DO $$
BEGIN
DELETE FROM s_period WHERE r_p IN (select "R_TABLE"::bigint from ora_replog999 WHERE "N_TABLE" = 'S_PERIOD' and "OPER" = 'D');
DELETE FROM ora_replog999 WHERE "N_TABLE" = 'S_PERIOD' AND "OPER" = 'D';
END;
$$ LANGUAGE plpgsql;