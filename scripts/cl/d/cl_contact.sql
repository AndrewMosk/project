DO $$
BEGIN
DELETE FROM cl_contact WHERE c_contact IN (select "R_TABLE"::bigint from ora_replog999 WHERE "N_TABLE" = 'CL_CONTACT' and "OPER" = 'D');
DELETE FROM ora_replog999 WHERE "N_TABLE" = 'CL_CONTACT' AND "OPER" = 'D';
END;
$$ LANGUAGE plpgsql;