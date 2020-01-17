DO $$
BEGIN
DELETE FROM pers_pcl WHERE r IN (select "R_TABLE"::bigint from ora_replog999 WHERE "N_TABLE" = 'PERS_PCL' and "OPER" = 'D');
DELETE FROM ora_replog999 WHERE "N_TABLE" = 'PERS_PCL' AND "OPER" = 'D';
END;
$$ LANGUAGE plpgsql;