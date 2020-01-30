DO $$
BEGIN
DELETE FROM sl_house WHERE houseid IN (select "R_TABLE" from ora_replog999 WHERE "N_TABLE" = 'SL_HOUSE' and "OPER" = 'D');
DELETE FROM ora_replog999 WHERE "N_TABLE" = 'SL_HOUSE' AND "OPER" = 'D';
END;
$$ LANGUAGE plpgsql;