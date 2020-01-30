DO $$
BEGIN
DELETE FROM sl_rez WHERE rez_cod IN (select "R_TABLE"::bigint from ora_replog999 WHERE "N_TABLE" = 'SL_REZ' and "OPER" = 'D');
DELETE FROM ora_replog999 WHERE "N_TABLE" = 'SL_REZ' AND "OPER" = 'D';
END;
$$ LANGUAGE plpgsql;