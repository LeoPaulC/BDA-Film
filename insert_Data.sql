\copy localisation(latitude,longitude) from csv/localisation.csv delimiter ',';

\copy lieu(departement,ville,pays,adresse,code_postale,id_localisation) from csv/lieu.csv delimiter ',';

\copy festival(theme,nom_festival,description,periodicite,date_creation,website) from csv/festival.csv delimiter ',';

\copy film(nom_film,type_film,annee,realisateur,producteur) from csv/film.csv delimiter ',';

\copy site(nom,lien) from csv/site.csv delimiter ',';

\copy Personne(nom,prenom,date_naissance) from csv/personne.csv delimiter ',';

\copy Edition(date_debut, date_fin, id_lieu,id_festival,capacite_max_place) from csv/edition.csv delimiter ',';

\copy Film_Edition from csv/film_edition.csv delimiter ',';

\copy Categorie(id_edition,descriptif,capacite,prix) from csv/categorie.csv delimiter ',';

\copy Compte(solde) from csv/compte.csv delimiter ',';

\copy Utilisateur(email,mdp,id_personne,id_compte) from csv/utilisateur.csv delimiter ',';
