DO $$
BEGIN
DELETE FROM vac_cr WHERE r IN (select "R_TABLE"::bigint from ora_replog999 WHERE "N_TABLE" = 'VAC_CR' and "OPER" = 'D');
DELETE FROM ora_replog999 WHERE "N_TABLE" = 'VAC_CR' AND "OPER" = 'D';
END;
$$ LANGUAGE plpgsql;