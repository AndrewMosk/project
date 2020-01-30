DO $$
BEGIN
DELETE FROM sl_rez_det WHERE rez_det IN (select "R_TABLE"::bigint from ora_replog999 WHERE "N_TABLE" = 'SL_REZ_DET' and "OPER" = 'D');
DELETE FROM ora_replog999 WHERE "N_TABLE" = 'SL_REZ_DET' AND "OPER" = 'D';
END;
$$ LANGUAGE plpgsql;