DO $$
BEGIN
DELETE FROM sl_rk_osn WHERE rk_osn IN (select "R_TABLE"::bigint from ora_replog999 WHERE "N_TABLE" = 'SL_RK_OSN' and "OPER" = 'D');
DELETE FROM ora_replog999 WHERE "N_TABLE" = 'SL_RK_OSN' AND "OPER" = 'D';
END;
$$ LANGUAGE plpgsql;