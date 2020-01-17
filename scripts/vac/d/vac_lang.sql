DO $$
BEGIN
DELETE FROM vac_lang WHERE r IN (select "R_TABLE"::bigint from ora_replog999 WHERE "N_TABLE" = 'VAC_LANG' and "OPER" = 'D');
DELETE FROM ora_replog999 WHERE "N_TABLE" = 'VAC_LANG' AND "OPER" = 'D';
END;
$$ LANGUAGE plpgsql;