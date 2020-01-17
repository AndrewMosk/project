DO $$
BEGIN
DELETE FROM s_dep WHERE r IN (select "R_TABLE"::bigint from ora_replog999 WHERE "N_TABLE" = 'S_DEP' and "OPER" = 'D');
DELETE FROM ora_replog999 WHERE "N_TABLE" = 'S_DEP' AND "OPER" = 'D';
END;
$$ LANGUAGE plpgsql;