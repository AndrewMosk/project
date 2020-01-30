DO $$
BEGIN
DELETE FROM sl_addrobj WHERE aoguid IN (select "R_TABLE"::bigint from ora_replog999 WHERE "N_TABLE" = 'SL_ADDROBJ' and "OPER" = 'D');
DELETE FROM ora_replog999 WHERE "N_TABLE" = 'SL_ADDROBJ' AND "OPER" = 'D';
END;
$$ LANGUAGE plpgsql;