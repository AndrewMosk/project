DO $$
BEGIN
DELETE FROM prof_cel WHERE r IN (select "R_TABLE"::bigint from ora_replog999 WHERE "N_TABLE" = 'PROF_CEL' and "OPER" = 'D');
DELETE FROM ora_replog999 WHERE "N_TABLE" = 'PROF_CEL' AND "OPER" = 'D';
END;
$$ LANGUAGE plpgsql;