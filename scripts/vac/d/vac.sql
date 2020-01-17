DO $$
BEGIN
DELETE FROM vac WHERE vac_num IN (select "R_TABLE"::bigint from ora_replog999 WHERE "N_TABLE" = 'VAC' and "OPER" = 'D');
DELETE FROM ora_replog999 WHERE "N_TABLE" = 'VAC' AND "OPER" = 'D';
END;
$$ LANGUAGE plpgsql;