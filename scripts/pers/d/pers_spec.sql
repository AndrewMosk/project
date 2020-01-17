DO $$
BEGIN
DELETE FROM pers_spec WHERE r IN (select "R_TABLE"::bigint from ora_replog999 WHERE "N_TABLE" = 'PERS_SPEC' and "OPER" = 'D');
DELETE FROM ora_replog999 WHERE "N_TABLE" = 'PERS_SPEC' AND "OPER" = 'D';
END;
$$ LANGUAGE plpgsql;