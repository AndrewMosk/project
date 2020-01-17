DO $$
BEGIN
DELETE FROM vac_def WHERE r IN (select "R_TABLE"::bigint from ora_replog999 WHERE "N_TABLE" = 'VAC_DEF' and "OPER" = 'D');
DELETE FROM ora_replog999 WHERE "N_TABLE" = 'VAC_DEF' AND "OPER" = 'D';
END;
$$ LANGUAGE plpgsql;