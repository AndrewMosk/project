DO $$
BEGIN
INSERT INTO
	sl_plc ("plc_cod", "parent_cod", "plc_name", "adress", "cz_cod", "pr", "repl", "ip_address", "framerelay", "note", "router", "back_up")
SELECT "plc_cod", "parent_cod", "plc_name", "adress", "cz_cod", "pr", "repl", "ip_address", "framerelay", "note", "router", "back_up"
FROM ora_sl_plc WHERE ora_sl_plc.plc_cod = '%s'
ON CONFLICT ("plc_cod") DO UPDATE SET "parent_cod" = EXCLUDED.parent_cod, "plc_name" = EXCLUDED.plc_name, "adress" = EXCLUDED.adress, "cz_cod" = EXCLUDED.cz_cod, 
		"pr" = EXCLUDED.pr, "repl" = EXCLUDED.repl, "ip_address" = EXCLUDED.ip_address, "framerelay" = EXCLUDED.framerelay, "note" = EXCLUDED.note, 
		"router" = EXCLUDED.router, "back_up" = EXCLUDED.back_up;
--удаляю обработанные строки из оракл		
DELETE FROM ora_replog999 WHERE "N_TABLE" = 'SL_PLC' AND "R_TABLE" = '%s';
END;
$$ LANGUAGE plpgsql;