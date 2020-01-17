DO $$
BEGIN
DELETE FROM vac_history WHERE r IN (select "R_TABLE"::bigint from ora_replog999 WHERE "N_TABLE" = 'VAC_HISTORY' and "OPER" = 'D');
DELETE FROM ora_replog999 WHERE "N_TABLE" = 'VAC_HISTORY' AND "OPER" = 'D';
END;
$$ LANGUAGE plpgsql;