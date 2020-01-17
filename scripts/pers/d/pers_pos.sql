DO $$
BEGIN
DELETE FROM pers_pos WHERE reg_num IN (select "R_TABLE"::bigint from ora_replog999 WHERE "N_TABLE" = 'PERS_POS' and "OPER" = 'D');
DELETE FROM ora_replog999 WHERE "N_TABLE" = 'PERS_POS' AND "OPER" = 'D';
END;
$$ LANGUAGE plpgsql;