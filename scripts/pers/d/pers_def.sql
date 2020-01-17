DO $$
BEGIN
DELETE FROM pers_def WHERE r IN (select "R_TABLE"::bigint from ora_replog999 WHERE "N_TABLE" = 'PERS_DEF' and "OPER" = 'D');
DELETE FROM ora_replog999 WHERE "N_TABLE" = 'PERS_DEF' AND "OPER" = 'D';
END;
$$ LANGUAGE plpgsql;