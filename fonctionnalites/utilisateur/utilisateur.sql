DROP TRIGGER IF EXISTS manage_utilisateur ON utilisateur;
DROP FUNCTION IF EXISTS gestion_utilisateur;
DROP FUNCTION IF EXISTS liste_film_edition_festival;
DROP FUNCTION IF EXISTS recherche_participant_film;
DROP FUNCTION IF EXISTS consultation_film_annee;
DROP FUNCTION IF EXISTS consultation_all_film;
DROP FUNCTION IF EXISTS consultation_festival_description;
DROP FUNCTION IF EXISTS consultation_festival_annee;
DROP FUNCTION IF EXISTS consultation_festival_nom;
DROP FUNCTION IF EXISTS consultation_all_festival;
DROP FUNCTION IF EXISTS create_utilisateur;
DROP TYPE IF EXISTS donne_participant;
--DROP FUNCTION IF EXISTS suppression_utilisateur;

CREATE OR REPLACE FUNCTION create_utilisateur(email VARCHAR(100), mdp VARCHAR(50), nom VARCHAR(80), prenom VARCHAR(80), date_n date)
RETURNS INTEGER AS $$
DECLARE
	id_compte INTEGER;
	id_personne INTEGER;
	id_lieu INTEGER;
	id INTEGER;
BEGIN
	id_compte := create_compte();
	RAISE NOTICE '

id du compte pour l utilisateur : %',id_compte;
	-- id_personne := create_personne();
	SELECT Personne.Id_personne INTO id_personne FROM Personne WHERE 
						Nom_personne = nom AND
						Prenom_personne = prenom AND
						date_n = Date_naissance;
	IF NOT FOUND 
		THEN 	RAISE NOTICE '

création d une nouvelle personne ';
				id_personne := create_personne(nom,prenom,date_n);
	ELSE	RAISE NOTICE '

la personne : %, % est déjà enregistrée 
et possède l identificateur : %',nom,prenom,id_personne;
	END IF;
	INSERT INTO Utilisateur(Email, Mdp, Id_personne, Id_compte) VALUES (
		email,
		mdp,
		id_personne,
		id_compte
	) RETURNING Id_utilisateur INTO id;
	RAISE NOTICE '

création de l utilisateur ayant pour :
_id : %,
_id de persnne : %,
_id de compte : %',id,id_personne,id_compte;
	RETURN id;
END
$$ LANGUAGE plpgsql;


CREATE OR REPLACE FUNCTION suppression_utilisateur(num_compte INTEGER) RETURNS VOID AS $$
DECLARE
BEGIN
	PERFORM * FROM Compte WHERE Compte.Id_compte = num_compte;
	IF FOUND 
		THEN DELETE FROM Compte WHERE Compte.Id_compte = num_compte;
	END IF;
END
$$ LANGUAGE plpgsql;



-- 	------- PARTIES DES FONCTIONNALITES COMPOSEE DE REQUETES : -------

-- Un utilisateur peut consulter un registre contenant un ensemble de festival.

-- recherche tout les festivals
CREATE OR REPLACE FUNCTION consultation_all_festival() RETURNS setof festival AS $$
	select * from festival 
	order by date_creation desc;
$$ LANGUAGE SQL;

-- recherche de festival par nom
CREATE OR REPLACE FUNCTION consultation_festival_nom(nom varchar) RETURNS setof festival AS $$
	select * from festival 
	where nom_festival = nom
	order by date_creation desc ;
$$ LANGUAGE SQL;

-- recherche de festival par année de création
CREATE OR REPLACE FUNCTION consultation_festival_annee(annee date) RETURNS setof festival AS $$
	select * from festival 
	where date_creation = annee
	order by date_creation desc;
$$ LANGUAGE SQL;

-- recherche de festival par description
CREATE OR REPLACE FUNCTION consultation_festival_description(des varchar) RETURNS setof festival AS $$
	select * from festival where description = des;
$$ LANGUAGE SQL;



-- Un utilisateur peut consulter un registre contenant un ensemble de film.

-- recherche tout les films
CREATE OR REPLACE FUNCTION consultation_all_film() RETURNS setof film AS $$
	select * from film
	order by nom_film asc;
$$ LANGUAGE SQL;

-- recherche de film par date de 
CREATE OR REPLACE FUNCTION consultation_film_annee(sortie integer) RETURNS setof film AS $$
	select * from film where annee = sortie
	order by nom_film asc;
$$ LANGUAGE SQL;

-- Un utilisateur peut accéder à la liste des personnes ayant participé à un film.

CREATE TYPE donne_participant AS (nom varchar, prenom varchar, role varchar);

CREATE OR REPLACE FUNCTION recherche_participant_film(film INTEGER) RETURNS setof donne_participant AS $$
	select nom, prenom,role
	from participant natural join personne
	where id_film = film
	order by nom asc;
$$ LANGUAGE SQL;


-- Un utilisateur peut consulter une liste de film liés à une édition d’un festival.

CREATE OR REPLACE FUNCTION liste_film_edition_festival(edition integer) RETURNS setof film AS $$
	select *
	from (select id_film 
		from film_edition 
		where id_edition = edition)filmedit natural join film
	order by nom_film asc;
$$LANGUAGE SQL;




-- gestion de contrainte : TRIGGER + FONCTION ASSOCIEE

CREATE OR REPLACE FUNCTION gestion_utilisateur() RETURNS TRIGGER AS $$
DECLARE
	operation VARCHAR(80) := TG_OP;
	id_compte INTEGER;
BEGIN
	IF operation = 'UPDATE'
		THEN RAISE EXCEPTION 'vous ne pouvez change le comptee d un utilisateur';
	END IF;
END
$$ LANGUAGE plpgsql;


CREATE TRIGGER manage_utilisateur
	BEFORE UPDATE ON Utilisateur
	FOR EACH ROW 
	WHEN (OLD.Id_compte <> NEW.Id_compte)
	EXECUTE PROCEDURE gestion_utilisateur();


-- EXECUTE 'SELECT count(*) FROM matable WHERE insere_par = $1 AND insere <= $2'
--   INTO c
--   USING utilisateur_verifie, date_verifiee;
