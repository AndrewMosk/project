DO $$
BEGIN
DELETE FROM avac_onv WHERE к IN (select "R_TABLE"::bigint from ora_replog999 WHERE "N_TABLE" = 'AVAC_ONV' and "OPER" = 'D');
DELETE FROM ora_replog999 WHERE "N_TABLE" = 'AVAC_ONV' AND "OPER" = 'D';
END;
$$ LANGUAGE plpgsql;