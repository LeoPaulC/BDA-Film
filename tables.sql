
DROP TABLE IF EXISTS Place;

DROP TABLE IF EXISTS Utilisateur;#
DROP TABLE IF EXISTS Participant;#
DROP TABLE IF EXISTS Localisation;#
DROP TABLE IF EXISTS Film_Edition;#
DROP TABLE IF EXISTS Edition;#
DROP TABLE IF EXISTS Categorie;#
DROP TABLE IF EXISTS Personne_Invitee;#
DROP TABLE IF EXISTS Critique;#
DROP TABLE IF EXISTS Personne;#
DROP TABLE IF EXISTS Film;#
DROP TABLE IF EXISTS Compte;#
DROP TABLE IF EXISTS Festival;#
DROP TABLE IF EXISTS Site_Critique;#
DROP TABLE IF EXISTS Lieu;#


CREATE TABLE Personne(
		Id_personne INTEGER PRIMARY KEY,
		nom_personne VARCHAR(50) NOT NULL,
		prenom_personne VARCHAR(50) NOT NULL,
		date_naissance DATE CHECK (date_naissance < now()- interval'18 year' ),
		UNIQUE(nom_personne,prenom_personne,date_naissance)
);

CREATE TABLE Film(
		Id_film INTEGER PRIMARY KEY,
		Nom_film VARCHAR(50) NOT NULL,
		Type_film VARCHAR(50) CHECK( type_film IN ('Documentaire', 'Action','Drame','Animation')),
		Duree_film INTEGER CHECK( duree_film > 0),
		Date_parution DATE
);


CREATE TABLE Compte(
		Id_compte INTEGER PRIMARY KEY,
		Solde NUMERIC(10,2) CHECK( Solde > Decouvert_autorise) NOT NULL,
		Decouvert_autorise NUMERIC(10,2) NOT NULL DEFAULT 0
);

CREATE TABLE Festival(
		Id_festival INTEGER PRIMARY KEY,
		Theme VARCHAR(50),
		Nom_festival VARCHAR(50) NOT NULL UNIQUE,
		Capacite_max INTEGER,
		Description_lieu VARCHAR(50),
		Periodicite VARCHAR(50),
		Date_creation DATE,
		Website VARCHAR(50) UNIQUE
);


CREATE TABLE Site_Critique(
		Id_site INTEGER PRIMARY KEY,
		Nom VARCHAR(50) NOT NULL,
		Lien VARCHAR(50) NOT NULL UNIQUE
);

CREATE TABLE Lieu(
		Latitude INTEGER,
		Longitude INTEGER,
		Departement VARCHAR(50) NOT NULL,
		Ville VARCHAR(50) NOT NULL,
		Pays VARCHAR(50) NOT NULL,
		Adresse VARCHAR(50),
		Code_postale VARCHAR(6) NOT NULL,
		PRIMARY KEY(Latitude, Longitude)
);


CREATE TABLE Personne_Invitee(
		Id_personne INTEGER,
		Id_film INTEGER,
		Id_festival INTEGER,
		metier VARCHAR(50) CHECK(metier IN ('Acteur','Réalisateur','Producteur','Cameraman')) NOT NULL,
		PRIMARY KEY(Id_personne, Id_film, Id_festival),
		FOREIGN KEY(Id_personne) REFERENCES Personne(Id_personne),
		FOREIGN KEY(Id_film) REFERENCES Film(Id_film),
		FOREIGN KEY(Id_festival) REFERENCES Festival(Id_festival)
);





CREATE TABLE Localisation(
		Id_localisation INTEGER PRIMARY KEY,
		Latitude INTEGER,
		Longitude INTEGER,
		FOREIGN KEY(Latitude,Longitude) REFERENCES Lieu(Latitude,Longitude)
);

CREATE TABLE Edition(
		Id_edition INTEGER PRIMARY KEY,
		Id_festival INTEGER,
		Annee INTEGER,
		Capacite_max_place INTEGER ,
		Date_debut DATE,
		Date_fin DATE,
		Id_localisation INTEGER,
		UNIQUE(Id_festival, Annee, Date_debut, Date_fin),
		FOREIGN KEY(Id_festival) REFERENCES Festival(Id_festival),
		FOREIGN KEY(Id_localisation) REFERENCES Localisation(Id_localisation)
);
CREATE TABLE Film_Edition(
		Id_edition INTEGER,
		Id_film INTEGER,
		PRIMARY KEY(Id_edition, Id_film),
		FOREIGN KEY(Id_film) REFERENCES Film(Id_film),
		FOREIGN KEY(Id_edition) REFERENCES Edition(Id_edition)
);

CREATE TABLE Participant(
		Id_participant INTEGER PRIMARY KEY,
		Id_film INTEGER,
		Id_personne INTEGER,
		Role VARCHAR(50) CHECK(Role IN ('Acteur','Réalisateur','Producteur','Cameraman')) NOT NULL,
		UNIQUE(Id_film, Id_personne, Role),
		FOREIGN KEY(Id_film) REFERENCES Film(Id_film),
		FOREIGN KEY(Id_personne) REFERENCES Personne(Id_personne)
);
CREATE TABLE Utilisateur(
		Id_user INTEGER PRIMARY KEY,
		Id_personne INTEGER UNIQUE,
		Id_localisation INTEGER,
		Id_compte INTEGER UNIQUE,
		Email VARCHAR(50) NOT NULL,
		Mdp VARCHAR(50) NOT NULL,
		Telephone VARCHAR(50),
		UNIQUE(Email,Mdp),
		FOREIGN KEY(Id_personne) REFERENCES Personne(Id_personne),
		FOREIGN KEY(Id_compte) REFERENCES Compte(Id_compte) ON DELETE CASCADE,
		FOREIGN KEY(Id_localisation) REFERENCES Localisation(Id_localisation)
);


CREATE TABLE Categorie(
		Id_categorie INTEGER PRIMARY KEY,
		Prix INTEGER,
		Descriptif VARCHAR(50),
		Id_edition INTEGER,
		Capacite_max INTEGER ,
		FOREIGN KEY(Id_edition) REFERENCES Edition(Id_edition)
);

CREATE TABLE Place(
		Id_place INTEGER PRIMARY KEY,
		Id_user INTEGER,
		Nom_place VARCHAR(50) NOT NULL,
		Prenom_place VARCHAR(50) NOT NULL,
		Id_categorie INTEGER,
		Numero_place INTEGER,
		UNIQUE(Nom_place, Prenom_place),
		UNIQUE(Numero_place),
		FOREIGN KEY(Id_user) REFERENCES Utilisateur(Id_user),
		FOREIGN KEY(Id_categorie) REFERENCES Categorie(Id_categorie)
);

CREATE TABLE Critique(
		Id_critique INTEGER PRIMARY KEY,
		Id_film INTEGER,
		Id_site INTEGER,
		Note_globale INTEGER CHECK( Note_globale BETWEEN 0 AND 10) NOT NULL,
		Avis_general VARCHAR(50),
		UNIQUE(Id_film, Id_site),
		FOREIGN KEY(Id_film) REFERENCES Film(Id_film),
		FOREIGN KEY(Id_site) REFERENCES Site_Critique(Id_site)		
);
