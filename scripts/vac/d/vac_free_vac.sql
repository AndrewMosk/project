DO $$
BEGIN
DELETE FROM vac_free_vac WHERE r IN (select "R_TABLE"::bigint from ora_replog999 WHERE "N_TABLE" = 'VAC_FREE_VAC' and "OPER" = 'D');
DELETE FROM ora_replog999 WHERE "N_TABLE" = 'VAC_FREE_VAC' AND "OPER" = 'D';
END;
$$ LANGUAGE plpgsql;