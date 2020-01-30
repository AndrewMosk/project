DO $$
BEGIN
DELETE FROM sl_ok_kzot WHERE id_article IN (select "R_TABLE"::bigint from ora_replog999 WHERE "N_TABLE" = 'SL_OK_KZOT' and "OPER" = 'D');
DELETE FROM ora_replog999 WHERE "N_TABLE" = 'SL_OK_KZOT' AND "OPER" = 'D';
END;
$$ LANGUAGE plpgsql;