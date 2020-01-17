DO $$
BEGIN
DELETE FROM vac_trv WHERE r IN (select "R_TABLE"::bigint from ora_replog999 WHERE "N_TABLE" = 'VAC_TRV' and "OPER" = 'D');
DELETE FROM ora_replog999 WHERE "N_TABLE" = 'VAC_TRV' AND "OPER" = 'D';
END;
$$ LANGUAGE plpgsql;