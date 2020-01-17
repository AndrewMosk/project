DO $$
BEGIN
DELETE FROM pers_rez WHERE r_rez IN (select "R_TABLE"::bigint from ora_replog999 WHERE "N_TABLE" = 'PERS_REZ' and "OPER" = 'D');
DELETE FROM ora_replog999 WHERE "N_TABLE" = 'PERS_REZ' AND "OPER" = 'D';
END;
$$ LANGUAGE plpgsql;