DO $$
BEGIN
DELETE FROM sl_oksm WHERE oksm_cod IN (select "R_TABLE"::bigint from ora_replog999 WHERE "N_TABLE" = 'SL_OKSM' and "OPER" = 'D');
DELETE FROM ora_replog999 WHERE "N_TABLE" = 'SL_OKSM' AND "OPER" = 'D';
END;
$$ LANGUAGE plpgsql;