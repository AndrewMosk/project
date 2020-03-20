DO $$
BEGIN
DELETE FROM s_ost WHERE r IN (select "R_TABLE"::bigint from ora_replog999 WHERE "N_TABLE" = 'S_OST' and "OPER" = 'D');
DELETE FROM ora_replog999 WHERE "N_TABLE" = 'S_OST' AND "OPER" = 'D';
END;
$$ LANGUAGE plpgsql;