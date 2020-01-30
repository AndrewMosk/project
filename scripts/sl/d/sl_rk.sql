DO $$
BEGIN
DELETE FROM sl_rk WHERE rk_cod IN (select "R_TABLE"::bigint from ora_replog999 WHERE "N_TABLE" = 'SL_RK' and "OPER" = 'D');
DELETE FROM ora_replog999 WHERE "N_TABLE" = 'SL_RK' AND "OPER" = 'D';
END;
$$ LANGUAGE plpgsql;