DO $$
BEGIN
DELETE FROM s_fil WHERE otd_cod IN (select "R_TABLE"::bigint from ora_replog999 WHERE "N_TABLE" = 'S_FIL' and "OPER" = 'D');
DELETE FROM ora_replog999 WHERE "N_TABLE" = 'S_FIL' AND "OPER" = 'D';
END;
$$ LANGUAGE plpgsql;