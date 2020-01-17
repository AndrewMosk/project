DO $$
BEGIN
DELETE FROM vac_lg WHERE r IN (select "R_TABLE"::bigint from ora_replog999 WHERE "N_TABLE" = 'VAC_LG' and "OPER" = 'D');
DELETE FROM ora_replog999 WHERE "N_TABLE" = 'VAC_LG' AND "OPER" = 'D';
END;
$$ LANGUAGE plpgsql;