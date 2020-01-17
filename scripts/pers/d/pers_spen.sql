DO $$
BEGIN
DELETE FROM pers_spen WHERE r IN (select "R_TABLE"::bigint from ora_replog999 WHERE "N_TABLE" = 'PERS_SPEN' and "OPER" = 'D');
DELETE FROM ora_replog999 WHERE "N_TABLE" = 'PERS_SPEN' AND "OPER" = 'D';
END;
$$ LANGUAGE plpgsql;