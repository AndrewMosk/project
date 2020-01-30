DO $$
BEGIN
INSERT INTO
	sl_addrobj ("aoguid", "formalname", "regioncode", "autocode", "areacode", "citycode", "ctarcode", "placecode", "streetcode", "extrcode", "sextcode", "offname", 
		"postalcode", "ifnsfl", "terrifnsfl", "ifnsul", "terrifnsul", "okato", "oktmo", "updatedate", "shortname", "aolevel", "parentguid", "previd", "nextid", 
		"code", "plaincode", "actstatus", "centstatus", "operstatus", "currstatus", "startdate", "enddate", "normdoc")
SELECT "aoguid", "formalname", "regioncode", "autocode", "areacode", "citycode", "ctarcode", "placecode", "streetcode", "extrcode", "sextcode", "offname", 
		"postalcode", "ifnsfl", "terrifnsfl", "ifnsul", "terrifnsul", "okato", "oktmo", "updatedate", "shortname", "aolevel", "parentguid", "previd", "nextid", 
		"code", "plaincode", "actstatus", "centstatus", "operstatus", "currstatus", "startdate", "enddate", "normdoc"
FROM ora_sl_addrobj WHERE ora_sl_addrobj.aoid  = '%s'
ON CONFLICT ("aoid") DO UPDATE SET "aoguid" = EXCLUDED.aoguid, "formalname" = EXCLUDED.formalname, "regioncode" = EXCLUDED.regioncode, "autocode" = EXCLUDED.autocode, 
		"areacode" = EXCLUDED.areacode, "citycode" = EXCLUDED.citycode, "ctarcode" = EXCLUDED.ctarcode, "placecode" = EXCLUDED.placecode, 
		"streetcode" = EXCLUDED.streetcode, "extrcode" = EXCLUDED.extrcode, "sextcode" = EXCLUDED.sextcode, "offname" = EXCLUDED.offname, 
		"postalcode" = EXCLUDED.postalcode, "ifnsfl" = EXCLUDED.ifnsfl, "terrifnsfl" = EXCLUDED.terrifnsfl, "ifnsul" = EXCLUDED.ifnsul, 
		"terrifnsul" = EXCLUDED.terrifnsul, "okato" = EXCLUDED.okato, "oktmo" = EXCLUDED.oktmo, "updatedate" = EXCLUDED.updatedate, "shortname" = EXCLUDED.shortname, 
		"aolevel" = EXCLUDED.aolevel, "parentguid" = EXCLUDED.parentguid, "previd" = EXCLUDED.previd, "nextid" = EXCLUDED.nextid, "code" = EXCLUDED.code, 
		"plaincode" = EXCLUDED.plaincode, "actstatus" = EXCLUDED.actstatus, "centstatus" = EXCLUDED.centstatus, "operstatus" = EXCLUDED.operstatus, 
		"currstatus" = EXCLUDED.currstatus, "startdate" = EXCLUDED.startdate, "enddate" = EXCLUDED.enddate, "normdoc" = EXCLUDED.normdoc;
--удаляю обработанные строки из оракл		
DELETE FROM ora_replog999 WHERE "N_TABLE" = 'SL_ADDROBJ' AND "R_TABLE"  = '%s';
END;
$$ LANGUAGE plpgsql;