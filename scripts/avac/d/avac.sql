DO $$
BEGIN
DELETE FROM avac WHERE vac_num IN (select "R_TABLE"::bigint from ora_replog999 WHERE "N_TABLE" = 'AVAC' and "OPER" = 'D');
DELETE FROM ora_replog999 WHERE "N_TABLE" = 'AVAC' AND "OPER" = 'D';
END;
$$ LANGUAGE plpgsql;