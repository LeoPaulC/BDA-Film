DROP TRIGGER IF EXISTS manage_edition ON edition;
DROP FUNCTION IF EXISTS gestion_edition;
DROP FUNCTION IF EXISTS create_edtion;



CREATE OR REPLACE FUNCTION create_edtion(debut date, fin date, lieu integer, festival integer, capacite integer) RETURNS VOID AS $$
	insert INTO  edition
		(date_debut,date_fin,id_lieu,id_festival,Capacite_max_place) values
		(debut,fin,lieu,festival,capacite);

$$ LANGUAGE SQL;



CREATE OR REPLACE FUNCTION gestion_edition() RETURNS TRIGGER AS $$
DECLARE
	operation VARCHAR(80) := TG_OP;
	ed edition;
BEGIN
-- on verifie si l'edition correspond à un festival existant
	PERFORM * FROM festival WHERE festival.id_festival = NEW.id_festival;
	IF NOT FOUND
		THEN RAISE EXCEPTION '

le festival en  question (id : %), n existe pas
',NEW.id_festival;
	END IF;
-- on verifie si l'edition se déroulera dans un lieu existant
	PERFORM * FROM lieu WHERE lieu.id_lieu = NEW.id_lieu;
	IF NOT FOUND 
		THEN RAISE EXCEPTION '

le lieu en  question (id : %), n existe pas
',NEW.id_lieu;
	END IF;

	IF operation = 'UPDATE'
		THEN IF OLD.id_edition <> NEW.id_edition
			THEN RAISE EXCEPTION '

vous ne pouvez pas changer l identificateur
du tuple correspondant à l edition en question,
 id : % 
 ',OLD.id_edition;			
		END IF;
	END IF;

-- in verifie s'il existe une edition de festival prévu 
-- sur le même lieu avec des dates chevauchant celles
-- de la nouvelle édition 
	PERFORM * from  edition
	where id_lieu = NEW.id_lieu and (
	(NEW.date_debut <= date_debut and date_debut <= NEW.date_fin ) or
	(NEW.date_debut <= date_fin and date_fin <= NEW.date_fin ) or
	(date_debut < NEW.date_debut and date_fin > NEW.date_fin) );

	IF FOUND THEN RAISE EXCEPTION '

les dates saisies chevauchent celles d une autre édition ayant lieu
au même endroit
';
	END IF;
	RETURN NEW;

END
$$ LANGUAGE plpgsql;

CREATE TRIGGER manage_edition
	BEFORE INSERT OR UPDATE ON edition
	FOR EACH ROW 
	EXECUTE PROCEDURE gestion_edition();


--select create_edtion('2004-08-29'::date, '2004-09-01'::date,101,100,5000);




--select * from gestion_deroulement_edition('2004-08-29'::date, '2004-09-01'::date,11);