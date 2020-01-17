DO $$
BEGIN
DELETE FROM vac_fair WHERE r IN (select "R_TABLE"::bigint from ora_replog999 WHERE "N_TABLE" = 'VAC_FAIR' and "OPER" = 'D');
DELETE FROM ora_replog999 WHERE "N_TABLE" = 'VAC_FAIR' AND "OPER" = 'D';
END;
$$ LANGUAGE plpgsql;