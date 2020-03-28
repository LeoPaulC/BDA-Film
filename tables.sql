CREATE TABLE Personne(
		Id_personne INTEGER PRIMARY KEY,
		nom_personne VARCHAR(50) NOT NULL,
		prenom_personne VARCHAR(50) NOT NULL,
		date_naissance DATE
);
CREATE TABLE Personne_Invitée(
		Id_personne INTEGER ,
		Id_film INTEGER ,
		Id_festival INTEGER ,
		metier VARCHAR(50) NOT NULL,
		date_arrivee DATE,
		date_depart DATE ,
		PRIMARY KEY(Id_personne , Id_film , Id_festival ) ,
		FOREIGN KEY(Id_personne) REFERENCES Personne(Id_personne) ,
		FOREIGN KEY(Id_film) REFERENCES Film(Id_film) ,
		FOREIGN KEY(Id_festival) REFERENCES Festival(Id_festival) 
);
CREATE TABLE Film(
		Id_film INTEGER PRIMARY KEY,
		nom_film VARCHAR(50) NOT NULL,
		type_film VARCHAR(50) NOT NULL,
		duree_film INTEGER,
		Date_parution DATE
);
CREATE TABLE Participant(
		Id_participant INTEGER PRIMARY KEY,
		Id_film INTEGER,
		Id_personne INTEGER,
		Role VARCHAR(50) NOT NULL
);
CREATE TABLE Utilisateur(
		Id_user INTEGER PRIMARY KEY,
		Id_personne INTEGER PRIMARY KEY,
		Id_localisation INTEGER PRIMARY KEY,
		Email VARCHAR(50) NOT NULL,
		Mdp VARCHAR(50) NOT NULL,
		Téléphone 
);
CREATE TABLE Localisation(
		Id_localisation INTEGER PRIMARY KEY,
		Latitude INTEGER PRIMARY KEY,
		Longitude INTEGER PRIMARY KEY
);
CREATE TABLE Lieu(
		Latitude INTEGER PRIMARY KEY,
		Longitude INTEGER PRIMARY KEY,
		Departement VARCHAR(50) NOT NULL,
		Ville VARCHAR(50) NOT NULL,
		Pays VARCHAR(50) NOT NULL,
		Adresse VARCHAR(50) NOT NULL,
		Code_postale INTEGER
);
CREATE TABLE Festival(
		Id_festival INTEGER PRIMARY KEY,
		Id_edition INTEGER PRIMARY KEY,
		Theme VARCHAR(50) NOT NULL,
		Nom_festival VARCHAR(50) NOT NULL,
		Capacite_max INTEGER,
		Description_lieu VARCHAR(50) NOT NULL,
		Periodicite VARCHAR(50) NOT NULL,
		Date_création DATE,
		Website VARCHAR(50) NOT NULL
);
CREATE TABLE Edition(
		Id_edition INTEGER PRIMARY KEY,
		Id_festival INTEGER PRIMARY KEY,
		Année PRIMARY KEY,
		Date_debut DATE,
		Date_fin DATE,
		Id_localisation INTEGER
);
CREATE TABLE Place(
		Id_place INTEGER PRIMARY KEY,
		Id_festival INTEGER PRIMARY KEY,
		Id_personne INTEGER PRIMARY KEY,
		Nom_place VARCHAR(50) NOT NULL,
		Prenom_place VARCHAR(50) NOT NULL,
		Id_catégorie INTEGER,
		Numéro_place INTEGER
);
CREATE TABLE Categorie(
		Id_categorie INTEGER PRIMARY KEY,
		Prix INTEGER,
		Descriptif VARCHAR(50) NOT NULL
);
CREATE TABLE Site_Critique(
		Id_site INTEGER PRIMARY KEY,
		Nom VARCHAR(50) NOT NULL,
		Lien VARCHAR(50) NOT NULL
);
CREATE TABLE Critique(
		Id_critique INTEGER PRIMARY KEY,
		Id_film INTEGER PRIMARY KEY,
		Id_site INTEGER PRIMARY KEY,
		Note_global INTEGER,
		Avis_general VARCHAR(50) NOT NULL
);
