DO $$
BEGIN
DELETE FROM vac_spar WHERE r IN (select "R_TABLE"::bigint from ora_replog999 WHERE "N_TABLE" = 'VAC_SPAR' and "OPER" = 'D');
DELETE FROM ora_replog999 WHERE "N_TABLE" = 'VAC_SPAR' AND "OPER" = 'D';
END;
$$ LANGUAGE plpgsql;