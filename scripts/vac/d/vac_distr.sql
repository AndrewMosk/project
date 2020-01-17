DO $$
BEGIN
DELETE FROM vac_distr WHERE r IN (select "R_TABLE"::bigint from ora_replog999 WHERE "N_TABLE" = 'VAC_DISTR' and "OPER" = 'D');
DELETE FROM ora_replog999 WHERE "N_TABLE" = 'VAC_DISTR' AND "OPER" = 'D';
END;
$$ LANGUAGE plpgsql;