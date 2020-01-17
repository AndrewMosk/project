DO $$
BEGIN
DELETE FROM vac_kvot_rm WHERE r IN (select "R_TABLE"::bigint from ora_replog999 WHERE "N_TABLE" = 'VAC_KVOT_RM' and "OPER" = 'D');
DELETE FROM ora_replog999 WHERE "N_TABLE" = 'VAC_KVOT_RM' AND "OPER" = 'D';
END;
$$ LANGUAGE plpgsql;