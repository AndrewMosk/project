DO $$
BEGIN
DELETE FROM pers_ask_plist WHERE r IN (select "R_TABLE"::bigint from ora_replog999 WHERE "N_TABLE" = 'ASK_PLIST' and "OPER" = 'D');
DELETE FROM ora_replog999 WHERE "N_TABLE" = 'ASK_PLIST' AND "OPER" = 'D';
END;
$$ LANGUAGE plpgsql;