DO $$
BEGIN
INSERT INTO
	sl_statstr ("str_cod", "str_name", "table_name", "p_modi", "d_modi")
SELECT "str_cod", "str_name", "table_name", "pers_modi" AS "p_modi", "d_modi"
FROM ora_sl_statstr WHERE ora_sl_statstr.str_cod = '%s'
ON CONFLICT ("str_cod") DO UPDATE SET "str_name" = EXCLUDED.str_name, "table_name" = EXCLUDED.table_name, "p_modi" = EXCLUDED.p_modi, "d_modi" = EXCLUDED.d_modi;
--удаляю обработанные строки из оракл		
DELETE FROM ora_replog999 WHERE "N_TABLE" = 'SL_STATSTR' AND "R_TABLE" = '%s';
END;
$$ LANGUAGE plpgsql;