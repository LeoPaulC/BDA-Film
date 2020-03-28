CREATE TABLE Personne(
		Id_personne INTEGER PRIMARY KEY,
		nom_personne VARCHAR(50) NOT NULL,
		prenom_personne VARCHAR(50) NOT NULL,
		date_naissance DATE
);
CREATE TABLE Personne_Invitee(
		Id_personne INTEGER ,
		Id_film INTEGER ,
		Id_festival INTEGER ,
		metier VARCHAR(50) NOT NULL,
		PRIMARY KEY(Id_personne, Id_film, Id_festival),
		FOREIGN KEY(Id_personne) REFERENCES Personne(Id_personne),
		FOREIGN KEY(Id_film) REFERENCES Film(Id_film),
		FOREIGN KEY(Id_festival) REFERENCES Festival(Id_festival)

);
CREATE TABLE Film(
		Id_film INTEGER PRIMARY KEY,
		nom_film VARCHAR(50) NOT NULL,
		type_film VARCHAR(50),
		duree_film INTEGER,
		Date_parution DATE
);
CREATE TABLE Participant(
		Id_participant INTEGER PRIMARY KEY,
		Id_film INTEGER,
		Id_personne INTEGER,
		Role VARCHAR(50) NOT NULL ,
		FOREIGN KEY(Id_film) REFERENCES Film(Id_film),
		FOREIGN KEY(Id_personne) REFERENCES Personne(Id_personne)
);
CREATE TABLE Utilisateur(
		Id_user INTEGER,
		Id_personne INTEGER,
		Id_localisation INTEGER,
		Email VARCHAR(50) NOT NULL,
		Mdp VARCHAR(50) NOT NULL,
		Telephone VARCHAR(50),
		PRIMARY KEY(Id_user, Id_personne, Id_localisation),
		FOREIGN KEY(Id_personne) REFERENCES Personne(Id_personne),
		FOREIGN KEY(Id_localisation) REFERENCES Localisation(Id_localisation)
);
CREATE TABLE Localisation(
		Id_localisation INTEGER PRIMARY KEY UNIQUE ,
		Latitude INTEGER,
		Longitude INTEGER,
		FOREIGN KEY(Latitude) REFERENCES Lieu(Latitude),
		FOREIGN KEY(Longitude) REFERENCES Lieu(Longitude)
);
CREATE TABLE Lieu(
		Latitude INTEGER UNIQUE,
		Longitude INTEGER UNIQUE,
		Departement VARCHAR(50) NOT NULL,
		Ville VARCHAR(50),
		Pays VARCHAR(50) NOT NULL,
		Adresse VARCHAR(50),
		Code_postale VARCHAR(6) NOT NULL,
		PRIMARY KEY(Latitude, Longitude)
);
CREATE TABLE Festival(
		Id_festival INTEGER PRIMARY KEY,
		Theme VARCHAR(50),
		Nom_festival VARCHAR(50) NOT NULL,
		Capacite_max INTEGER,
		Description_lieu VARCHAR(50),
		Periodicite VARCHAR(50),
		Date_creation DATE,
		Website VARCHAR(50)
);
CREATE TABLE Edition(
		Id_edition INTEGER,
		Id_festival INTEGER UNIQUE,
		Annee INTEGER,
		Date_debut DATE,
		Date_fin DATE,
		Id_localisation INTEGER,
		PRIMARY KEY(Id_edition, Id_festival, Annee),
		FOREIGN KEY(Id_festival) REFERENCES Festival(Id_festival)
		
);
CREATE TABLE Place(
		Id_place INTEGER,
		Id_festival INTEGER,
		Id_personne INTEGER,
		Nom_place VARCHAR(50) NOT NULL,
		Prenom_place VARCHAR(50) NOT NULL,
		Id_categorie INTEGER,
		Numero_place INTEGER,
		PRIMARY KEY(Id_place, Id_festival, Id_personne)
		FOREIGN KEY(Id_festival) REFERENCES Festival(Id_festival),
		FOREIGN KEY(Id_personne) REFERENCES Personne(Id_personne),
		FOREIGN KEY(Id_categorie) REFERENCES Categorie(Id_categorie)
);
CREATE TABLE Categorie(
		Id_categorie INTEGER PRIMARY KEY,
		Prix INTEGER,
		Descriptif VARCHAR(50) 
);
CREATE TABLE Site_Critique(
		Id_site INTEGER PRIMARY KEY,
		Nom VARCHAR(50) NOT NULL,
		Lien VARCHAR(50) NOT NULL
);
CREATE TABLE Critique(
		Id_critique INTEGER UNIQUE ,
		Id_film INTEGER UNIQUE ,
		Id_site INTEGER,
		Note_global INTEGER,
		Avis_general VARCHAR(50),
		PRIMARY KEY(Id_critique, Id_film, Id_site),
		FOREIGN KEY(Id_film) REFERENCES Film(Id_film),
		FOREIGN KEY(Id_site) REFERENCES Site_Critique(Id_site)
		
);
