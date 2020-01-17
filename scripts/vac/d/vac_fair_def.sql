DO $$
BEGIN
DELETE FROM vac_fair_def WHERE r IN (select "R_TABLE"::bigint from ora_replog999 WHERE "N_TABLE" = 'VAC_FAIR_DEF' and "OPER" = 'D');
DELETE FROM ora_replog999 WHERE "N_TABLE" = 'VAC_FAIR_DEF' AND "OPER" = 'D';
END;
$$ LANGUAGE plpgsql;