DO $$
BEGIN
DELETE FROM pers_ask_or WHERE reg_num IN (select "R_TABLE"::bigint from ora_replog999 WHERE "N_TABLE" = 'ASK_OR' and "OPER" = 'D');
DELETE FROM ora_replog999 WHERE "N_TABLE" = 'ASK_OR' AND "OPER" = 'D';
END;
$$ LANGUAGE plpgsql;