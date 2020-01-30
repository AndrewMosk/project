DO $$
BEGIN
DELETE FROM sl_vactype WHERE type_cod IN (select "R_TABLE"::bigint from ora_replog999 WHERE "N_TABLE" = 'SL_VACTYPE' and "OPER" = 'D');
DELETE FROM ora_replog999 WHERE "N_TABLE" = 'SL_VACTYPE' AND "OPER" = 'D';
END;
$$ LANGUAGE plpgsql;