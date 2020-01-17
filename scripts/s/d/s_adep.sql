DO $$
BEGIN
DELETE FROM s_adep WHERE r IN (select "R_TABLE"::bigint from ora_replog999 WHERE "N_TABLE" = 'S_ADEP' and "OPER" = 'D');
DELETE FROM ora_replog999 WHERE "N_TABLE" = 'S_ADEP' AND "OPER" = 'D';
END;
$$ LANGUAGE plpgsql;