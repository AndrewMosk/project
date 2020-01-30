DO $$
BEGIN
DELETE FROM sl_are WHERE are_cod IN (select "R_TABLE"::bigint from ora_replog999 WHERE "N_TABLE" = 'SL_ARE' and "OPER" = 'D');
DELETE FROM ora_replog999 WHERE "N_TABLE" = 'SL_ARE' AND "OPER" = 'D';
END;
$$ LANGUAGE plpgsql;