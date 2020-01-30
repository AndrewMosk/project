DO $$
BEGIN
DELETE FROM sl_gu WHERE gu_cod IN (select "R_TABLE"::bigint from ora_replog999 WHERE "N_TABLE" = 'SL_GU' and "OPER" = 'D');
DELETE FROM ora_replog999 WHERE "N_TABLE" = 'SL_GU' AND "OPER" = 'D';
END;
$$ LANGUAGE plpgsql;