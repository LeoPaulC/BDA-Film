DROP TRIGGER IF EXISTS manage_lieu ON lieu;
DROP FUNCTION IF EXISTS gestion_lieu;
DROP FUNCTION IF EXISTS create_lieu;


CREATE OR REPLACE FUNCTION create_lieu(departement integer, ville varchar, pays varchar, adresse varchar, postal varchar, localisation integer)
RETURNS INTEGER AS $$
	
	insert into lieu (departement, ville, pays, adresse, code_postal, id_localisation) values
		(departement,ville,pays,adresse,postal,localisation) 
		RETURNING id_lieu;

$$ LANGUAGE SQL;


CREATE OR REPLACE FUNCTION gestion_lieu() RETURNS TRIGGER AS $$
DECLARE
	operation varchar := TG_OP;
BEGIN
RETURN NEW;
	--IF operation = 'INSERT' THEN 
END
$$ LANGUAGE plpgsql;


CREATE TRIGGER manage_lieu	
	BEFORE INSERT on lieu
	FOR EACH ROW
	EXECUTE PROCEDURE gestion_lieu();