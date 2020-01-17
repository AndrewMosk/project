DO $$
BEGIN
DELETE FROM vac_agr WHERE vac_num IN (select "R_TABLE"::bigint from ora_replog999 WHERE "N_TABLE" = 'VAC_AGR' and "OPER" = 'D');
DELETE FROM ora_replog999 WHERE "N_TABLE" = 'VAC_AGR' AND "OPER" = 'D';
END;
$$ LANGUAGE plpgsql;