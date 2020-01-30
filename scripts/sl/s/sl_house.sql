DO $$
BEGIN
INSERT INTO
	sl_house ("postalcode", "ifnsfl", "terrifnsfl", "ifnsul", "terrifnsul", "okato", "oktmo", "updatedate", "housenum", "eststatus", "buildnum", "strucnum", 
		"strstatus", "houseid", "houseguid", "aoguid", "startdate", "enddate", "statstatus", "normdoc", "counter")
SELECT "postalcode", "ifnsfl", "terrifnsfl", "ifnsul", "terrifnsul", "okato", "oktmo", "updatedate", "housenum", "eststatus", "buildnum", "strucnum", 
		"strstatus", "houseid", "houseguid", "aoguid", "startdate", "enddate", "statstatus", "normdoc", "counter"
FROM ora_sl_house WHERE ora_sl_house.houseid = '%s'
ON CONFLICT ("houseid") DO UPDATE SET "postalcode" = EXCLUDED.postalcode, "ifnsfl" = EXCLUDED.ifnsfl, "terrifnsfl" = EXCLUDED.terrifnsfl, "ifnsul" = EXCLUDED.ifnsul, 
		"terrifnsul" = EXCLUDED.terrifnsul, "okato" = EXCLUDED.okato, "oktmo" = EXCLUDED.oktmo, "updatedate" = EXCLUDED.updatedate, "housenum" = EXCLUDED.housenum, 
		"eststatus" = EXCLUDED.eststatus, "buildnum" = EXCLUDED.buildnum, "strucnum" = EXCLUDED.strucnum, "strstatus" = EXCLUDED.strstatus, 
		"houseguid" = EXCLUDED.houseguid, "aoguid" = EXCLUDED.aoguid, "startdate" = EXCLUDED.startdate, "enddate" = EXCLUDED.enddate, "statstatus" = EXCLUDED.statstatus,
		"normdoc" = EXCLUDED.normdoc, "counter" = EXCLUDED.counter;
--удаляю обработанные строки из оракл		
DELETE FROM ora_replog999 WHERE "N_TABLE" = 'SL_HOUSE' AND "R_TABLE" = '%s';
END;
$$ LANGUAGE plpgsql;