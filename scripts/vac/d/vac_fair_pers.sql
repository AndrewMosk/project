DO $$
BEGIN
DELETE FROM vac_fair_pers WHERE r IN (select "R_TABLE"::bigint from ora_replog999 WHERE "N_TABLE" = 'VAC_FAIR_PERS' and "OPER" = 'D');
DELETE FROM ora_replog999 WHERE "N_TABLE" = 'VAC_FAIR_PERS' AND "OPER" = 'D';
END;
$$ LANGUAGE plpgsql;