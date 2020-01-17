DO $$
BEGIN
DELETE FROM s_aperiod WHERE r_p IN (select "R_TABLE"::bigint from ora_replog999 WHERE "N_TABLE" = 'S_APERIOD' and "OPER" = 'D');
DELETE FROM ora_replog999 WHERE "N_TABLE" = 'S_APERIOD' AND "OPER" = 'D';
END;
$$ LANGUAGE plpgsql;