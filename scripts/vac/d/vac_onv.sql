DO $$
BEGIN
DELETE FROM vac_onv WHERE r IN (select "R_TABLE"::bigint from ora_replog999 WHERE "N_TABLE" = 'VAC_ONV' and "OPER" = 'D');
DELETE FROM ora_replog999 WHERE "N_TABLE" = 'VAC_ONV' AND "OPER" = 'D';
END;
$$ LANGUAGE plpgsql;