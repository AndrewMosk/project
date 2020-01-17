DO $$
BEGIN
DELETE FROM vac_kvot_doc WHERE r IN (select "R_TABLE"::bigint from ora_replog999 WHERE "N_TABLE" = 'VAC_KVOT_DOC' and "OPER" = 'D');
DELETE FROM ora_replog999 WHERE "N_TABLE" = 'VAC_KVOT_DOC' AND "OPER" = 'D';
END;
$$ LANGUAGE plpgsql;