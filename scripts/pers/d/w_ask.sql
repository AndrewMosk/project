DO $$
BEGIN
DELETE FROM pers_ask WHERE reg_num IN (select "R_TABLE"::bigint from ora_replog999 WHERE "N_TABLE" = 'W_ASK' and "OPER" = 'D');
DELETE FROM ora_replog999 WHERE "N_TABLE" = 'W_ASK' AND "OPER" = 'D';
END;
$$ LANGUAGE plpgsql;