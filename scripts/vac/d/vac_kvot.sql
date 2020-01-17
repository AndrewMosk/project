DO $$
BEGIN
DELETE FROM vac_kvot WHERE pac_num IN (select "R_TABLE"::bigint from ora_replog999 WHERE "N_TABLE" = 'VAC_KVOT' and "OPER" = 'D');
DELETE FROM ora_replog999 WHERE "N_TABLE" = 'VAC_KVOT' AND "OPER" = 'D';
END;
$$ LANGUAGE plpgsql;