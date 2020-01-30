DO $$
BEGIN
DELETE FROM sl_plc WHERE plc_cod IN (select "R_TABLE"::bigint from ora_replog999 WHERE "N_TABLE" = 'SL_PLC' and "OPER" = 'D');
DELETE FROM ora_replog999 WHERE "N_TABLE" = 'SL_PLC' AND "OPER" = 'D';
END;
$$ LANGUAGE plpgsql;