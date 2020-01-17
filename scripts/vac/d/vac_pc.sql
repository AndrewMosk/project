DO $$
BEGIN
DELETE FROM vac_pc WHERE r IN (select "R_TABLE"::bigint from ora_replog999 WHERE "N_TABLE" = 'VAC_PC' and "OPER" = 'D');
DELETE FROM ora_replog999 WHERE "N_TABLE" = 'VAC_PC' AND "OPER" = 'D';
END;
$$ LANGUAGE plpgsql;