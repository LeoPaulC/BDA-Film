
DROP TABLE IF EXISTS Critique;
DROP TABLE IF EXISTS Place;
DROP TABLE IF EXISTS Categorie;
DROP TABLE IF EXISTS Utilisateur;
DROP TABLE IF EXISTS Participant;
DROP TABLE IF EXISTS Film_Edition;
DROP TABLE IF EXISTS Personne_Invitee;
DROP TABLE IF EXISTS Edition;
DROP TABLE IF EXISTS Lieu;
DROP TABLE IF EXISTS Localisation;
DROP TABLE IF EXISTS Site_Critique;
DROP TABLE IF EXISTS Festival;
DROP TABLE IF EXISTS Compte;
DROP TABLE IF EXISTS Film;
DROP TABLE IF EXISTS Personne;


CREATE TABLE Personne(
		Id_personne SERIAL PRIMARY KEY,
		Nom_personne VARCHAR(50) NOT NULL,
		Prenom_personne VARCHAR(50) NOT NULL,
		Date_naissance DATE CHECK (date_naissance < now()- interval'18 year' ),
		UNIQUE(nom_personne,prenom_personne,date_naissance)
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


CREATE TABLE Site_Critique(
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
		Code_postale VARCHAR(6) NOT NULL,
		Id_localisation INTEGER REFERENCES Localisation(Id_localisation),
		UNIQUE(Adresse, Code_postale, Id_localisation)
);


CREATE TABLE Edition(
		Id_edition SERIAL PRIMARY KEY,
		Date_debut DATE,
		Date_fin DATE,
		Id_lieu INTEGER,
		Id_festival INTEGER,
		Annee INTEGER,
		Capacite_max_place INTEGER ,
		UNIQUE(Id_festival, Annee, Date_debut, Date_fin),
		FOREIGN KEY(Id_festival) REFERENCES Festival(Id_festival),
		FOREIGN KEY(Id_lieu) REFERENCES Lieu(Id_lieu)
);

CREATE TABLE Personne_Invitee(
		Id_personne INTEGER,
		Id_film INTEGER,
		Id_edition INTEGER,
		Metier VARCHAR(50) CHECK(metier IN ('Acteur','Réalisateur','Producteur','Cameraman')) NOT NULL,
		PRIMARY KEY(Id_personne, Id_film, Id_edition),
		FOREIGN KEY(Id_personne) REFERENCES Personne(Id_personne),
		FOREIGN KEY(Id_film) REFERENCES Film(Id_film),
		FOREIGN KEY(Id_edition) REFERENCES Edition(Id_edition)
);

CREATE TABLE Film_Edition(
		Id_edition INTEGER,
		Id_film INTEGER,
		PRIMARY KEY(Id_edition, Id_film),
		FOREIGN KEY(Id_film) REFERENCES Film(Id_film),
		FOREIGN KEY(Id_edition) REFERENCES Edition(Id_edition)
);

CREATE TABLE Participant(
		Id_participant SERIAL PRIMARY KEY,
		Id_film INTEGER,
		Id_personne INTEGER,
		Role VARCHAR(50) CHECK(Role IN ('Acteur','Realisateur','Producteur','Cameraman')) NOT NULL,
		UNIQUE(Id_film, Id_personne, Role),
		FOREIGN KEY(Id_film) REFERENCES Film(Id_film),
		FOREIGN KEY(Id_personne) REFERENCES Personne(Id_personne)
);

CREATE TABLE Utilisateur(
		Id_user SERIAL PRIMARY KEY,
		Email VARCHAR(100) NOT NULL,
		Mdp VARCHAR(50) NOT NULL,
		Telephone VARCHAR(50),
		Id_lieu INTEGER NOT NULL,
		Id_personne INTEGER UNIQUE NOT NULL,
		Id_compte INTEGER UNIQUE NOT NULL,
		UNIQUE(Email,Mdp),
		FOREIGN KEY(Id_personne) REFERENCES Personne(Id_personne),
		FOREIGN KEY(Id_compte) REFERENCES Compte(Id_compte) ON DELETE CASCADE,
		FOREIGN KEY(Id_lieu) REFERENCES Lieu(Id_lieu)
);


CREATE TABLE Categorie(
		Id_categorie SERIAL PRIMARY KEY,
		Prix INTEGER,
		Descriptif VARCHAR(50),
		Capacite_max INTEGER ,
		Id_edition INTEGER,
		FOREIGN KEY(Id_edition) REFERENCES Edition(Id_edition)
);

CREATE TABLE Place(
		Id_place SERIAL PRIMARY KEY,
		Nom_place VARCHAR(50) NOT NULL,
		Prenom_place VARCHAR(50) NOT NULL,
		Id_categorie INTEGER,
		Numero_place INTEGER,
		Id_user INTEGER,
		UNIQUE(Nom_place, Prenom_place),
		UNIQUE(Numero_place),
		FOREIGN KEY(Id_user) REFERENCES Utilisateur(Id_user),
		FOREIGN KEY(Id_categorie) REFERENCES Categorie(Id_categorie)
);

CREATE TABLE Critique(
		Id_critique SERIAL PRIMARY KEY,
		Note_globale INTEGER CHECK( Note_globale BETWEEN 0 AND 10) NOT NULL,
		Avis_general VARCHAR(50),
		Id_film INTEGER,
		Id_site INTEGER,
		UNIQUE(Id_film, Id_site),
		FOREIGN KEY(Id_film) REFERENCES Film(Id_film),
		FOREIGN KEY(Id_site) REFERENCES Site_Critique(Id_site)		
);
