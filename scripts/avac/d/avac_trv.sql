DO $$
BEGIN
DELETE FROM avac_trv WHERE к IN (select "R_TABLE"::bigint from ora_replog999 WHERE "N_TABLE" = 'AVAC_TRV' and "OPER" = 'D');
DELETE FROM ora_replog999 WHERE "N_TABLE" = 'AVAC_TRV' AND "OPER" = 'D';
END;
$$ LANGUAGE plpgsql;