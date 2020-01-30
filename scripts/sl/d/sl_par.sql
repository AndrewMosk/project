DO $$
BEGIN
DELETE FROM sl_par WHERE cd_par IN (select "R_TABLE"::bigint from ora_replog999 WHERE "N_TABLE" = 'SL_PAR' and "OPER" = 'D');
DELETE FROM ora_replog999 WHERE "N_TABLE" = 'SL_PAR' AND "OPER" = 'D';
END;
$$ LANGUAGE plpgsql;