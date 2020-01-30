DO $$
BEGIN
DELETE FROM sl_statpok WHERE r_pok IN (select "R_TABLE"::bigint from ora_replog999 WHERE "N_TABLE" = 'SL_STATPOK' and "OPER" = 'D');
DELETE FROM ora_replog999 WHERE "N_TABLE" = 'SL_STATPOK' AND "OPER" = 'D';
END;
$$ LANGUAGE plpgsql;