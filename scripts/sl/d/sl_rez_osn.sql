DO $$
BEGIN
DELETE FROM sl_rez_osn WHERE rez_osn IN (select "R_TABLE"::bigint from ora_replog999 WHERE "N_TABLE" = 'SL_REZ_OSN' and "OPER" = 'D');
DELETE FROM ora_replog999 WHERE "N_TABLE" = 'SL_REZ_OSN' AND "OPER" = 'D';
END;
$$ LANGUAGE plpgsql;