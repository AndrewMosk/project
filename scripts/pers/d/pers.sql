DO $$
BEGIN
DELETE FROM pers WHERE reg_num IN (select "R_TABLE"::bigint from ora_replog999 WHERE "N_TABLE" = 'PERS' and "OPER" = 'D');
DELETE FROM ora_replog999 WHERE "N_TABLE" = 'PERS' AND "OPER" = 'D';
END;
$$ LANGUAGE plpgsql;