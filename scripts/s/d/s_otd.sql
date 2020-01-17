DO $$
BEGIN
DELETE FROM s_otd WHERE otd_cod IN (select "R_TABLE"::bigint from ora_replog999 WHERE "N_TABLE" = 'S_OTD' and "OPER" = 'D');
DELETE FROM ora_replog999 WHERE "N_TABLE" = 'S_OTD' AND "OPER" = 'D';
END;
$$ LANGUAGE plpgsql;