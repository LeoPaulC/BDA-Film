DROP TABLE IF EXISTS Critique CASCADE;
DROP TABLE IF EXISTS Place CASCADE;
DROP TABLE IF EXISTS Categorie CASCADE;
DROP TABLE IF EXISTS Utilisateur CASCADE;
DROP TABLE IF EXISTS Personne_Invitee CASCADE;
DROP TABLE IF EXISTS Participant CASCADE;
DROP TABLE IF EXISTS Film_Edition CASCADE;
DROP TABLE IF EXISTS Edition CASCADE;
DROP TABLE IF EXISTS Lieu CASCADE;
DROP TABLE IF EXISTS Localisation CASCADE;
DROP TABLE IF EXISTS Site CASCADE;
DROP TABLE IF EXISTS Festival CASCADE;
DROP TABLE IF EXISTS Compte CASCADE;
DROP TABLE IF EXISTS Film CASCADE;
DROP TABLE IF EXISTS Personne CASCADE;


CREATE TABLE Personne(
		Id_personne SERIAL PRIMARY KEY,
		Nom VARCHAR(80) NOT NULL,
		Prenom VARCHAR(80) NOT NULL,
		Date_naissance DATE CHECK (date_naissance < now()- interval'18 year' ) NOT NULL,
		UNIQUE(nom,prenom,date_naissance)
);

CREATE TABLE Film(
		Id_film SERIAL PRIMARY KEY,
		Nom_film VARCHAR(200) NOT NULL,
		Type_film VARCHAR(50) CHECK( Type_film IN ('Docu','Anim', 'Fiction','Animation','Documentaire')),
		Annee INTEGER,
		Realisateur VARCHAR(300),
		Producteur VARCHAR(300)
);


CREATE TABLE Compte(
		Id_compte SERIAL PRIMARY KEY,
		Solde NUMERIC(10,2) CHECK( Solde > Decouvert_autorise) NOT NULL,
		Decouvert_autorise NUMERIC(10,2) NOT NULL DEFAULT -120
);

CREATE TABLE Festival(
		Id_festival SERIAL PRIMARY KEY,
		Theme VARCHAR(60),
		Nom_festival VARCHAR(100) NOT NULL UNIQUE,
		Description VARCHAR(60),
		Periodicite VARCHAR(60),
		Date_creation DATE,
		Website VARCHAR(100)
);


CREATE TABLE Site(
		Id_site SERIAL PRIMARY KEY,
		Nom VARCHAR(50) NOT NULL,
		Lien VARCHAR(50) NOT NULL UNIQUE
);

CREATE TABLE Localisation(
		Id_localisation SERIAL PRIMARY KEY,
		Latitude REAL,
		Longitude REAL
);

CREATE TABLE Lieu(
		Id_lieu SERIAL PRIMARY KEY,
		Departement VARCHAR(50) NOT NULL,
		Ville VARCHAR(50) NOT NULL,
		Pays VARCHAR(50) NOT NULL,
		Adresse VARCHAR(100),
		Code_postal VARCHAR(6) NOT NULL,
		Id_localisation INTEGER REFERENCES Localisation(Id_localisation),
		UNIQUE(Adresse, Code_postal, Id_localisation)
);


CREATE TABLE Edition(
		Id_edition SERIAL PRIMARY KEY,
		Date_debut DATE,
		Date_fin DATE,
		Id_lieu INTEGER REFERENCES Lieu(Id_lieu),
		Id_festival INTEGER REFERENCES Festival(Id_festival),
		Capacite_max_place INTEGER,
		UNIQUE(Id_festival, Date_debut, Date_fin)
);


CREATE TABLE Film_Edition(
		Id_edition INTEGER REFERENCES Edition(Id_edition) ON DELETE CASCADE,
		-- si je supprime une edition, on ne peut plus y présenter de film.
		Id_film INTEGER REFERENCES Film(Id_film) ON DELETE CASCADE,
		-- si je supprime un film, on ne peut plus le présenter à une édition.
		PRIMARY KEY(Id_edition, Id_film)
);

CREATE TABLE Participant(
		Id_participant SERIAL PRIMARY KEY,
		Id_film INTEGER REFERENCES Film(Id_film) ON DELETE CASCADE,
		Id_personne INTEGER REFERENCES Personne(Id_personne) ON DELETE CASCADE,
		Role VARCHAR(50) CHECK(Role IN ('Acteur','Realisateur','Producteur','Cameraman','Cascadeur','Scenariste')) NOT NULL,
		UNIQUE(Id_film, Id_personne, Role)
);

CREATE TABLE Personne_Invitee(
		Id_edition INTEGER REFERENCES Edition(Id_edition) ON DELETE CASCADE,
		Id_participant INTEGER REFERENCES Participant(Id_participant) ON DELETE CASCADE,
		PRIMARY KEY(Id_participant, Id_edition)
);

CREATE TABLE Utilisateur(
		Id_utilisateur SERIAL PRIMARY KEY,
		Email VARCHAR(100) NOT NULL,
		Mdp VARCHAR(50) NOT NULL,
		Telephone VARCHAR(50) DEFAULT NULL,
		Id_lieu INTEGER DEFAULT NULL REFERENCES Lieu(Id_lieu) ON DELETE SET NULL,
		Id_personne INTEGER UNIQUE NOT NULL REFERENCES Personne(Id_personne) ON DELETE CASCADE,
		Id_compte INTEGER UNIQUE NOT NULL REFERENCES Compte(Id_compte) ON DELETE CASCADE,
		UNIQUE(Email,Mdp)
);


CREATE TABLE Categorie(
		Id_categorie SERIAL PRIMARY KEY,
		Id_edition INTEGER REFERENCES Edition(Id_edition) ON DELETE CASCADE,
		Descriptif VARCHAR(50) CHECK(Descriptif IN ('VIP','Premium','Classic','Eco')),
		Capacite INTEGER ,
		Prix INTEGER CHECK(Prix > 0)
);

CREATE TABLE Place(
		Id_place SERIAL PRIMARY KEY,
		Nom_place VARCHAR(50) NOT NULL,
		Prenom_place VARCHAR(50) NOT NULL,
		Id_categorie INTEGER REFERENCES Categorie(Id_categorie) ON DELETE CASCADE,
		Numero_place INTEGER NOT NULL,
		Id_utilisateur INTEGER NOT NULL,
		UNIQUE(Nom_place, Prenom_place),
		UNIQUE(Numero_place,Id_categorie),
		FOREIGN KEY(Id_utilisateur) REFERENCES Utilisateur(Id_utilisateur)
);

CREATE TABLE Critique(
		Id_critique SERIAL PRIMARY KEY,
		Note_globale INTEGER CHECK( Note_globale BETWEEN 0 AND 10) NOT NULL,
		Avis_general VARCHAR(50),
		Id_film INTEGER,
		Id_site INTEGER,
		UNIQUE(Id_film, Id_site),
		FOREIGN KEY(Id_film) REFERENCES Film(Id_film),
		FOREIGN KEY(Id_site) REFERENCES Site(Id_site)		
);
