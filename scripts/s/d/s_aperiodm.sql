DO $$
BEGIN
DELETE FROM s_aperiodm WHERE r_p IN (select "R_TABLE"::bigint from ora_replog999 WHERE "N_TABLE" = 'S_APERIODM' and "OPER" = 'D');
DELETE FROM ora_replog999 WHERE "N_TABLE" = 'S_APERIODM' AND "OPER" = 'D';
END;
$$ LANGUAGE plpgsql;