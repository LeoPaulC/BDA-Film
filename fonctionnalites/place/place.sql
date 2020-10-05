DROP TRIGGER IF EXISTS manage_place ON place;
DROP FUNCTION IF EXISTS gestion_place;
DROP FUNCTION IF EXISTS nombre_place_edition;
DROP FUNCTION IF EXISTS create_place;

CREATE OR REPLACE FUNCTION create_place(nom varchar, prenom varchar, cat integer, utilisateur integer)
RETURNS integer AS $$

	insert into place (nom_place,prenom_place,id_categorie,numero_place,id_utilisateur)
	values
	(nom,prenom,cat,
		(select CAST(COUNT(id_place) AS integer) from place where id_categorie = cat),
	utilisateur
	)RETURNING id_place;
$$ LANGUAGE SQL;

CREATE OR REPLACE FUNCTION nombre_place_edition(id_edition integer, id_utilisateur integer) RETURNS integer AS $$
	select CAST(COUNT(place.id_utilisateur) AS integer)
	from categorie natural join place 
	where categorie.id_edition = id_edition and
	place.id_utilisateur = id_utilisateur;
$$ LANGUAGE SQL;


CREATE OR REPLACE FUNCTION gestion_place() RETURNS TRIGGER AS $$
DECLARE
	nb_place integer := 0;
	edition integer;
BEGIN 
	SELECT id_edition INTO edition FROM categorie WHERE NEW.id_categorie = id_categorie;
	nb_place := nb_place + nombre_place_edition(edition, NEW.id_utilisateur);
	IF nb_place >= 5 THEN RAISE EXCEPTION '
Vous ne pouvez pas réserver plus de 5 places
dans une seule et même catégorie ';
	END IF;
END
$$ LANGUAGE plpgsql;


CREATE TRIGGER manage_place
	BEFORE INSERT on place
	FOR EACH ROW
	EXECUTE PROCEDURE gestion_place();

