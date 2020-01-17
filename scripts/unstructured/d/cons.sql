DO $$
BEGIN
DELETE FROM cons WHERE r IN (select "R_TABLE"::bigint from ora_replog999 WHERE "N_TABLE" = 'CONS' and "OPER" = 'D');
DELETE FROM ora_replog999 WHERE "N_TABLE" = 'CONS' AND "OPER" = 'D';
END;
$$ LANGUAGE plpgsql;