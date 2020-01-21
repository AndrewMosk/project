DO $$
BEGIN
DELETE FROM pers_rezdoc WHERE r IN (select "R_TABLE" from ora_replog999 WHERE "N_TABLE" = 'PERS_REZDOC' and "OPER" = 'D');
DELETE FROM ora_replog999 WHERE "N_TABLE" = 'PERS_REZDOC' AND "OPER" = 'D';
END;
$$ LANGUAGE plpgsql;