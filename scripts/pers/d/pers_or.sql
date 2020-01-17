DO $$
BEGIN
DELETE FROM pers_or WHERE dir_num IN (select "R_TABLE"::bigint from ora_replog999 WHERE "N_TABLE" = 'PERS_OR' and "OPER" = 'D');
DELETE FROM ora_replog999 WHERE "N_TABLE" = 'PERS_OR' AND "OPER" = 'D';
END;
$$ LANGUAGE plpgsql;