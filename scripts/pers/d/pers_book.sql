DO $$
BEGIN
DELETE FROM pers_book WHERE r IN (select "R_TABLE"::bigint from ora_replog999 WHERE "N_TABLE" = 'PERS_BOOK' and "OPER" = 'D');
DELETE FROM ora_replog999 WHERE "N_TABLE" = 'PERS_BOOK' AND "OPER" = 'D';
END;
$$ LANGUAGE plpgsql;