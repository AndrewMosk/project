DO $$
BEGIN
DELETE FROM sl_gud WHERE gud_cod IN (select "R_TABLE"::bigint from ora_replog999 WHERE "N_TABLE" = 'SL_GUD' and "OPER" = 'D');
DELETE FROM ora_replog999 WHERE "N_TABLE" = 'SL_GUD' AND "OPER" = 'D';
END;
$$ LANGUAGE plpgsql;