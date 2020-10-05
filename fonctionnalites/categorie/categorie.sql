DROP TRIGGER IF EXISTS manage_categorie ON categorie;
DROP FUNCTION IF EXISTS gestion_categorie;
DROP FUNCTION IF EXISTS create_categorie;

CREATE OR REPLACE FUNCTION create_categorie(id_edition integer, descriptif varchar, capacite integer, prix integer)
RETURNS void AS $$

	insert INTO categorie(id_edition,descriptif,capacite,prix) values 
		(id_edition,descriptif,capacite,prix);
$$ LANGUAGE SQL; 


CREATE OR REPLACE FUNCTION gestion_categorie() RETURNS TRIGGER AS $$
DECLARE
	operation varchar := TG_OP;
	cap_totale integer;
	cap_libre integer;
	descrip varchar;
BEGIN 
	IF NEW.capacite = 0 THEN RAISE EXCEPTION '

La capacite d une catégorie ne peut pas être de 0 !
';
	END IF;

	SELECT capacite_max_place INTO cap_totale FROM edition WHERE edition.id_edition = NEW.id_edition; 
	SELECT SUM(capacite) INTO cap_libre FROM categorie WHERE categorie.id_edition = NEW.id_edition;
	cap_libre := cap_totale - cap_libre;
	IF NEW.capacite > cap_libre THEN RAISE EXCEPTION '
	
La capacité de la catégorie (%) est supérieur au nombre de 
place disponible pour la création d une nouvelle catégorie (%)
',NEW.capacite,cap_libre ;
	END IF;

	PERFORM * FROM categorie WHERE categorie.descriptif = NEW.descriptif;
	IF FOUND THEN RAISE EXCEPTION '

Une catégorie de même descriptif existe déjà pour cette édition
';
	END IF;

END
$$ LANGUAGE plpgsql;





CREATE TRIGGER manage_categorie
	BEFORE INSERT ON categorie
	FOR EACH ROW 
	EXECUTE PROCEDURE gestion_categorie();

--insert INTO categorie(id_edition,descriptif,capacite,prix) values (5,'Eco',20,0);